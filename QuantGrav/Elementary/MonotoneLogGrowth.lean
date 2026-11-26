/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Elementary.LogIntegralLimit
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.MeasureTheory.Integral.DivergenceTheorem
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Logarithmic growth of a nondecreasing function from its running mean

Paper: arXiv:2611.34924v1, Sec 5.3: (5.57a), (5.57b), (5.58).

This file is Track A item 4 of `handoff.md`, Section 14.3, for a general nondecreasing function
`Z`. In the paper `Z(ℓ)` is the thermal trace of the diamond with maximum clock reading `ℓ`,
(5.56). Write `I(ℓ) = ∫_0^ℓ Z`. By (5.56), `I(ℓ) = Z(ℓ) (ℓ - ⟨u⟩_ℓ)`, so

* `I(ℓ) / (ℓ Z(ℓ))` is `1 - ⟨u⟩_ℓ / ℓ`, and (5.57b) says that it tends to `1 - q`;
* `(ℓ Z(ℓ) - I(ℓ)) / I(ℓ)` is `⟨u⟩_ℓ / (ℓ - ⟨u⟩_ℓ)`, the right side of (5.57a) and the
  integrand of (5.58).

Nothing in this file refers to states. The dictionary to a spectrum is in
`QuantGrav/Entropy/ClockTraceAsymptotics.lean`.

## Results

* `log_integral_div_sub_log_integral_div`: (5.57a) integrated from `a` to `ℓ`, across the jumps
  of `Z`. For `0 < a ≤ ℓ` with `I(a) > 0`,
  `log (I(ℓ) / ℓ) - log (I(a) / a) = ∫_a^ℓ [(t Z(t) - I(t)) / I(t)] dt / t`.
* `log_eq_integral_add_log_sub_log`: the first equality of (5.58), exactly, with `log Z(ℓ)` on
  the left as in the paper. The paper's `O(1)` is `log (I(a) / a) - log (I(ℓ) / (ℓ Z(ℓ)))`. The
  first term is a constant. The second is bounded when `I(ℓ) / (ℓ Z(ℓ))` stays away from zero,
  which (5.57b) with `q < 1` provides; in general it is only nonnegative.
* `tendsto_log_div_log_of_tendsto_integral_div`: (5.58) from (5.57b). If `Z` is nondecreasing and
  somewhere positive, and `I(ℓ) / (ℓ Z(ℓ)) → 1 - q` with `q < 1`, then
  `log Z(ℓ) / log ℓ → q / (1 - q)`.
* `tendsto_log_div_log_div_of_tendsto_integral_div`: the same with `log (ℓ / ℓ₀)` in the
  denominator, as (5.58) is written.

## What this does and does not say

The limit `q` is a hypothesis. The paper obtains its existence, and the bound `q < 1`, from
(5.53) and (5.54); none of that is proved here.
-/

public section

namespace QuantGrav

open Filter Topology MeasureTheory

/-- The running integral `ℓ ↦ ∫_0^ℓ Z` of a nondecreasing `Z` is continuous. -/
private theorem continuous_integral_of_monotone {Z : ℝ → ℝ} (hZ : Monotone Z) :
    Continuous fun t => ∫ x in (0 : ℝ)..t, Z x :=
  intervalIntegral.continuous_primitive (fun _ _ => hZ.intervalIntegrable) 0

/-- For a nondecreasing `Z` and `0 < a`, if `∫_0^a Z > 0` then `Z(a) > 0`: otherwise `Z ≤ 0` on
`[0, a]`. -/
private theorem pos_of_integral_pos {Z : ℝ → ℝ} (hZ : Monotone Z) {a : ℝ} (ha : 0 < a)
    (hI : 0 < ∫ t in (0 : ℝ)..a, Z t) : 0 < Z a := by
  by_contra h
  rw [not_lt] at h
  refine hI.not_ge ?_
  rw [intervalIntegral.integral_of_le ha.le]
  exact setIntegral_nonpos measurableSet_Ioc fun t ht => (hZ ht.2).trans h

/-- For a nondecreasing `Z` and `0 < a ≤ ℓ`, if `∫_0^a Z > 0` then `∫_0^ℓ Z > 0`. This is the
paper's condition on the lower limit `ℓ_0` of (5.58), carried to every later `ℓ`. -/
theorem integral_pos_of_integral_pos_of_le {Z : ℝ → ℝ} (hZ : Monotone Z) {a ℓ : ℝ} (ha : 0 < a)
    (haℓ : a ≤ ℓ) (hI : 0 < ∫ t in (0 : ℝ)..a, Z t) : 0 < ∫ t in (0 : ℝ)..ℓ, Z t := by
  have hZa : 0 < Z a := pos_of_integral_pos hZ ha hI
  have h1 : 0 ≤ ∫ t in a..ℓ, Z t :=
    intervalIntegral.integral_nonneg haℓ fun t ht => hZa.le.trans (hZ ht.1)
  have h2 := intervalIntegral.integral_add_adjacent_intervals
    (hZ.intervalIntegrable (μ := volume) (a := 0) (b := a))
    (hZ.intervalIntegrable (μ := volume) (a := a) (b := ℓ))
  rw [← h2]
  exact add_pos_of_pos_of_nonneg hI h1

/-- The integrand of (5.58) is integrable on `[a, ℓ]`. -/
theorem intervalIntegrable_sub_integral_div_integral_div {Z : ℝ → ℝ} (hZ : Monotone Z)
    {a ℓ : ℝ} (ha : 0 < a) (haℓ : a ≤ ℓ) (hI : 0 < ∫ t in (0 : ℝ)..a, Z t) :
    IntervalIntegrable
      (fun t => ((t * Z t - ∫ x in (0 : ℝ)..t, Z x) / ∫ x in (0 : ℝ)..t, Z x) / t)
      volume a ℓ := by
  have hpos : ∀ t ∈ Set.uIcc a ℓ, 0 < t ∧ 0 < ∫ x in (0 : ℝ)..t, Z x := by
    intro t ht
    rw [Set.uIcc_of_le haℓ] at ht
    exact ⟨ha.trans_le ht.1, integral_pos_of_integral_pos_of_le hZ ha ht.1 hI⟩
  -- On `[a, ℓ]` the integrand is `Z(t) / I(t) - 1 / t`: a monotone function times a continuous
  -- one, minus a continuous one.
  have h1 : IntervalIntegrable (fun t => Z t * (∫ x in (0 : ℝ)..t, Z x)⁻¹) volume a ℓ :=
    hZ.intervalIntegrable.mul_continuousOn
      ((continuous_integral_of_monotone hZ).continuousOn.fun_inv₀ fun t ht => (hpos t ht).2.ne')
  have h2 : IntervalIntegrable (fun t : ℝ => t⁻¹) volume a ℓ :=
    (continuousOn_id.fun_inv₀ fun t ht => (hpos t ht).1.ne').intervalIntegrable
  refine (h1.sub h2).congr fun t ht => ?_
  obtain ⟨ht0, hIt⟩ := hpos t (Set.uIoc_subset_uIcc ht)
  field_simp

/-- **(5.57a), integrated.** For a nondecreasing `Z`, with `I(ℓ) = ∫_0^ℓ Z` and `0 < a ≤ ℓ` such
that `I(a) > 0`:
`log (I(ℓ) / ℓ) - log (I(a) / a) = ∫_a^ℓ [(t Z(t) - I(t)) / I(t)] dt / t`.
By (5.56) the integrand in brackets is `⟨u⟩_t / (t - ⟨u⟩_t)`, the right side of (5.57a). The
jumps of `Z` are allowed. -/
theorem log_integral_div_sub_log_integral_div {Z : ℝ → ℝ} (hZ : Monotone Z) {a ℓ : ℝ}
    (ha : 0 < a) (haℓ : a ≤ ℓ) (hI : 0 < ∫ t in (0 : ℝ)..a, Z t) :
    Real.log ((∫ t in (0 : ℝ)..ℓ, Z t) / ℓ) - Real.log ((∫ t in (0 : ℝ)..a, Z t) / a)
      = ∫ t in a..ℓ, ((t * Z t - ∫ x in (0 : ℝ)..t, Z x) / ∫ x in (0 : ℝ)..t, Z x) / t := by
  have hpos : ∀ t, a ≤ t → 0 < ∫ x in (0 : ℝ)..t, Z x := fun t ht =>
    integral_pos_of_integral_pos_of_le hZ ha ht hI
  -- The fundamental theorem of calculus for `F(t) = log (I(t) / t)` on `[a, ℓ]`, with the
  -- countably many discontinuities of `Z` as the exceptional set.
  symm
  refine integral_eq_of_hasDerivAt_off_countable_of_le
    (fun t => Real.log ((∫ x in (0 : ℝ)..t, Z x) / t))
    (fun t => ((t * Z t - ∫ x in (0 : ℝ)..t, Z x) / ∫ x in (0 : ℝ)..t, Z x) / t)
    haℓ hZ.countable_not_continuousAt ?_ ?_
    (intervalIntegrable_sub_integral_div_integral_div hZ ha haℓ hI)
  · -- `F` is continuous on `[a, ℓ]`, where `I > 0` and `t > 0`.
    intro t ht
    have ht0 : 0 < t := ha.trans_le ht.1
    refine ContinuousAt.continuousWithinAt (ContinuousAt.log ?_ (div_pos (hpos t ht.1) ht0).ne')
    exact (continuous_integral_of_monotone hZ).continuousAt.div₀ continuousAt_id ht0.ne'
  · -- Where `Z` is continuous, `I'(t) = Z(t)`, so
    -- `F'(t) = ((t Z(t) - I(t)) / t ^ 2) / (I(t) / t)`, which is the integrand.
    rintro t ⟨ht, hts⟩
    have ht0 : 0 < t := ha.trans ht.1
    have hIt : 0 < ∫ x in (0 : ℝ)..t, Z x := hpos t ht.1.le
    have hd : HasDerivAt (fun u => ∫ x in (0 : ℝ)..u, Z x) (Z t) t :=
      intervalIntegral.integral_hasDerivAt_right hZ.intervalIntegrable
        hZ.measurable.stronglyMeasurable.stronglyMeasurableAtFilter (not_not.mp hts)
    convert ((hd.fun_div (hasDerivAt_id' t) ht0.ne').log (div_pos hIt ht0).ne') using 1
    field_simp

/-- **The first equality of (5.58), exactly.** The last two terms are the paper's `O(1)`:
`log (I(a) / a)` is a constant, and `I(ℓ) / (ℓ Z(ℓ))` is `1 - ⟨u⟩_ℓ / ℓ` by (5.56). The last
term is bounded when that ratio stays away from zero, as under (5.57b) with `q < 1`; in general
it is only nonnegative. -/
theorem log_eq_integral_add_log_sub_log {Z : ℝ → ℝ} (hZ : Monotone Z) {a ℓ : ℝ}
    (ha : 0 < a) (haℓ : a ≤ ℓ) (hI : 0 < ∫ t in (0 : ℝ)..a, Z t) :
    Real.log (Z ℓ)
      = (∫ t in a..ℓ, ((t * Z t - ∫ x in (0 : ℝ)..t, Z x) / ∫ x in (0 : ℝ)..t, Z x) / t)
        + Real.log ((∫ t in (0 : ℝ)..a, Z t) / a)
        - Real.log ((∫ t in (0 : ℝ)..ℓ, Z t) / (ℓ * Z ℓ)) := by
  have hℓ : 0 < ℓ := ha.trans_le haℓ
  have hZℓ : 0 < Z ℓ := (pos_of_integral_pos hZ ha hI).trans_le (hZ haℓ)
  have hIℓ : 0 < ∫ t in (0 : ℝ)..ℓ, Z t := integral_pos_of_integral_pos_of_le hZ ha haℓ hI
  -- `I(ℓ) / ℓ = Z(ℓ) * (I(ℓ) / (ℓ Z(ℓ)))`, and both factors are positive.
  have h1 : Real.log ((∫ t in (0 : ℝ)..ℓ, Z t) / ℓ)
      = Real.log (Z ℓ) + Real.log ((∫ t in (0 : ℝ)..ℓ, Z t) / (ℓ * Z ℓ)) := by
    rw [← Real.log_mul hZℓ.ne' (div_pos hIℓ (mul_pos hℓ hZℓ)).ne']
    congr 1
    field_simp
  rw [← log_integral_div_sub_log_integral_div hZ ha haℓ hI, h1]
  ring

/-- **(5.58) from (5.57b).** Let `Z` be nondecreasing and somewhere positive. If
`(1 / ℓ) ∫_0^ℓ Z = [1 - q + o(1)] Z(ℓ)` with `q < 1`, then
`log Z(ℓ) = [q / (1 - q) + o(1)] log ℓ`. The hypotheses force `0 ≤ q`, because
`∫_0^ℓ Z ≤ ℓ Z(ℓ)` for a nondecreasing `Z`. -/
theorem tendsto_log_div_log_of_tendsto_integral_div {Z : ℝ → ℝ} {q : ℝ} (hZ : Monotone Z)
    (hpos : ∃ ℓ₀, 0 < Z ℓ₀) (hq1 : q < 1)
    (hq : Tendsto (fun ℓ => (∫ t in (0 : ℝ)..ℓ, Z t) / (ℓ * Z ℓ)) atTop (𝓝 (1 - q))) :
    Tendsto (fun ℓ => Real.log (Z ℓ) / Real.log ℓ) atTop (𝓝 (q / (1 - q))) := by
  obtain ⟨ℓ₀, hℓ₀⟩ := hpos
  have hq0 : 0 < 1 - q := sub_pos.mpr hq1
  -- A base point `a ≥ max ℓ₀ 1` with `I(a) > 0`.
  obtain ⟨a, hρa, haM⟩ :=
    ((hq.eventually_const_lt hq0).and (eventually_ge_atTop (max ℓ₀ 1))).exists
  have ha : 0 < a := zero_lt_one.trans_le ((le_max_right ℓ₀ 1).trans haM)
  have hZa : 0 < Z a := hℓ₀.trans_le (hZ ((le_max_left ℓ₀ 1).trans haM))
  have hI : 0 < ∫ t in (0 : ℝ)..a, Z t := (div_pos_iff_of_pos_right (mul_pos ha hZa)).mp hρa
  -- The integrand of (5.58) tends to `q / (1 - q)`.
  have hφ : Tendsto (fun t => (t * Z t - ∫ x in (0 : ℝ)..t, Z x) / ∫ x in (0 : ℝ)..t, Z x)
      atTop (𝓝 (q / (1 - q))) := by
    have h1 : Tendsto (fun t => ((∫ x in (0 : ℝ)..t, Z x) / (t * Z t))⁻¹ - 1) atTop
        (𝓝 ((1 - q)⁻¹ - 1)) := (hq.inv₀ hq0.ne').sub_const 1
    have h2 : (1 - q)⁻¹ - 1 = q / (1 - q) := by
      field_simp
      ring
    rw [h2] at h1
    refine h1.congr' ?_
    filter_upwards [eventually_ge_atTop a] with t ht
    rw [inv_div, div_sub_one (integral_pos_of_integral_pos_of_le hZ ha ht hI).ne']
  -- The three terms of `log_eq_integral_add_log_sub_log`, each divided by `log ℓ`.
  have hJ := tendsto_integral_div_div_log ha
    (fun ℓ hℓ => intervalIntegrable_sub_integral_div_integral_div hZ ha hℓ hI) hφ
  have hc : Tendsto (fun ℓ : ℝ => Real.log ((∫ t in (0 : ℝ)..a, Z t) / a) / Real.log ℓ) atTop
      (𝓝 0) := tendsto_const_nhds.div_atTop Real.tendsto_log_atTop
  have hρ : Tendsto
      (fun ℓ => Real.log ((∫ t in (0 : ℝ)..ℓ, Z t) / (ℓ * Z ℓ)) / Real.log ℓ) atTop (𝓝 0) :=
    ((Real.continuousAt_log hq0.ne').tendsto.comp hq).div_atTop Real.tendsto_log_atTop
  have hsum := (hJ.add hc).sub hρ
  rw [add_zero, sub_zero] at hsum
  refine hsum.congr' ?_
  filter_upwards [eventually_ge_atTop a] with ℓ hℓ
  rw [log_eq_integral_add_log_sub_log hZ ha hℓ hI]
  ring

/-- (5.58) as the paper writes it, with `log (ℓ / ℓ₀)` in the denominator for a fixed
`ℓ₀ > 0`. Any positive `ℓ₀` will do; the paper's condition `∫_0^{ℓ₀} Z > 0` is not needed for
the limit. -/
theorem tendsto_log_div_log_div_of_tendsto_integral_div {Z : ℝ → ℝ} {q : ℝ} (hZ : Monotone Z)
    (hpos : ∃ ℓ₀, 0 < Z ℓ₀) (hq1 : q < 1)
    (hq : Tendsto (fun ℓ => (∫ t in (0 : ℝ)..ℓ, Z t) / (ℓ * Z ℓ)) atTop (𝓝 (1 - q)))
    {ℓ₀ : ℝ} (hℓ₀ : 0 < ℓ₀) :
    Tendsto (fun ℓ => Real.log (Z ℓ) / Real.log (ℓ / ℓ₀)) atTop (𝓝 (q / (1 - q))) := by
  have h := tendsto_log_div_log_of_tendsto_integral_div hZ hpos hq1 hq
  -- For `ℓ > 1`, `log (ℓ / ℓ₀) = log ℓ * (1 - log ℓ₀ / log ℓ)`, and the last factor tends to `1`.
  have h1 : Tendsto (fun ℓ : ℝ => 1 - Real.log ℓ₀ / Real.log ℓ) atTop (𝓝 (1 - 0)) :=
    (tendsto_const_nhds.div_atTop Real.tendsto_log_atTop).const_sub 1
  rw [sub_zero] at h1
  have h2 : Tendsto (fun ℓ => Real.log (Z ℓ) / Real.log ℓ / (1 - Real.log ℓ₀ / Real.log ℓ)) atTop
      (𝓝 (q / (1 - q) / 1)) := h.div h1 one_ne_zero
  rw [div_one] at h2
  refine h2.congr' ?_
  filter_upwards [eventually_gt_atTop 1] with ℓ hℓ
  have hL : Real.log ℓ ≠ 0 := (Real.log_pos hℓ).ne'
  rw [Real.log_div (zero_lt_one.trans hℓ).ne' hℓ₀.ne', one_sub_div hL,
    div_div_div_cancel_right₀ hL]

end QuantGrav
