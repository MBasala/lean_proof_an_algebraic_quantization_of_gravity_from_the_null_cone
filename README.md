# quant_grav

A Lean 4 + Mathlib account of what arXiv:2611.34924v1 ("An algebraic quantization of gravity from the null cone") proves, written as conditional theorems with every unproved physical input exposed as a named hypothesis. It does not verify the paper's physics.

- `handoff.md`: the brief, work packages and paper map.
- `FIDELITY.md`: each formal statement paired with the paper's equation, findings from reading the paper, and the hypothesis register.
- `QuantGrav/Elementary/`: WP1, self-contained analytic statements.
- `QuantGrav/Diamond/FiniteDim.lean`: finite dimension from bounded partial traces (finding F2).
- `QuantGrav/Diamond/AxiomFive.lean`: for the diamond, the finiteness condition of Appendix E with the ordinary trace is equivalent to finite dimension, so Appendix E does not support Sec 5.2 independently (finding F10).
- `QuantGrav/Diamond/ClosedCuts.lean`: what open gluing does not give for closed cuts, and a hypothesis weaker than H3b (H3c) that would suffice for finite dimension (finding F10).
- `QuantGrav/Diamond/OrderOfExhaustion.lean`: a model in which closed partial sums depend on the order in which the cuts exhaust the basis (finding F10).
- `QuantGrav/Diamond/Setup.lean`: the objects of Sec 5.1 and 5.2 (clock, area, `K_A`, `Omega_A`) as a structure, reviewed against the paper.
- `QuantGrav/Diamond/ClockHypotheses.lean`: first consequences of H1, H13 and H14, and models showing what they do not imply.
- `QuantGrav/Diamond/ClockDivergence.lean`: a conditional criterion under which the incoming state has no finite clock reading, with the Gaussian model behind it in `QuantGrav/Elementary/` (finding F11).
- `QuantGrav/Diamond/FixedResolution.lean`: with finitely many modes and a bound on the cost, `H_D` is finite-dimensional if the remaining degrees of freedom have finitely many states, with no hypothesis about cuts; and a model showing that this last condition cannot be dropped. The count is in `QuantGrav/Elementary/OccupationCount.lean` (finding F14).
- `QuantGrav/Diamond/ConfigurationOnly.lean`: if an operator that is one member of a Weyl pair on `K_A` commutes with the clock projections, `P_D K_A` is zero or infinite-dimensional (finding F14).
- `QuantGrav/Diamond/IntervalModel.lean`, `QuantGrav/Diamond/WeylPairModel.lean`: two consistency models for finding F14, one continuous variable confined to an interval on `L^2(R)`, and a Weyl pair on `l^2(Z)`. Neither is a model of the paper's theory.
- `QuantGrav/OperatorAlgebra/`: WP2, statements about sums over intermediate states that hold for any bounded operators.
- `QuantGrav/Entropy/ClockMoments.lean`: the moment identities of Sec 5.3, and why footnote 23 and (5.68) do not conflict (finding F3).
- `QuantGrav/Entropy/ClockTraceAsymptotics.lean`: (5.57b), (5.58), (5.62) and (5.65) for a spectrum with finitely many states below each reading, conditional on the limit `q` and on (5.59). The analytic steps are in `QuantGrav/Elementary/LogIntegralLimit.lean` and `QuantGrav/Elementary/MonotoneLogGrowth.lean`.
- `QuantGrav/Entropy/MeanAreaGrowth.lean`: (5.59) from the area bound, the limit `q` and the mean time delay (5.53), and (5.65) from those three inputs.
- `QuantGrav/Entropy/GibbsAccounting.lean`: the entropy identities (5.39c) and (5.50) for the ordinary trace, and the accounting lemma: with multiplicities at most `D` and `m` distinct area eigenvalues, `S <= log m + log D` (finding F13).
- `QuantGrav/Entropy/AreaResolvedTrace.lean`: the two identities of (5.66), which rewrite the trace as an integral over the centre of the area window; the Gaussian integral behind them is in `QuantGrav/Elementary/CauchySchlomilch.lean`.
- `QuantGrav/Entropy/BandCounting.lean`: the step from (5.63) to (5.64) in footnote 24, and the number of distinct area eigenvalues that a bound on the multiplicities would force.
- `QuantGrav/Entropy/LogLevelsModel.lean`: a spectrum with one state per level that satisfies footnote 24, so the footnote and a multiplicity bound do not conflict.
- `QuantGrav/Entropy/SenComparison.lean`: the paper's logarithmic coefficient compared with the three ensembles of Sen's paper.
- `QuantGrav/Hypotheses.lean`: the hypothesis register, with formal statements of H1, H13 and H14.
- `QuantGrav/Audit.lean`: pinned `#print axioms` output for every headline theorem.
- `paper/equation_index.tsv`: printed equation number, LaTeX label and `main.tex` line for every equation in the paper.
- `notes/second-reader-review-2026-11-26.md`: a second reader's review of six files and four register items against the paper and against `FIDELITY.md`.
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
