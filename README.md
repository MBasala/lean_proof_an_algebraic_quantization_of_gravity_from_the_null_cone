# quant_grav

A Lean 4 + Mathlib account of what arXiv:2611.34924v1 ("An algebraic quantization of gravity from the null cone") proves, written as conditional theorems with every unproved physical input exposed as a named hypothesis. It does not verify the paper's physics.

- `handoff.md`: the brief, work packages and paper map.
- `FIDELITY.md`: each formal statement paired with the paper's equation, findings from reading the paper, and the hypothesis register.
- `QuantGrav/Elementary/`: WP1, self-contained analytic statements.
- `QuantGrav/Diamond/FiniteDim.lean`: finite dimension from bounded partial traces (finding F2).
- `QuantGrav/Diamond/ClosedCuts.lean`: what open gluing does not give for closed cuts, and a weaker hypothesis (H3c) that would suffice for finite dimension (finding F10).
- `QuantGrav/Diamond/OrderOfExhaustion.lean`: a model in which closed partial sums depend on the order in which the cuts exhaust the basis (finding F10).
- `QuantGrav/Diamond/Setup.lean`: the objects of Sec 5.1 and 5.2 (clock, area, `K_A`, `Omega_A`) as a structure, reviewed against the paper.
- `QuantGrav/Diamond/ClockHypotheses.lean`: first consequences of H1, H13 and H14, and models showing what they do not imply.
- `QuantGrav/OperatorAlgebra/`: WP2, statements about sums over intermediate states that hold for any bounded operators.
- `QuantGrav/Entropy/SenComparison.lean`: the paper's logarithmic coefficient compared with the three ensembles of Sen's paper.
- `QuantGrav/Hypotheses.lean`: the hypothesis register, with formal statements of H1, H13 and H14.
- `QuantGrav/Audit.lean`: pinned `#print axioms` output for every headline theorem.
- `paper/equation_index.tsv`: printed equation number, LaTeX label and `main.tex` line for every equation in the paper.
- `notes/note-to-author-draft.md`: a draft of questions for the paper's author. Not sent.

The paper's PDF and TeX source are not in the repository (its arXiv licence does not allow redistribution). To rebuild the index, put the PDF in the repository root, unpack the arXiv source into `paper/arxiv-src/`, and run `scripts/extract_pdf_text.py` and `scripts/tex_label_index.py`.

The directory `Axioms/` will appear under `QuantGrav/` when its work package starts.

## Build

Toolchain `leanprover/lean4:v4.37.0-rc1`, Mathlib tag `v4.37.0-rc1` (see `lean-toolchain`, `lake-manifest.json`).

```
lake exe cache get
lake build --wfail
bash scripts/check_forbidden.sh
```

`--wfail` makes any warning, including a placeholder proof, fail the build. `scripts/check_forbidden.sh` rejects placeholder proofs, `native_decide` and new axiom declarations. The GitHub workflow runs both, but its runner does not have enough disk space to finish, so these two commands are run locally before each commit.

## Licence

MIT; see `LICENSE`. It covers the contents of this repository. The paper it studies (arXiv:2611.34924) is not part of the repository and is under its own licence.

Each Lean file under `QuantGrav/` carries a copyright header in Mathlib's format with the MIT line. Mathlib's header linter enforces it, with its licence line set in `lakefile.toml`.

## GitHub configuration

To set up your new GitHub repository, follow these steps:

* Under your repository name, click **Settings**.
* In the **Actions** section of the sidebar, click "General".
* Check the box **Allow GitHub Actions to create and approve pull requests**.
* Click the **Pages** section of the settings sidebar.
* In the **Source** dropdown menu, select "GitHub Actions".

After following the steps above, you can remove this section from the README file.
