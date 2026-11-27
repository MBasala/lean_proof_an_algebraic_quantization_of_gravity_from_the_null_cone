# HANDOFF: Formalizing "An algebraic quantization of gravity from the null cone"

Date: 2026-11-26
Owner: Michael
Status: first session done on 2026-11-26. WP0 is set up, WP1-a to WP1-g are proved, and Section 5 below is corrected. Findings and the current hypothesis register are in `FIDELITY.md`. This document remains the brief for whoever (person or agent) picks up the work. An independent review of WP1 was done the same day; the next steps are in Section 13.

---

## 1. Purpose

Produce a machine-checked account of what arXiv:2611.34924v1 actually proves, by formalizing its mathematical skeleton as **conditional theorems** with every unproved physical input exposed as a named hypothesis.

The deliverable is not "quantum gravity verified". It is:

1. A Lean development that compiles with no `sorry`.
2. A hypothesis register stating exactly which assumptions each headline result depends on.
3. A fidelity log pairing every formal statement with the paper's equation and noting any divergence.

## 2. Source

| Item | Value |
|---|---|
| Title | An algebraic quantization of gravity from the null cone |
| Author | Venkatesa Chandrasekaran (Leinweber Institute for Theoretical Physics, Stanford) |
| arXiv | 2611.34924v1, hep-th (cross-list gr-qc, math-ph), submitted 2026-11-25 |
| Length | 54 pages + appendices, 34 figures |
| Abstract page | https://arxiv.org/abs/2611.34924 |
| PDF | https://arxiv.org/pdf/2611.34924 |
| HTML | https://arxiv.org/html/2611.34924v1 |
| TeX source | https://arxiv.org/src/2611.34924 |
| Review status | Unreviewed preprint. No formal proofs released with it. |
| AI involvement | Acknowledgments credit an OpenAI model (named there as GPT-6 Astra, ~400M tokens) for several calculations and proofs. Which ones is not stated. |

## 3. What has been done so far, and how far to trust it

- The paper was read through **LLM extraction passes over the full PDF text**, not line by line by a human or by the author of this handoff.
- **Every equation number and section reference below came from that extraction. Treat them as pointers to verify, not as facts.** First task is to check them against the TeX source.
- The TeX source was downloaded on 2026-11-26 (v1, sha256 `1251f05a…3407be`) and unpacked to `paper/arxiv-src/`, which is git-ignored because the paper's arXiv licence does not allow redistribution. `paper/equation_index.tsv` maps every printed equation number to its LaTeX label and `main.tex` line. It was computed by `scripts/tex_label_index.py` without running TeX, and its numbers agree with all 528 equation tags found in the PDF text.
- Independently recomputed and confirmed by hand:
  - The pair-amplitude sum reduces to a dilogarithm, and its small-argument expansion gives a leading `-i log(s) / s^3` term (see WP1-a, WP1-b).
  - `q/(2(1-q)) - 1/2 = 106/45` iff `q = 257/302` (WP1-d).
  - `q = 2x^2/(1+x^2)` implies `q/(2(1-q)) = x^2/(1-x^2)` (WP1-e).
  - `u * (L/(L+u))^2 <= L/4` for `L > 0, u >= 0`, with equality at `u = L` (WP1-c).
- Nothing else has been verified.

## 4. Goal and non-goals

**Goal**

- Phase 1: WP0 to WP3. Self-contained mathematics. No physics input needed.
- Phase 2: WP4 and WP5. The headline claims (finite-dimensional diamond Hilbert space, entropy formula) as theorems conditional on the hypothesis register.
- Phase 3 (optional, research-grade): discharge hypotheses, starting with H1.

**Non-goals**

- Formalizing the classical reduced phase space of vacuum GR on intersecting null cones (Sec 3). It is an infinite-dimensional quotient by diffeomorphisms that the paper does not define rigorously. Axiomatize its outputs instead.
- Formalizing the one-loop semiclassical Einstein equations (Sec 6, App D.1).
- Any claim about whether the construction describes nature.

## 5. Paper map

Section boundaries and equation ranges below were rebuilt on 2026-11-26 from the PDF in the repository root (printed equation numbers, PyMuPDF text). They replace the extraction-based map. LaTeX labels for every equation are in `paper/equation_index.tsv`. "Read" means read directly for `FIDELITY.md`; other rows are indexed only and their content descriptions still come from the earlier extraction.

| Section | Pages | Equations | Content | Read? | Plan |
|---|---|---|---|---|---|
| 2.1 | 6-8 | 2.1 to 2.9d | JT warm-up: gravitational clock on a finite null cone | No | Optional later |
| 2.2 | 8-10 | 2.10a to 2.17b | JT quantization and gluing; infinitely many orthogonal states with identical clock statistics; infinite closed trace (2.17b) | (2.17) with its paragraph, and line 320 | Optional later |
| 3.1 | 11-14 | 3.1 to 3.16 | First order gravity; constrained BF action; vacuum equations | No | Axiomatize outputs |
| 3.2 | 14-17 | 3.17a to 3.31 | Null initial data; clock reading `u_*` (3.27), angular average (3.28); fn 8 | fn 8 and (3.27) only | Axiomatize outputs |
| 3.3 | 18-19 | 3.32 to 3.45 | Symplectic form with edge modes; canonical pairs (3.39, 3.42, 3.43) | No | Axiomatize outputs |
| 3.4 | 20-21 | 3.46 to 3.55 | Reduced Hamiltonian | No | Axiomatize outputs |
| 3.5 | 21-22 | 3.56a to 3.59 | Metric and dressed observables | No | Axiomatize outputs |
| 3.6 | 22-24 | 3.60a to 3.66 | Matching fields across subregions (3.62); classical gluing and additivity of the action; cited for the diffeomorphism-invariance step before (5.37), which it does not contain (F12) | Yes | Hypothesis H3 |
| 4.1 | 25-26 | 4.1 to 4.6 | Algebra of observables; causal factorization (4.2e); reduced action (4.5) | No | WP2 |
| 4.2 | 26-30 | 4.7 to 4.19b | Gaussian wavefunctions (4.7); Fock space (4.10); rank-one operators (4.11); pure state and GNS (4.16, 4.17); unitarity (4.18) | No | WP2 |
| 4.3 | 30-31 | 4.20 to 4.28 | Weyl ordering (4.20); clock operator (4.26, 4.27) | No | WP2, H13 |
| 4.4 | 31-34 | 4.29 to 4.34 | Cut-state sum (4.29); absolute convergence (4.30); truncation error (4.31); graviton pair amplitude (4.32 to 4.34) | Yes | WP1, WP2 |
| 5.1 | 35-38 | 5.1 to 5.20 | `H_D = P_D H_omega` (5.1, 5.2); existence argument (5.4 to 5.19); spanning statement (5.20) | Yes | WP4 |
| 5.2 | 38-45 | 5.21a to 5.49 | Area bound (5.21, 5.30a); boost weight (5.22, 5.23); trace-distance bound (5.32); contradiction (5.37, 5.38); thermal trace (5.39); AdS boundary spectrum (5.42 to 5.49) | Yes | WP4 |
| 5.3 | 45-49 | 5.50 to 5.69 | Entropy (5.50); marginal trapping (5.51); `q` (5.54); `log Z` (5.56 to 5.58); entropy formula (5.65); one-loop coefficient (5.66, 5.67); `q` value (5.68, 5.69); fn 23 with (5.60, 5.61) | Yes | WP5 |
| 5.4 | 49-51 | 5.70 to 5.77b | Spatial topology and null states; unit weight for each rank one projection in the physical trace (line 2141) | Line 2141 only | Out of scope |
| 6.1 | 52-53 | 6.1a to 6.5 | Classical solution | No | Out of scope |
| 6.2 | 53-54 | 6.6 to 6.16 | Graviton fluctuations and backreaction | No | Out of scope |
| App A | 54-59 | A.1 to A.42 | Null constraints and symplectic reduction | No | Out of scope |
| App B | 59-64 | B.1 to B.24 | Boundary terms in the Hamiltonian | No | Out of scope |
| C.1 | 64-65 | C.1 to C.6 | Physical inner product; change of variables on a cut | No | WP2 inputs |
| C.2 | 65-67 | C.7 to C.17 | Weyl ordering and contact terms; clock self-adjointness (C.11); `Psi_L` and norm limits (C.12 to C.16d); extension to number states (C.17) | From (C.13) | WP4 inputs, H1, H13 |
| C.3 | 67-68 | C.18a to C.22 | Boundary operators; rank-one operators (C.19); `E_N` limit (C.20); (C.21); generation claim after (C.22) | Yes | WP2 |
| D.1 | 68-70 | D.1a to D.12 | One-loop determinant, Schwinger-Keldysh action | No | Out of scope |
| D.2 | 70-73 | D.13 to D.36 | Corner boosts; proof of (5.32) in (D.22, D.23); cycle construction (D.24, D.25); remainder estimate (D.36) | Yes | WP4 inputs, H4 |
| D.3 | 73-76 | D.37 to D.55 | Focusing and graviton state count (D.45, D.46); replica ratio (D.47 to D.49) | Yes | WP4 inputs, H10, H11 |
| E.1 | 76-77 | E.1a to E.5 | Conditions on amplitudes (the axioms); cut independence is condition 1, finiteness of closed amplitudes is in condition 5 | Yes | WP3 |
| E.2 | 77-79 | E.6 to E.14c | Equivalence with the Euclidean formulation; integer weights of the Euclidean theorem (E.12) | Yes | WP3, H12 |
| E.3 | 79-80 | E.15a to E.18 | Realization in first order gravity; closing is the ordinary trace (E.15) | Yes | Deferred |

Corrections to the earlier map:

- (3.39) and (3.43) are in Sec 3.3, not 3.2. Sec 3.2 starts at (3.17a); (3.15a) is in Sec 3.1.
- (4.18) is in Sec 4.2. (4.26) is in Sec 4.3.
- (5.20) is in Sec 5.1. Sec 5.3 starts at (5.50), which is the entropy formula.
- C.1 is titled "Physical inner product". C.2 is "Weyl ordering and contact terms".
- App D runs to (D.55), App E to (E.18), Sec 6 to (6.16).
- The paper has appendices A and B, absent from the earlier map.
- Reference [36] is Colafranceschi, Dong, Marolf, Wang, arXiv:2310.02189. [51] is Carlip and Teitelboim, arXiv:gr-qc/9312002. [71] is Bastianelli, Bonezzi, Melis, arXiv:2206.13287. Sen is [34].

## 6. Work packages

### WP0. Setup

- Lean 4 with Mathlib, toolchain and Mathlib commit pinned.
- CI that fails on `sorry`, on new `axiom` declarations, and on build warnings.
- Directory layout: `Elementary/`, `OperatorAlgebra/`, `Axioms/`, `Diamond/`, `Entropy/`, `Hypotheses.lean`, `FIDELITY.md`.
- **Rule: physical inputs are structure fields or explicit theorem arguments, never global `axiom`s.** They must be visible in every theorem signature that uses them.
- Before writing anything, survey what already exists (see Section 9).

### WP1. Elementary analytic statements

Low risk. Good first targets and a calibration of tooling.

- **WP1-a (4.32, 4.33).** With `(Dq_k)^2 = 1/(2 s k)` and `s > 0`:
  `2 * sum_{k>=1} (Dq_k)^4 * exp(-2 i k / s) = (1/(2 s^2)) * sum_{k>=1} exp(-2 i k / s) / k^2`.
  The right-hand sum is `Li_2(exp(-2i/s))`. State it as a `tsum` identity so it does not depend on a dilogarithm definition.
- **WP1-b (4.34).** Two statements:
  1. Divergence of the naive expansion: the first-order term in `1/s` of the summand is `-(i/s^3) * sum 1/k`, which diverges (harmonic series).
  2. Finite resummed form: with `theta = 2/s`, `Im sum_{k>=1} exp(-i theta k)/k^2 = theta log(theta) - theta + O(theta^3)` as `theta -> 0+`. Hence the amplitude has leading imaginary part `-log(s)/s^3`.
- **WP1-c (5.17).** For `L > 0`, `u >= 0`: `u * (L/(L+u))^2 <= L/4`.
- **WP1-d (5.68, 5.69).** For `q != 1`: `q/(2(1-q)) - 1/2 = 106/45  <->  q = 257/302`.
- **WP1-e (5.61, footnote 23).** For `x^2 != 1`: `q = 2x^2/(1+x^2)` implies `q/(2(1-q)) = x^2/(1-x^2)`.
  Derived consequence to record: `q = 257/302` forces `x^2 = 257/347`, `x ~ 0.8606`, where `x = (1-eps) r_h / l`. Per extraction the paper does not justify this ratio. See H8. Corrected on 2026-11-26 by B3 of Section 14: the ratio is an output of the theory, not a free parameter. See finding F3 in `FIDELITY.md`.
- **WP1-f (footnote 8, 3.27).** `(1-eps) sqrt(A/4pi) <= mean clock reading`, by Cauchy-Schwarz on the corner sphere. Needs the exact definition from 3.27 before it can be stated. Done on 2026-11-26 in `QuantGrav/Elementary/ClockLowerBound.lean`, with the average of (3.28) read from the TeX.

Statement sketches. **Superseded; marked on 2026-11-26.** They were written before anything was compiled and are kept as a record of the brief. The `sorry` placeholders below are not part of the development. The proved statements are:

- `clock_weight_le` in `QuantGrav/Elementary/ClockWeight.lean`: the first sketch, with the same statement.
- `log_coefficient_eq_iff` in `QuantGrav/Elementary/LogCoefficient.lean`: the second sketch, over the real numbers instead of the rationals.

```lean
theorem clock_weight_bound (L u : ℝ) (hL : 0 < L) (hu : 0 ≤ u) :
    u * (L / (L + u)) ^ 2 ≤ L / 4 := by
  sorry

theorem q_value (q : ℚ) (hq : q ≠ 1) :
    q / (2 * (1 - q)) - 1 / 2 = 106 / 45 ↔ q = 257 / 302 := by
  sorry
```

### WP2. Operator-algebra layer

Standard mathematics. The point is to show which "results" are automatic.

- **WP2-a (4.16, 4.17).** A pure state on a C*-algebra has an irreducible GNS representation, so `pi_omega(A)'' = B(H_omega)`. This is the paper's type I claim. Expect it to follow from purity alone.
- **WP2-b (4.10c, 4.11).** Fixed-area space as a bosonic Fock space `K_A = ⊕_m Sym^m l^2(N)`; the algebra generated by the canonical pairs is `B(K_A)`.
- **WP2-c (4.18, 4.30).** For bounded operators `U_1, U_2`, vectors `a, b`, and an orthonormal basis `{n}`: `sum_n |<a|U_2|n><n|U_1|b>| <= ||U_2† a|| * ||U_1 b||`. This is the "absolutely convergent sums over intermediate states" claim. Expect it to hold for any bounded operators, not only for this theory.
- **WP2-d (4.31).** If projections `P_j` increase strongly to the identity, the truncation error tends to zero. The paper asserts the premise; record it as H5.
- **WP2-e (C.21).** `P X Y P = (P X P)(P Y P) + P X (1-P) Y P`. One line.
- **WP2-f (C.19, C.20, C.22).** Rank-one operators from Weyl quantization; norm convergence `E_N -> |Omega_A><Omega_A|`; generation of all bounded operators on `P_D(A) K_A`. The generation claim is only sketched in the paper. Either prove it or register it.

### WP3. Appendix E as an axiom system

- Encode the five axioms as a Lean structure: diffeomorphism invariance, reality and positivity, factorization, continuous unitary evolution, spectral finiteness (E.4, E.5).
- Derive: Hilbert algebra with trace (E.6, E.7); reflection positivity (E.8, E.9); the isometry `V` with `V C_L(s) V† = C_E(s)` (E.14).
- The type I structure with integer weights and the converse (Euclidean to Lorentzian) direction are imported from the paper's reference [36]. Obtain [36]; decide whether to formalize or register as H12.
- Do not attempt E.3 (realizing the axioms in first-order gravity) in Phase 1. It depends on WP4.

### WP4. Finite-dimensional diamond Hilbert space (Sec 5.1, 5.2)

The central claim. Target form:

> Given H1, H2, H3, H4 (and whatever else surfaces), `dim H_D < infinity`, the area operator restricted to `H_D` has finitely many eigenvalues, and the largest satisfies `s <= s* = pi l(D)^2 / (G hbar (1-eps)^2)` (5.30a).

Known soft spots, per extraction:

- The step `|| Psi_L - Omega_A || -> 0` as `L -> infinity` is supported in the paper only by "strong evidence" (near 5.1 and 5.7). Footnote 18 concedes a classical bound was applied to noncommuting operators (those in 4.26). This is H1.
- The contradiction argument for (5.38) uses a pigeonhole step that is fine for countable dimension and needs care otherwise.
- (5.39c), `d_D = Z * Tr(rho_D * exp(A/4G hbar))`, reduces to `Tr(1) = d_D`. It is an identity, not an independent count.
- (5.20) is a spanning statement, not a dimension formula.
- The paper gives no area eigenvalues or spacings.

### WP5. Entropy (Sec 5.3)

Target form:

> Given WP4, H6, H7, H8: `S(rho_D) = <A>/(4 G hbar) + [q/(2(1-q))] * log(<A>/(4 G hbar)) + o(log)` (5.65).

Questions the formalization must answer:

- Is `q` (5.54b: limit of mean clock reading over `l(D)`) computed independently, or solved for so the coefficient equals 106/45? Per extraction it is solved for. Confirm against the source. This decides whether the match with Sen (arXiv:1205.0971) is a prediction or a consistency condition.
- The 1/4 follows from `K = A/(8 pi G)` (5.22) plus continuation of the boost to `i pi` and squaring (5.23). Trace the 8 pi G normalization back to (3.43) and record it as H6.
- Which ensemble: the paper compares at fixed mass with angular momenta summed (5.69). Check this against the ensemble in Sen's result.

### WP6. Deferred

Classical phase space (Sec 3), semiclassical equations (Sec 6, D.1), topology (5.4), JT warm-up (Sec 2).

## 7. Hypothesis register (initial)

Maintain in `Hypotheses.lean` and `FIDELITY.md`. Add entries as they surface. Never delete; mark as discharged with a link to the proof.

| ID | Statement | Paper location | Paper's support |
|---|---|---|---|
| H1 | `‖Psi_L - Omega_A‖ -> 0` as `L -> infinity` | 5.1, 5.7, fn 18 | "Strong evidence"; heuristic |
| H2 | Amplitude maps `U_M` are unitary | 4.18 | Assumed |
| H3 | Cut-state sum equals uncut amplitude | 4.29, Sec 3.6 | Diffeomorphism-invariance argument |
| H4 | Bound on boost-sensitive observable over cycle-closed projections | 5.32, D.22 to D.36 | Appendix argument, unverified |
| H5 | Truncation projections converge strongly to identity | 4.31 | Asserted |
| H6 | Boost generator is `A/(8 pi G)` | 5.22, 3.43 | Classical corner symplectic structure |
| H7 | One-loop log coefficient `(106/45) log s_b` from a bulk curvature integral | 5.67a to 5.67c, ref [71] | Imported |
| H8 | `q` exists as a limit; its value | 5.54b, 5.69, fn 23 | Possibly fitted |
| H9 | Choice of pure extension `omega`; unitary equivalence of other choices | 4.16, fn 20 | Deferred by author |
| H10 | `log d(s) ≲ 1 + (s Q*)^(3/4)` | D.46c | Unspecified constants |
| H11 | Gauss-Bonnet disk factor `exp(-s)` | App D.3, ref [51] | Citation |
| H12 | Type I with integer weights; Euclidean-to-Lorentzian converse | E.12, ref [36] | Citation |

## 8. Fidelity and audit rules

The known failure mode in AI-assisted formalization is a formal statement that is weaker than the prose claim while the proof still compiles.

- Every theorem gets a `FIDELITY.md` entry: paper equation, verbatim-in-substance prose claim, formal statement in plain English, and a "differs from paper?" field.
- Any weakening (extra hypothesis, restricted domain, changed quantifier) is logged before merging.
- No `sorry`, no `native_decide`, no new `axiom`. Run `#print axioms` on every headline theorem and commit the output.
- Definitions get the same scrutiny as theorems. A wrong definition of `H_D` or of the area operator makes the downstream proofs meaningless.
- A second reader (or a fresh agent with no access to the proof) reviews statements against the paper before a work package is closed.

## 9. First-session checklist

1. Download the TeX source and build an authoritative equation and label index. Correct Section 5 of this file.
2. Reread Sec 5.1 to 5.3 and App C.3, D.2, D.3 directly. Confirm or correct the soft spots in WP4 and WP5.
3. Survey existing formal libraries at the pinned versions. Do not assume; check:
   - Mathlib: C*-algebras, states, GNS, double commutant, von Neumann algebras, symmetric tensor powers / Fock space, polylogarithm or Clausen function, asymptotics API.
   - physlib (leanprover-community/physlib, formerly PhysLean).
   - MathlibAnnex Naimark project (arXiv:2609.26930) for pure states and GNS kernels.
   - Douglas, Hoback, Mei, Nissim, "Formalization of QFT" (arXiv:2603.15770) for method and reusable Gaussian-measure infrastructure.
   - Isabelle AFP entry "The Gelfand-Naimark-Segal Construction" as a reference proof.
4. Do WP1-c and WP1-d end to end, including CI and fidelity entries, to validate the pipeline.
5. Report back: corrected paper map, library gaps, and an effort estimate for WP2 and WP3.

## 10. Open decisions for Michael

- Proof assistant: Lean 4 + Mathlib assumed. Confirm.
- Repository: location and visibility.
- Scope of first push: Phase 1 only (recommended), or straight to WP4.
- Whether to contact the author for the TeX-level details of 5.1 and for any existing formal artifacts.
- Whether the work is done by hand, by an agent, or mixed; this changes how strict Section 8 review needs to be.

## 11. References

- Chandrasekaran, "An algebraic quantization of gravity from the null cone", arXiv:2611.34924v1.
- Sen, "Logarithmic Corrections to Schwarzschild and Other Non-extremal Black Hole Entropy in Different Dimensions", arXiv:1205.0971.
- Douglas, Hoback, Mei, Nissim, "Formalization of QFT", arXiv:2603.15770.
- "A separably representable counterexample to Naimark's problem in ZFC", arXiv:2609.26930 (Lean development with GNS).
- Schmoetten, Fleuriot, "The Gelfand-Naimark-Segal Construction", Isabelle AFP, 2026.
- physlib: https://github.com/leanprover-community/physlib

## 12. Library survey (2026-11-26)

Answers checklist item 3. The Mathlib rows come from grep over the pinned checkout (tag `v4.37.0-rc1`, commit `31ce06ea`); four of them were spot-checked by hand. The external rows were read from the web by a research agent through a summarising fetcher. Nothing external was cloned or compiled, so treat names and pins there as pointers to verify.

### Pinned Mathlib

| Need | State | Where |
|---|---|---|
| GNS space and representation | Present: `PositiveLinearMap.GNS`, `gnsStarAlgHom` | `Mathlib/Analysis/CStarAlgebra/GelfandNaimarkSegal.lean` |
| Cyclic vector, states, pure states, irreducibility, Schur | Absent. The GNS file lists the cyclic vector as a TODO | |
| von Neumann algebras | `VonNeumannAlgebra` takes "equals its double commutant" as a field. No bicommutant theorem, factors or type classification | `Mathlib/Analysis/VonNeumannAlgebra/Basic.lean` |
| Parseval over a Hilbert basis | Present: `HilbertBasis.hasSum_inner_mul_inner`, `tsum_inner_mul_inner` | `Mathlib/Analysis/InnerProductSpace/l2Space.lean` |
| Hölder for infinite sums | Present: `inner_le_Lp_mul_Lq_tsum_of_nonneg` | `Mathlib/Analysis/MeanInequalities.lean` |
| Increasing projections converge strongly | Present per vector: `starProjection_tendsto_self` | `Mathlib/Analysis/InnerProductSpace/Projection/Submodule.lean` |
| Rank-one operators | Present: `InnerProductSpace.rankOne` | `Mathlib/Analysis/InnerProductSpace/LinearMap.lean` |
| Trace class, Hilbert-Schmidt, infinite-dimensional trace | Absent. Trace is finite-dimensional only | |
| Fock space, Hilbert tensor powers | Absent. `SymmetricPower` is algebraic; inner product exists only on binary `TensorProduct` | |
| Dilogarithm, Clausen function | Absent. `hasSum_zeta_two` and the Bernoulli Fourier series exist | `Mathlib/NumberTheory/ZetaValues.lean` |
| Harmonic series diverges | Present: `Real.not_summable_one_div_natCast` | `Mathlib/Analysis/PSeries.lean` |
| Asymptotics near `0+` | Present: `=O[𝓝[>] 0]`, `Real.tendsto_log_nhdsGT_zero` | `Mathlib/Analysis/Asymptotics/Defs.lean` |
| Weyl / CCR algebra, Hermite functions as a basis | Absent | |
| von Neumann entropy, density operators | Absent. `Real.negMulLog` exists | |

Note for writing Lean here: Mathlib files are modules, so project files start with `module` and use `public import`. `Mathlib.Data.Real.Basic` is deprecated in favour of `Mathlib.Basic.Real.Basic`. `orthogonalProjection` is deprecated in favour of `Submodule.starProjection`.

### Unbounded operators and spectral theory (checked 2026-11-26 for Step 3)

By grep over the same pinned checkout.

| Need | State | Where |
|---|---|---|
| Unbounded operators | Present: `LinearPMap` (`E →ₗ.[𝕜] F`), its adjoint, `IsSelfAdjoint` for it, `IsSelfAdjoint.dense_domain`, `IsSelfAdjoint.isClosed`, closable operators and closures | `Mathlib/Analysis/InnerProductSpace/LinearPMap.lean`, `Mathlib/Topology/Algebra/Module/LinearPMap.lean` |
| Spectral theorem | Compact self-adjoint operators and finite dimension only. Continuous functional calculus exists for bounded operators | `Mathlib/Analysis/InnerProductSpace/Spectrum.lean` |
| Spectral measure, projection-valued measure, Borel functional calculus, spectral projections `1_I(T)` of an unbounded `T` | Absent | |
| Closed quadratic forms, Friedrichs extension, monotone convergence of forms, resolvent of a `LinearPMap` | Absent | |
| Measure from a monotone right-continuous function | Present: `StieltjesFunction` | `Mathlib/MeasureTheory/Measure/Stieltjes.lean` |

Consequence: `P_D = 1_{[0, l(D)]}(u)` cannot be defined from an operator here. `QuantGrav/Diamond/Setup.lean` represents the clock and the area operator by their families of spectral projections instead.

### External (not verified locally)

| Source | Pin | Relevant content | Use |
|---|---|---|---|
| MathlibAnnex, https://github.com/r-tanaka-math/mathlib-annex (arXiv:2609.26930) | Lean 4.35.0, Apache-2.0 | `stateSpace`, `IsPureState`, cyclic GNS vector, `isPureState_iff_gnsStarAlgHom_isIrreducible`, Schur (`StarAlgHom.eq_algebraMap_of_irreducible`), bicommutant theorem, type decomposition. The paper says the Lean source was produced by an AI model | Port the specific files for WP2-a and re-check each under this pin. Do not add as a dependency |
| physlib, https://github.com/leanprover-community/physlib | Lean 4.36.0, Apache-2.0 | `L²(ℝ)` Hilbert space, Gaussians in `L²`, Hermite functions, ladder operators on Schwartz space, finite-dimensional `MState` and von Neumann entropy, a `GlimmJaffeAxioms` structure. No Fock space | Copy files as needed for WP2-b, WP5 |
| OSforGFF, https://github.com/mrdouglasny/OSforGFF (arXiv:2603.15770) | Lean 4.33.0-rc1, Apache-2.0 | OS axioms as one `Prop` definition each, bundled in a `Prop`-valued structure; reflection positivity as a positive-semidefinite sum | Pattern for WP3 |
| Isabelle AFP "Gelfand-Naimark-Segal", https://isa-afp.org/entries/Gelfand_Naimark_Segal.html | Isabelle | GNS with cyclic vector. No pure states, no irreducibility | Blueprint only |
| Mathlib PR 44531 | open | `Complex.polylog`, no dilogarithm identities | WP1-a, WP1-b must be stated as `tsum` identities, as planned |

The source paper's arXiv listing has no ancillary files and no mention of formal proofs.

## 13. Next steps (set 2026-11-26, after independent review of WP1)

### State at this point

- WP0 is done. WP1-a to WP1-e are proved: 15 theorems pinned in `QuantGrav/Audit.lean`, all on Lean's three standard axioms.
- Independent review of WP1 (separate session, 2026-11-26): every statement in `QuantGrav/Elementary/` was re-derived by hand and matches (4.32) to (4.34), (5.17), (5.61), (5.68), (5.69). `paper/arxiv-src/main.tex` lines 1996 to 2100 were read directly. The reconstruction behind `q_of_growth_exponent_iff` and `log_coefficient_roundtrip` is correct, and so is finding F3.
- The reviewer did not rerun the build. The evidence for it is indirect: build artifacts exist for every module, their logs are clean, and the declaration positions in the `.ilean` files match the current sources.
- None of H1 to H14 has a formal statement. No headline claim of the paper (finite dimension, entropy formula, type I factor, semiclassical equations) is formalized.
- The work so far does not change how likely the paper is to be right, with one exception: the agreement with Sen in (5.69) is now known to return the coefficient imported at (5.67c), for any value of that coefficient.

### Step 0. Housekeeping

1. Add a remote and push. CI has never run, because the repository has no remote.
2. From a clean checkout run `lake exe cache get`, `lake build --wfail` and `bash scripts/check_forbidden.sh`. Record the date, commit and result in `FIDELITY.md`.
3. Line endings: `handoff.md` and `FIDELITY.md` showed as modified against HEAD only because of CRLF. Add `*.md text eol=lf` (and `*.tsv`, `*.toml`, `*.yml`) to `.gitattributes`, renormalize and commit.
4. Record the WP1 review above in `FIDELITY.md` under "How the paper was read", which still says no second reader has reviewed the entries. Re-check findings F1, F2 and F4 against the TeX. F3 and F5 are confirmed.
5. Move to the stable `v4.37.0` toolchain and Mathlib tag once they exist. The current pin is a release candidate.
6. Remove the template "GitHub configuration" section from `README.md`. Mark the two `sorry` sketches in Section 6 (WP1) of this file as superseded by `ClockWeight.lean` and `LogCoefficient.lean`.
7. Choose a licence so that `linter.style.header` can be switched back on.

### Step 1. Finding F2 as a conditional theorem (highest value)

Why first: it would show which single hypothesis the central claim rests on, and it needs no new infrastructure.

Read first, in `paper/arxiv-src/main.tex`: (5.30c) at line 1746, (5.37a) at 1811, (5.37b) at 1815, (5.38) at 1823, (D.24) at 3373, and the AdS argument (5.44) to (5.46). Question to settle: is the uncut amplitude with no insertion assumed finite?

Then prove, in `QuantGrav/Diamond/FiniteDim.lean`, this abstract statement. It uses no physics and no infinite-dimensional trace:

> Let `H` and `K` be complex Hilbert spaces, `C : H →L[ℂ] K` bounded, `c > 0` with `c * ‖v‖^2 ≤ ‖C v‖^2` for all `v`, and `Z` a real number with `∑ i, ‖C (e i)‖^2 ≤ Z` for every finite orthonormal family `e` in `H`. Then `H` is finite-dimensional and `finrank H ≤ Z / c`.

Mapping to the paper: `c = e^{-s_*} m_{b,D}` from (5.30c). The bound `Z` is what H3 supplies when it is applied with no insertion.

Follow-up in the register:

- Split H3 into H3a (no insertion: partial traces of `C_b† C_b` are bounded) and H3b (with the insertion `X` of (5.37a)).
- Record in `FIDELITY.md` whether the paper's own argument needs H3b and H4 at all.
- If the theorem goes through, state the consequence plainly in the log: given the lower bound (5.30c), `dim H_D < ∞` holds exactly when the partial traces of `C_b† C_b` are bounded. The finiteness claim is then only as strong as the diffeomorphism-invariance argument of Sec 3.6 behind H3a.

### Step 2. Quick items

Mathlib already has the ingredients for the first three; see Section 12.

- WP2-c, from `HilbertBasis.hasSum_inner_mul_inner` and Cauchy-Schwarz.
- WP2-d, from `starProjection_tendsto_self`.
- WP2-e, one line.
- New WP2-g: `‖exp(i x) - 1‖ ≤ |x|` and the bound (5.32) derived from it as in (D.22), (D.23). Finding F4 notes this step is elementary.
- New WP1-g, the integrated clock bound. For a probability measure `μ` on `[0, ∞)` and `L, ℓ > 0`: `∫ u * (L / (L + u))^2 dμ ≤ L / 4`, and `∫_{u > ℓ} (L / (L + u))^2 dμ ≤ L / (4 ℓ)`. This is (5.17) with the spectral measure of the clock replaced by an arbitrary `μ`, so it does not depend on H13.

### Step 3. Definitions gate

No formal statement of H1, H13 or H14 before this is done.

1. Check the pinned Mathlib for unbounded self-adjoint operators and the spectral theorem. If support is thin, model the clock by its family of spectral projections `ℓ ↦ P_ℓ` instead of an operator.
2. Write `QuantGrav/Diamond/Setup.lean`: a structure holding the Hilbert space `K_A`, the clock data, an area operator commuting with it, and the vector `Ω_A`.
3. Have the definitions reviewed against (4.27), (5.1), (5.2) and (C.11) to (C.17) by a reader who did not write them.
4. Only then give H1, H13 and H14 formal statements in `Hypotheses.lean`.

### Step 4. WP2-a and WP3

- WP2-a: port "pure state implies irreducible GNS representation" from MathlibAnnex, which is pinned to Lean 4.35 and was produced by an AI model according to its paper. Re-check each ported file under this project's pin. Do not add it as a dependency.
- WP2-b and WP2-f are blocked: Mathlib has no Fock space, no Hilbert tensor powers and no trace class. Leave them registered. Do not build that infrastructure here without a decision from Michael.
- WP3 after WP2-a. Obtain the paper's reference [36] (arXiv:2310.02189) first.

### Step 5. WP5 open question

Read Sen (arXiv:1205.0971). Record his logarithmic coefficient for a four-dimensional Schwarzschild black hole in pure gravity and the ensemble it belongs to, and compare with the paper's "fixed mass, angular momenta summed" in (5.69). Nobody has done this yet.

### Step 6. Questions for the author

Draft a short note. Michael decides whether to send it.

1. Footnote 23 gives `q = 2x^2 / (1 + x^2)` with `x = (1 - eps) r_h / l`, and (5.68) gives `q = 257/302`. Both hold only if `x^2 = 257/347`. Is `l(D) / r_h` fixed by consistency, or is one of the two evaluations approximate?
2. Is there an evaluation of `q` that does not use (5.67c)? Otherwise the agreement with Sen in (5.69) holds by construction once the one-loop coefficient is granted.
3. Is the dense domain of the clock (footnote 14) established independently of the estimate (5.8) to (5.16)?
4. At (5.37b), is the uncut amplitude with no insertion assumed finite?
5. Are formal artifacts, or records of the model's derivations, available for the proofs the acknowledgments credit to an AI model?

### Progress on these steps (2026-11-26)

- Step 0.1: done by Michael. `origin` is a private GitHub repository and `main` is pushed.
- Step 0.2: done for commit `1651972`, with `.lake/packages` linked instead of downloaded again. Recorded in `FIDELITY.md`.
- Step 0.3: done. `.gitattributes` now covers `.md`, `.tsv`, `.toml` and `.yml`.
- Step 0.4: done. F1 and F4 hold against the TeX; the (5.20) item in F4 was corrected to a density statement. F2 was replaced by the result of Step 1.
- Step 1: done. `QuantGrav/Diamond/FiniteDim.lean` proves the abstract statement and its converse. H3 is split into H3a and H3b, and H15 is added for (5.23). Answer to the question: the paper does not state that the uncut amplitude with no insertion is finite, but the sentences around (5.38) use its squared norm as a positive real number. See finding F2 in `FIDELITY.md`.
- Step 2: done. WP2-c, WP2-d, WP2-e in `QuantGrav/OperatorAlgebra/CutSums.lean`, WP2-g in `QuantGrav/OperatorAlgebra/BoostBound.lean`, WP1-g in `QuantGrav/Elementary/ClockWeightIntegral.lean`. H5 is proved for increasing sequences of subspaces with dense union and remains a hypothesis otherwise. None of these files has had a second reader.
- Step 3: done.
  - Item 1: the pinned Mathlib has `LinearPMap` with adjoint and self-adjointness but no spectral theorem, spectral measure or closed forms for unbounded operators; see Section 12.
  - Item 2: `QuantGrav/Diamond/Setup.lean` models the clock and the area operator by their spectral projections, on `H_omega`, with `K_A` a closed subspace.
  - Item 3: reviewed by an independent reader with no access to this file, `FIDELITY.md` or `Hypotheses.lean`. No field wrong; one gap (positivity of the area) and several citations fixed. Recorded in `FIDELITY.md`.
  - Item 4: `DiamondSetup.H1`, `DiamondSetup.H13`, `DiamondSetup.H14` in `QuantGrav/Hypotheses.lean`, with first consequences in `QuantGrav/Diamond/ClockHypotheses.lean`. The same reader checked the final statements in a second pass and required nothing further. `DiamondSetup.H14a`, the fixed-area half of H14, was added afterwards at its suggestion.
  - New register entries H16 and H17: the clock and the area operator on `H_omega` are assumed, not constructed (finding F6). H13 was narrowed to density on `K_A`.
  - Not done in Step 3, and candidates for WP4: split `DiamondSetup` into a fixed-area part and an `H_omega` part so that H1 and H13 do not formally depend on the assumed extension; define the distribution of clock readings as a Stieltjes measure, which would connect WP1-g to the setup and let `‖Psi_L - Omega_A‖` be stated.
- Step 5: done. Sen's paper was read directly. The paper's (5.69) is Sen's mixed ensemble (his (1.4): fixed mass, all angular momenta summed), not his microcanonical or singlet result; in four dimensions that coefficient is the local coefficient `212/45` of `ln a` alone, which is what (5.67c) imports. Finding F9 in `FIDELITY.md`; arithmetic in `QuantGrav/Entropy/SenComparison.lean`.
  - Candidate for WP1, found while reading (5.66): with `sigma_s^2 = 2 s_b` the paper says `int_0^infinity exp(-(s - s_b)^2/(4 s_b)) ds_b/(4 pi s_b)^(1/2) = 1` for every `s > 0`. It checks numerically and follows from the substitution `s_b = t^2` and the Cauchy-Schlomilch identity. Not formalized.
- CI: GitHub Actions cannot complete on this repository because the runner does not have enough disk space (Michael, 2026-11-26). The gates are run locally before each commit: `bash scripts/check_forbidden.sh` and `lake build --wfail`.
- Step 0.7: done. Licence is MIT (Michael, 2026-11-26). `LICENSE` is added, `lakefile.toml` has `license = "MIT"`, the header linter is on again with its licence line set to MIT through the option `linter.style.header.license`, and every Lean file under `QuantGrav/` carries the header. The copyright holder and the `Authors:` line are the git author name; change them in `LICENSE` and the file headers if that is not what is wanted.
- Step 6: drafted, not sent. `notes/note-to-author-draft.md` has six questions: the five listed in Step 6, plus how the clock is defined on `H_omega` outside `K_A` (finding F6), with the choice among Sen's ensembles folded into the question about `q` (finding F9). The file lists what to settle before sending. Michael decides whether to send it.
- WP1-f: done (2026-11-26). `QuantGrav/Elementary/ClockLowerBound.lean` proves footnote 8, `(1 - eps) sqrt(A/(4 pi)) <= mean clock reading`, together with its steps: nonnegativity of the focusing term (3.26c), the bound per generator (3.27), Cauchy-Schwarz on the sphere, and the equality case. These are the classical forms of (5.21a) to (5.21c); the operator inequalities remain H14 and H14a. With this, every item listed under WP1 in Section 6 is proved, and WP1-g from Step 2 as well.
- External audits (2026-11-26). `notes/external-audits-2026-11-26.md`, written by a separate review session, collects what others published about the paper that day and what to do with it. Its section 5 was acted on:
  - Items 1 and 2: `QuantGrav/Diamond/ClosedCuts.lean`. Open gluing cannot imply H3a; on cuts whose response stays a margin `gamma` below `delta/2` the closed amplitude is at most `-(c gamma) rank P` (stated with `delta/4` until the second-reader review of 2026-11-26); a lower bound on it along such cuts (new register entry H3c) already gives finite dimension, without H3b or H4. Finding F10.
  - Item 3: `QuantGrav/Elementary/PairAmplitudeReal.lean`. The real part of the pair amplitude is `(1/(2 s^2))(pi^2/6 - pi/s + 1/s^2)` for `s >= 1/pi`, exactly.
  - Item 4: `QuantGrav/Diamond/OrderOfExhaustion.lean`. Decision: done, in a simplified form with the insertion `delta F ⊗ F̄ - delta/2` put in directly instead of derived from a boost. Five increasing exhaustions of one basis give closed amplitudes that tend to plus infinity, equal `w delta`, `0`, `-w delta`, and tend to minus infinity, while the open sums of (4.29) converge to the same limit along all of them. Three of the five satisfy the left inequality of (5.37b) on every nonempty cut. So H3b cannot come from open gluing. Written from the model description in section 1.2 A of the note; their Lean was not read.
  - Item 5: `FIDELITY.md` records the external sources and how far they were read, F10, the single-cut limit of WP2-c, the App E circularity under H12, and a candidate entry H18 (dependence on the reduction and on operator ordering).
  - Item 6: question 2 of `notes/note-to-author-draft.md` now asks for which cuts and insertions the closed partial sums must reproduce the uncut amplitude.
  - Item 7: the second-reader record for `FiniteDim.lean`, `CutSums.lean`, `BoostBound.lean` and `ClockWeightIntegral.lean` is in `FIDELITY.md`.
- Step 0.6: done. The template "GitHub configuration" section is removed from `README.md`, and the two sketches in Section 6 (WP1) are marked as superseded by `clock_weight_le` and `log_coefficient_eq_iff`.
- Step 0.5: not started. Checked on 2026-11-26: `v4.37.0-rc1` is the only `v4.37.0` tag in both the Lean and the Mathlib repositories, so there is no stable release to move to yet.
- Step 4: not started.

### Order for the next session

Superseded on 2026-11-26 by Section 14.4.

### Decisions needed from Michael

- Where the remote lives and whether it is public. Decided: a private GitHub repository.
- Licence. Decided on 2026-11-26: MIT.
- Whether to send the note in Step 6.
- Whether porting AI-produced MathlibAnnex files is acceptable under the review rules of Section 8.

## 14. Direction from review (2026-11-26, 14:30): prove what can be proved, and try to break it

Written by the review session at Michael's request. It replaces "Order for the next session" in Section 13. Michael's goal: a working Lean development that goes as far as can be expected toward proving the paper, and that also tries to disprove it by breaking the model.

Everything in 14.2 marked "reviewer's reading" comes from the TeX lines cited and has had no second reader. Treat it as a lead to confirm, not a finding.

### 14.1 Rules for this phase

- Two tracks. Track B (break) goes first: a successful break changes what Track A should assemble.
- Every break attempt ends in exactly one of four outcomes, recorded in `FIDELITY.md`:
  1. **Inconsistent**: a Lean theorem that a named set of the paper's displayed statements implies `False`.
  2. **Invalid inference**: a Lean countermodel satisfying the stated premises of a step and violating its conclusion. `OrderOfExhaustion.lean` is the pattern.
  3. **Consistent**: a Lean proof that the suspected tension is not one.
  4. **Undecided**, with the exact missing input.
- Before any outcome 1 or 2 is described as a disproof of the paper: the equations involved are re-read in the TeX by a reader who did not write the Lean, the formal statement is checked against them, and the result is added to `notes/note-to-author-draft.md`. A countermodel to an inference is not a counterexample to the theory. Say which one it is.
- Outcome 3 is as valuable as outcome 1. Do not stretch a result.

### 14.2 Track B: break attempts, in order

**B1. Is the clock finite on the Gaussian state once every mode is included? (H1, H13, (5.19))**

This is the best lead. Reviewer's reading:

- The argument for (5.19) holds "at fixed angular and radial resolution". The phrase is at `main.tex` lines 1500, 3067 and 3116, and a search for "resolution" finds no place where the resolution is removed.
- The step (C.16), lines 3116 to 3123, needs a compact set `K` in the regular domain carrying `1 - delta` of the Wigner measure, on which the focusing `Xi_y(1)` is bounded.
- The focusing is a positive quadratic form in derivatives of the conformal metric: (4.22) at line 1188 and (C.15) at line 3108, `Xi_y(1) = (1/4) ∫ v [(∂_v z^1)^2 + e^{2 z^1} (∂_v z^2)^2] dv`. No vacuum subtraction: positivity is what (5.21) uses.
- The incoming state is a product Gaussian over infinitely many modes with variances `(Δq_k)^2 = 1/(2 s k)` (4.32).
- For a Gaussian measure, a positive quadratic form `Q = sum a_k q_k^2` is finite almost surely iff `sum a_k sigma_k^2` converges, and is infinite almost surely otherwise. With `sigma_k^2 = 1/(2 s k)` the series diverges unless the focusing weights `a_k` decay, and a derivative-squared form makes them grow.
- If it diverges: the probability that the clock is below any `L` tends to `0` as the resolution is removed, so `P_M Omega_A = 0`, (5.19) fails in that limit, and `H_D` as built in (5.20) is trivial. If the paper intends a permanent mode cutoff, that is an unstated hypothesis and it limits every claim about short wavelengths.
- An external audit reports the same phenomenon for the source in (4.33): the uncentred positive quadratic form is infinite on every nonzero state (`notes/external-audits-2026-11-26.md`, 1.2 G item 2).

Work:

1. Read and extract exactly: the mode expansion and Gaussian widths, (4.7) to (4.10) and (4.32); how `z^1(v)` depends on the canonical pairs; the capped form (C.11) and its limit (C.13); where "resolution" is defined, and whether any statement is uniform in it.
2. Prove the mathematics, independent of the paper:
   - G1: for `x_k >= 0`, `prod_{k<N} (1 + x_k) >= 1 + sum_{k<N} x_k`. For a positive semidefinite matrix `A`, `det(1 + A) >= 1 + tr A`.
   - G2: for a centred Gaussian of variance `sigma^2` and `t, a >= 0`, `E exp(-t a q^2) = (1 + 2 t a sigma^2)^(-1/2)`.
   - G3: for independent centred Gaussians and `Q_N = sum_{k<N} a_k q_k^2` with `a_k >= 0`, and any `c > 0`: `P(Q_N <= c) <= e * (1 + (2/c) sum_{k<N} a_k sigma_k^2)^(-1/2)`. So if the series diverges, `P(Q_N <= c) -> 0` for every `c`.
   - Only the first polarisation is needed: `Xi >= (1/4) ∫ v (∂_v z^1)^2 dv`, which is purely quadratic.
3. Insert the paper's `a_k` and `sigma_k^2`. `tendsto_harmonic_atTop` already gives divergence whenever `a_k` is bounded below.
4. Outcome 1 if the series diverges and the paper claims (5.19) with all modes. Outcome 3 if it converges; then record the convergent series as the content of H1 at zeroth order. If the paper keeps the cutoff, register it as a new hypothesis (H19: fixed resolution) and state which results depend on it.

**B2. Where are the `e^s` states? (entropy, H10, H11, (5.63), (D.45) to (D.49))**

Reviewer's reading:

- Footnote 24, (5.63), claims `dim(1_{[0, a s_*]}(ŝ) H_D) = exp[a s_* + o(s_*)]`: about `e^s` orthogonal states per unit of `s`.
- (D.46c), line 3529, bounds the number of graviton states at fixed `s` by `log d(s) ≲ 1 + (s Q_*)^(3/4)`.
- The `e^s` in the one-loop weights is a disk factor attached to each graviton state, lines 3541 to 3545, citing Carlip and Teitelboim. It is not a count.
- With the ordinary trace on `H_D`, `S(rho_D) <= log(m * max_j d_j)`, where `m` is the number of distinct area eigenvalues and `d_j` their multiplicities. So entropy near `<s>` forces `m >= exp(<s> - C s_*^(3/4))`: exponentially many distinct area eigenvalues below `s_*`, spacing of order `e^{-A/4Għ}`. The paper gives no eigenvalues (finding F4).

Work:

1. Prove the accounting lemma. For a finite-dimensional space with a self-adjoint operator having `m` distinct eigenvalues `s_j` of multiplicity `d_j`, and `rho = e^{-s}/Z`: `S(rho) = <s> + log Z` and `S(rho) <= log(sum_j d_j) <= log m + log max_j d_j`. Finite sums only; this also gives (5.39c) and (5.50) as identities.
2. Read (5.39) to (5.41), footnote 24, (D.37) to (D.49) and App E.2 to settle one question: is the trace in (5.56) the ordinary trace on `H_D`, or a trace with weights (register entry H12, "integer weights")?
3. Outcome 1 if the paper states both an ordinary trace with multiplicity at most `d(s)` per area value and a spectrum too sparse to supply `e^s`. Otherwise outcome 3, with the forced spectral density recorded as a consequence the paper does not state. Either way this answers the criticism that the entropy is not a count of microstates.

**B3. Finding F3 is probably not a tension. Prove it and correct the record.**

Reviewer's reading:

- (5.53), near line 1961, defines `r_h` from the state: `4 pi r_h^2 = <Â>`. The state `rho_D` has one parameter, `l`. So `l / r_h` is an output, not a free ratio.
- If `Z(l)` behaves as `l^p`, then (5.57) gives `p = q/(1-q)`, the first moment is `<u>/l = p/(p+1) = q`, and the second is `<u^2>/l^2 = p/(p+2) = q/(2-q)`.
- With (5.53), `x^2 = (1-eps)^2 r_h^2 / l^2 = <u^2>/l^2`. So `x^2 = q/(2-q)`, which is footnote 23's `q = 2x^2/(1+x^2)` read backwards. It is an identity between `x` and `q`, not a second evaluation of `q`.
- Then `q = 257/302` gives `x^2 = 257/347` as a consequence. The bounds (5.54b), (5.54c) hold: `x^2 <= q <= x`.
- Consequences to record: `l(D)/r_h = (1-eps) sqrt(347/257)`, about `1.162 (1-eps)`. The area in `rho_D` is spread as a power law on `[0, s_*]` with exponent `q/(2(1-q)) - 1 = 167/90`, mean `<s>/s_* = 257/347` and relative standard deviation about `0.27`. The density of states per unit area is `e^s s^(167/90)`, and per unit mass `e^s s^(106/45)`, which is (5.69). Reviewer's arithmetic; check it.

Work:

1. Prove the moment lemma: for `Z(l) = K l^p` on `[0, l]`, `p > 0`, the weighted first and second moments of the reading are `p/(p+1)` and `p/(p+2)` times `l` and `l^2`. Then prove the exact finite-spectrum identities (5.56) and (5.57a) for a finite list of readings and weights.
2. Derive `x^2 = q/(2-q)` and the equivalence with footnote 23.
3. If confirmed: outcome 3. Rewrite F3, the H8 row, the docstring of `ratio_sq_of_q`, and question 4 of the author note, which currently presents this as a tension. The remaining question for the author is whether "at fixed `l(D)/r_h`" is meant as a free choice.

**B4. Smaller checks, after B1 to B3**

- Read Sec 3.6. Nobody on this project has. Decide whether it argues that the uncut amplitude with no insertion is finite (H3a), or that closed sums are bounded below (H3c), or neither.
- (5.30c) inputs: state H15 formally and check that `0 <= e^{-s} f_b(s) <= 1` and the lower bound follow from H14 with `f_b` continuous and positive on `[0, s_*]`.
- Appendix E: formalise "axiom 5 on a bounded spectrum with the ordinary trace implies finite dimension", and record the circularity with (5.39c).

### 14.3 Track A: the conditional theorems

The target is one file that states the paper's Sec 5 claims as theorems with every assumption named.

1. `Diamond/Main.lean`. Given a `DiamondSetup`, a maximum reading `l`, a bounded `C` on the diamond space with the bounds of (5.30c), and H3a: `diamondSpace l` is finite-dimensional with `finrank <= Z e^{s_*} / m_{b,D}`. A second version from H3c. Both are direct applications of `FiniteDim.lean` and `ClosedCuts.lean`.
2. Finite area spectrum, (5.40): on a finite-dimensional `diamondSpace l` the area projections take finitely many values.
3. Entropy identities (5.39c), (5.50) and the accounting lemma of B2.
4. Clock and trace: (5.56), (5.57a) exactly for finite spectra; then (5.58) and (5.65) as asymptotic statements conditional on the limit `q` existing.
5. The Gaussian identity in (5.66), already listed in Section 13.
6. WP2-a (pure state gives an irreducible representation) and WP3, unchanged from Section 13.
7. The Wick step before (4.33) for a single oscillator: the centred `q^2` on the Gaussian vector, rotated by the mode phase, gives `2 (Δq)^4 e^{-2iθ}`.

Do not attempt: constructing the amplitude maps (H2), the reduced phase space of Sec 3, or the semiclassical equations. Those are research problems and are out of scope in Section 4.

### 14.4 Order

1. B3. It is short and corrects an item that is about to go to the author.
2. B1 step 1 (reading), then G1 to G3, then the decision.
3. B4 first item (Sec 3.6).
4. B2.
5. Track A items 1 to 4.
6. Remaining items.

Stop and report to Michael after B1 is decided, whichever way it goes.

### 14.5 Report format

For each item: outcome 1, 2, 3 or 4; the theorem names; the TeX lines read; what changed in the register; and one sentence on what it means for the paper.

### 14.6 Reports

Written by the code session, in the format of 14.5.

**B3 (2026-11-26). Outcome 3: consistent.**

- Theorems, all in `QuantGrav/Entropy/ClockMoments.lean`:
  - (5.56): `integral_momentSum_zero`, `firstMomentOf_momentSum`. Its second-moment analogue: `secondMomentOf_momentSum`.
  - (5.57a): `hasDerivAt_log_integral_momentSum_div`.
  - (5.60) and the sum in footnote 23: `reading_eq_sq_div_add_integral`, `momentSum_one_eq_div_add_integral`.
  - (5.55), and the first half of (5.60) with an explicit error: `sum_sq_reading_bounds`.
  - The moment lemma for `Z(l) = K l^p`: `firstMomentOf_rpow`, `secondMomentOf_rpow`.
  - `x^2 = q/(2-q)` and its equivalence with footnote 23: `powerLaw_moment_ratios`, `eq_sq_mul_two_sub_iff`, `sq_eq_div_two_sub_iff`.
  - (5.54b), (5.54c): `sq_le_and_le_of_sq_eq_div`. The numbers for `q = 257/302`: `moment_ratios_of_q`.
- TeX read by the code session: `main.tex` lines 1912 to 2097, all of Sec 5.3 with footnotes 23 and 24. The reviewer's reading in 14.2 B3 is confirmed on every point, including the arithmetic: `l(D)/r_h = 1.162 (1 - eps)`, exponent `167/90`, mean `257/347`, relative standard deviation `0.269`, and `e^s s^(106/45)` per unit mass.
- Register and record: finding F3 is rewritten; the H8 row no longer says "tension"; the docstring of `ratio_sq_of_q` and its `FIDELITY.md` entry are corrected; question 4 of `notes/note-to-author-draft.md` now asks only whether "at fixed `l(D)/r_h`" is meant as a free choice.
- What it means for the paper: footnote 23 and (5.68) do not conflict; together they determine `l(D)/r_h`, which the paper does not state and its wording suggests is chosen.
- Limits: the moment lemma is for an exact power law. The asymptotic version, which would follow from Karamata's theorem, is not formalized. That `Z` grows as a power at all is (5.58) and rests on H8.

**B1 (2026-11-26). Outcome 2 for the passage from fixed resolution to (5.19). Outcome 4, undecided, for (5.19) itself. Not outcome 1.**

- Theorems.
  - G1: `one_add_sum_le_prod_one_add`, `one_add_trace_le_det_one_add` (`Elementary/OneAddSumLeProd.lean`).
  - G2: `integral_exp_neg_mul_sq_gaussianReal` (`Elementary/GaussianExpSq.lean`).
  - G3 and its consequence with all modes: `measureReal_sum_mul_sq_le_le`, `ae_tendsto_sum_mul_sq_atTop` (`Elementary/GaussianQuadraticForm.lean`).
  - The scalings of (4.32) and (D.41) inserted: `le_sum_mul_radialVariance`, `measureReal_focusing_le_le`, `ae_tendsto_focusing_atTop`, and `ae_tendsto_focusing_atTop_of_le` for weights only bounded below (`Elementary/FocusingDivergence.lean`).
  - The two limits: `tendsto_integral_div_add_fixed_modes`, `tendsto_integral_div_add_all_modes` (`Elementary/GaussianModeLimits.lean`).
  - The conditional statement about `P_D Omega_A`: `DiamondSetup.diamondProj_Ω_eq_zero_of_gaussian_modes`, `DiamondSetup.not_H1_of_forall_diamondProj_Ω_eq_zero` (`Diamond/ClockDivergence.lean`).
- TeX read by the code session: lines 546 to 597, 1029 to 1068, 1166 to 1238, 1386 to 1438, 1449 to 1612, 2995 to 3133, 3460 to 3533. An independent reader, who did not write the Lean and did not see this file or `FIDELITY.md`, read the same ranges and more and checked the statements against them, as 14.1 requires. Its twelve required changes were applied.
- The reviewer's reading in 14.2 B1, point by point.
  - Confirmed: the argument is at fixed resolution; the word is used at lines 1500, 3067 and 3116, is not defined and is never removed; the Wigner function (C.15a) is for a finite set of canonical pairs (line 3048); the focusing (4.22) is positive and unsubtracted, and (5.21) uses that; the Gaussian criterion (G3) and the divergence of the series.
  - Corrected: `(Delta q_k)^2 = 1/(2 s k)` is the variance of the pair example (4.32) only. (4.7) has free widths and Sec 5.1 does not give them. The equations cited as (C.15) and (C.16) in 14.2 are (C.16b) and (C.16d); the cost and its scaling are (D.40) and (D.41).
  - Not confirmed: "P_M Omega_A = 0, (5.19) fails". That needs three links the paper's text does not settle: that `Omega_A` has the (4.32) variances; that the clock's focusing with all modes is unsubtracted with weights growing like `k^2`; and that a bounded reading bounds it. On the second, App D.3 counts cost by occupation numbers, under which a Gaussian state costs nothing.
- Why not outcome 1: there is no Lean theorem that a set of the paper's displayed statements implies `False`. The displayed statements are restricted to fixed resolution, and the divergence is shown in a model. Why outcome 2: the paper passes from an estimate at fixed resolution to (5.19) for the full state; the model satisfies the analogue of the premise at every fixed number of modes and violates the analogue of the conclusion with all modes. It is a countermodel to an inference, not a counterexample to the theory.
- Register: candidate H19 (a fixed resolution) is added; the H1 and H13 rows point to it; finding F11 is new; question 7 is added to `notes/note-to-author-draft.md`.
- What it means for the paper: the support for (5.19) does not reach the full state. To close the gap the paper would need one of three things: an estimate uniform in the resolution, which the model suggests is not available with the (4.32) variances; a permanent mode cutoff, which would be a hypothesis and sits uneasily with its statements about arbitrarily short wavelengths; or a subtracted focusing, which gives up the positivity that (5.21) uses.
- Stopped here, as 14.4 asks. Next in the order is the first item of B4, reading Sec 3.6.

**B4, first item (2026-11-26). Decision: neither. Sec 3.6 argues neither H3a nor H3c, and not H3b.** This is a reading, not a break attempt, so none of the four outcomes applies.

- Theorems: none new. The paper's (2.17b) is the counting step `mul_card_le_sum_sq_norm` of `Diamond/ClosedCuts.lean`.
- TeX read by the code session: Sec 3.6 in full (lines 870 to 942, (3.60) to (3.66)); line 947; lines 1250 to 1272 and 1366 to 1384; App E.1 (lines 3596 to 3657); lines 302 to 311; and every sentence citing Sec 3.6 or its equations. An independent reader read the same section blind, with Sec 4.4, Sec 5.2 and App E, and searched the whole TeX. The two readings agree.
- What Sec 3.6 is: classical matching of frames and fields across overlaps and across `S`, the glued symplectic potential, and additivity of the action. It has no statement about amplitudes, traces or sums over states, and the word diffeomorphism does not occur in it. The nearest it comes is classical: after gluing, the frame and the angular embedding of an internal cut are gauge (lines 924, 938).
- Where the claim "closing the cut reproduces the uncut amplitude" comes from: it is stated five times in Sec 5 (lines 1447, 1771, 1800, 1830, 1834). The reasons given are the law (4.29) (lines 1447, 1834), diffeomorphism invariance of (4.5) at fixed external states (line 1771), and diffeomorphism invariance with a pointer to Sec 3.6 (line 1800). (4.29) to (4.31) derive the open case only. In App E.1 the same invariance is condition 1 and finiteness of closed amplitudes is part of condition 5; both are requirements.
- The paper's JT prologue has an infinite closed trace, (2.17b). So finiteness of the closed amplitude with no insertion does not follow from the gluing rules alone in the paper's own framework.
- Register: the rows H3, H3a, H3b and H3c now say this; finding F12 is new; the sentence in F2 that Sec 3.6 had not been read is replaced; the rows 2.2, 3.6, E.1 and E.3 of the paper map in Section 5 are brought up to date. Question 2 of `notes/note-to-author-draft.md` gains two sentences asking where the closed case is derived.
- What it means for the paper: the step on which the finite-dimension argument turns is a principle the paper assumes for closed configurations, not one it derives.
- Next in the order of 14.4 is B2.

**B2 (2026-11-26). Outcome 3, consistent. Footnote 24 and (D.46c) do not contradict each other. What the paper leaves undetermined is where the states are.**

- Work item 2, the one question: the trace in (5.56) is the ordinary trace on `H_D`. (5.39b) writes `Tr_{H_D}`; (5.50) is a von Neumann entropy on a finite dimensional space; the sentence after (5.56) counts states with equal `(s_i, u_i)` separately; line 2141 gives unit weight to each rank one projection; (E.15) evaluates closing as `Tr_{H_Sigma}`. The integer weights of register entry H12 are those of the Euclidean theorem the paper cites, (E.12), and E.3 assigns no weights to `H_D`.
- A numbering point: in footnote 24 the count `dim(...) = exp[a s_* + o(s_*)]` is (5.64), and (5.63) is the cumulative probability. Section 14.2 above cites the count as (5.63). Checked in the TeX and in the PDF.
- Work item 1, theorems. `QuantGrav/Entropy/GibbsAccounting.lean`: `gibbsEntropy_eq_mean_add_log` is (5.50), `card_eq_gibbsZ_mul_mean_exp` is (5.39c), `gibbsEntropy_le_log_card` is `S <= log d_D`, and the accounting lemma is `gibbsEntropy_le_log_card_levelValues_add_log`, with the product form `gibbsZ_mul_exp_mean_le_card_levelValues_mul`; `sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq` is the Cauchy-Schwarz step of (D.49). `QuantGrav/Entropy/BandCounting.lean`: `tendsto_log_card_levelsBelow_div` is footnote 24's step to (5.64), and `tendsto_log_card_image_levelsBelow_div` is the number of distinct levels a multiplicity bound forces, each with finite forms. `QuantGrav/Entropy/LogLevelsModel.lean`: a spectrum with one state per level that satisfies the footnote, ending in `tendsto_log_card_levelsBelow_logLevels`. 38 theorems, all pinned in `Audit.lean`. The proofs were written by three subagents from fixed statements; the types of all public declarations were compared before and after.
- TeX read by the code session: lines 1834 to 1865, 1912 to 1931, 1962 to 2097, 3456 to 3555, 3596 to 3771, and 320, 1032 to 1034, 1445, 2141. An independent reader read the same blind and searched the whole TeX for statements about the area spectrum. The two readings agree.
- What the accounting gives. With the ordinary trace, `S <= log d_D`, and (5.64) needs `exp[a s_* + o(s_*)]` orthogonal states below `a s_*`. If the multiplicities of the area eigenvalues are sub-exponential, there must be `exp[a s_* + o(s_*)]` distinct eigenvalues below `a s_*`. If the eigenvalues are few, the multiplicities must be of order `e^s`. The paper states neither, and gives no eigenvalue, spacing or multiplicity.
- Why (D.46c) does not settle it: it bounds graviton states at fixed area, at one loop in flat spacetime with the corner data fixed, and App D.3 never relates `d(s)` to the eigenspaces of (5.40). The Fock space at fixed area also has excitations of the corner variables (line 1032).
- The `e^s` of App D.3 is the action of a disk (line 3542). Read with an ordinary trace, (D.48) says each graviton state at area `s` stands for `e^s` orthonormal states of weight `e^{-s} k_a(s)`, and then the denominator of (D.49) is the number of states. The paper does not say this.
- Why not outcome 1: the rule above asks for an ordinary trace, a multiplicity bound per area value, and a spectrum too sparse. The first is stated; the second is stated for graviton states only; the third is stated nowhere.
- Register: the rows H10, H11 and H12 now say this, in `FIDELITY.md` and in the docstring of `Hypotheses.lean`. Finding F13 is new. No new entry: the count is a consequence of the statements of Sec 5.3, not a further input. Question 8 is added to `notes/note-to-author-draft.md`.
- What it means for the paper: the entropy is asserted as a count of orthogonal states, and the paper does not show where those states are; they are not among the graviton states it counts, so they would have to be in an area spectrum or in corner excitations that it does not compute.
- Track A item 3 is done by the same files: (5.39c), (5.50) and the accounting lemma. Next in the order of 14.4 are Track A items 1, 2 and 4. Items 1 and 2 are drafted on the branch `wp4-statement-draft`, which waits for review. Item 4 is not started.

**Track A item 4 (2026-11-26). (5.57b), (5.58), (5.62) and (5.65) are theorems, conditional on named limits.** This is not a break attempt, so no outcome applies.

- (5.56) and (5.57a) for finite spectra were already in `QuantGrav/Entropy/ClockMoments.lean`. A finite spectrum cannot carry the limit, because its trace is eventually constant. So the asymptotic statements are for a spectrum with finitely many states below each reading, and (5.56) is extended to it (`integral_cutoffZ`).
- (5.58), first equality, exactly: `log_eq_integral_add_log_sub_log` in `QuantGrav/Elementary/MonotoneLogGrowth.lean`, for any nondecreasing trace, with the paper's `O(1)` written out. It rests on `log_integral_div_sub_log_integral_div`, which is (5.57a) integrated across the jumps of the trace. Second equality: `tendsto_integral_div_div_log_div` in `QuantGrav/Elementary/LogIntegralLimit.lean`.
- (5.57b) and (5.58), conditional on `<u>_l/l -> q < 1`: `tendsto_integral_cutoffZ_div` and `tendsto_log_cutoffZ_div_log` in `QuantGrav/Entropy/ClockTraceAsymptotics.lean`.
- (5.65) and (5.62), conditional on that limit and on `log <s>_l = (2 + o(1)) log l`: `tendsto_cutoffEntropy_sub_div_log` and `tendsto_log_cutoffZ_div_log_cutoffMeanArea`, same file. By (5.50) they are one statement, `log Z = (q/(2(1 - q)) + o(1)) log <s>`. The paper states (5.62) as a rate, `log Z/<s> = O(log <s>/<s>)`, which this gives.
- 29 theorems in the four files, all pinned in `Audit.lean`. The proofs were written by four subagents from fixed statements; the types of all public declarations were compared before and after. One theorem was added afterwards by the code session, `tendsto_log_cutoffZ_div_log_cutoffMeanArea`, when a proof agent pointed out that (5.62) is a rate.
- A point the item did not list. (5.65) needs more than the limit `q`. It also needs (5.59), which the paper gets by holding `l(D)/r_h` fixed. `QuantGrav/Entropy/MeanAreaGrowth.lean` derives it from the area bound (5.21c) state by state, `q > 0`, and the mean time delay (5.53): `tendsto_log_cutoffMeanArea_div_log`. So (5.65) is proved from three named inputs, `tendsto_cutoffEntropy_sub_div_log_of_delay`.
- TeX: no new passage; lines 1962 to 2051 as read for B2 and B3.
- Register: H8 now names the theorems that take the limit as a hypothesis. New candidate entry H20, the mean time delay (5.53).
- What it means for the paper: the logarithmic term of (5.65) follows from the area bound, the limit `q` and the mean time delay, with no other input; whether those three hold is not addressed.
- Track A items 1 and 2 remain on the branch `wp4-statement-draft`, waiting for review. Item 3 was done with B2.

**Second-reader review (2026-11-26).** Not an item of 14.4. Michael asked for one more agent on the work most needed outside the current item; the outstanding second-reader review listed under "Open items that affect fidelity" was chosen. The report is `notes/second-reader-review-2026-11-26.md`.

- Covered: every public declaration of `ClosedCuts.lean`, `OrderOfExhaustion.lean`, `ClockLowerBound.lean`, `ClockMoments.lean`, `PairAmplitudeReal.lean`, `SenComparison.lean`, and the four `H14a` items. 88 declarations. First pass blind, with the Lean and the TeX only; second pass, this log's rows against the Lean.
- Result: no statement mismatched, miscited, false or vacuous. 17 faithful, 10 faithful with a caveat, 61 not in the paper and labelled so.
- One required change, applied. `ClosedCuts.lean` assumed a response of at most `delta/4` on a cut and called such cuts the paper's own. The paper has only a bound strictly below `delta_eta/2`, the same for every cut: (5.37b) and the sentence after (D.25), line 3383. The four theorems now take a margin `gamma` and assume `Delta <= delta/2 - gamma`, which covers the paper's cuts exactly. With `gamma = 0` the conclusions fail, as the cuts `(3n, n)` of `OrderOfExhaustion.lean` show.
- Two consequences for what was said before. First, H3c is not weaker than H3a: on cuts with a margin it bounds the partial trace, new theorem `sum_sq_norm_le_div_of_neg_le_cut_amplitude`. It remains weaker than H3b and independent of H4. Second, the order dependence of F10 is among cuts with no uniform margin; for cuts built as the paper builds them the closed sums tend to minus infinity in every order. Neither changes the conclusion that H3b is assumed and not derived.
- Also applied: pointers and qualifications in the docstrings of `ClosedCuts.lean`, `OrderOfExhaustion.lean` and `ClockMoments.lean`; rows for helper theorems and missing hypotheses in `FIDELITY.md`; one stale sentence that said H3b has to come from Sec 3.6. Question 2 of the note to the author is qualified accordingly.
- Left open: `exists_setup_H1_H13_not_H14` could conclude `not H14a`; the reviewer checked that by hand only. The branch `wp4-statement-draft` calls `finiteDimensional_of_cut_amplitude_bddBelow` with the old hypothesis and will need the margin when it is rebased.
- Still without a second reader: the statements of the B1 files, and the seven files of B2 and Track A item 4.

**B4, third item (2026-11-26). Condition 5 of Appendix E on a bounded spectrum is equivalent to finite dimension.** A formalisation and a record, not a break attempt, so no outcome applies.

- Theorems, in `QuantGrav/Diamond/AxiomFive.lean`. General: `finiteDimensional_iff_exists_card_orthonormal_le`, a space is finite-dimensional exactly when the sizes of its finite orthonormal families are bounded, which is "the identity has finite ordinary trace"; and (E.17), `norm_trace_le_finrank_mul`. For the diamond: `DiamondSetup.finiteDimensional_diamondSpace_of_trace_area_proj_le`, under the area bound (5.21d) a finite trace of the spectral projection onto the bounded interval gives finite dimension; and `DiamondSetup.finiteDimensional_diamondSpace_iff_exists_trace_area_proj_le`, the equivalence. Eight theorems, pinned in `Audit.lean`.
- TeX: no new passage. App E as read for B2; condition 5 at lines 3637 to 3653, (E.7b) at 3672, (E.15) at 3737 to 3742, (E.17) at 3753 to 3758.
- The circle: App E.3 verifies condition 5 for the diamond by citing `dim H_D < infinity` from (5.39c), and with the ordinary trace of (E.15a) one instance of condition 5, (E.7b) for the interval that contains the spectrum, gives `dim H_D < infinity` back. So App E cannot support Sec 5.2 independently. This was in F10 as prose; it is now a theorem.
- Not formalised: the filter `F_g = g(K)`. The statements start where the spectrum is bounded and the filter is a spectral projection that acts as the identity on `H_D`. The area stands in for the boost generator, through (5.22), register entry H6.
- Register: row H12 points to the theorem. No new entry.
- What it means for the paper: for the causal diamond, the finiteness axiom of Appendix E and the finite dimension of Sec 5.2 are the same statement, so neither supports the other.
