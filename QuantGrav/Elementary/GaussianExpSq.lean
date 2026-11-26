/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Tactic.Field
import Mathlib.Tactic.Positivity

/-!
# The mean of `exp (-b q²)` for a centred Gaussian variable

This file is mathematics only. It uses nothing from the paper. It is lemma G2 of break attempt
B1 in `handoff.md`, Section 14.

* `integral_exp_neg_mul_sq_gaussianReal`: for a centred Gaussian variable `q` of variance `v`
  and `b ≥ 0`, the mean of `exp (-b q²)` is `(1 + 2 b v) ^ (-1/2)`. This is the moment
  generating function of a chi-square variable, evaluated at a nonpositive argument.
-/

public section

namespace QuantGrav

open MeasureTheory ProbabilityTheory
open scoped NNReal

/-- **G2.** For a centred Gaussian variable `q` of variance `v` and `b ≥ 0`, the mean of
`exp (-b q²)` is `(1 + 2 b v) ^ (-1/2)`. -/
theorem integral_exp_neg_mul_sq_gaussianReal (v : ℝ≥0) {b : ℝ} (hb : 0 ≤ b) :
    ∫ x, Real.exp (-(b * x ^ 2)) ∂(gaussianReal 0 v) = (1 + 2 * b * v) ^ (-(1 / 2 : ℝ)) := by
  -- For `v = 0` the measure is the point mass at `0`, and both sides are `1`.
  rcases eq_or_ne v 0 with rfl | hv
  · simp
  have hv' : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have h1 : (0 : ℝ) < 1 + 2 * b * v := by positivity
  -- The Gaussian density times `exp (-b x²)` is a constant times `exp (-(b + 1 / (2 v)) x²)`.
  have hfun : ∀ x : ℝ, gaussianPDFReal 0 v x • Real.exp (-(b * x ^ 2)) =
      (Real.sqrt (2 * Real.pi * v))⁻¹ * Real.exp (-(b + 1 / (2 * v)) * x ^ 2) := by
    intro x
    have hexp : -(x - 0) ^ 2 / (2 * v) + -(b * x ^ 2) = -(b + 1 / (2 * v)) * x ^ 2 := by
      field
    rw [gaussianPDFReal, smul_eq_mul, mul_assoc, ← Real.exp_add, hexp]
  have h2 : Real.pi / (b + 1 / (2 * v)) = 2 * Real.pi * v / (1 + 2 * b * v) := by
    field
  -- Mathlib's Gaussian integral gives `√(π / (b + 1 / (2 v)))` for the Lebesgue integral of the
  -- second factor. The rest is algebra with square roots.
  rw [integral_gaussianReal_eq_integral_smul hv]
  simp_rw [hfun]
  rw [integral_const_mul, integral_gaussian, h2, Real.sqrt_div (by positivity),
    Real.rpow_neg h1.le, ← Real.sqrt_eq_rpow]
  field

end QuantGrav
