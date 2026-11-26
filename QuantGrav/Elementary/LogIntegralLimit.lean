/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# The logarithmic mean of a function with a limit

Paper: arXiv:2611.34924v1, Sec 5.3, the second equality of (5.58).

In (5.58) the paper passes from `∫_{ℓ_0}^{ℓ} φ(ℓ') dℓ' / ℓ' + O(1)` to
`[κ + o(1)] log (ℓ / ℓ_0)`, where the integrand `φ` tends to `κ = q / (1 - q)`. This file proves
that step for the integral, for any function `φ` with a limit at infinity. The `O(1)` term is
made explicit in `QuantGrav/Elementary/MonotoneLogGrowth.lean`. Together with that file and
`QuantGrav/Entropy/ClockTraceAsymptotics.lean` this is Track A item 4 of `handoff.md`,
Section 14.3.

## Results

* `tendsto_integral_div_div_log_div`: for `a > 0`, if `φ(t) → κ` as `t → ∞`, then
  `(∫_a^ℓ φ(t) dt / t) / log (ℓ / a) → κ`.
* `tendsto_integral_div_div_log`: the same with `log ℓ` in the denominator.

No regularity of `φ` is assumed beyond the integrability of `φ(t) / t` on each interval
`[a, ℓ]`.
-/

public section

namespace QuantGrav

open Filter Topology MeasureTheory

/-- For `c` constant, `t ↦ c / t` is integrable between two positive points. -/
private theorem intervalIntegrable_const_div {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (c : ℝ) :
    IntervalIntegrable (fun t : ℝ => c / t) volume a b :=
  (continuousOn_const.div continuousOn_id fun _ hx h0 =>
    Set.notMem_uIcc_of_lt ha hb (h0 ▸ hx)).intervalIntegrable

/-- For `a, b > 0`, `∫_a^b c dt / t = c log (b / a)`. -/
private theorem integral_const_div {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (c : ℝ) :
    ∫ t in a..b, c / t = c * Real.log (b / a) := by
  simp only [div_eq_mul_inv, intervalIntegral.integral_const_mul, integral_inv_of_pos ha hb]

/-- The case `κ = 0` of `tendsto_integral_div_div_log_div`: if `ψ(t) → 0` as `t → ∞`, then
`∫_a^ℓ ψ(t) dt / t = o(log (ℓ / a))`.

Given `ε > 0`, choose `T ≥ a` with `|ψ| ≤ ε / 2` on `[T, ∞)`. The integral over `[a, T]` is a
constant, and the integral over `[T, ℓ]` is at most `(ε / 2) log (ℓ / T) ≤ (ε / 2) log (ℓ / a)`
in absolute value. -/
private theorem tendsto_integral_div_div_log_div_zero {ψ : ℝ → ℝ} {a : ℝ} (ha : 0 < a)
    (hψ : ∀ ℓ, a ≤ ℓ → IntervalIntegrable (fun t => ψ t / t) volume a ℓ)
    (h0 : Tendsto ψ atTop (𝓝 0)) :
    Tendsto (fun ℓ => (∫ t in a..ℓ, ψ t / t) / Real.log (ℓ / a)) atTop (𝓝 0) := by
  rw [Metric.tendsto_nhds]
  intro ε hε
  have hδ : 0 < ε / 2 := half_pos hε
  -- A point `T ≥ a` beyond which `|ψ| ≤ ε / 2`.
  obtain ⟨T, haT, hbd⟩ : ∃ T, a ≤ T ∧ ∀ t, T ≤ t → |ψ t| ≤ ε / 2 := by
    obtain ⟨N, hN⟩ := Metric.tendsto_atTop.mp h0 (ε / 2) hδ
    refine ⟨max N a, le_max_right N a, fun t ht => ?_⟩
    have h := hN t ((le_max_left N a).trans ht)
    rw [Real.dist_eq, sub_zero] at h
    exact h.le
  have hT0 : 0 < T := ha.trans_le haT
  have hlog : Tendsto (fun ℓ : ℝ => Real.log (ℓ / a)) atTop atTop :=
    Real.tendsto_log_atTop.comp (tendsto_id.atTop_div_const ha)
  -- Take `ℓ ≥ T` so large that the integral over `[a, T]` is below `(ε / 2) log (ℓ / a)`.
  filter_upwards [eventually_ge_atTop T,
    hlog.eventually_gt_atTop (|∫ t in a..T, ψ t / t| / (ε / 2))] with ℓ hTℓ hℓ
  have hℓ0 : 0 < ℓ := hT0.trans_le hTℓ
  have hlogpos : 0 < Real.log (ℓ / a) := (div_nonneg (abs_nonneg _) hδ.le).trans_lt hℓ
  have hhead : |∫ t in a..T, ψ t / t| < ε / 2 * Real.log (ℓ / a) := (div_lt_iff₀' hδ).mp hℓ
  have hsplit : ∫ t in a..ℓ, ψ t / t = (∫ t in a..T, ψ t / t) + ∫ t in T..ℓ, ψ t / t :=
    (intervalIntegral.integral_add_adjacent_intervals (hψ T haT)
      ((hψ T haT).symm.trans (hψ ℓ (haT.trans hTℓ)))).symm
  have htail : |∫ t in T..ℓ, ψ t / t| ≤ ε / 2 * Real.log (ℓ / a) :=
    calc |∫ t in T..ℓ, ψ t / t|
        = ‖∫ t in T..ℓ, ψ t / t‖ := (Real.norm_eq_abs _).symm
      _ ≤ ∫ t in T..ℓ, ε / 2 / t := by
          refine intervalIntegral.norm_integral_le_of_norm_le hTℓ
            (Eventually.of_forall fun t ht => ?_) (intervalIntegrable_const_div hT0 hℓ0 _)
          have ht0 : 0 < t := hT0.trans ht.1
          rw [Real.norm_eq_abs, abs_div, abs_of_pos ht0]
          exact div_le_div_of_nonneg_right (hbd t ht.1.le) ht0.le
      _ = ε / 2 * Real.log (ℓ / T) := integral_const_div hT0 hℓ0 _
      _ ≤ ε / 2 * Real.log (ℓ / a) :=
          mul_le_mul_of_nonneg_left (Real.log_le_log (div_pos hℓ0 hT0)
            (div_le_div_of_nonneg_left hℓ0.le ha haT)) hδ.le
  rw [Real.dist_eq, sub_zero, abs_div, abs_of_pos hlogpos, div_lt_iff₀ hlogpos, hsplit]
  calc |(∫ t in a..T, ψ t / t) + ∫ t in T..ℓ, ψ t / t|
      ≤ |∫ t in a..T, ψ t / t| + |∫ t in T..ℓ, ψ t / t| := abs_add_le _ _
    _ < ε / 2 * Real.log (ℓ / a) + ε / 2 * Real.log (ℓ / a) := add_lt_add_of_lt_of_le hhead htail
    _ = ε * Real.log (ℓ / a) := by ring

/-- **The second equality of (5.58).** If `φ(t) → κ` as `t → ∞`, then
`∫_a^ℓ φ(t) dt / t = [κ + o(1)] log (ℓ / a)`. -/
theorem tendsto_integral_div_div_log_div {φ : ℝ → ℝ} {a κ : ℝ} (ha : 0 < a)
    (hφ : ∀ ℓ, a ≤ ℓ → IntervalIntegrable (fun t => φ t / t) volume a ℓ)
    (hκ : Tendsto φ atTop (𝓝 κ)) :
    Tendsto (fun ℓ => (∫ t in a..ℓ, φ t / t) / Real.log (ℓ / a)) atTop (𝓝 κ) := by
  have hψ : ∀ ℓ, a ≤ ℓ → IntervalIntegrable (fun t => (φ t - κ) / t) volume a ℓ := by
    intro ℓ hℓ
    simp only [sub_div]
    exact (hφ ℓ hℓ).sub (intervalIntegrable_const_div ha (ha.trans_le hℓ) κ)
  have h0 : Tendsto (fun t => φ t - κ) atTop (𝓝 0) := by
    have h := hκ.sub_const κ
    rwa [sub_self] at h
  have key : Tendsto (fun ℓ => κ + (∫ t in a..ℓ, (φ t - κ) / t) / Real.log (ℓ / a)) atTop
      (𝓝 κ) := by
    have h := (tendsto_integral_div_div_log_div_zero ha hψ h0).const_add κ
    rwa [add_zero] at h
  refine key.congr' ?_
  filter_upwards [eventually_gt_atTop a] with ℓ hℓ
  have hℓ0 : 0 < ℓ := ha.trans hℓ
  have hlog : Real.log (ℓ / a) ≠ 0 := (Real.log_pos ((one_lt_div ha).mpr hℓ)).ne'
  have hint : ∫ t in a..ℓ, (φ t - κ) / t = (∫ t in a..ℓ, φ t / t) - κ * Real.log (ℓ / a) := by
    simp only [sub_div]
    rw [intervalIntegral.integral_sub (hφ ℓ hℓ.le) (intervalIntegrable_const_div ha hℓ0 κ),
      integral_const_div ha hℓ0]
  rw [hint, sub_div, mul_div_assoc, div_self hlog, mul_one, add_sub_cancel]

/-- The same limit with `log ℓ` in the denominator: if `φ(t) → κ` as `t → ∞`, then
`∫_a^ℓ φ(t) dt / t = [κ + o(1)] log ℓ`. -/
theorem tendsto_integral_div_div_log {φ : ℝ → ℝ} {a κ : ℝ} (ha : 0 < a)
    (hφ : ∀ ℓ, a ≤ ℓ → IntervalIntegrable (fun t => φ t / t) volume a ℓ)
    (hκ : Tendsto φ atTop (𝓝 κ)) :
    Tendsto (fun ℓ => (∫ t in a..ℓ, φ t / t) / Real.log ℓ) atTop (𝓝 κ) := by
  have h1 : Tendsto (fun ℓ : ℝ => 1 - Real.log a / Real.log ℓ) atTop (𝓝 1) := by
    have h := (Real.tendsto_log_atTop.const_div_atTop (Real.log a)).const_sub 1
    rwa [sub_zero] at h
  have key : Tendsto (fun ℓ => (∫ t in a..ℓ, φ t / t) / Real.log (ℓ / a)
      * (1 - Real.log a / Real.log ℓ)) atTop (𝓝 κ) := by
    have h := (tendsto_integral_div_div_log_div ha hφ hκ).mul h1
    rwa [mul_one] at h
  refine key.congr' ?_
  filter_upwards [eventually_gt_atTop (max 1 a)] with ℓ hℓ
  have hℓ1 : 1 < ℓ := (le_max_left 1 a).trans_lt hℓ
  have hℓa : a < ℓ := (le_max_right 1 a).trans_lt hℓ
  have hℓ0 : 0 < ℓ := zero_lt_one.trans hℓ1
  have hL : Real.log ℓ ≠ 0 := (Real.log_pos hℓ1).ne'
  have hLa : Real.log (ℓ / a) ≠ 0 := (Real.log_pos ((one_lt_div ha).mpr hℓa)).ne'
  rw [one_sub_div hL, ← Real.log_div hℓ0.ne' ha.ne', div_mul_div_cancel₀ hLa]

end QuantGrav
