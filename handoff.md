# HANDOFF: Formalizing "An algebraic quantization of gravity from the null cone"

Date: 2026-11-26
Owner: Michael
Status: first session done on 2026-11-26. WP0 is set up, WP1-a to WP1-e are proved (WP1-f is not), and Section 5 below is corrected. Findings and the current hypothesis register are in `FIDELITY.md`. This document remains the brief for whoever (person or agent) picks up the work. An independent review of WP1 was done the same day; the next steps are in Section 13.

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
| 2.2 | 8-10 | 2.10a to 2.17b | JT quantization and gluing; infinitely many orthogonal states with identical clock statistics | No | Optional later |
| 3.1 | 11-14 | 3.1 to 3.16 | First order gravity; constrained BF action; vacuum equations | No | Axiomatize outputs |
| 3.2 | 14-17 | 3.17a to 3.31 | Null initial data; clock reading `u_*` (3.27), angular average (3.28); fn 8 | fn 8 and (3.27) only | Axiomatize outputs |
| 3.3 | 18-19 | 3.32 to 3.45 | Symplectic form with edge modes; canonical pairs (3.39, 3.42, 3.43) | No | Axiomatize outputs |
| 3.4 | 20-21 | 3.46 to 3.55 | Reduced Hamiltonian | No | Axiomatize outputs |
| 3.5 | 21-22 | 3.56a to 3.59 | Metric and dressed observables | No | Axiomatize outputs |
| 3.6 | 22-24 | 3.60a to 3.66 | Matching fields across subregions (3.62); source of the diffeomorphism-invariance argument | No | Hypothesis H3 |
| 4.1 | 25-26 | 4.1 to 4.6 | Algebra of observables; causal factorization (4.2e); reduced action (4.5) | No | WP2 |
| 4.2 | 26-30 | 4.7 to 4.19b | Gaussian wavefunctions (4.7); Fock space (4.10); rank-one operators (4.11); pure state and GNS (4.16, 4.17); unitarity (4.18) | No | WP2 |
| 4.3 | 30-31 | 4.20 to 4.28 | Weyl ordering (4.20); clock operator (4.26, 4.27) | No | WP2, H13 |
| 4.4 | 31-34 | 4.29 to 4.34 | Cut-state sum (4.29); absolute convergence (4.30); truncation error (4.31); graviton pair amplitude (4.32 to 4.34) | Yes | WP1, WP2 |
| 5.1 | 35-38 | 5.1 to 5.20 | `H_D = P_D H_omega` (5.1, 5.2); existence argument (5.4 to 5.19); spanning statement (5.20) | Yes | WP4 |
| 5.2 | 38-45 | 5.21a to 5.49 | Area bound (5.21, 5.30a); boost weight (5.22, 5.23); trace-distance bound (5.32); contradiction (5.37, 5.38); thermal trace (5.39); AdS boundary spectrum (5.42 to 5.49) | Yes | WP4 |
| 5.3 | 45-49 | 5.50 to 5.69 | Entropy (5.50); marginal trapping (5.51); `q` (5.54); `log Z` (5.56 to 5.58); entropy formula (5.65); one-loop coefficient (5.66, 5.67); `q` value (5.68, 5.69); fn 23 with (5.60, 5.61) | Yes | WP5 |
| 5.4 | 49-51 | 5.70 to 5.77b | Spatial topology and null states | No | Out of scope |
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
| E.1 | 76-77 | E.1a to E.5 | Conditions on amplitudes (the axioms) | No | WP3 |
| E.2 | 77-79 | E.6 to E.14c | Equivalence with the Euclidean formulation | No | WP3, H12 |
| E.3 | 79-80 | E.15a to E.18 | Realization in first order gravity | No | Deferred |

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
  Derived consequence to record: `q = 257/302` forces `x^2 = 257/347`, `x ~ 0.8606`, where `x = (1-eps) r_h / l`. Per extraction the paper does not justify this ratio. See H8.
- **WP1-f (footnote 8, 3.27).** `(1-eps) sqrt(A/4pi) <= mean clock reading`, by Cauchy-Schwarz on the corner sphere. Needs the exact definition from 3.27 before it can be stated.

Statement sketches. **Not compiled. Check all names against the pinned Mathlib.**

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
- Steps 0.5 to 0.7 and Steps 3 to 6: not started.

### Order for the next session

Step 0 items 1 to 4, then Step 1, then Step 2. Stop and report after Step 1: its outcome decides whether WP4 keeps its current shape.

### Decisions needed from Michael

- Where the remote lives and whether it is public.
- Licence.
- Whether to send the note in Step 6.
- Whether porting AI-produced MathlibAnnex files is acceptable under the review rules of Section 8.
