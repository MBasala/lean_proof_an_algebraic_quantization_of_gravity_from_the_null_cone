/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.MeasureTheory.Integral.Bochner.Set
public import QuantGrav.Elementary.ClockWeight
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# WP1-g: the integrated clock bound

Paper: arXiv:2611.34924v1, (5.17), with the sentence above it and the sentence above (C.14).

In the paper `μ` is the distribution of clock readings in the incoming state and the weight
`(L / (L + u))²` turns it into the distribution in `Ψ_L`. Here `μ` is an arbitrary probability
measure on the real line that gives no mass to negative readings. The statements therefore do
not depend on the clock operator or its spectral measure (hypothesis H13).

* `integral_clock_weight_le`: `∫ u (L / (L + u))² dμ ≤ L / 4`, the second inequality of (5.17)
  times `ℓ(D)`.
* `setIntegral_clock_tail_le_integral_div`: the Markov step, the first inequality of (5.17).
* `setIntegral_clock_tail_le`: `∫_{u > ℓ} (L / (L + u))² dμ ≤ L / (4 ℓ)`, the two combined.
-/

public section

namespace QuantGrav

open MeasureTheory

/-- For `L > 0` and `u ≥ 0` the factor `(L / (L + u))²` lies in `[0, 1]`. -/
theorem clock_factor_le_one (L u : ℝ) (hL : 0 < L) (hu : 0 ≤ u) : (L / (L + u)) ^ 2 ≤ 1 := by
  have h : 0 < L + u := add_pos_of_pos_of_nonneg hL hu
  have h1 : L / (L + u) ≤ 1 := by
    rw [div_le_one h]
    linarith
  have h0 : 0 ≤ L / (L + u) := by positivity
  nlinarith

/-- The weighted clock reading `u (L / (L + u))²` is integrable against a finite measure that
gives no mass to negative readings. -/
theorem integrable_clock_weight (μ : Measure ℝ) [IsFiniteMeasure μ] (hμ : ∀ᵐ u ∂μ, 0 ≤ u)
    (L : ℝ) (hL : 0 < L) : Integrable (fun u : ℝ => u * (L / (L + u)) ^ 2) μ := by
  refine Integrable.of_bound (Measurable.aestronglyMeasurable (by fun_prop)) (L / 4) ?_
  filter_upwards [hμ] with u hu
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  exact clock_weight_le L u hL hu

/-- The factor `(L / (L + u))²` is integrable against a finite measure that gives no mass to
negative readings. -/
theorem integrable_clock_factor (μ : Measure ℝ) [IsFiniteMeasure μ] (hμ : ∀ᵐ u ∂μ, 0 ≤ u)
    (L : ℝ) (hL : 0 < L) : Integrable (fun u : ℝ => (L / (L + u)) ^ 2) μ := by
  refine Integrable.of_bound (Measurable.aestronglyMeasurable (by fun_prop)) 1 ?_
  filter_upwards [hμ] with u hu
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  exact clock_factor_le_one L u hL hu

/-- **WP1-g**, paper (5.17) and (C.14). For a probability measure `μ` on clock readings `u ≥ 0`
and `L > 0`, the mean of the weighted reading `u (L / (L + u))²` is at most `L / 4`. -/
theorem integral_clock_weight_le (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hμ : ∀ᵐ u ∂μ, 0 ≤ u) (L : ℝ) (hL : 0 < L) :
    ∫ u, u * (L / (L + u)) ^ 2 ∂μ ≤ L / 4 := by
  have h : ∫ u, u * (L / (L + u)) ^ 2 ∂μ ≤ ∫ _u, L / 4 ∂μ := by
    refine integral_mono_ae (integrable_clock_weight μ hμ L hL) (integrable_const _) ?_
    filter_upwards [hμ] with u hu
    exact clock_weight_le L u hL hu
  simpa using h

/-- **WP1-g**, the Markov step in paper (5.17). The weight that `(L / (L + u))² μ` gives to
readings above `ℓ > 0` is at most the mean weighted reading divided by `ℓ`. -/
theorem setIntegral_clock_tail_le_integral_div (μ : Measure ℝ) [IsFiniteMeasure μ]
    (hμ : ∀ᵐ u ∂μ, 0 ≤ u) (L ℓ : ℝ) (hL : 0 < L) (hℓ : 0 < ℓ) :
    ∫ u in Set.Ioi ℓ, (L / (L + u)) ^ 2 ∂μ ≤ (∫ u, u * (L / (L + u)) ^ 2 ∂μ) / ℓ := by
  have hw := integrable_clock_weight μ hμ L hL
  have hf := integrable_clock_factor μ hμ L hL
  have h1 : ∫ u in Set.Ioi ℓ, (L / (L + u)) ^ 2 ∂μ
      ≤ ∫ u in Set.Ioi ℓ, u * (L / (L + u)) ^ 2 / ℓ ∂μ := by
    refine setIntegral_mono_on hf.integrableOn (hw.div_const ℓ).integrableOn
      measurableSet_Ioi fun u hu => ?_
    have hu' : ℓ < u := hu
    rw [le_div_iff₀ hℓ]
    have hnn : 0 ≤ (L / (L + u)) ^ 2 := by positivity
    nlinarith
  have h2 : ∫ u in Set.Ioi ℓ, u * (L / (L + u)) ^ 2 / ℓ ∂μ
      ≤ ∫ u, u * (L / (L + u)) ^ 2 / ℓ ∂μ := by
    refine setIntegral_le_integral (hw.div_const ℓ) ?_
    filter_upwards [hμ] with u hu
    positivity
  have h3 : ∫ u, u * (L / (L + u)) ^ 2 / ℓ ∂μ = (∫ u, u * (L / (L + u)) ^ 2 ∂μ) / ℓ :=
    integral_div ℓ _
  exact h1.trans (h2.trans_eq h3)

/-- **WP1-g**, paper (5.17). For a probability measure `μ` on clock readings `u ≥ 0` and
`L, ℓ > 0`, the weight that `(L / (L + u))² μ` gives to readings above `ℓ` is at most
`L / (4 ℓ)`. -/
theorem setIntegral_clock_tail_le (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hμ : ∀ᵐ u ∂μ, 0 ≤ u) (L ℓ : ℝ) (hL : 0 < L) (hℓ : 0 < ℓ) :
    ∫ u in Set.Ioi ℓ, (L / (L + u)) ^ 2 ∂μ ≤ L / (4 * ℓ) := by
  refine (setIntegral_clock_tail_le_integral_div μ hμ L ℓ hL hℓ).trans ?_
  rw [div_le_div_iff₀ hℓ (by positivity)]
  have h := integral_clock_weight_le μ hμ L hL
  nlinarith

end QuantGrav
