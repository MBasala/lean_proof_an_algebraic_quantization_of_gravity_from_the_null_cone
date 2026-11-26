"""Extract page-delimited text from a PDF. usage: extract_pdf_text.py in.pdf out.txt"""
import sys

import pymupdf as fitz
pdf, out = sys.argv[1], sys.argv[2]
doc = fitz.open(pdf)
print("pages", len(doc), doc.metadata)
with open(out, "w", encoding="utf-8") as f:
    for i, p in enumerate(doc):
        f.write(f"\n\n===== PAGE {i+1} =====\n")
        f.write(p.get_text())
