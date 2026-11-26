/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Hypotheses
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# First consequences of H1, H13 and H14, and what they do not imply

Paper: arXiv:2611.34924v1, (5.19), (5.20), (5.21), footnote 8.

Consequences:

* `H13.h1`: H13 implies H1.
* `H1_iff_tendsto_norm_sq`: H1 is the limit (5.19), `‖P_D Ω_𝒜‖² → 1` as `ℓ(D) → ∞`.
* `H1.exists_diamondProj_ne_zero`: under H1 some finite maximum reading has `P_D Ω_𝒜 ≠ 0`,
  which is what the paper uses to prepare the state `ψ` of (5.20).
* `H14.h14a`: H14 implies its fixed-area half H14a, that the clock has no readings below
  `(1 - ε) (𝒜 / 4π)^(1/2)` on `K_𝒜`. This is the quantum form of footnote 8.
* `H14a.fixedAreaDiamondSpace_eq_bot`: under H14a the part of `H_D` inside `K_𝒜` is trivial
  when the maximum reading is below that bound.

Limits of the hypotheses, shown on the model `DiamondSetup.ofProjections`:

* `exists_setup_not_H1`: the fields of `DiamondSetup` do not imply H1.
* `exists_setup_H1_H13_not_H14`: nor do the fields together with H1 and H13 imply H14.
* `exists_setup_H1_H13_H14_diamondSpace_eq_top`: H1, H13 and H14 are jointly satisfiable, and
  they hold in a setup where `H_D` is the whole Hilbert space. So they put no bound on the
  dimension of `H_D`.
-/

public section

namespace QuantGrav

namespace DiamondSetup

open Filter Topology

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- H13 implies H1, because `Ω_𝒜` lies in `K_𝒜`. -/
theorem H13.h1 {S : DiamondSetup H} (h : S.H13) : S.H1 :=
  h S.Ω S.Ω_mem

/-- Paper (5.19). H1 holds exactly when `‖P_D Ω_𝒜‖² → 1` as the maximum reading grows. The
proof is Pythagoras for a projection. It is not the paper's route through (5.17) and (5.18),
which needs `Ψ_L` and is not formalized. -/
theorem H1_iff_tendsto_norm_sq (S : DiamondSetup H) :
    S.H1 ↔ Tendsto (fun ℓ : ℝ => ‖S.diamondProj ℓ S.Ω‖ ^ 2) atTop (𝓝 1) := by
  have key : ∀ ℓ : ℝ, ‖S.clock.proj ℓ S.Ω - S.Ω‖ ^ 2 = 1 - ‖S.clock.proj ℓ S.Ω‖ ^ 2 := by
    intro ℓ
    have h := S.clock.norm_sq_eq_add ℓ S.Ω
    rw [S.norm_Ω, norm_sub_rev] at h
    linarith
  constructor
  · intro h
    have h1 : Tendsto (fun ℓ : ℝ => ‖S.clock.proj ℓ S.Ω - S.Ω‖ ^ 2) atTop (𝓝 (0 ^ 2)) :=
      (tendsto_iff_norm_sub_tendsto_zero.mp h).pow 2
    simp only [key] at h1
    have h2 := (tendsto_const_nhds (x := (1 : ℝ)) (f := atTop)).sub h1
    simpa [diamondProj] using h2
  · intro h
    have h1 : Tendsto (fun ℓ : ℝ => ‖S.clock.proj ℓ S.Ω - S.Ω‖ ^ 2) atTop (𝓝 0) := by
      simp only [key]
      simpa [diamondProj] using (tendsto_const_nhds (x := (1 : ℝ)) (f := atTop)).sub h
    have h2 := (Real.continuous_sqrt.tendsto 0).comp h1
    rw [H1, SpectralFamily.Exhausts, tendsto_iff_norm_sub_tendsto_zero]
    simpa [Function.comp_def, Real.sqrt_sq (norm_nonneg _)] using h2

/-- The step from (5.19) to (5.20): under H1 there is a finite maximum reading for which the
projected Gaussian state `P_D Ω_𝒜` is nonzero, so that it can be normalized to the state `ψ`.
Only this consequence of H1 is used at that step. -/
theorem H1.exists_diamondProj_ne_zero {S : DiamondSetup H} (h : S.H1) :
    ∃ ℓ : ℝ, S.diamondProj ℓ S.Ω ≠ 0 := by
  by_contra hcon
  push Not at hcon
  have h0 : Tendsto (fun ℓ : ℝ => S.clock.proj ℓ S.Ω) atTop (𝓝 0) :=
    Tendsto.congr (fun ℓ => (hcon ℓ).symm) tendsto_const_nhds
  have hΩ : S.Ω = 0 := tendsto_nhds_unique h h0
  have hn := S.norm_Ω
  rw [hΩ, norm_zero] at hn
  exact zero_ne_one hn

/-- Footnote 8 and (5.21c) at fixed area, for the quantum clock: under H14 no vector of `K_𝒜`
has a clock reading below `(1 - ε) (𝒜 / 4π)^(1/2)`. -/
theorem H14.clock_proj_eq_zero_of_lt_clockLowerBound {S : DiamondSetup H} (h : S.H14) {ℓ : ℝ}
    (hℓ : ℓ < S.clockLowerBound) {x : H} (hx : x ∈ S.fixedArea) : S.clock.proj ℓ x = 0 := by
  by_cases hneg : ℓ < 0
  · rw [S.clock_proj_of_neg ℓ hneg]
    rfl
  · have hℓ0 : 0 ≤ ℓ := not_lt.mp hneg
    have hε : 0 < 1 - S.ε := sub_pos.mpr S.ε_lt_one
    have hpi : 0 < 4 * Real.pi := by positivity
    have hlt : S.areaBound ℓ < S.area₀ := by
      have hm : S.clockLowerBound ^ 2 = (1 - S.ε) ^ 2 * (S.area₀ / (4 * Real.pi)) := by
        rw [clockLowerBound, mul_pow, Real.sq_sqrt (div_nonneg S.area₀_pos.le hpi.le)]
      have hsq : ℓ ^ 2 < S.clockLowerBound ^ 2 := by
        have := mul_self_lt_mul_self hℓ0 hℓ
        nlinarith
      rw [hm] at hsq
      rw [areaBound, div_lt_iff₀ (by positivity)]
      have h4 : (1 - S.ε) ^ 2 * (S.area₀ / (4 * Real.pi)) * (4 * Real.pi)
          = S.area₀ * (1 - S.ε) ^ 2 := by
        field_simp
      nlinarith
    have hy : S.clock.proj ℓ x ∈ S.fixedArea := S.clock_proj_mem ℓ x hx
    have hyD : S.clock.proj ℓ x ∈ S.diamondSpace ℓ := S.diamondProj_apply_mem ℓ x
    rw [← (h ℓ _ hyD).1]
    exact S.area_proj_of_lt _ hlt _ hy

/-- H14 implies its fixed-area half H14a. -/
theorem H14.h14a {S : DiamondSetup H} (h : S.H14) : S.H14a :=
  fun _ hℓ _ hx => h.clock_proj_eq_zero_of_lt_clockLowerBound hℓ hx

/-- Under H14a the part of `H_D` inside `K_𝒜`, which is `P_D(𝒜) K_𝒜`, is trivial when the
maximum reading is below `(1 - ε) (𝒜 / 4π)^(1/2)`. -/
theorem H14a.fixedAreaDiamondSpace_eq_bot {S : DiamondSetup H} (h : S.H14a) {ℓ : ℝ}
    (hℓ : ℓ < S.clockLowerBound) : S.fixedAreaDiamondSpace ℓ = ⊥ := by
  rw [eq_bot_iff]
  rintro x ⟨hxD, hxK⟩
  have hx : S.clock.proj ℓ x = x := (S.mem_diamondSpace_iff ℓ x).mp hxD
  rw [Submodule.mem_bot, ← hx]
  exact h ℓ hℓ x hxK

/-- In the model `ofProjections`, H1 holds exactly when `Ω` lies in the range of `Q`, the
subspace on which the model's clock is defined. -/
theorem ofProjections_H1_iff (P Q : H →L[ℂ] H) (hP : IsStarProjection P)
    (hQ : IsStarProjection Q) (hQP : Q * P = Q) (Ω : H) (hΩ : ‖Ω‖ = 1) (hPΩ : P Ω = Ω)
    (A A' u₀ ε : ℝ) (hA : 0 < A) (hAA' : A < A') (hu₀ : 0 ≤ u₀) (hε : 0 < ε) (hε' : ε < 1) :
    (ofProjections P Q hP hQ hQP Ω hΩ hPΩ A A' u₀ ε hA hAA' hu₀ hε hε').H1 ↔ Q Ω = Ω := by
  have hev : (fun t : ℝ => (SpectralFamily.ofProj Q hQ u₀).proj t Ω)
      =ᶠ[atTop] fun _ => Q Ω := by
    filter_upwards [eventually_ge_atTop u₀] with t ht
    simp only [SpectralFamily.ofProj, ht, ↓reduceIte]
  constructor
  · intro h
    have h1 : Tendsto (fun _ : ℝ => Q Ω) atTop (𝓝 Ω) := Tendsto.congr' hev h
    exact tendsto_nhds_unique tendsto_const_nhds h1
  · intro h
    have h1 : Tendsto (fun _ : ℝ => Q Ω) atTop (𝓝 Ω) := by
      rw [h]
      exact tendsto_const_nhds
    exact Tendsto.congr' hev.symm h1

/-- In the model `ofProjections` with `Q = P`, the clock is defined on all of `K_𝒜`, so H13
holds. -/
theorem ofProjections_self_H13 (P : H →L[ℂ] H) (hP : IsStarProjection P) (Ω : H)
    (hΩ : ‖Ω‖ = 1) (hPΩ : P Ω = Ω) (A A' u₀ ε : ℝ) (hA : 0 < A) (hAA' : A < A')
    (hu₀ : 0 ≤ u₀) (hε : 0 < ε) (hε' : ε < 1) :
    (ofProjections P P hP hP hP.isIdempotentElem.eq Ω hΩ hPΩ A A' u₀ ε hA hAA' hu₀
      hε hε').H13 := by
  intro x hx
  obtain ⟨y, rfl⟩ := hx
  have hPP : P (P y) = P y := by
    rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, hP.isIdempotentElem.eq]
  refine Tendsto.congr' ?_ tendsto_const_nhds
  filter_upwards [eventually_ge_atTop u₀] with t ht
  simp only [ofProjections, SpectralFamily.ofProj, ht, ↓reduceIte]
  exact hPP.symm

/-- In the model `ofProjections`, H14 holds when the model's clock reading is at least the
lower bound `(1 - ε) (A / 4π)^(1/2)`. -/
theorem ofProjections_H14 (P Q : H →L[ℂ] H) (hP : IsStarProjection P)
    (hQ : IsStarProjection Q) (hQP : Q * P = Q) (Ω : H) (hΩ : ‖Ω‖ = 1) (hPΩ : P Ω = Ω)
    (A A' u₀ ε : ℝ) (hA : 0 < A) (hAA' : A < A') (hu₀ : 0 ≤ u₀) (hε : 0 < ε) (hε' : ε < 1)
    (h : (1 - ε) * Real.sqrt (A / (4 * Real.pi)) ≤ u₀) :
    (ofProjections P Q hP hQ hQP Ω hΩ hPΩ A A' u₀ ε hA hAA' hu₀ hε hε').H14 := by
  intro ℓ x hx
  rw [mem_diamondSpace_iff] at hx
  have hPQ : P * Q = Q := by
    have h1 := congrArg star hQP
    rwa [star_mul, hP.isSelfAdjoint.star_eq, hQ.isSelfAdjoint.star_eq] at h1
  by_cases hℓ : u₀ ≤ ℓ
  · have hQx : Q x = x := by
      simpa only [diamondProj, ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte] using hx
    have hPx : P x = x := by
      rw [← hQx, ← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, hPQ]
    have hε1 : 0 < 1 - ε := sub_pos.mpr hε'
    have hpi : 0 < 4 * Real.pi := by positivity
    have hm0 : 0 ≤ (1 - ε) * Real.sqrt (A / (4 * Real.pi)) := by positivity
    have hsq : ((1 - ε) * Real.sqrt (A / (4 * Real.pi))) ^ 2 ≤ ℓ ^ 2 :=
      pow_le_pow_left₀ hm0 (h.trans hℓ) 2
    rw [mul_pow, Real.sq_sqrt (div_nonneg hA.le hpi.le)] at hsq
    have hbound : A ≤ 4 * Real.pi * ℓ ^ 2 / (1 - ε) ^ 2 := by
      rw [le_div_iff₀ (by positivity)]
      have h4 : (1 - ε) ^ 2 * (A / (4 * Real.pi)) * (4 * Real.pi) = A * (1 - ε) ^ 2 := by
        field_simp
      nlinarith
    constructor
    · by_cases hA' : A' ≤ 4 * Real.pi * ℓ ^ 2 / (1 - ε) ^ 2
      · simp [ofProjections, SpectralFamily.twoStep, areaBound, hA']
      · simp only [ofProjections, SpectralFamily.twoStep, areaBound, hA', hbound, ↓reduceIte]
        exact hPx
    · intro a ha
      have h1 : ¬A ≤ a := not_le.mpr (ha.trans hA)
      have h2 : ¬A' ≤ a := fun h' => h1 (hAA'.le.trans h')
      simp [ofProjections, SpectralFamily.twoStep, h1, h2]
  · have hx0 : x = 0 := by
      have h0 : (0 : H →L[ℂ] H) x = x := by
        simpa only [diamondProj, ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte] using hx
      rw [← h0]
      rfl
    subst hx0
    constructor
    · exact map_zero _
    · intro a _
      exact map_zero _

/-- The fields of `DiamondSetup` do not imply H1: on any Hilbert space with a unit vector there
is a setup in which H1 fails. In the model the clock is defined nowhere. -/
theorem exists_setup_not_H1 (Ω : H) (hΩ : ‖Ω‖ = 1) : ∃ S : DiamondSetup H, ¬S.H1 := by
  have hPΩ : (1 : H →L[ℂ] H) Ω = Ω := rfl
  refine ⟨ofProjections 1 0 (IsStarProjection.one _) (IsStarProjection.zero _) (zero_mul 1) Ω hΩ
    hPΩ 1 2 1 (1 / 2) one_pos one_lt_two zero_le_one (by norm_num) (by norm_num), ?_⟩
  rw [ofProjections_H1_iff]
  intro h
  have h0 : (0 : H) = Ω := h
  rw [← h0, norm_zero] at hΩ
  exact zero_ne_one hΩ

/-- H14 is not implied by the fields of `DiamondSetup` together with H1 and H13: on any Hilbert
space with a unit vector there is a setup satisfying H1 and H13 in which H14 fails. In the
model the clock reads `0` while the area is `1`. -/
theorem exists_setup_H1_H13_not_H14 (Ω : H) (hΩ : ‖Ω‖ = 1) :
    ∃ S : DiamondSetup H, S.H1 ∧ S.H13 ∧ ¬S.H14 := by
  have hPΩ : (1 : H →L[ℂ] H) Ω = Ω := rfl
  have hone : IsStarProjection (1 : H →L[ℂ] H) := IsStarProjection.one _
  have h13 := ofProjections_self_H13 1 hone Ω hΩ hPΩ 1 2 0 (1 / 2) one_pos one_lt_two le_rfl
    (by norm_num) (by norm_num)
  refine ⟨_, h13.h1, h13, ?_⟩
  intro h
  have e1 : ¬((2 : ℝ) ≤ 0) := by norm_num
  have e2 : ¬((1 : ℝ) ≤ 0) := by norm_num
  have hΩD : Ω ∈ (ofProjections 1 1 hone hone hone.isIdempotentElem.eq Ω hΩ hPΩ 1 2 0 (1 / 2)
      one_pos one_lt_two le_rfl (by norm_num) (by norm_num)).diamondSpace 0 := by
    rw [mem_diamondSpace_iff]
    simp [diamondProj, ofProjections, SpectralFamily.ofProj]
  have h1 := (h 0 Ω hΩD).1
  have h2 : (0 : H) = Ω := by
    simpa [ofProjections, SpectralFamily.twoStep, areaBound, e1, e2] using h1
  rw [← h2, norm_zero] at hΩ
  exact zero_ne_one hΩ

/-- H1, H13 and H14 are jointly satisfiable, and they do not bound the dimension of `H_D`: on
any Hilbert space with a unit vector there is a setup satisfying all three in which `K_𝒜` and
every `H_D` with `ℓ(D) ≥ 1` are the whole space. Finite dimension of `H_D` therefore has to come
from other inputs. -/
theorem exists_setup_H1_H13_H14_diamondSpace_eq_top (Ω : H) (hΩ : ‖Ω‖ = 1) :
    ∃ S : DiamondSetup H, S.H1 ∧ S.H13 ∧ S.H14 ∧ S.fixedArea = ⊤ ∧
      ∀ ℓ : ℝ, 1 ≤ ℓ → S.diamondSpace ℓ = ⊤ := by
  have hPΩ : (1 : H →L[ℂ] H) Ω = Ω := rfl
  have hone : IsStarProjection (1 : H →L[ℂ] H) := IsStarProjection.one _
  have hpi : (1 : ℝ) ≤ 4 * Real.pi := by linarith [Real.two_le_pi]
  have hsqrt : Real.sqrt (1 / (4 * Real.pi)) ≤ 1 :=
    Real.sqrt_le_one.mpr (by rw [div_le_one (by positivity)]; exact hpi)
  have hmin : (1 - (1 / 2 : ℝ)) * Real.sqrt (1 / (4 * Real.pi)) ≤ 1 := by nlinarith
  have h13 := ofProjections_self_H13 1 hone Ω hΩ hPΩ 1 2 1 (1 / 2) one_pos one_lt_two
    zero_le_one (by norm_num) (by norm_num)
  have h14 := ofProjections_H14 1 1 hone hone hone.isIdempotentElem.eq Ω hΩ hPΩ 1 2 1 (1 / 2)
    one_pos one_lt_two zero_le_one (by norm_num) (by norm_num) hmin
  refine ⟨_, h13.h1, h13, h14, ?_, ?_⟩
  · rw [Submodule.eq_top_iff']
    intro x
    exact LinearMap.mem_range.mpr ⟨x, rfl⟩
  · intro ℓ hℓ
    rw [Submodule.eq_top_iff']
    intro x
    rw [mem_diamondSpace_iff]
    simp only [diamondProj, ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte]
    rfl

end DiamondSetup

end QuantGrav
