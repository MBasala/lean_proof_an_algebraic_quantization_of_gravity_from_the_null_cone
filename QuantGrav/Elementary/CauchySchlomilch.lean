/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral

/-!
# A Gaussian integral with an inverse term

Paper: arXiv:2611.34924v1, Sec 5.3, (5.66). This file is the analytic step behind the first
identity of (5.66); the identity itself is in `QuantGrav/Entropy/AreaResolvedTrace.lean`. Both
are Track A item 5 of `handoff.md`, Section 14.3.

For `a > 0` and `b ≥ 0`,

`∫_0^∞ exp(-(a u - b / u)²) du = √π / (2 a)`,

the same value as for `b = 0`. This is the Cauchy–Schlömilch transformation for the Gaussian.
For `b > 0` the substitution `y = a u - b / u` maps `(0, ∞)` onto the line with
`dy = (a + b / u²) du`, and the substitution `u ↦ b / (a u)` shows that the two parts of that
measure contribute equally. For `b = 0` the integral is the Gaussian integral over the half
line.

## Results

* `integrableOn_exp_neg_sq_mul_sub_div`: the integrand is integrable on `(0, ∞)`.
* `integral_exp_neg_sq_mul_sub_div`: the value `√π / (2 a)`.

The paper does not state this integral. It states the identity that follows from it.
-/

public section

namespace QuantGrav

open MeasureTheory

/-! ### The substitution `y = a u - b / u` -/

/-- On `(0, ∞)` the map `u ↦ a u - b / u` has derivative `a + b / u²`. -/
private theorem hasDerivWithinAt_mul_sub_div (a b : ℝ) {u : ℝ} (hu : u ∈ Set.Ioi (0 : ℝ)) :
    HasDerivWithinAt (fun u : ℝ => a * u - b / u) (a + b / u ^ 2) (Set.Ioi 0) u := by
  have hu' : u ≠ 0 := (Set.mem_Ioi.mp hu).ne'
  have h := ((hasDerivAt_id u).const_mul a).sub
    ((hasDerivAt_const u b).div (hasDerivAt_id u) hu')
  refine (h.congr_deriv ?_).hasDerivWithinAt
  simp only [id]
  ring

/-- For `a > 0` and `b ≥ 0` the map `u ↦ a u - b / u` is strictly increasing on `(0, ∞)`. -/
private theorem strictMonoOn_mul_sub_div {a b : ℝ} (ha : 0 < a) (hb : 0 ≤ b) :
    StrictMonoOn (fun u : ℝ => a * u - b / u) (Set.Ioi 0) := by
  intro x hx y _ hxy
  have h1 : a * x < a * y := mul_lt_mul_of_pos_left hxy ha
  have h2 : b / y ≤ b / x := div_le_div_of_nonneg_left hb hx hxy.le
  beta_reduce
  linarith

/-- For `a > 0` and `b > 0` the map `u ↦ a u - b / u` sends `(0, ∞)` onto the line: the
positive root `u = (y + √(y² + 4 a b)) / (2 a)` of `a u² - y u - b = 0` is a preimage of `y`. -/
private theorem image_mul_sub_div_Ioi {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    (fun u : ℝ => a * u - b / u) '' Set.Ioi 0 = Set.univ := by
  refine Set.eq_univ_of_forall fun y => ?_
  have hab : 0 < a * b := mul_pos ha hb
  obtain ⟨s, hs0, hs⟩ : ∃ s : ℝ, 0 ≤ s ∧ s ^ 2 = y ^ 2 + 4 * a * b :=
    ⟨Real.sqrt (y ^ 2 + 4 * a * b), Real.sqrt_nonneg _, Real.sq_sqrt (by positivity)⟩
  have hlt : -s < y := (abs_lt_of_sq_lt_sq' (by rw [hs]; linarith) hs0).1
  have hu : 0 < (y + s) / (2 * a) := div_pos (by linarith) (by linarith)
  refine ⟨(y + s) / (2 * a), hu, ?_⟩
  have h : b / ((y + s) / (2 * a)) = a * ((y + s) / (2 * a)) - y := by
    rw [div_eq_iff hu.ne']
    field_simp
    linear_combination -hs
  beta_reduce
  rw [h]
  ring

/-- The substitution `y = a u - b / u` carries the Gaussian on the line to the weight
`a + b / u²` on `(0, ∞)`: the weighted integrand is integrable. -/
private theorem integrableOn_add_div_sq_mul_exp {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    IntegrableOn (fun u : ℝ => (a + b / u ^ 2) * Real.exp (-(a * u - b / u) ^ 2))
      (Set.Ioi 0) := by
  have hg : IntegrableOn (fun y : ℝ => Real.exp (-y ^ 2))
      ((fun u : ℝ => a * u - b / u) '' Set.Ioi 0) := by
    rw [image_mul_sub_div_Ioi ha hb, integrableOn_univ]
    simpa only [neg_mul, one_mul] using integrable_exp_neg_mul_sq one_pos
  refine ((integrableOn_image_iff_integrableOn_abs_deriv_smul measurableSet_Ioi
    (fun u hu => hasDerivWithinAt_mul_sub_div a b hu)
    (strictMonoOn_mul_sub_div ha hb.le).injOn _).mp hg).congr_fun (fun u hu => ?_)
    measurableSet_Ioi
  have hu0 : (0 : ℝ) < u := hu
  simp only [smul_eq_mul]
  rw [abs_of_pos (by positivity)]

/-- The substitution `y = a u - b / u` carries the Gaussian on the line to the weight
`a + b / u²` on `(0, ∞)`: the weighted integral is `√π`. -/
private theorem integral_add_div_sq_mul_exp {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    ∫ u in Set.Ioi (0 : ℝ), (a + b / u ^ 2) * Real.exp (-(a * u - b / u) ^ 2) =
      Real.sqrt Real.pi := by
  have h := integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi
    (fun u hu => hasDerivWithinAt_mul_sub_div a b hu) (strictMonoOn_mul_sub_div ha hb.le).injOn
    (fun y : ℝ => Real.exp (-y ^ 2))
  rw [image_mul_sub_div_Ioi ha hb, setIntegral_univ] at h
  have hg : ∫ y : ℝ, Real.exp (-y ^ 2) = Real.sqrt Real.pi := by
    simpa only [neg_mul, one_mul, div_one] using integral_gaussian 1
  rw [← hg, h]
  refine setIntegral_congr_fun measurableSet_Ioi fun u hu => ?_
  have hu0 : (0 : ℝ) < u := hu
  simp only [smul_eq_mul]
  rw [abs_of_pos (by positivity)]

/-! ### The substitution `u ↦ b / (a u)` -/

/-- On `(0, ∞)` the map `u ↦ b / (a u)` has derivative `-(b / (a u²))`. -/
private theorem hasDerivWithinAt_div_mul {a : ℝ} (ha : a ≠ 0) (b : ℝ) {u : ℝ}
    (hu : u ∈ Set.Ioi (0 : ℝ)) :
    HasDerivWithinAt (fun u : ℝ => b / (a * u)) (-(b / (a * u ^ 2))) (Set.Ioi 0) u := by
  have hu' : u ≠ 0 := (Set.mem_Ioi.mp hu).ne'
  have h := (hasDerivAt_const u b).div ((hasDerivAt_id u).const_mul a) (mul_ne_zero ha hu')
  refine (h.congr_deriv ?_).hasDerivWithinAt
  simp only [id]
  field_simp
  ring

/-- For `a > 0` and `b > 0` the map `u ↦ b / (a u)` is its own inverse on `(0, ∞)`. -/
private theorem div_mul_div_mul {a b u : ℝ} (ha : 0 < a) (hb : 0 < b) (hu : 0 < u) :
    b / (a * (b / (a * u))) = u := by
  field_simp

/-- For `a > 0` and `b > 0` the map `u ↦ b / (a u)` is injective on `(0, ∞)`. -/
private theorem injOn_div_mul {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    Set.InjOn (fun u : ℝ => b / (a * u)) (Set.Ioi 0) :=
  Set.LeftInvOn.injOn (f₁' := fun u : ℝ => b / (a * u)) fun _ hu => div_mul_div_mul ha hb hu

/-- For `a > 0` and `b > 0` the map `u ↦ b / (a u)` sends `(0, ∞)` onto itself. -/
private theorem image_div_mul_Ioi {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    (fun u : ℝ => b / (a * u)) '' Set.Ioi 0 = Set.Ioi 0 := by
  ext y
  constructor
  · rintro ⟨u, hu, rfl⟩
    have hu0 : (0 : ℝ) < u := hu
    exact Set.mem_Ioi.mpr (by positivity)
  · intro hy
    have hy0 : (0 : ℝ) < y := hy
    exact ⟨b / (a * y), Set.mem_Ioi.mpr (by positivity), div_mul_div_mul ha hb hy0⟩

/-- The substitution `u ↦ b / (a u)` changes the sign of `a u - b / u`. -/
private theorem mul_div_mul_sub_div_div_mul {a b u : ℝ} (ha : 0 < a) (hb : 0 < b) (hu : 0 < u) :
    a * (b / (a * u)) - b / (b / (a * u)) = -(a * u - b / u) := by
  field_simp
  ring

/-- The substitution `u ↦ b / (a u)` leaves `exp(-(a u - b / u)²)` unchanged and turns `du` into
`b / (a u²) du`. -/
private theorem integral_div_mul_sq_mul_exp {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    ∫ u in Set.Ioi (0 : ℝ), b / (a * u ^ 2) * Real.exp (-(a * u - b / u) ^ 2) =
      ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2) := by
  have h := integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi
    (fun u hu => hasDerivWithinAt_div_mul ha.ne' b hu) (injOn_div_mul ha hb)
    (fun u : ℝ => Real.exp (-(a * u - b / u) ^ 2))
  rw [image_div_mul_Ioi ha hb] at h
  rw [h]
  refine setIntegral_congr_fun measurableSet_Ioi fun u hu => ?_
  have hu0 : (0 : ℝ) < u := hu
  simp only [smul_eq_mul]
  rw [abs_neg, abs_of_pos (by positivity), mul_div_mul_sub_div_div_mul ha hb hu0, neg_sq]

/-! ### The integral -/

/-- For `a > 0` and `b ≥ 0`, `u ↦ exp(-(a u - b / u)²)` is integrable on `(0, ∞)`. -/
theorem integrableOn_exp_neg_sq_mul_sub_div {a b : ℝ} (ha : 0 < a) (hb : 0 ≤ b) :
    IntegrableOn (fun u : ℝ => Real.exp (-(a * u - b / u) ^ 2)) (Set.Ioi 0) := by
  rcases hb.eq_or_lt with rfl | hb'
  · -- For `b = 0` the integrand is the Gaussian `exp(-a² u²)`.
    have h := (integrable_exp_neg_mul_sq (sq_pos_of_pos ha)).integrableOn (s := Set.Ioi 0)
    refine h.congr_fun (fun u _ => ?_) measurableSet_Ioi
    simp only [zero_div, sub_zero]
    congr 1
    ring
  · -- For `b > 0` the integrand is at most `1 / a` times the one with the weight `a + b / u²`.
    refine Integrable.mono' ((integrableOn_add_div_sq_mul_exp ha hb').const_mul a⁻¹) ?_ ?_
    · exact (by fun_prop : Measurable fun u : ℝ =>
        Real.exp (-(a * u - b / u) ^ 2)).aestronglyMeasurable
    · refine ae_restrict_of_forall_mem measurableSet_Ioi fun u hu => ?_
      have hu0 : (0 : ℝ) < u := hu
      have h1 : 1 ≤ a⁻¹ * (a + b / u ^ 2) := by
        have h2 : 0 ≤ a⁻¹ * (b / u ^ 2) := by positivity
        rw [mul_add, inv_mul_cancel₀ ha.ne']
        linarith
      rw [Real.norm_of_nonneg (Real.exp_pos _).le, ← mul_assoc]
      exact le_mul_of_one_le_left (Real.exp_pos _).le h1

/-- **The Cauchy–Schlömilch transformation for the Gaussian.** For `a > 0` and `b ≥ 0`,
`∫_0^∞ exp(-(a u - b / u)²) du = √π / (2 a)`. -/
theorem integral_exp_neg_sq_mul_sub_div {a b : ℝ} (ha : 0 < a) (hb : 0 ≤ b) :
    ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2) = Real.sqrt Real.pi / (2 * a) := by
  rcases hb.eq_or_lt with rfl | hb'
  · -- For `b = 0` this is the half-line Gaussian integral of `exp(-a² u²)`.
    have h := integral_gaussian_Ioi (a ^ 2)
    rw [Real.sqrt_div Real.pi_pos.le, Real.sqrt_sq ha.le, div_div, mul_comm a 2] at h
    rw [← h]
    refine setIntegral_congr_fun measurableSet_Ioi fun u _ => ?_
    simp only [zero_div, sub_zero]
    congr 1
    ring
  · -- Write `I` for the integral. By the symmetry `I` is also the integral with the weight
    -- `b / (a u²)`, which is `1 / a` times the weight `a + b / u²` minus `1`. The integral with
    -- the weight `a + b / u²` is `√π`, so `I = √π / a - I`.
    have key : ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2) =
        a⁻¹ * Real.sqrt Real.pi - ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2) :=
      calc ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2)
          = ∫ u in Set.Ioi (0 : ℝ), b / (a * u ^ 2) * Real.exp (-(a * u - b / u) ^ 2) :=
            (integral_div_mul_sq_mul_exp ha hb').symm
        _ = ∫ u in Set.Ioi (0 : ℝ), (a⁻¹ * ((a + b / u ^ 2) *
              Real.exp (-(a * u - b / u) ^ 2)) - Real.exp (-(a * u - b / u) ^ 2)) := by
            refine setIntegral_congr_fun measurableSet_Ioi fun u hu => ?_
            have hu0 : (0 : ℝ) < u := hu
            field_simp
            ring
        _ = a⁻¹ * Real.sqrt Real.pi -
              ∫ u in Set.Ioi (0 : ℝ), Real.exp (-(a * u - b / u) ^ 2) := by
            rw [integral_sub ((integrableOn_add_div_sq_mul_exp ha hb').const_mul a⁻¹)
              (integrableOn_exp_neg_sq_mul_sub_div ha hb), integral_const_mul,
              integral_add_div_sq_mul_exp ha hb']
    linear_combination key / 2

end QuantGrav
