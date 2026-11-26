/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.Setup

/-!
# Hypothesis register

Physical and analytic inputs of arXiv:2611.34924v1 that this development does not prove.

Rule (handoff.md, WP0): an input enters Lean only as a structure field or an explicit theorem
argument, so that it is visible in the signature of every theorem that uses it. This file
declares no constants. An entry gets a formal statement only once the objects it mentions have
reviewed definitions; until then it is prose with a status line, because a formal statement
over a wrong definition would be worse than none.

H1, H13 and H14 have formal statements below, as propositions about a `DiamondSetup`. The
definitions in `Diamond/Setup.lean` were reviewed against the paper by an independent reader on
2026-11-26 before these statements were written, and the statements were checked by the same
reader in a second pass. H14a was added after that pass, at the reader's suggestion. H16 and
H17 are the assumptions carried by the fields of `DiamondSetup` itself.

Locations were checked against the PDF text or the TeX on 2026-11-26 unless marked
"not re-read". `FIDELITY.md` holds the longer notes and the paper's own support for each entry.

* **H1.** `‖Ψ_L - Ω_A‖ → 0` as `L → ∞`. By (C.14) this is the same as `Ω_A` lying in the closure
  `M` of the form domain of the clock operator.
  Paper: (5.7), (5.16), fn 18, (C.13) to (C.16d).
  Status: formal: `DiamondSetup.H1`, in the `Ω_A ∈ M` form.
* **H2.** Amplitude maps `U_M` are unitary.
  Paper: (4.18).
  Status: prose only.
* **H3.** The sum over cut states converges to the uncut amplitude, with insertions held fixed,
  along the net of finite cycle-closed projections.
  Paper: (4.29), Sec 3.6, used at (5.38).
  Status: prose only; split into H3a, H3b on 2026-11-26; H3c added the same day.
* **H3a.** With no insertion: the partial traces `Tr(P C_b† C_b)` over finite orthonormal families
  in `H_D` are bounded.
  Paper: implicit around (5.38); not stated in the paper.
  Status: the abstract form is the hypothesis `hZ` of `finiteDimensional_of_sum_sq_norm_le` in
  `Diamond/FiniteDim.lean`; tied to `H_D` and `C_b` in prose only.
* **H3b.** With the insertion `X` of (5.37a): the partial sums `Z_P[X]` over cycle-closed
  projections converge to `Z[X]`.
  Paper: (5.38), Figure 30, (4.29).
  Status: prose only. It does not follow from open gluing, from `P → 1` strongly, or from the
  left inequality of (5.37b): see the model in `Diamond/OrderOfExhaustion.lean`.
* **H3c.** The closed amplitudes `Z_P[X]` are bounded below along the paper's cuts of small
  response. Weaker than H3b, and enough for finite dimension without H4.
  Paper: not stated.
  Status: the abstract form is the hypothesis `hcuts` of
  `finiteDimensional_of_cut_amplitude_bddBelow` in `Diamond/ClosedCuts.lean`; new on 2026-11-26.
* **H4.** The boost-sensitive observable has `⟨Δ_η O⟩ > δ_η / 2` in the uncut preparation `C_b`.
  Paper: (5.36b), (5.37b), (D.26) to (D.36).
  Status: prose only.
* **H5.** Truncation projections on each cut converge strongly to the identity.
  Paper: sentence after (4.31).
  Status: hypothesis `hlim` of `tendsto_inner_evolveCut` in `OperatorAlgebra/CutSums.lean`; proved
  there for increasing sequences of subspaces with dense union.
* **H6.** The boost generator is `A / (8 π G)`.
  Paper: (5.22), (3.43) not re-read.
  Status: prose only.
* **H7.** `log Tr(C_b† C_b) = (106 / 45) log s_b + O(1)` from a one-loop curvature integral.
  Paper: (5.67a) to (5.67c), ref [71].
  Status: prose only.
* **H8.** The limit `q` in (5.54b) exists; its value.
  Paper: (5.54b), (5.61), (5.68), fn 23.
  Status: arithmetic in `Elementary/LogCoefficient.lean`; the moment identities (5.56), (5.57a),
  (5.60) and the relation of footnote 23 in `Entropy/ClockMoments.lean`; existence of the limit is
  prose only.
* **H9.** Choice of pure extension `ω`; unitary equivalence of other choices.
  Paper: (4.16), fn 20.
  Status: prose only.
* **H10.** `log d(s) ≲ 1 + (s Q_*)^(3/4)`.
  Paper: (D.45a) to (D.46c).
  Status: prose only. `d(s)` counts graviton states at fixed area, at one loop in flat spacetime
  and with the corner data held fixed. The paper does not relate it to the multiplicities of the
  area eigenvalues of (5.40). What a bound on those multiplicities would force is in
  `Entropy/BandCounting.lean`.
* **H11.** Each weight `k_a(s)` carries a disk factor `exp(s)`.
  Paper: paragraph above (D.48), ref [51].
  Status: prose only. The Cauchy–Schwarz step of (D.49) is
  `sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq` in `Entropy/GibbsAccounting.lean`.
* **H12.** Type I with integer weights; Euclidean to Lorentzian converse.
  Paper: App E.2, ref [36]. App E.2 and E.3 were read on 2026-11-26; ref [36] was not.
  Status: prose only. The integer weights are those of the Euclidean theorem, (E.12). In App E.3
  the paper's own trace is the ordinary trace on `H_D`, (E.15), with no sector weights. App E.3
  verifies its finiteness condition for the causal diamond by citing (5.39c), so App E does not
  support Sec 5.2 independently.
* **H13.** The clock (4.27) is densely defined on `K_A`.
  Paper: fn 14, the paragraph after (C.17).
  Status: formal: `DiamondSetup.H13`. The rest of the earlier entry (the clock exists as a
  positive self-adjoint operator and commutes with the area) moved to H16.
* **H14.** Operator inequality `û ≥ (1 - ε) (A / 4π)^(1/2)`, giving `0 ≤ P_D A P_D ≤ 4π ℓ(D)² / (1
  - ε)² P_D`.
  Paper: (5.21a) to (5.21d), fn 8.
  Status: formal: `DiamondSetup.H14`, as spectral support.
* **H14a.** On `K_A` the clock has no readings below `(1 - ε) (A / 4π)^(1/2)`: the fixed-area
  half of H14.
  Paper: (5.21a) to (5.21c) at fixed area, fn 8.
  Status: formal: `DiamondSetup.H14a`; implied by H14; new on 2026-11-26.
* **H15.** `C_D† C_D = P_D exp(-A / (4 G ℏ)) P_D`, from continuing the corner boost to `iπ` and
  gluing to the time reflection.
  Paper: (5.23a), (5.23b), App C.
  Status: prose only.
* **H16.** The clock has spectral projections on all of `H_ω`, they map `K_A` to itself, and they
  commute with those of the area operator.
  Paper: (5.2); asserted after (5.2), before (5.20) and before (5.21); constructed on `K_A` only,
  (4.26), (4.27), (C.11), (C.13).
  Status: fields `clock`, `clock_proj_of_neg`, `clock_proj_mem`, `commute` of `DiamondSetup`; new
  on 2026-11-26.
* **H17.** The area operator is a self-adjoint operator on `H_ω`, with `K_A` in its eigenspace for
  the value `A`.
  Paper: (4.12) to (4.15); `Â = A 1` before (4.24).
  Status: fields `area`, `area_exhausts`, `area_tendsto_atBot`, `area_proj_of_lt`,
  `area_proj_area₀` of `DiamondSetup`; new on 2026-11-26.
* **H18 (candidate).** The quantization of the reduced phase space is taken to be the quantum
  theory. The outcome may depend on the reduction and on the operator ordering, here Weyl
  ordering (4.20), and it is not compared with Dirac quantization.
  Paper: Sec 3, Sec 4.1, (4.20); Sec 3 not re-read.
  Status: prose only; raised in an external review; new on 2026-11-26.
* **H19 (candidate).** The focusing in the clock is taken at a fixed angular and radial
  resolution, that is, with finitely many modes.
  Paper: the sentence before (5.8); (C.15a); the sentences before (C.15c) and (C.16d). Used in the
  argument for (5.19), not stated as a hypothesis; the resolution is not defined or removed.
  Status: prose only. A model with all radial modes is in `Elementary/FocusingDivergence.lean`
  and `Elementary/GaussianModeLimits.lean`; a conditional criterion for the failure of H1 is in
  `Diamond/ClockDivergence.lean`; new on 2026-11-26.

Entries are never deleted. A discharged entry keeps its row and links to the proof.
-/

@[expose] public section

namespace QuantGrav

namespace DiamondSetup

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- **H1.** The incoming Gaussian state has no component outside the finite readings of the
clock: `P_ℓ Ω_𝒜 → Ω_𝒜` as `ℓ → ∞`. In the paper's terms, `Ω_𝒜` lies in `M`.

Paper: the claim is `‖Ψ_L - Ω_𝒜‖ → 0` as `L → ∞`, argued in (5.7) to (5.16). The paper calls
the outcome strong evidence, and footnote 18 says the last step is a heuristic. By the sentence
after (C.14), that limit holds exactly when `Ω_𝒜` lies in `M`, which is the form stated here.
`Ψ_L` is not defined in this development, so that equivalence is the paper's and is not a
theorem here. With `‖Ω_𝒜‖ = 1` this statement is (5.19): see `H1_iff_tendsto_norm_sq`.

The paper's evidence concerns the Gaussian centred on spherically symmetric data, at fixed
`b` (Sec 5.1). For nearby Gaussian states footnote 19 claims only a nonzero projection. -/
def H1 (S : DiamondSetup H) : Prop :=
  S.clock.Exhausts S.Ω

/-- **H13.** The clock is densely defined on the fixed-area space: `P_ℓ x → x` as `ℓ → ∞` for
every `x` in `K_𝒜`. In the paper's terms, `M = K_𝒜`.

Paper: footnote 14, and the paragraph after (C.17), which derives it on the condition that the
estimate behind H1 also holds for displaced Gaussian states. Those states are not part of
`DiamondSetup`, so the paper's conditional form cannot be stated here. The statement is about
`K_𝒜` only; the paper makes no such claim on `H_ω`. It implies H1 (`H13.h1`). -/
def H13 (S : DiamondSetup H) : Prop :=
  ∀ x ∈ S.fixedArea, S.clock.Exhausts x

/-- The area bound (5.21d) for one maximum reading `ℓ`, as spectral support: every vector of
`H_D` has its area in `[0, 4π ℓ² / (1 - ε)²]`. In the paper's notation,
`0 ≤ P_D Â P_D ≤ 4π ℓ(D)² / (1 - ε)² P_D`. The two forms agree because the clock and area
projections commute (field `commute`); without commutation the form here would be the
stronger one. -/
def AreaBoundAt (S : DiamondSetup H) (ℓ : ℝ) : Prop :=
  ∀ x ∈ S.diamondSpace ℓ,
    S.area.proj (S.areaBound ℓ) x = x ∧ ∀ a < 0, S.area.proj a x = 0

/-- **H14.** The area bound (5.21d) holds for every maximum reading. For a commuting clock and
area operator this is the operator inequality (5.21c), `û ≥ (1 - ε) (Â / 4π)^(1/2)`, together
with `Â ≥ 0` where the clock is defined. That reading is the dictionary between operators and
their spectral projections; it is not a theorem here.

Paper: (5.21a) to (5.21d), argued at fixed area from positivity of the focusing term and
Cauchy-Schwarz on `S`. The zero lower bound is the one printed in (5.21d); the paper does not
argue it separately, and it follows from (5.21b). On `H_ω` the statement rests on the
extension of the clock that the paper does not specify (H16). Its consequence on `K_𝒜` is
H14a (`H14.h14a`). -/
def H14 (S : DiamondSetup H) : Prop :=
  ∀ ℓ : ℝ, S.AreaBoundAt ℓ

/-- **H14a.** The fixed-area half of H14: no vector of `K_𝒜` has a clock reading below
`(1 - ε) (𝒜 / 4π)^(1/2)`.

Paper: (5.21a) to (5.21c) at fixed area, where `Â` is the number `𝒜`; footnote 8 gives the
classical bound. This is the part of H14 that the paper's argument supports directly, and it
does not involve the extension of the clock to `H_ω`. H14 implies it (`H14.h14a`). -/
def H14a (S : DiamondSetup H) : Prop :=
  ∀ ℓ < S.clockLowerBound, ∀ x ∈ S.fixedArea, S.clock.proj ℓ x = 0

end DiamondSetup

end QuantGrav
