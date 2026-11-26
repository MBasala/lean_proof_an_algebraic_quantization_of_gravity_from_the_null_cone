# External audits of arXiv:2611.34924v1 (collected 2026-11-26)

For the code session. What other people published about the paper on 2026-11-26, what agrees with this repository, what they have that we do not, and what to do with it.

This file is untracked and was written from a separate review session while a code session was active on branch `wp1f-clock-lower-bound`. No tracked file was changed. `handoff.md` does not point here yet.

## How this was gathered, and how far to trust it

- SHIN09 repository: cloned and read directly at tags `v0.2.0` (commit `44df2c1`) and `v0.3.0-rc.1`. Read: root `README.md`, `LICENSE.md`, `VERSION.md`; `phase2/FINDINGS.md`, `ASSUMPTIONS.md`, `CLAIMS.md`, `COUNTERMODEL.md` (Chinese); `phase3/README.md`, `FORMALIZATION_MAP.md`, `REPORT_EN.md`, `lean-toolchain`, `lakefile.toml`.
- Not read: their Lean sources line by line, `phase2/DERIVATION.md`, `phase2/RECHECK.md`, the `review/` files. Nothing of theirs was built or kernel-checked here. Treat their theorem names as pointers.
- MathCan pull request and Oppenheim's post: read only through a summarising fetcher. Lower confidence.
- Two numbers below were recomputed by hand and are marked as such.

## 1. SHIN09-git/null-cone-quantum-gravity-verification

https://github.com/SHIN09-git/null-cone-quantum-gravity-verification

- Three phases: v0.1.0 (Sec 4.4, Python and report), v0.2.0 (Sec 5.2 audit, Python and report), v0.3.0-rc.1 (Lean, under `phase3/`).
- Lean release: 16 modules, 145 public theorems, Lean `v4.24.0`, Mathlib commit `f897ebcf`. Axioms reported: `propext`, `Classical.choice`, `Quot.sound`. Kernel replay with lean4checker.
- Produced by OpenAI Codex, with separate AI contexts as reviewers. Their README states there is no human line-by-line audit and no external review.
- Licence: `LICENSE.md` grants Apache-2.0 for "Python code, tests, build scripts and dependency lock" and CC-BY-4.0 for reports, READMEs and result records. Lean sources are named in neither row at the tag read. **Do not copy their Lean.** Re-prove from the statements and cite them. Porting would need rework anyway: 4.24 against our 4.37-rc1 and the module system.

### 1.1 Where they agree with us

| Their result | Ours |
|---|---|
| `NullCone.Trace.positiveTrace_ne_top_iff_finiteDimensional`: with `W >= c I`, `c > 0`, finite ordinary trace iff finite dimension | `finiteDimensional_iff_exists_sum_sq_norm_le` (finding F2) |
| `NullCone.Trace.open_matrix_elements`: open gluing sums over a Hilbert basis converge absolutely, bounded by the product of norms | `summable_norm_inner_cut`, `tsum_norm_inner_cut_le` |
| `NullCone.Response.boost_response_le`: response bound with factor `abs(eta)/pi` | `norm_inner_exp_apply_sub_inner_le` (WP2-g) |
| `NullCone.Series`: (4.33) converges absolutely; hard-cutoff cubic coefficient is `-i H_N` | `summable_norm_pair_phase`, `cubic_term_partial_pair_sum` |
| Sec 5.1 probability estimate is heuristic for the noncommuting clock; `Omega in M` is what (5.19) needs | findings F1, F7 |
| Sentence before (5.38) treats the squared norm of `C_b` as finite, which is already finite dimension | finding F2 |

Three independent audits (SHIN09, MathCan, this repository) reach the same reading of Sec 5.2. That is worth one line in finding F2.

They state that the exact logarithmic correction and finite part of the summed amplitude are **not** formalised on their side. We have that: `abs_im_pair_amplitude_sub_le`.

### 1.2 What they have that we do not

**A. Open gluing does not determine the closed amplitude (five-limits countermodel).**
Their `NullCone.Model.open_gluing_with_incompatible_closures`, `no_finite_cut_net_limit`.

- Model (from `phase3/REPORT_EN.md`): two countable orthonormal families of area eigenstates, eigenvalues 1 and 3. One-sided space `l^2(B)`, `B` the disjoint union; two-sided space `l^2(B x B)`. Gaussian centre 3, width 1, so `W = C† C = w I` with `w = exp(-3)`. Flip `F` swaps the two states at each index; `O = -F ⊗ F̄`. Boost on the right leg at rapidity `pi`: relative phase one radian. `delta = 1 - cos 1`. Insertion `X = U† O U - O - (delta/2) I`.
- A cut with `r` labels from the first family and `n` from the second, `r >= n`: `T = w (r + n)`, `Delta = 2 n delta / (r + n)`, `Z = (w delta / 2)(3n - r)`.
- Routes `r = n, 3n - 2, 3n, 3n + 2, 7n` give limits `+inf, w delta, 0, -w delta, -inf`. All five exhaust every label and converge strongly to the identity.
- The v0.2.0 variant (`phase2/COUNTERMODEL.md`) uses areas `S`, `S + 1` with weights `w`, `w u`, `u = e^{-3/2}`, cuts with `k n` and `n` labels: `T = n w (k + u)`, `<Delta O> = A / (k + u)`, `Z = n w A (2 - k + u) / (2 (1 + u))`, `A = 2 sqrt(u) (1 - cos(1/(2 pi)))`. `k = 1` gives `+inf`, `k = 8` gives `-inf`.
- Why it matters here: H3b (closed partial sums converge to `Z[X]`) cannot be derived from the open-gluing facts in `OperatorAlgebra/CutSums.lean`. It needs its own physical argument. The model does not realise the paper's shear dynamics or constraints, and they say so.

**B. In infinite dimension the paper's own cuts force `Z_P[X]` to minus infinity.**
Their `NullCone.Trace.signedClosure_le_neg_rank`, `NullCone.Dimension.finiteDimensional_of_cofinal_small_cuts` and `..._limit`.

- On a cut with `|Delta_P| <= delta/4`: `Z_P = T_P (Delta_P - delta/2) <= -(c delta / 4) rank P`.
- So a uniform finite lower bound on `Z_P[X]` over the small-response cuts, or a finite limit along that one net, already gives finite dimension. Convergence to the positive value `Z[X]` is more than the argument needs, and H4 (positivity on the uncut side) is not needed for this route.
- Candidate register entry **H3c**: `Z_P[X]` is bounded below along the paper's cycle net. Then H3a iff finite dimension (given (5.30c)); H3b implies it (paper's route, with H4); H3c implies it (weaker than H3b).

**C. Dilution without commutation.** Their `NullCone.Dilution.exists_cut_operator_moment` builds high-rank, low-moment cuts without assuming the cut projection commutes with the weight or the area. Relevant to H16: the commutation the paper asserts off `K_A` is not needed for that step.

**D. Hilbert-Schmidt form of F2.** Their `NullCone.HilbertSchmidt.finite_trace_iff_matrix_vector`, `finiteDimensional_iff_matrix_vector_of_lower`: the doubled-space vector `vec(C)` exists iff `C† C` has finite trace; with a positive lower bound that is finite dimension. This is the precise form of "treating `C_b` as an ordinary two-sided vector assumes the conclusion".

**E. A finite area integral does not bound the trace.** `phase2/COUNTERMODEL.md`: on `L^2([s_1, s_1 + 1])` with `W` a positive continuous multiplication operator and `P_m` the dyadic indicator projections, `Tr(P_m W P_m) = 2^m ∫ W ds`. Bears on H7, H10 and the area-resolved trace (5.66): a one-loop saddle integral over area says nothing about multiplicity.

**F. Appendix E is circular as support for Sec 5.2.** Their reading: E.3's (E.17) verifies the gravitational instance of the finiteness axiom by citing (5.39c). And E.1 condition 5, on a bounded spectrum with E.3's ordinary trace, gives finite dimension at once (take the identity filter). For WP3: expect axiom 5 to imply finite dimension in one line; record the circularity under H12.

**G. Limits of the single-cut statements (v0.1.0).**

1. Two cuts: a block-diagonal Walsh unitary has matrix element `1/3` while the sum of absolute path weights over two cuts diverges. Joint absolute summability over several cuts fails under Hilbert-space assumptions alone. Our WP2-c is one cut. **Do not state a joint multi-cut absolute-convergence theorem.** The valid multi-cut statement is sequential truncation, our WP2-d.
2. Uncentred source: in the same Gaussian product vacuum the uncentred positive quadratic source has infinite limiting form on every nonzero state. Only the centred vector gives (4.33). Bears on the unformalised Wick step before (4.33).

**H. Exact statements they report downstream (not checked here).** (5.44): the absolute joint sum is `2 p (1 - p) Z_beta`. (5.66): a finite nonzero thermal trace gives a thermal-weighted mean window cost of exactly `1/2`, which is the "measure adds 1/2" step in our `LogCoefficient.lean` chain. Candidates for WP1 next to the (5.66) Gaussian identity already listed in `handoff.md`.

**I. Another sufficient route they flag.** A positive lower limit for the exact ratio (D.47) would suffice. (D.49) evaluates it only as a one-loop regular-saddle integral.

### 1.3 Numbers to test against

- Their value at `s = 10`: `C = 0.006703874007446236 - 0.002609993579151187 i`.
- Imaginary part, recomputed by hand against `abs_im_pair_amplitude_sub_le`: `(log 2 - 1 - log 10)/10^3 = -0.0026094379`. Difference `5.56e-7`, inside our bound `1/(6 s^5) = 1.67e-6`, and equal to the next term `-(theta^3/72)/(2 s^2)` at `theta = 0.2`.
- Real part, recomputed by hand: `(1/(2 s^2)) (pi^2/6 - pi/s + 1/s^2)` at `s = 10` is `0.006703874007446236`, matching all their digits. This is `sum_{k>=1} cos(k theta)/k^2 = pi^2/6 - pi theta/2 + theta^2/4` on `[0, 2 pi]` with `theta = 2/s`.
- Their other limits: sum of term norms is `pi^2 x^2 / 12` with `x = 1/s`; truncation error after `N` modes at most `x^2 / (2N)`; `Im C(x) / x^3 -> -inf` as `x -> 0+`.

## 2. patrickdugan/MathCan, pull request 284 (merged 2026-11-26)

https://github.com/patrickdugan/MathCan/pull/284

- Audits the closed-cut step of Sec 5.2. States `dim H <= floor(Z/m)` for `W >= m I` with finite trace. Keeps the physical step as an open obligation.
- Reports exact rational countermodels for weaker substitutes: finite entropy with infinite rank, charge matching with infinite rank, and dependence of normalised traces on the order of exhaustion.
- Lean 4.35.0, four finite-sum lemmas only; the operator argument is prose.
- Use: "finite entropy does not imply finite rank" is worth a model theorem before WP5, in the style of `ClockHypotheses.lean`. The entropy formula needs finite dimension, not finite entropy.

## 3. Jonathan Oppenheim, "Has AI come for quantum gravity?" (Substack, 2026-11-26)

https://superposer.substack.com/p/has-ai-come-for-quantum-gravity

One physicist's blog post, not peer reviewed. He says there may be mistakes in his details.

- A swarm of Claude referees listed 21 known obstacles to canonical quantisation and scored the paper: 1 solved, 7 sidestepped, 6 assumed, 7 not mentioned.
- The full list is at https://claude.ai/artifact/SXaWWPiDsnArgJffs4Ww7z?sk=F_TS3NTSc3rhD8UBIzAHNw . It could not be read from the review session. Michael can open it; it is a ready-made checklist against the hypothesis register.
- Criticisms he names, mapped to our register:

| His point | Our register |
|---|---|
| The finite-dimension proof assumes its conclusion | F2, H3a |
| Diffeomorphism invariance is imposed as an axiom, not shown | H3; Appendix E axiom 1 |
| The semiclassical limit relies on a Hamiltonian operator that is never constructed | H2; Sec 6 is out of scope |
| Reduced phase space quantisation depends on the reduction and on operator ordering; no check against Dirac quantisation | not registered. Candidate **H18** |
| The entropy is not obtained by counting microstates | F4: (5.39c) is an identity and no area eigenvalues are given |

- His three quick checks for any such paper: microstate counting, diffeomorphism invariance shown rather than assumed, and a classical limit with the Hamiltonian actually constructed.
- Related: https://github.com/Open-Science-Ledger/how-to-train-your-slop-cannon (Oppenheim, Osborne, Loader). Not read.

## 4. Seen but not read

- the-omega-institute/trureturing-books, pull request 1362: documentation, with a formalisation said to be pending.
- brandonrdug/holonics, pull request 1153.
- No response from the paper's author and no peer review were found as of 2026-11-26.

## 5. Suggested actions, in order

1. **Corollary, about ten lines.** On any infinite-dimensional Hilbert space the identity operator satisfies the open-gluing bound of `tsum_norm_inner_cut_le` and has unbounded partial traces by `finiteDimensional_iff_exists_sum_sq_norm_le`. So (4.29), (4.30) cannot imply H3a. Both ingredients are already proved here.
2. **H3c.** Register it, then prove the negative rank bound of 1.2 B and "bounded below along cuts of unbounded rank implies finite dimension" on top of `FiniteDim.lean`.
3. **Real part of the pair amplitude.** `Re C = (1/(2 s^2)) (pi^2/6 - pi/s + 1/s^2)` for `s >= 1/pi`. Section 12 of `handoff.md` records that Mathlib has the Bernoulli Fourier series. Test against 1.3. `FIDELITY.md` currently says the amplitude theorem "says nothing about the real part".
4. **Five-limits countermodel in our own terms.** Larger. Decide after items 1 and 2. Write it from the model description in 1.2 A, not from their Lean.
5. **`FIDELITY.md` updates.** F2: three independent audits agree. H12: Appendix E circularity. WP2-c entry: single cut only, with the Walsh counterexample as the reason. New candidate H18. Under "How the paper was read": that these external sources were read as described at the top of this file.
6. **Author note.** Consider one more question in `notes/note-to-author-draft.md`: for which family of cuts, and which insertions, are the closed partial sums required to reproduce the uncut amplitude, given the order-of-exhaustion counterexample.
7. **Second reader.** `FiniteDim.lean`, `CutSums.lean`, `BoostBound.lean` and `ClockWeightIntegral.lean` were reviewed by the separate review session on 2026-11-26 (statements re-derived by hand, Sec 5.2 of the TeX read at `main.tex` lines 1728 to 1830). `FIDELITY.md` still says `FiniteDim.lean` has had no second reader.
