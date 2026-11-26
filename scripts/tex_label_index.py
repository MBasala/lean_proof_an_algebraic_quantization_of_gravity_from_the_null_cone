"""Compute the printed equation number of every label in an arXiv main.tex, without running TeX.

usage: tex_label_index.py main.tex out.tsv [pdf_text]

If pdf_text (output of extract_pdf_text.py) is given, the computed numbers are compared with the
equation tags printed in the PDF. The input is untrusted third-party text: it is only parsed.
"""
import re, sys

BS = chr(92)
src = open(sys.argv[1], encoding="utf-8").read()
# strip comments, keep line structure
src = re.sub(r"(?<!" + BS + BS + r")%.*", "", src)
NUM_MULTI = {"align", "gather", "alignat", "flalign", "eqnarray"}
NUM_SINGLE = {"equation", "multline"}
B = BS + BS  # regex for one literal backslash
tok = re.compile(
    B + B + "|" + B + "[{}%]|"
    + B + r"begin\{(?P<b>[A-Za-z]+\*?)\}|" + B + r"end\{(?P<e>[A-Za-z]+\*?)\}|"
    + B + r"label\{(?P<l>[^}]*)\}|" + B + r"(?:nonumber|notag)\b|" + B + r"tag\*?\{(?P<t>[^}]*)\}|"
    + B + r"section(?P<star>\*?)\s*[\[{]|" + B + r"appendix\b|[{}]"
)
ROWBREAK = BS + BS
sec = 0
app = False
eq = 0
sub = None
stack = []   # environment names
disp = None  # index in stack of the active numbered display env
brace = 0
row = None
out = []
warn = []
carry = []


def secname():
    return chr(64 + sec) if app else str(sec)


def line(pos):
    return src.count("\n", 0, pos) + 1


def newrow(pos):
    return {"labels": [], "nonum": False, "tag": None, "start": pos}


def finalize(pos, at_end):
    global eq, row
    r = row
    row = None
    body = src[r["start"]:pos].strip()
    if at_end and not body and not r["labels"]:
        return
    if r["nonum"]:
        # amsmath defers a label on an untagged row to the next tagged row of the same display
        if r["labels"] and not at_end:
            carry.extend(r["labels"])
        elif r["labels"]:
            warn.append(f"label on unnumbered final row {r['labels']} line {line(pos)}")
        return
    if carry:
        r["labels"] = carry + r["labels"]
        carry.clear()
    if r["tag"] is not None:
        n = r["tag"]
    elif sub is not None:
        sub["k"] += 1
        n = f"{sub['parent']}{chr(96 + sub['k'])}"
    else:
        eq += 1
        n = f"{secname()}.{eq}"
    out.append((n, ",".join(r["labels"]) or "-", line(r["start"])))


for m in tok.finditer(src):
    s = m.group(0)
    pos = m.start()
    if s in (BS + "{", BS + "}", BS + "%"):
        continue
    if s == "{":
        brace += 1
        continue
    if s == "}":
        brace -= 1
        continue
    if s == BS + "appendix":
        app = True
        sec = 0
        continue
    if s.startswith(BS + "section"):
        if not m.group("star"):
            sec += 1
            eq = 0
        if s.endswith("{"):
            brace += 1
        continue
    if m.group("b"):
        name = m.group("b")
        stack.append(name)
        if name == "subequations":
            eq += 1
            sub = {"parent": f"{secname()}.{eq}", "k": 0, "labels": [], "line": line(pos)}
        elif disp is None and name in NUM_MULTI | NUM_SINGLE:
            disp = len(stack) - 1
            brace = 0
            row = newrow(m.end())
        continue
    if m.group("e"):
        name = m.group("e")
        if disp is not None and len(stack) - 1 == disp:
            finalize(pos, True)
            disp = None
        if name == "subequations":
            out.append((sub["parent"], ",".join(sub["labels"]) or "-", sub["line"]))
            sub = None
        if not stack or stack[-1] != name:
            warn.append(f"env mismatch {name} line {line(pos)}")
        else:
            stack.pop()
        continue
    if disp is None:
        if m.group("l") and sub is not None and stack and stack[-1] == "subequations":
            sub["labels"].append(m.group("l"))
        continue
    top = len(stack) - 1 == disp
    if s == ROWBREAK:
        if top and brace == 0 and stack[disp] in NUM_MULTI:
            finalize(pos, False)
            row = newrow(m.end())
    elif m.group("l"):
        row["labels"].append(m.group("l"))
    elif m.group("t") is not None:
        row["tag"] = m.group("t")
    else:
        row["nonum"] = True

with open(sys.argv[2], "w", encoding="utf-8", newline="\n") as f:
    f.write("number\tlabel\tmain_tex_line\n")
    for n, lab, ln in out:
        f.write(f"{n}\t{lab}\t{ln}\n")
mine = [n for n, _, _ in out]
print(f"tex numbers: {len(mine)}")
print("duplicate numbers:", sorted({n for n in mine if mine.count(n) > 1}))
print("warnings:", warn)
if len(sys.argv) > 3:
    # Tags that share a line with other glyphs in the PDF text are missed by this pattern.
    pdf = re.findall(r"^\(((?:\d|[A-E])\.\d+[a-z]?)\)$", open(sys.argv[3], encoding="utf-8").read(), re.M)
    parents = {n for n in mine if any(o != n and o.startswith(n) and o[len(n):].isalpha() for o in mine)}
    print(f"subequation parents: {len(parents)}, pdf tags: {len(pdf)}")
    print("only in tex:", sorted(set(mine) - set(pdf) - parents))
    print("only in pdf:", sorted(set(pdf) - set(mine)))
