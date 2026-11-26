/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.Calculus.Deriv.Inv
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Clock moments and footnote 23

Paper: arXiv:2611.34924v1, Sec 5.3: (5.53) to (5.58), (5.60), (5.61), footnote 23, (5.68).

This file is break attempt B3 of `handoff.md`, Section 14. Footnote 23 gives
`q = 2 x² / (1 + x²)` with `x = (1 - ε) r_h / ℓ`, and (5.68) gives `q = 257 / 302`. The question
was whether these are two evaluations of `q` that can disagree. They are not. The relation of
footnote 23 holds between the first and second moments of the clock for every power-law growth
of the trace `Z`, so it is a relation between `q` and `x`, and `x` is determined by `q`.

## Notation

A finite spectrum is a finite family of states `i` with clock readings `u i` and weights `w i`.
In the paper `w i = e^{-s_i}`. `momentSum u w k t` is `∑_{u_i ≤ t} u_i^k w_i`. So
`momentSum u w 0` is the paper's `Z` of (5.56), and the paper's `⟨û⟩_ℓ` is
`momentSum u w 1 ℓ / momentSum u w 0 ℓ`.

For any function `Z`, `firstMomentOf Z ℓ = ℓ Z(ℓ) - ∫_0^ℓ Z` and
`secondMomentOf Z ℓ = ℓ² Z(ℓ) - 2 ∫_0^ℓ t Z(t) dt`. For the counting function of a finite
spectrum these are the weighted sums of `u_i` and of `u_i²` (`firstMomentOf_momentSum`,
`secondMomentOf_momentSum`). The first of these is (5.56).

## Results

* `integral_momentSum_zero`, `firstMomentOf_momentSum`: (5.56), exact for a finite spectrum.
* `hasDerivAt_log_integral_momentSum_div`: (5.57a), at any `ℓ` that is not a reading.
* `reading_eq_sq_div_add_integral`, `momentSum_one_eq_div_add_integral`: the identity of (5.60)
  for one reading, and its sum over readings, which footnote 23 uses.
* `sum_sq_reading_bounds`: (5.55), and the first half of (5.60) with an explicit error.
* `firstMomentOf_rpow`, `secondMomentOf_rpow`: if `Z(t) = K t^p`, the first and second moments
  are `p / (p + 1)` and `p / (p + 2)` times `ℓ Z(ℓ)` and `ℓ² Z(ℓ)`.
* `powerLaw_moment_ratios`: so with `q = p / (p + 1)` and `x² = p / (p + 2)`, the relation
  `q = 2 x² / (1 + x²)` of (5.61) holds for every `p > 0`, with `x² = q / (2 - q)` and
  `p = q / (1 - q)`, the exponent of (5.58).
* `sq_le_and_le_of_sq_eq_div`: the bounds (5.54b), (5.54c), `x² ≤ q ≤ x < 1`, then hold for
  every `0 < q < 1`.
* `moment_ratios_of_q`: for `q = 257 / 302`, `p = 257 / 45` and `x² = 257 / 347`.

## What is not here

That `Z` grows as a power of `ℓ` in the paper's theory is (5.58), which rests on the existence
of the limit `q` (register entry H8). The step from exact power laws to asymptotic ones is not
formalized.
-/

@[expose] public section

namespace QuantGrav

open MeasureTheory

variable {ι : Type*} [Fintype ι]

/-! ### Finite spectra -/

/-- The weighted moment sum over the states whose clock reading is at most `t`:
`∑_{u_i ≤ t} u_i^k w_i`. For `k = 0` and `w_i = e^{-s_i}` this is the paper's `Z(t)` of
(5.56). -/
noncomputable def momentSum (u w : ι → ℝ) (k : ℕ) (t : ℝ) : ℝ :=
  ∑ i, if u i ≤ t then u i ^ k * w i else 0

/-- The first moment of the readings up to `ℓ`, computed from the counting function `Z` alone:
`ℓ Z(ℓ) - ∫_0^ℓ Z`. For a finite spectrum it is `∑_{u_i ≤ ℓ} u_i w_i`
(`firstMomentOf_momentSum`). -/
noncomputable def firstMomentOf (Z : ℝ → ℝ) (ℓ : ℝ) : ℝ :=
  ℓ * Z ℓ - ∫ t in (0 : ℝ)..ℓ, Z t

/-- The second moment of the readings up to `ℓ`, computed from the counting function `Z` alone:
`ℓ² Z(ℓ) - 2 ∫_0^ℓ t Z(t) dt`. For a finite spectrum it is `∑_{u_i ≤ ℓ} u_i² w_i`
(`secondMomentOf_momentSum`). -/
noncomputable def secondMomentOf (Z : ℝ → ℝ) (ℓ : ℝ) : ℝ :=
  ℓ ^ 2 * Z ℓ - 2 * ∫ t in (0 : ℝ)..ℓ, t * Z t

/-- The integral over `[0, ℓ]` of a function that is switched on at `u ≥ 0` is its integral over
`[u, ℓ]` when `u ≤ ℓ`, and zero when `ℓ < u`. No integrability is assumed. -/
theorem integral_ite_le (g : ℝ → ℝ) {u ℓ : ℝ} (hu : 0 ≤ u) (hℓ : 0 ≤ ℓ) :
    ∫ t in (0 : ℝ)..ℓ, (if u ≤ t then g t else 0) = if u ≤ ℓ then ∫ t in u..ℓ, g t else 0 := by
  have hind : (fun t => if u ≤ t then g t else 0) = (Set.Ici u).indicator g := by
    funext t
    by_cases ht : u ≤ t <;> simp [ht]
  rw [intervalIntegral.integral_of_le hℓ, hind, setIntegral_indicator measurableSet_Ici]
  split_ifs with h
  · rw [intervalIntegral.integral_of_le h]
    rcases hu.eq_or_lt with h0 | h0
    · -- `u = 0`: the cutoff removes nothing from `(0, ℓ]`.
      subst h0
      have hsub : Set.Ioc (0 : ℝ) ℓ ⊆ Set.Ici 0 := fun t ht => ht.1.le
      rw [Set.inter_eq_left.mpr hsub]
    · -- `0 < u ≤ ℓ`: what is left is `[u, ℓ]`, which differs from `(u, ℓ]` by a null set.
      have hset : Set.Ioc 0 ℓ ∩ Set.Ici u = Set.Icc u ℓ := by
        ext t
        simp only [Set.mem_inter_iff, Set.mem_Ioc, Set.mem_Ici, Set.mem_Icc]
        exact ⟨fun ht => ⟨ht.2, ht.1.2⟩, fun ht => ⟨⟨h0.trans_le ht.1, ht.2⟩, ht.1⟩⟩
      rw [hset, integral_Icc_eq_integral_Ioc]
  · -- `ℓ < u`: nothing is left.
    have hset : Set.Ioc 0 ℓ ∩ Set.Ici u = ∅ := by
      ext t
      simp only [Set.mem_inter_iff, Set.mem_Ioc, Set.mem_Ici, Set.mem_empty_iff_false, iff_false]
      exact fun ht => h (ht.2.trans ht.1.2)
    rw [hset, setIntegral_empty]

/-- A continuous function that is switched on at `u` is interval integrable: it is the product
of a monotone step and a continuous function. -/
theorem intervalIntegrable_ite_le {g : ℝ → ℝ} (hg : Continuous g) (u a b : ℝ) :
    IntervalIntegrable (fun t => if u ≤ t then g t else 0) volume a b := by
  have hmono : Monotone fun t : ℝ => if u ≤ t then (1 : ℝ) else 0 := by
    intro s t hst
    dsimp only
    split_ifs with hs ht ht
    · exact le_rfl
    · exact absurd (hs.trans hst) ht
    · exact zero_le_one
    · exact le_rfl
  have heq : (fun t => if u ≤ t then g t else 0)
      = fun t => (if u ≤ t then (1 : ℝ) else 0) * g t := by
    funext t
    split_ifs
    · rw [one_mul]
    · rw [zero_mul]
  rw [heq]
  exact hmono.intervalIntegrable.mul_continuousOn hg.continuousOn

/-- Paper (5.56), first equality: `∫_0^ℓ Z(ℓ') dℓ' = ∑_{u_i ≤ ℓ} (ℓ - u_i) e^{-s_i}`. -/
theorem integral_momentSum_zero (u w : ι → ℝ) (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    ∫ t in (0 : ℝ)..ℓ, momentSum u w 0 t = ∑ i, if u i ≤ ℓ then (ℓ - u i) * w i else 0 := by
  have hint : ∀ i ∈ Finset.univ, IntervalIntegrable
      (fun t : ℝ => if u i ≤ t then u i ^ 0 * w i else 0) volume 0 ℓ := fun i _ =>
    intervalIntegrable_ite_le continuous_const _ _ _
  simp only [momentSum]
  rw [intervalIntegral.integral_finsetSum hint]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [integral_ite_le (fun _ => u i ^ 0 * w i) (hu i) hℓ]
  split_ifs with h
  · rw [intervalIntegral.integral_const, smul_eq_mul, pow_zero, one_mul]
  · rfl

/-- Paper (5.56), second equality, `∫_0^ℓ Z = Z(ℓ) (ℓ - ⟨û⟩_ℓ)`, in the form
`ℓ Z(ℓ) - ∫_0^ℓ Z = ∑_{u_i ≤ ℓ} u_i e^{-s_i}`. -/
theorem firstMomentOf_momentSum (u w : ι → ℝ) (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    firstMomentOf (momentSum u w 0) ℓ = momentSum u w 1 ℓ := by
  rw [firstMomentOf, integral_momentSum_zero u w hu hℓ]
  simp only [momentSum]
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  split_ifs with h <;> ring

/-- The second-moment analogue of (5.56):
`ℓ² Z(ℓ) - 2 ∫_0^ℓ t Z(t) dt = ∑_{u_i ≤ ℓ} u_i² e^{-s_i}`. Not in the paper. -/
theorem secondMomentOf_momentSum (u w : ι → ℝ) (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    secondMomentOf (momentSum u w 0) ℓ = momentSum u w 2 ℓ := by
  have hint : ∀ i ∈ Finset.univ, IntervalIntegrable
      (fun t : ℝ => if u i ≤ t then t * w i else 0) volume 0 ℓ := fun i _ =>
    intervalIntegrable_ite_le (continuous_id.mul continuous_const) _ _ _
  have hI : ∫ t in (0 : ℝ)..ℓ, t * momentSum u w 0 t
      = ∑ i, if u i ≤ ℓ then (ℓ ^ 2 - u i ^ 2) / 2 * w i else 0 := by
    have h1 : ∀ t : ℝ, t * momentSum u w 0 t = ∑ i, if u i ≤ t then t * w i else 0 := by
      intro t
      rw [momentSum, Finset.mul_sum]
      refine Finset.sum_congr rfl fun i _ => ?_
      split_ifs <;> ring
    simp only [h1]
    rw [intervalIntegral.integral_finsetSum hint]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [integral_ite_le (fun t => t * w i) (hu i) hℓ]
    split_ifs with h
    · rw [intervalIntegral.integral_mul_const, integral_id]
    · rfl
  rw [secondMomentOf, hI]
  simp only [momentSum]
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  split_ifs with h <;> ring

/-- The integral of `c / t ^ 2` over `[u, ℓ]` with `0 < u ≤ ℓ` is `c / u - c / ℓ`. -/
theorem integral_div_sq (c : ℝ) {u ℓ : ℝ} (hu : 0 < u) (huℓ : u ≤ ℓ) :
    ∫ t in u..ℓ, c / t ^ 2 = c / u - c / ℓ := by
  have hpos : ∀ t ∈ Set.uIcc u ℓ, 0 < t := fun t ht => by
    rw [Set.uIcc_of_le huℓ] at ht
    exact hu.trans_le ht.1
  -- The antiderivative is `-c / t`.
  have hderiv : ∀ t ∈ Set.uIcc u ℓ, HasDerivAt (fun s : ℝ => -c / s) (c / t ^ 2) t := by
    intro t ht
    have h := (hasDerivAt_inv (hpos t ht).ne').const_mul (-c)
    have e1 : (fun s : ℝ => -c / s) = fun s => -c * s⁻¹ := by
      funext s
      rw [div_eq_mul_inv]
    have e2 : c / t ^ 2 = -c * -(t ^ 2)⁻¹ := by ring
    rw [e1, e2]
    exact h
  have hint : IntervalIntegrable (fun t : ℝ => c / t ^ 2) volume u ℓ := by
    refine ContinuousOn.intervalIntegrable ?_
    refine continuousOn_const.div (continuousOn_id.pow 2) fun t ht => ?_
    exact pow_ne_zero 2 (hpos t ht).ne'
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  ring

/-- Paper (5.60), second half, the identity for one reading `u` with `0 < u ≤ ℓ`:
`u = u² / ℓ + ∫_u^ℓ (u / t)² dt`. -/
theorem reading_eq_sq_div_add_integral {u ℓ : ℝ} (hu : 0 < u) (huℓ : u ≤ ℓ) :
    u = u ^ 2 / ℓ + ∫ t in u..ℓ, (u / t) ^ 2 := by
  have hu0 : u ≠ 0 := hu.ne'
  have hℓ0 : ℓ ≠ 0 := (hu.trans_le huℓ).ne'
  simp only [div_pow]
  rw [integral_div_sq (u ^ 2) hu huℓ]
  field_simp
  ring

/-- Footnote 23, "summing this identity over clock readings as in (5.56)", exact for a finite
spectrum with positive readings:
`∑_{u_i ≤ ℓ} u_i w_i = (1 / ℓ) ∑_{u_i ≤ ℓ} u_i² w_i + ∫_0^ℓ (1 / t²) ∑_{u_i ≤ t} u_i² w_i dt`. -/
theorem momentSum_one_eq_div_add_integral (u w : ι → ℝ) (hu : ∀ i, 0 < u i) {ℓ : ℝ}
    (hℓ : 0 < ℓ) :
    momentSum u w 1 ℓ
      = momentSum u w 2 ℓ / ℓ + ∫ t in (0 : ℝ)..ℓ, momentSum u w 2 t / t ^ 2 := by
  have hℓ0 : ℓ ≠ 0 := hℓ.ne'
  -- Each term is integrable: where it is nonzero, `t ≥ u i > 0`, so `1 / t ^ 2` may be replaced
  -- by the continuous function `1 / (max t (u i)) ^ 2`.
  have hint : ∀ i ∈ Finset.univ, IntervalIntegrable
      (fun t : ℝ => if u i ≤ t then u i ^ 2 * w i / t ^ 2 else 0) volume 0 ℓ := by
    intro i _
    have hcont : Continuous fun t : ℝ => u i ^ 2 * w i / max t (u i) ^ 2 := by
      refine continuous_const.div ((continuous_id.max continuous_const).pow 2) fun t => ?_
      exact pow_ne_zero 2 ((hu i).trans_le (le_max_right t (u i))).ne'
    have heq : (fun t : ℝ => if u i ≤ t then u i ^ 2 * w i / t ^ 2 else 0)
        = fun t : ℝ => if u i ≤ t then u i ^ 2 * w i / max t (u i) ^ 2 else 0 := by
      funext t
      split_ifs with ht
      · rw [max_eq_left ht]
      · rfl
    rw [heq]
    exact intervalIntegrable_ite_le hcont (u i) 0 ℓ
  have hI : ∫ t in (0 : ℝ)..ℓ, momentSum u w 2 t / t ^ 2
      = ∑ i, if u i ≤ ℓ then u i * w i - u i ^ 2 * w i / ℓ else 0 := by
    have h1 : ∀ t : ℝ, momentSum u w 2 t / t ^ 2
        = ∑ i, if u i ≤ t then u i ^ 2 * w i / t ^ 2 else 0 := by
      intro t
      rw [momentSum, Finset.sum_div]
      refine Finset.sum_congr rfl fun i _ => ?_
      split_ifs
      · rfl
      · rw [zero_div]
    simp only [h1]
    rw [intervalIntegral.integral_finsetSum hint]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [integral_ite_le (fun t => u i ^ 2 * w i / t ^ 2) (hu i).le hℓ.le]
    split_ifs with h
    · rw [integral_div_sq _ (hu i) h]
      have hui : u i ≠ 0 := (hu i).ne'
      field_simp
    · rfl
  rw [hI]
  simp only [momentSum]
  rw [Finset.sum_div, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  split_ifs with h
  · ring
  · simp

/-- The moment sums are interval integrable on every interval. -/
theorem intervalIntegrable_momentSum (u w : ι → ℝ) (k : ℕ) (a b : ℝ) :
    IntervalIntegrable (momentSum u w k) volume a b := by
  have h : momentSum u w k = ∑ i, fun t : ℝ => if u i ≤ t then u i ^ k * w i else 0 := by
    funext t
    simp only [momentSum, Finset.sum_apply]
  rw [h]
  exact IntervalIntegrable.sum _ fun i _ => intervalIntegrable_ite_le continuous_const _ _ _

/-- The moment sums are measurable functions of the cutoff. -/
theorem measurable_momentSum (u w : ι → ℝ) (k : ℕ) : Measurable (momentSum u w k) := by
  unfold momentSum
  exact Finset.measurable_sum _ fun i _ =>
    Measurable.ite measurableSet_Ici measurable_const measurable_const

/-- A constant that is switched on at `u` is continuous at every point other than `u`, because
it is constant near such a point. -/
theorem continuousAt_ite_le_const (c : ℝ) {u ℓ : ℝ} (h : u ≠ ℓ) :
    ContinuousAt (fun t : ℝ => if u ≤ t then c else 0) ℓ := by
  rcases lt_or_gt_of_ne h with h | h
  · have hc : ContinuousAt (fun _ : ℝ => c) ℓ := continuousAt_const
    refine hc.congr ?_
    filter_upwards [lt_mem_nhds h] with t ht
    exact (ite_eq_left ht.le).symm
  · have hc : ContinuousAt (fun _ : ℝ => (0 : ℝ)) ℓ := continuousAt_const
    refine hc.congr ?_
    filter_upwards [gt_mem_nhds h] with t ht
    exact (ite_eq_right (not_le.mpr ht)).symm

/-- A moment sum is continuous at every cutoff that is not a reading. -/
theorem continuousAt_momentSum (u w : ι → ℝ) (k : ℕ) {ℓ : ℝ} (hne : ∀ i, u i ≠ ℓ) :
    ContinuousAt (momentSum u w k) ℓ := by
  unfold momentSum
  exact tendsto_finsetSum _ fun i _ => continuousAt_ite_le_const _ (hne i)

/-- Paper (5.57a): at a maximum reading `ℓ > 0` that is not itself a reading, and with
`∫_0^ℓ Z > 0`, the function `log[(1 / ℓ) ∫_0^ℓ Z]` has derivative `D` with
`ℓ D = ⟨û⟩_ℓ / (ℓ - ⟨û⟩_ℓ)`. The right-hand side is written as
`∑ u_i w_i / ∑ (ℓ - u_i) w_i`, the integrand of (5.58). -/
theorem hasDerivAt_log_integral_momentSum_div (u w : ι → ℝ) (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ}
    (hℓ : 0 < ℓ) (hne : ∀ i, u i ≠ ℓ)
    (hpos : 0 < ℓ * momentSum u w 0 ℓ - momentSum u w 1 ℓ) :
    HasDerivAt (fun r : ℝ => Real.log ((∫ t in (0 : ℝ)..r, momentSum u w 0 t) / r))
      (momentSum u w 1 ℓ / (ℓ * momentSum u w 0 ℓ - momentSum u w 1 ℓ) / ℓ) ℓ := by
  have hℓ0 : ℓ ≠ 0 := hℓ.ne'
  -- The value of the integral at `ℓ`, by (5.56).
  have hval : ∫ t in (0 : ℝ)..ℓ, momentSum u w 0 t
      = ℓ * momentSum u w 0 ℓ - momentSum u w 1 ℓ := by
    have h := firstMomentOf_momentSum u w hu hℓ.le
    rw [firstMomentOf] at h
    linarith
  -- The derivative of the integral at `ℓ` is `Z(ℓ)`, since `Z` is continuous at `ℓ`.
  have hF : HasDerivAt (fun r : ℝ => ∫ t in (0 : ℝ)..r, momentSum u w 0 t)
      (momentSum u w 0 ℓ) ℓ :=
    intervalIntegral.integral_hasDerivAt_right (intervalIntegrable_momentSum u w 0 0 ℓ)
      (measurable_momentSum u w 0).stronglyMeasurable.stronglyMeasurableAtFilter
      (continuousAt_momentSum u w 0 hne)
  have hdiv := hF.fun_div (hasDerivAt_id' ℓ) hℓ0
  have hlog := hdiv.log (by rw [hval]; exact (div_pos hpos hℓ).ne')
  refine hlog.congr_deriv ?_
  rw [hval]
  field_simp
  ring

/-- Paper (5.55), and the first half of (5.60) with an explicit error. For states with weights
`w i ≥ 0`, readings `u i ≤ ℓ` and lower bounds `0 ≤ a i ≤ u i`, where in the paper
`a i = (1 - ε) (𝒜_i / 4π)^(1/2)` by (5.21c):
`∑ w a² ≤ ∑ w u² ≤ ℓ ∑ w u`, and `∑ w u² ≤ ∑ w a² + 2 ℓ ∑ w (u - a)`.
After division by the total weight, `∑ w a²` is `(1 - ε)² r_h²` and `∑ w (u - a)` is the mean
time delay of (5.53). -/
theorem sum_sq_reading_bounds (u a w : ι → ℝ) {ℓ : ℝ} (hw : ∀ i, 0 ≤ w i) (ha : ∀ i, 0 ≤ a i)
    (hau : ∀ i, a i ≤ u i) (huℓ : ∀ i, u i ≤ ℓ) :
    ∑ i, w i * a i ^ 2 ≤ ∑ i, w i * u i ^ 2 ∧
      ∑ i, w i * u i ^ 2 ≤ ℓ * ∑ i, w i * u i ∧
      ∑ i, w i * u i ^ 2 ≤ ∑ i, w i * a i ^ 2 + 2 * ℓ * ∑ i, w i * (u i - a i) := by
  refine ⟨?_, ?_, ?_⟩
  · refine Finset.sum_le_sum fun i _ => ?_
    exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (ha i) (hau i) 2) (hw i)
  · -- Term by term, `ℓ w u - w u² = w u (ℓ - u) ≥ 0`.
    rw [Finset.mul_sum]
    refine Finset.sum_le_sum fun i _ => ?_
    have h0 : 0 ≤ u i := (ha i).trans (hau i)
    nlinarith [mul_nonneg (hw i) (mul_nonneg h0 (sub_nonneg.mpr (huℓ i)))]
  · -- Term by term, `w a² + 2 ℓ w (u - a) - w u² = w (u - a) (2 ℓ - u - a) ≥ 0`.
    rw [Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_le_sum fun i _ => ?_
    have h2 : 0 ≤ 2 * ℓ - u i - a i := by linarith [hau i, huℓ i]
    nlinarith [mul_nonneg (hw i) (mul_nonneg (sub_nonneg.mpr (hau i)) h2)]

/-! ### Power-law growth of the trace -/

/-- Moment lemma, first moment. If the counting function is `Z(t) = K t^p` with `p > 0`, the
first moment of the readings up to `ℓ` is `p / (p + 1)` times `ℓ Z(ℓ)`. -/
theorem firstMomentOf_rpow {K p ℓ : ℝ} (hp : 0 < p) (hℓ : 0 < ℓ) :
    firstMomentOf (fun t => K * t ^ p) ℓ = p / (p + 1) * (ℓ * (K * ℓ ^ p)) := by
  have hp1 : p + 1 ≠ 0 := by linarith
  rw [firstMomentOf, intervalIntegral.integral_const_mul,
    integral_rpow (Or.inl (by linarith : -1 < p)), Real.zero_rpow hp1,
    Real.rpow_add_one hℓ.ne']
  field_simp
  ring

/-- Moment lemma, second moment. If the counting function is `Z(t) = K t^p` with `p > 0`, the
second moment of the readings up to `ℓ` is `p / (p + 2)` times `ℓ² Z(ℓ)`. -/
theorem secondMomentOf_rpow {K p ℓ : ℝ} (hp : 0 < p) (hℓ : 0 < ℓ) :
    secondMomentOf (fun t => K * t ^ p) ℓ = p / (p + 2) * (ℓ ^ 2 * (K * ℓ ^ p)) := by
  have hp1 : p + 1 ≠ 0 := by linarith
  have hp2 : p + 1 + 1 ≠ 0 := by linarith
  have hp2' : p + 2 ≠ 0 := by linarith
  -- On `[0, ℓ]`, `t * t ^ p = t ^ (p + 1)`, including at `t = 0`.
  have hcongr : ∫ t in (0 : ℝ)..ℓ, t * (K * t ^ p) = ∫ t in (0 : ℝ)..ℓ, K * t ^ (p + 1) := by
    refine intervalIntegral.integral_congr fun t ht => ?_
    rw [Set.uIcc_of_le hℓ.le] at ht
    rw [Real.rpow_add_one' ht.1 hp1]
    ring
  rw [secondMomentOf, hcongr, intervalIntegral.integral_const_mul,
    integral_rpow (Or.inl (by linarith : -1 < p + 1)), Real.zero_rpow hp2,
    Real.rpow_add_one hℓ.ne', Real.rpow_add_one hℓ.ne']
  field_simp
  ring

/-! ### Footnote 23 -/

/-- Paper (5.61): the first two forms are equivalent, `q = x² (2 - q)` and
`q = 2 x² / (1 + x²)`. -/
theorem eq_sq_mul_two_sub_iff (q x : ℝ) :
    q = x ^ 2 * (2 - q) ↔ q = 2 * x ^ 2 / (1 + x ^ 2) := by
  have h : 1 + x ^ 2 ≠ 0 := by positivity
  rw [eq_div_iff h]
  constructor <;> intro h' <;> linarith

/-- Footnote 23 read backwards: for `q ≠ 2`, `x² = q / (2 - q)` exactly when
`q = 2 x² / (1 + x²)`. -/
theorem sq_eq_div_two_sub_iff {q : ℝ} (x : ℝ) (hq : q ≠ 2) :
    x ^ 2 = q / (2 - q) ↔ q = 2 * x ^ 2 / (1 + x ^ 2) := by
  have h1 : 1 + x ^ 2 ≠ 0 := by positivity
  have h2 : 2 - q ≠ 0 := sub_ne_zero.mpr hq.symm
  rw [eq_div_iff h1, eq_div_iff h2]
  constructor <;> intro h' <;> linarith

/-- For a power law with exponent `p > 0`, the first-moment ratio `q = p / (p + 1)` and the
second-moment ratio `x² = p / (p + 2)` satisfy the relation (5.61) of footnote 23,
`q = 2 x² / (1 + x²)`. Also `x² = q / (2 - q)`, and `p = q / (1 - q)`, the exponent of
(5.58). -/
theorem powerLaw_moment_ratios {p : ℝ} (hp : 0 < p) :
    p / (p + 1) = 2 * (p / (p + 2)) / (1 + p / (p + 2)) ∧
      p / (p + 2) = p / (p + 1) / (2 - p / (p + 1)) ∧
      p = p / (p + 1) / (1 - p / (p + 1)) := by
  have h1 : p + 1 ≠ 0 := by linarith
  have h2 : p + 2 ≠ 0 := by linarith
  have e1 : 1 + p / (p + 2) = 2 * (p + 1) / (p + 2) := by
    field_simp
    ring
  have e2 : 2 - p / (p + 1) = (p + 2) / (p + 1) := by
    field_simp
    ring
  have e3 : 1 - p / (p + 1) = 1 / (p + 1) := by
    field_simp
    ring
  rw [e1, e2, e3]
  refine ⟨?_, ?_, ?_⟩ <;> field_simp

/-- Paper (5.54b), (5.54c): for `0 < q < 1` and `x ≥ 0` with `x² = q / (2 - q)`, the bounds
`x² ≤ q ≤ x` hold, and `x < 1`, which is `ℓ(D) / r_h > 1 - ε`. -/
theorem sq_le_and_le_of_sq_eq_div {q x : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (hx : 0 ≤ x)
    (h : x ^ 2 = q / (2 - q)) : x ^ 2 ≤ q ∧ q ≤ x ∧ x < 1 := by
  have h2 : 0 < 2 - q := by linarith
  have hx2 : x ^ 2 * (2 - q) = q := (eq_div_iff h2.ne').mp h
  refine ⟨?_, ?_, ?_⟩
  · -- `q - x² = x² (1 - q) ≥ 0`.
    nlinarith [mul_nonneg (sq_nonneg x) (sub_nonneg.mpr hq1.le)]
  · -- If `x < q` then `q = x² (2 - q) < q² (2 - q)`, which says `q (1 - q)² < 0`.
    by_contra hlt
    push Not at hlt
    have hxq : x ^ 2 < q ^ 2 := pow_lt_pow_left₀ hlt hx (by norm_num)
    have hlt2 : x ^ 2 * (2 - q) < q ^ 2 * (2 - q) := mul_lt_mul_of_pos_right hxq h2
    nlinarith [mul_nonneg hq0.le (sq_nonneg (1 - q))]
  · -- If `1 ≤ x` then `q = x² (2 - q) ≥ 2 - q`, which says `q ≥ 1`.
    by_contra hge
    push Not at hge
    have hx1 : 1 ≤ x ^ 2 := one_le_pow₀ hge
    nlinarith [mul_le_mul_of_nonneg_right hx1 h2.le]

/-- The numbers for `q = 257 / 302`, the value of (5.68): the exponent of (5.58) is
`q / (1 - q) = 257 / 45`; the second-moment ratio is `q / (2 - q) = 257 / 347`; and
`q / (2 (1 - q)) - 1 = 167 / 90`. -/
theorem moment_ratios_of_q :
    ((257 : ℝ) / 302) / (1 - 257 / 302) = 257 / 45 ∧
      ((257 : ℝ) / 302) / (2 - 257 / 302) = 257 / 347 ∧
      ((257 : ℝ) / 302) / (2 * (1 - 257 / 302)) - 1 = 167 / 90 := by
  norm_num

end QuantGrav
