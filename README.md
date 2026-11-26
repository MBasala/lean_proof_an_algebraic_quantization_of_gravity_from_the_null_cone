# quant_grav

A Lean 4 + Mathlib account of what arXiv:2611.34924v1 ("An algebraic quantization of gravity from the null cone") proves, written as conditional theorems with every unproved physical input exposed as a named hypothesis. It does not verify the paper's physics.

- `handoff.md`: the brief, work packages and paper map.
- `FIDELITY.md`: each formal statement paired with the paper's equation, findings from reading the paper, and the hypothesis register.
- `QuantGrav/Elementary/`: WP1, self-contained analytic statements.
- `QuantGrav/Diamond/FiniteDim.lean`: finite dimension from bounded partial traces (finding F2).
- `QuantGrav/Diamond/Setup.lean`: the objects of Sec 5.1 and 5.2 (clock, area, `K_A`, `Omega_A`) as a structure, reviewed against the paper.
- `QuantGrav/Diamond/ClockHypotheses.lean`: first consequences of H1, H13 and H14, and models showing what they do not imply.
- `QuantGrav/OperatorAlgebra/`: WP2, statements about sums over intermediate states that hold for any bounded operators.
- `QuantGrav/Hypotheses.lean`: the hypothesis register, with formal statements of H1, H13 and H14.
- `QuantGrav/Audit.lean`: pinned `#print axioms` output for every headline theorem.
- `paper/equation_index.tsv`: printed equation number, LaTeX label and `main.tex` line for every equation in the paper.

The paper's PDF and TeX source are not in the repository (its arXiv licence does not allow redistribution). To rebuild the index, put the PDF in the repository root, unpack the arXiv source into `paper/arxiv-src/`, and run `scripts/extract_pdf_text.py` and `scripts/tex_label_index.py`.

Directories `Axioms/` and `Entropy/` will appear under `QuantGrav/` as their work packages start.

## Build

Toolchain `leanprover/lean4:v4.37.0-rc1`, Mathlib tag `v4.37.0-rc1` (see `lean-toolchain`, `lake-manifest.json`).

```
lake exe cache get
lake build --wfail
bash scripts/check_forbidden.sh
```

`--wfail` makes any warning, including a placeholder proof, fail the build. `scripts/check_forbidden.sh` rejects placeholder proofs, `native_decide` and new axiom declarations. CI runs both.

## GitHub configuration

To set up your new GitHub repository, follow these steps:

* Under your repository name, click **Settings**.
* In the **Actions** section of the sidebar, click "General".
* Check the box **Allow GitHub Actions to create and approve pull requests**.
* Click the **Pages** section of the settings sidebar.
* In the **Source** dropdown menu, select "GitHub Actions".

After following the steps above, you can remove this section from the README file.
