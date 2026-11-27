/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.ClockHypotheses
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.LinearAlgebra.Eigenspace.Triangularizable
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination

/-!
# A clock that restricts a variable in configuration only

Paper: arXiv:2611.34924v1, Sec 4.2, the representation of the canonical pairs before (4.7);
Sec 4.3, (4.20) and (4.22) to (4.27); the sentence after (5.19).

This file is the continuous half of statement L4 of break attempt B5 in `handoff.md`,
Section 14.7. A particle confined to an interval has an infinite-dimensional space of states: a
restriction on the position alone does not make the space finite-dimensional. The statements
here are the form of that fact which needs no `L²` space.

* `eq_bot_or_not_finiteDimensional_of_forall_ne_smul`: a subspace invariant under a linear map
  with no eigenvectors in it is zero or infinite-dimensional.
* `IsWeylPairOn K V W c`: on the subspace `K`, `V` and the family `W s` satisfy the Weyl
  relation `V W_s = e^{i c s} W_s V` with `c ≠ 0`, `V` preserves norms, and `s ↦ W_s x` is
  continuous at `0`. This is what a canonical pair gives: `V = e^{i t q̂}` with `t ≠ 0` and
  `W_s = e^{-i s p̂ / ħ}`, with `c = t`.
* `IsWeylPairOn.eq_zero_of_apply_eq_smul`: then `V` has no eigenvectors in `K`.
* `DiamondSetup.fixedAreaDiamondSpace_eq_bot_or_not_finiteDimensional_of_isWeylPairOn`: if `V`
  also commutes with the clock projection `P_D` on `K_𝒜`, then `P_D K_𝒜` is zero or
  infinite-dimensional.
* `DiamondSetup.not_finiteDimensional_of_diamondProj_ne_zero_of_isWeylPairOn`: if moreover
  `P_D Ω_𝒜 ≠ 0`, then `P_D K_𝒜` and `H_D` are infinite-dimensional.
* `DiamondSetup.H1.exists_forall_not_finiteDimensional_diamondSpace_of_isWeylPairOn`: under H1
  that holds for every large maximum reading.

## How this meets the paper

The paper represents every canonical pair of the fixed-area space on `L²(ℝ, dq_j)`, with
`q̂_j` acting by multiplication and `e^{-i a p̂_j / ħ}` by the shift (Sec 4.2). The pairs include
the corner variables on `S`. The Weyl relations for the smeared canonical variables are (4.20),
in Sec 4.3. The paper's representation satisfies `IsWeylPairOn` with `c = t`. Continuity of the
shift and invariance of `K_𝒜` are consequences that the paper does not state. The paper defines
these operators on `K_𝒜` only; any bounded extension to `H_ω` serves. That multiplication and
shift satisfy the hypothesis is standard and is not formalized here.

The other hypothesis, that some `V = e^{i t q̂}` commutes with the clock projections, is not a
statement of the paper. The clock (4.26) contains the distribution of area over the corner,
`f_S` of (4.23), and the shear term (4.22). No symbol for the variable conjugate to the
distribution of area occurs in (4.22) to (4.27). The paper does not say how `f_S` and the
conformal metric are written in the canonical pairs, so whether some `q̂` commutes with all of
them is not decided by the text. It is discussed in `FIDELITY.md`, finding F14.

The theorems below neither prove nor refute that commutation. They take it as the explicit
hypothesis `hcomm`, a statement about the clock projections on `K_𝒜`. Absence of the conjugate
variable from (4.26) would not by itself give `hcomm`: `q̂` must also commute with the other
operators that enter the clock.

Read the other way, the theorems give a necessary condition for `P_D K_𝒜` to be nonzero and
finite-dimensional: no operator `e^{i t q̂}`, `t ≠ 0`, of a canonical pair of `K_𝒜` commutes
with `P_D` on `K_𝒜`.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- A subspace that is invariant under a linear map with no eigenvectors in it is zero or
infinite-dimensional. On a nonzero finite-dimensional complex space every linear map has an
eigenvector. -/
theorem eq_bot_or_not_finiteDimensional_of_forall_ne_smul {K : Submodule ℂ H} (V : H →ₗ[ℂ] H)
    (hinv : ∀ x ∈ K, V x ∈ K) (hne : ∀ μ : ℂ, ∀ x ∈ K, V x = μ • x → x = 0) :
    K = ⊥ ∨ ¬FiniteDimensional ℂ K := by
  refine or_iff_not_imp_left.mpr fun hK hfin => ?_
  have : Nontrivial K := Submodule.nontrivial_iff_ne_bot.mpr hK
  obtain ⟨μ, hμ⟩ := Module.End.exists_eigenvalue (V.restrict hinv)
  obtain ⟨v, hv⟩ := hμ.exists_hasEigenvector
  have h1 : V (v : H) = μ • (v : H) := congrArg Subtype.val hv.apply_eq_smul
  exact hv.2 (Subtype.ext (hne μ v v.property h1))

/-- `IsWeylPairOn K V W c`: on the subspace `K`, the operator `V` and the family `W s` form a
Weyl pair with constant `c ≠ 0`. For a canonical pair `(q, p)` these are `V = e^{i t q̂}` and
`W_s = e^{-i s p̂ / ħ}`, with `c = t`.

Only what the theorems below use is asked for. `W` need not be a group, `s ↦ W s x` need only be
continuous at `0`, the `W s` need not preserve norms, and there is one operator `V`, not a
family.

Paper: Sec 4.2, where `q̂_j` acts by multiplication and `e^{-i a p̂_j / ħ}` by the shift
`χ_j(q_j) ↦ χ_j(q_j - a)` on `L²(ℝ, dq_j)`. With that representation
`e^{i t q̂_j} e^{-i s p̂_j / ħ} = e^{i t s} e^{-i s p̂_j / ħ} e^{i t q̂_j}`. The paper states the
Weyl relations for the smeared canonical variables as (4.20), in Sec 4.3. -/
structure IsWeylPairOn (K : Submodule ℂ H) (V : H →L[ℂ] H) (W : ℝ → H →L[ℂ] H) (c : ℝ) :
    Prop where
  /-- The constant in the Weyl relation is not zero. -/
  ne_zero : c ≠ 0
  /-- `V` maps `K` to itself. -/
  map_mem : ∀ x ∈ K, V x ∈ K
  /-- Each `W s` maps `K` to itself. -/
  shift_mem : ∀ (s : ℝ), ∀ x ∈ K, W s x ∈ K
  /-- `V` preserves norms on `K`. -/
  norm_map : ∀ x ∈ K, ‖V x‖ = ‖x‖
  /-- `s ↦ W s x` is continuous at `s = 0`, where it takes the value `x`. -/
  tendsto_shift : ∀ x ∈ K, Tendsto (fun s : ℝ => W s x) (𝓝 0) (𝓝 x)
  /-- The Weyl relation `V W_s = e^{i c s} W_s V` on `K`. -/
  weyl : ∀ (s : ℝ), ∀ x ∈ K, V (W s x) = Complex.exp (c * s * Complex.I) • W s (V x)

/-- **A Weyl pair has no eigenvectors.** If `V` and `W` form a Weyl pair on `K`, then `V` has no
eigenvector in `K`. An eigenvector `x` would be moved by `W s` to a vector that `V` multiplies
by a different number, which is therefore orthogonal to `x`; but `W s x → x` as `s → 0`. -/
theorem IsWeylPairOn.eq_zero_of_apply_eq_smul {K : Submodule ℂ H} {V : H →L[ℂ] H}
    {W : ℝ → H →L[ℂ] H} {c : ℝ} (h : IsWeylPairOn K V W c) {μ : ℂ} {x : H} (hxK : x ∈ K)
    (hx : V x = μ • x) : x = 0 := by
  by_contra hx0
  have hxpos : 0 < ‖x‖ := norm_pos_iff.mpr hx0
  -- The eigenvalue has modulus one.
  have hμ : ‖μ‖ = 1 := by
    have h1 := h.norm_map x hxK
    rw [hx, norm_smul] at h1
    exact (mul_eq_right₀ hxpos.ne').mp h1
  have hμμ : (starRingEnd ℂ) μ * μ = 1 := by
    rw [Complex.conj_mul', hμ, Complex.ofReal_one, one_pow]
  -- Choose `s > 0` with `|c| s < 2π` for which `W s` moves `x` by less than `‖x‖`.
  have hc : 0 < |c| := abs_pos.mpr h.ne_zero
  have hev : ∀ᶠ s in 𝓝[>] (0 : ℝ),
      dist (W s x) x < ‖x‖ ∧ s ∈ Set.Ioo (0 : ℝ) (2 * Real.pi / |c|) :=
    ((Metric.tendsto_nhds.mp (h.tendsto_shift x hxK) ‖x‖ hxpos).filter_mono
      nhdsWithin_le_nhds).and (Ioo_mem_nhdsGT (div_pos Real.two_pi_pos hc))
  obtain ⟨s, hclose, hs0, hs1⟩ := hev.exists
  rw [dist_eq_norm] at hclose
  have hcs : |c * s| < 2 * Real.pi := by
    rw [abs_mul, abs_of_pos hs0, mul_comm]
    exact (lt_div_iff₀ hc).mp hs1
  -- Then `e^{i c s} ≠ 1`.
  have he : Complex.exp (c * s * Complex.I) ≠ 1 := by
    intro h1
    have hcos : Real.cos (c * s) = 1 := by
      have h2 := congrArg Complex.re h1
      rwa [← Complex.ofReal_mul, Complex.exp_ofReal_mul_I_re, Complex.one_re] at h2
    exact mul_ne_zero h.ne_zero hs0.ne'
      ((Real.cos_eq_one_iff_of_lt_of_lt (abs_lt.mp hcs).1 (abs_lt.mp hcs).2).mp hcos)
  -- `W s x` lies in `K`, and `V` multiplies it by `e^{i c s} μ`.
  have hyK : W s x ∈ K := h.shift_mem s x hxK
  have hVy : V (W s x) = (Complex.exp (c * s * Complex.I) * μ) • W s x := by
    rw [h.weyl s x hxK, hx, map_smul, smul_smul]
  -- `V` preserves norms on `K`, hence inner products, so `x` and `W s x` are orthogonal.
  have hxy : inner ℂ x (W s x) = 0 := by
    have h1 : inner ℂ (V x) (V (W s x)) = inner ℂ x (W s x) :=
      (LinearMap.norm_map_iff_inner_map_map ((V : H →ₗ[ℂ] H).domRestrict K)).mp
        (fun u => h.norm_map u u.property) ⟨x, hxK⟩ ⟨W s x, hyK⟩
    rw [hx, hVy, inner_smul_left, inner_smul_right] at h1
    have h2 : (Complex.exp (c * s * Complex.I) - 1) * inner ℂ x (W s x) = 0 := by
      linear_combination h1 - Complex.exp (c * s * Complex.I) * inner ℂ x (W s x) * hμμ
    exact (mul_eq_zero.mp h2).resolve_left (sub_ne_zero.mpr he)
  -- Pythagoras: `‖W s x - x‖² = ‖W s x‖² + ‖x‖² ≥ ‖x‖²`, against the choice of `s`.
  have hsq : ‖W s x - x‖ ^ 2 = ‖W s x‖ ^ 2 + ‖x‖ ^ 2 := by
    rw [@norm_sub_sq ℂ, inner_eq_zero_symm.mpr hxy, map_zero, mul_zero, sub_zero]
  have hlt : ‖W s x - x‖ ^ 2 < ‖x‖ ^ 2 := pow_lt_pow_left₀ hclose (norm_nonneg _) two_ne_zero
  linarith [sq_nonneg ‖W s x‖]

end

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

namespace DiamondSetup

/-- **What a commuting operator without eigenvectors does to `P_D K_𝒜`.** If a bounded operator
`V` maps `K_𝒜` to itself, commutes with the clock projection `P_D` on `K_𝒜`, and has no
eigenvectors in `K_𝒜`, then `P_D K_𝒜` is zero or infinite-dimensional. Of the commutation only
this is used: `V` maps `P_D K_𝒜` into `H_D`. -/
theorem fixedAreaDiamondSpace_eq_bot_or_not_finiteDimensional (S : DiamondSetup H) (ℓ : ℝ)
    (V : H →L[ℂ] H) (hK : ∀ x ∈ S.fixedArea, V x ∈ S.fixedArea)
    (hcomm : ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x))
    (hne : ∀ μ : ℂ, ∀ x ∈ S.fixedArea, V x = μ • x → x = 0) :
    S.fixedAreaDiamondSpace ℓ = ⊥ ∨ ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) := by
  refine eq_bot_or_not_finiteDimensional_of_forall_ne_smul (V : H →ₗ[ℂ] H) ?_ ?_
  · rintro x ⟨hxD, hxK⟩
    refine ⟨(S.mem_diamondSpace_iff ℓ _).mpr ?_, hK x hxK⟩
    have h1 : S.clock.proj ℓ x = x := (S.mem_diamondSpace_iff ℓ x).mp hxD
    have h2 := hcomm x hxK
    rw [h1] at h2
    exact h2.symm
  · rintro μ x ⟨-, hxK⟩ hx
    exact hne μ x hxK hx

/-- **When `P_D Ω_𝒜 ≠ 0`.** If in addition the projected Gaussian state `P_D Ω_𝒜` is not zero,
then `P_D K_𝒜` is infinite-dimensional, and so is `H_D`, which contains it.

Paper: that `P_D Ω_𝒜` is nonzero for some finite maximum reading is the sentence after (5.19);
the state `ψ` of (5.20) is its normalization. -/
theorem not_finiteDimensional_of_diamondProj_ne_zero (S : DiamondSetup H) {ℓ : ℝ}
    (hΩ : S.diamondProj ℓ S.Ω ≠ 0) (V : H →L[ℂ] H)
    (hK : ∀ x ∈ S.fixedArea, V x ∈ S.fixedArea)
    (hcomm : ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x))
    (hne : ∀ μ : ℂ, ∀ x ∈ S.fixedArea, V x = μ • x → x = 0) :
    ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) ∧
      ¬FiniteDimensional ℂ (S.diamondSpace ℓ) := by
  -- `P_D Ω_𝒜` is a nonzero vector of `P_D K_𝒜`.
  have hmem : S.diamondProj ℓ S.Ω ∈ S.fixedAreaDiamondSpace ℓ :=
    ⟨S.diamondProj_apply_mem ℓ S.Ω, S.clock_proj_mem ℓ S.Ω S.Ω_mem⟩
  have hbot : S.fixedAreaDiamondSpace ℓ ≠ ⊥ := fun hb =>
    hΩ ((Submodule.eq_bot_iff _).mp hb _ hmem)
  have hinf : ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) :=
    (S.fixedAreaDiamondSpace_eq_bot_or_not_finiteDimensional ℓ V hK hcomm hne).resolve_left hbot
  -- `P_D K_𝒜` is a subspace of `H_D`.
  have hle : S.fixedAreaDiamondSpace ℓ ≤ S.diamondSpace ℓ := inf_le_left
  exact ⟨hinf, fun hfin => hinf (Submodule.finiteDimensional_of_le hle)⟩

/-- **With H1.** Suppose H1 holds, and a bounded operator `V` maps `K_𝒜` to itself, commutes
with every clock projection on `K_𝒜`, and has no eigenvectors in `K_𝒜`. Then `P_D K_𝒜` and
`H_D` are infinite-dimensional for every sufficiently large maximum reading. H1 is used only to
get one reading with `P_D Ω_𝒜 ≠ 0`. -/
theorem H1.exists_forall_not_finiteDimensional_diamondSpace {S : DiamondSetup H} (h1 : S.H1)
    (V : H →L[ℂ] H) (hK : ∀ x ∈ S.fixedArea, V x ∈ S.fixedArea)
    (hcomm : ∀ (ℓ : ℝ), ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x))
    (hne : ∀ μ : ℂ, ∀ x ∈ S.fixedArea, V x = μ • x → x = 0) :
    ∃ ℓ₀ : ℝ, ∀ ℓ : ℝ, ℓ₀ ≤ ℓ →
      ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) ∧
        ¬FiniteDimensional ℂ (S.diamondSpace ℓ) := by
  obtain ⟨ℓ₀, hℓ₀⟩ := h1.exists_diamondProj_ne_zero
  refine ⟨ℓ₀, fun ℓ hℓ => ?_⟩
  have hΩ : S.diamondProj ℓ S.Ω ≠ 0 := by
    intro h0
    have h2 := S.clock.proj_proj_of_le hℓ S.Ω
    have h0' : S.clock.proj ℓ S.Ω = 0 := h0
    rw [h0', map_zero] at h2
    exact hℓ₀ h2.symm
  exact S.not_finiteDimensional_of_diamondProj_ne_zero hΩ V hK (hcomm ℓ) hne

/-- **A variable restricted in configuration only.** If `V` and `W` form a Weyl pair on `K_𝒜`
and `V` commutes with the clock projection `P_D` on `K_𝒜`, then `P_D K_𝒜` is zero or
infinite-dimensional.

For a canonical pair `(q, p)` of `K_𝒜` and `V = e^{i t q̂}` with `t ≠ 0`: if the clock projection
commutes with `e^{i t q̂}`, as it does when the clock is a function of `q̂` and of operators that
commute with `q̂`, then bounding the clock reading cannot leave a nonzero finite-dimensional
space of states. -/
theorem fixedAreaDiamondSpace_eq_bot_or_not_finiteDimensional_of_isWeylPairOn
    (S : DiamondSetup H) (ℓ : ℝ) {V : H →L[ℂ] H} {W : ℝ → H →L[ℂ] H} {c : ℝ}
    (hVW : IsWeylPairOn S.fixedArea V W c)
    (hcomm : ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x)) :
    S.fixedAreaDiamondSpace ℓ = ⊥ ∨ ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) :=
  S.fixedAreaDiamondSpace_eq_bot_or_not_finiteDimensional ℓ V hVW.map_mem hcomm
    fun _ _ hxK hx => hVW.eq_zero_of_apply_eq_smul hxK hx

/-- **A Weyl pair, when `P_D Ω_𝒜 ≠ 0`.** If `V` and `W` form a Weyl pair on `K_𝒜`, `V` commutes
with the clock projection `P_D` on `K_𝒜`, and `P_D Ω_𝒜 ≠ 0`, then `P_D K_𝒜` and `H_D` are
infinite-dimensional. -/
theorem not_finiteDimensional_of_diamondProj_ne_zero_of_isWeylPairOn (S : DiamondSetup H)
    {ℓ : ℝ} (hΩ : S.diamondProj ℓ S.Ω ≠ 0) {V : H →L[ℂ] H} {W : ℝ → H →L[ℂ] H} {c : ℝ}
    (hVW : IsWeylPairOn S.fixedArea V W c)
    (hcomm : ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x)) :
    ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) ∧
      ¬FiniteDimensional ℂ (S.diamondSpace ℓ) :=
  S.not_finiteDimensional_of_diamondProj_ne_zero hΩ V hVW.map_mem hcomm
    fun _ _ hxK hx => hVW.eq_zero_of_apply_eq_smul hxK hx

/-- **A Weyl pair, with H1.** Suppose H1 holds, `V` and `W` form a Weyl pair on `K_𝒜`, and `V`
commutes with every clock projection on `K_𝒜`. Then `P_D K_𝒜` and `H_D` are infinite-dimensional
for every sufficiently large maximum reading.

So these three cannot hold together: H1; `H_D` finite-dimensional for arbitrarily large maximum
readings; and a canonical pair of `K_𝒜` whose operator `e^{i t q̂}`, `t ≠ 0`, commutes with the
clock projections. -/
theorem H1.exists_forall_not_finiteDimensional_diamondSpace_of_isWeylPairOn
    {S : DiamondSetup H} (h1 : S.H1) {V : H →L[ℂ] H} {W : ℝ → H →L[ℂ] H} {c : ℝ}
    (hVW : IsWeylPairOn S.fixedArea V W c)
    (hcomm : ∀ (ℓ : ℝ), ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x)) :
    ∃ ℓ₀ : ℝ, ∀ ℓ : ℝ, ℓ₀ ≤ ℓ →
      ¬FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) ∧
        ¬FiniteDimensional ℂ (S.diamondSpace ℓ) :=
  h1.exists_forall_not_finiteDimensional_diamondSpace V hVW.map_mem hcomm
    fun _ _ hxK hx => hVW.eq_zero_of_apply_eq_smul hxK hx

end DiamondSetup

end

end QuantGrav
