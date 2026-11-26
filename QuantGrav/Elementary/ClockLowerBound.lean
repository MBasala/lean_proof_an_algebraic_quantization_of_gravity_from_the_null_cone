/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Sqrt
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import Mathlib.MeasureTheory.Function.L2Space
public import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# WP1-f: the classical lower bound on the clock

Paper: arXiv:2611.34924v1, (3.26c), (3.27), (3.28), footnote 8, and the classical content of
(5.21a) to (5.21c).

On the corner sphere `S`, with solid angle element `ε₀` of total mass `4π`, the paper has an
area density `ϱ_S(y)`, the area `𝒜 = ∫ ϱ_S² ε₀`, a clock reading per null generator
`u_*(y) = ϱ_S(y) ∫_ε^1 exp (Ξ_y(v)) dv` with focusing term `Ξ_y ≥ 0`, and the averaged clock
`ū_* = (∫ ϱ_S u_* ε₀) / (∫ ϱ_S ε₀)` (3.28). Footnote 8 states
`(1 - ε) (𝒜 / 4π)^(1/2) ≤ ū_*`.

Here `S` is any measurable space with a finite measure `ν` of total mass `4π`, and `ϱ_S` is a
nonnegative square-integrable function `ρ`.

* `focusing_nonneg`: the focusing term (3.26c) is nonnegative.
* `clock_reading_ge`: hence `u_*(y) ≥ (1 - ε) ϱ_S(y)` (3.27).
* `sq_integral_le_measure_mul_integral_sq`: Cauchy-Schwarz on `S`, the classical form of
  (5.21b), `(∫ ϱ_S ε₀)² ≤ 4π 𝒜`.
* `clock_mean_ge_area_div`: the classical form of (5.21a), `ū_* ≥ (1 - ε) 𝒜 / ∫ ϱ_S ε₀`.
* `clock_mean_ge`, `clock_mean_ge_of_focusing`: footnote 8, the classical form of (5.21c).
* `clock_mean_eq_of_const`: the bound is attained for vanishing shear and constant area
  density, as the last sentence of App D.3 says.

These are statements about functions on the sphere. The operator inequalities (5.21a) to
(5.21c) for the quantum clock are hypotheses H14 and H14a and are not proved here.
-/

public section

namespace QuantGrav

open MeasureTheory

/-- Paper (3.26c): the focusing term `Ξ(v) = (1/8) ∫_ε^v s g(s) ds` is nonnegative, where
`g = (∂_s q̄)^{AB} ∂_s q̄_{AB}` is nonnegative because it is a sum of squares (4.21). -/
theorem focusing_nonneg (ε v : ℝ) (g : ℝ → ℝ) (hε : 0 ≤ ε) (hv : ε ≤ v)
    (hg : ∀ s ∈ Set.Icc ε v, 0 ≤ g s) : 0 ≤ 1 / 8 * ∫ s in ε..v, s * g s := by
  refine mul_nonneg (by norm_num) (intervalIntegral.integral_nonneg hv fun s hs => ?_)
  exact mul_nonneg (hε.trans hs.1) (hg s hs)

/-- Paper (3.27) with `Ξ ≥ 0`: the clock reading of one null generator,
`ϱ_S ∫_ε^1 exp (Ξ(v)) dv`, is at least `(1 - ε) ϱ_S`. -/
theorem clock_reading_ge (ρ₀ ε : ℝ) (Ξ : ℝ → ℝ) (hρ : 0 ≤ ρ₀) (hε : ε ≤ 1)
    (hΞ : ∀ v ∈ Set.Icc ε 1, 0 ≤ Ξ v)
    (hint : IntervalIntegrable (fun v => Real.exp (Ξ v)) volume ε 1) :
    (1 - ε) * ρ₀ ≤ ρ₀ * ∫ v in ε..1, Real.exp (Ξ v) := by
  have h1 : (∫ _v in ε..1, (1 : ℝ)) ≤ ∫ v in ε..1, Real.exp (Ξ v) :=
    intervalIntegral.integral_mono_on hε intervalIntegrable_const hint
      fun v hv => Real.one_le_exp (hΞ v hv)
  rw [intervalIntegral.integral_const, smul_eq_mul, mul_one] at h1
  calc (1 - ε) * ρ₀ = ρ₀ * (1 - ε) := mul_comm _ _
    _ ≤ ρ₀ * ∫ v in ε..1, Real.exp (Ξ v) := mul_le_mul_of_nonneg_left h1 hρ

variable {S : Type*} [MeasurableSpace S]

/-- Cauchy-Schwarz on `S`, the classical form of paper (5.21b): for a square-integrable `ρ` on
a finite measure space, `(∫ ρ)² ≤ ν(S) ∫ ρ²`. With `ν(S) = 4π` this is `𝖺² ≤ 4π 𝒜`. -/
theorem sq_integral_le_measure_mul_integral_sq (ν : Measure S) [IsFiniteMeasure ν] {ρ : S → ℝ}
    (hρ2 : MemLp ρ 2 ν) : (∫ y, ρ y ∂ν) ^ 2 ≤ ν.real Set.univ * ∫ y, ρ y ^ 2 ∂ν := by
  have hint : Integrable ρ ν := hρ2.integrable one_le_two
  have hsq : Integrable (fun y => ρ y ^ 2) ν := hρ2.integrable_sq
  have key : ∀ t : ℝ,
      0 ≤ ν.real Set.univ * (t * t) + -2 * (∫ y, ρ y ∂ν) * t + ∫ y, ρ y ^ 2 ∂ν := by
    intro t
    have h0 : 0 ≤ ∫ y, (ρ y - t) ^ 2 ∂ν := integral_nonneg fun y => sq_nonneg _
    have hexp : ∫ y, (ρ y - t) ^ 2 ∂ν
        = ∫ y, ρ y ^ 2 ∂ν - 2 * t * ∫ y, ρ y ∂ν + ν.real Set.univ * t ^ 2 := by
      have hfun : (fun y => (ρ y - t) ^ 2) = fun y => ρ y ^ 2 - 2 * t * ρ y + t ^ 2 := by
        funext y
        ring
      have hi1 : Integrable (fun y => 2 * t * ρ y) ν := hint.const_mul _
      have hi2 : Integrable (fun y => ρ y ^ 2 - 2 * t * ρ y) ν := hsq.sub hi1
      rw [hfun, integral_add hi2 (integrable_const _), integral_sub hsq hi1,
        integral_const_mul, integral_const, smul_eq_mul]
    rw [hexp] at h0
    linarith
  have hd := discrim_le_zero key
  rw [discrim] at hd
  nlinarith [hd]

/-- If `ρ ≥ 0` is integrable and `∫ ρ² > 0` then `∫ ρ > 0`. -/
theorem integral_pos_of_integral_sq_pos (ν : Measure S) {ρ : S → ℝ} (hρ : ∀ y, 0 ≤ ρ y)
    (hρint : Integrable ρ ν) (hA : 0 < ∫ y, ρ y ^ 2 ∂ν) : 0 < ∫ y, ρ y ∂ν := by
  have hρ' : 0 ≤ ρ := fun y => hρ y
  rcases (integral_nonneg hρ').lt_or_eq with h | h
  · exact h
  · exfalso
    have hz : ρ =ᵐ[ν] 0 := (integral_eq_zero_iff_of_nonneg hρ' hρint).mp h.symm
    have hz2 : (fun y => ρ y ^ 2) =ᵐ[ν] fun _ => (0 : ℝ) := by
      filter_upwards [hz] with y hy
      rw [hy]
      simp
    rw [integral_congr_ae hz2, integral_zero] at hA
    exact lt_irrefl _ hA

/-- The classical form of paper (5.21a): the averaged clock (3.28) is at least
`(1 - ε) 𝒜 / 𝖺`, where `𝒜 = ∫ ρ²` and `𝖺 = ∫ ρ`, when each generator reads at least
`(1 - ε) ρ`. -/
theorem clock_mean_ge_area_div (ν : Measure S) {ρ u : S → ℝ} {ε : ℝ} (hρ : ∀ y, 0 ≤ ρ y)
    (hρint : Integrable ρ ν) (hsq : Integrable (fun y => ρ y ^ 2) ν)
    (hu : ∀ y, (1 - ε) * ρ y ≤ u y) (hint : Integrable (fun y => ρ y * u y) ν)
    (hA : 0 < ∫ y, ρ y ^ 2 ∂ν) :
    (1 - ε) * (∫ y, ρ y ^ 2 ∂ν) / ∫ y, ρ y ∂ν ≤ (∫ y, ρ y * u y ∂ν) / ∫ y, ρ y ∂ν := by
  have hapos := integral_pos_of_integral_sq_pos ν hρ hρint hA
  have h1 : ∫ y, (1 - ε) * ρ y ^ 2 ∂ν ≤ ∫ y, ρ y * u y ∂ν := by
    refine integral_mono (hsq.const_mul _) hint fun y => ?_
    have h2 := mul_le_mul_of_nonneg_left (hu y) (hρ y)
    calc (1 - ε) * ρ y ^ 2 = ρ y * ((1 - ε) * ρ y) := by ring
      _ ≤ ρ y * u y := h2
  rw [integral_const_mul] at h1
  exact div_le_div_of_nonneg_right h1 hapos.le

/-- **WP1-f**, paper footnote 8 and the classical form of (5.21c). Let the corner sphere carry a
finite measure of total mass `4π`, an area density `ρ ≥ 0` in `L²` with area `𝒜 = ∫ ρ² > 0`,
and clock readings `u ≥ (1 - ε) ρ` with `ε ≤ 1`. Then the averaged clock `(∫ ρ u) / (∫ ρ)` is
at least `(1 - ε) (𝒜 / 4π)^(1/2)`. -/
theorem clock_mean_ge (ν : Measure S) [IsFiniteMeasure ν] (hν : ν.real Set.univ = 4 * Real.pi)
    {ρ u : S → ℝ} {ε : ℝ} (hε : ε ≤ 1) (hρ : ∀ y, 0 ≤ ρ y) (hρ2 : MemLp ρ 2 ν)
    (hu : ∀ y, (1 - ε) * ρ y ≤ u y) (hint : Integrable (fun y => ρ y * u y) ν)
    (hA : 0 < ∫ y, ρ y ^ 2 ∂ν) :
    (1 - ε) * Real.sqrt ((∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi))
      ≤ (∫ y, ρ y * u y ∂ν) / ∫ y, ρ y ∂ν := by
  have hρint : Integrable ρ ν := hρ2.integrable one_le_two
  have hsq : Integrable (fun y => ρ y ^ 2) ν := hρ2.integrable_sq
  have hpi : 0 < 4 * Real.pi := by positivity
  have hapos := integral_pos_of_integral_sq_pos ν hρ hρint hA
  have hCS : (∫ y, ρ y ∂ν) ^ 2 ≤ 4 * Real.pi * ∫ y, ρ y ^ 2 ∂ν := by
    have h := sq_integral_le_measure_mul_integral_sq ν hρ2
    rwa [hν] at h
  have hale : ∫ y, ρ y ∂ν ≤ Real.sqrt (4 * Real.pi * ∫ y, ρ y ^ 2 ∂ν) :=
    (Real.le_sqrt hapos.le (mul_nonneg hpi.le hA.le)).mpr hCS
  have hsqrt : Real.sqrt ((∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi))
      * Real.sqrt (4 * Real.pi * ∫ y, ρ y ^ 2 ∂ν) = ∫ y, ρ y ^ 2 ∂ν := by
    rw [← Real.sqrt_mul (div_nonneg hA.le hpi.le)]
    have h : (∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi) * (4 * Real.pi * ∫ y, ρ y ^ 2 ∂ν)
        = (∫ y, ρ y ^ 2 ∂ν) * ∫ y, ρ y ^ 2 ∂ν := by
      field_simp
    rw [h, Real.sqrt_mul_self hA.le]
  refine le_trans ?_ (clock_mean_ge_area_div ν hρ hρint hsq hu hint hA)
  rw [le_div_iff₀ hapos]
  calc (1 - ε) * Real.sqrt ((∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi)) * ∫ y, ρ y ∂ν
      ≤ (1 - ε) * Real.sqrt ((∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi))
          * Real.sqrt (4 * Real.pi * ∫ y, ρ y ^ 2 ∂ν) :=
        mul_le_mul_of_nonneg_left hale (mul_nonneg (sub_nonneg.mpr hε) (Real.sqrt_nonneg _))
    _ = (1 - ε) * ∫ y, ρ y ^ 2 ∂ν := by rw [mul_assoc, hsqrt]

/-- **WP1-f** in the paper's variables: with clock readings `u_*(y) = ρ(y) ∫_ε^1 exp (Ξ_y(v)) dv`
(3.27) and focusing terms `Ξ_y ≥ 0`, the averaged clock (3.28) is at least
`(1 - ε) (𝒜 / 4π)^(1/2)`. -/
theorem clock_mean_ge_of_focusing (ν : Measure S) [IsFiniteMeasure ν]
    (hν : ν.real Set.univ = 4 * Real.pi) {ρ : S → ℝ} {Ξ : S → ℝ → ℝ} {ε : ℝ} (hε : ε ≤ 1)
    (hρ : ∀ y, 0 ≤ ρ y) (hρ2 : MemLp ρ 2 ν) (hΞ : ∀ y, ∀ v ∈ Set.Icc ε 1, 0 ≤ Ξ y v)
    (hΞint : ∀ y, IntervalIntegrable (fun v => Real.exp (Ξ y v)) volume ε 1)
    (hint : Integrable (fun y => ρ y * (ρ y * ∫ v in ε..1, Real.exp (Ξ y v))) ν)
    (hA : 0 < ∫ y, ρ y ^ 2 ∂ν) :
    (1 - ε) * Real.sqrt ((∫ y, ρ y ^ 2 ∂ν) / (4 * Real.pi))
      ≤ (∫ y, ρ y * (ρ y * ∫ v in ε..1, Real.exp (Ξ y v)) ∂ν) / ∫ y, ρ y ∂ν :=
  clock_mean_ge ν hν hε hρ hρ2
    (fun y => clock_reading_ge (ρ y) ε (Ξ y) (hρ y) hε (hΞ y) (hΞint y)) hint hA

/-- The bound of `clock_mean_ge` is attained: for a constant area density `r > 0` and no shear,
so that every generator reads `(1 - ε) r`, the averaged clock equals
`(1 - ε) (𝒜 / 4π)^(1/2)`. Paper: the last sentence of App D.3. -/
theorem clock_mean_eq_of_const (ν : Measure S) [IsFiniteMeasure ν]
    (hν : ν.real Set.univ = 4 * Real.pi) (r ε : ℝ) (hr : 0 < r) :
    (∫ _y, r * ((1 - ε) * r) ∂ν) / ∫ _y, r ∂ν
      = (1 - ε) * Real.sqrt ((∫ _y, r ^ 2 ∂ν) / (4 * Real.pi)) := by
  have hpi : (4 * Real.pi) ≠ 0 := by positivity
  simp only [integral_const, smul_eq_mul, hν]
  have h1 : 4 * Real.pi * r ^ 2 / (4 * Real.pi) = r ^ 2 := by field_simp
  rw [h1, Real.sqrt_sq hr.le]
  field_simp

end QuantGrav
