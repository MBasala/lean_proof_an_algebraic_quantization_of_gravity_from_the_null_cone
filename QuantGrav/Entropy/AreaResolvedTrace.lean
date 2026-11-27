/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Elementary.CauchySchlomilch
public import QuantGrav.Entropy.GibbsAccounting

/-!
# The trace resolved by area: (5.66)

Paper: arXiv:2611.34924v1, Sec 5.2 and 5.3: (5.25), (5.66).

This file is Track A item 5 of `handoff.md`, Section 14.3: the Gaussian identity in (5.66).

The paper's preparation `C_b` of (5.25) carries the weight
`f_b(s) = exp[-(s - s_b)² / (2 σ_s²)]`, a window in the area `s` centred at `s_b`. Before (5.66)
it chooses `σ_s² = 2 s_b` and states

* `∫_0^∞ f_b(s) ds_b / (4π s_b)^{1/2} = 1` "at each area eigenvalue `s`";
* hence `Z(ℓ) = ∫_0^∞ ds_b / (4π s_b)^{1/2} Tr(C_b† C_b)`.

## Notation

`areaWindow s t` is `exp(-(s - t)² / (4 t)) / (4π t)^{1/2}`: the integrand of the first identity
as a function of the centre `t = s_b`, with `σ_s² = 2 t` put in (`areaWindow_eq_of_sq_eq`). A
finite spectrum is a finite family of states with areas `s i`, and `gibbsZ s` is its trace
`∑ᵢ e^{-sᵢ}`, as in `QuantGrav/Entropy/GibbsAccounting.lean`. By (5.23b) and (5.25), in an
eigenbasis of the area, `Tr(C_b† C_b) = ∑ᵢ e^{-sᵢ} f_b(sᵢ)`; that step is taken as given here.
For `t ≤ 0`, `areaWindow s t` is `0` by Lean's conventions for the square root and for division;
every integral below is over `t > 0`.

## Results

* `integrableOn_areaWindow`: the window is integrable in its centre, for every real `s`.
* `integral_areaWindow`: the first identity of (5.66), for `s ≥ 0`.
* `integral_areaWindow_of_nonpos`: for `s ≤ 0` the same integral is `e^{s}`. So the identity
  needs `s ≥ 0`, which holds for areas.
* `integral_sum_exp_neg_mul_areaWindow`: the second identity of (5.66) for a finite spectrum
  with nonnegative areas.

## What this does and does not say

The identity is exact; no approximation is involved. The second identity is proved for a finite
spectrum, where the sum and the integral can be exchanged. Nothing here concerns the evaluation
of `Tr(C_b† C_b)` at one loop, (5.67), which is register entry H7.
-/

@[expose] public section

namespace QuantGrav

open MeasureTheory

/-- The integrand of the first identity of (5.66), as a function of the centre `t = s_b` of the
window: `f_b(s) / (4π t)^{1/2}` with `σ_s² = 2 t`, that is,
`exp(-(s - t)² / (4 t)) / (4π t)^{1/2}`. -/
noncomputable def areaWindow (s t : ℝ) : ℝ :=
  Real.exp (-(s - t) ^ 2 / (4 * t)) / Real.sqrt (4 * Real.pi * t)

/-- `areaWindow s t` is the paper's `f_b(s) / (4π s_b)^{1/2}` of (5.25) and (5.66), with
`s_b = t` and `σ_s² = 2 s_b`. -/
theorem areaWindow_eq_of_sq_eq (s t : ℝ) {σ : ℝ} (hσ : σ ^ 2 = 2 * t) :
    areaWindow s t
      = Real.exp (-(s - t) ^ 2 / (2 * σ ^ 2)) / Real.sqrt (4 * Real.pi * t) := by
  rw [areaWindow, hσ, show 2 * (2 * t) = 4 * t by ring]

theorem areaWindow_nonneg (s t : ℝ) : 0 ≤ areaWindow s t := by
  exact div_nonneg (Real.exp_pos _).le (Real.sqrt_nonneg _)

/-- The substitution `t = u²` turns the window into a Gaussian with an inverse term: for
`u > 0`, `2 u · areaWindow s (u²) = exp(-(u / 2 - (s / 2) / u)²) / √π`. -/
theorem two_mul_mul_areaWindow_sq (s : ℝ) {u : ℝ} (hu : 0 < u) :
    2 * u * areaWindow s (u ^ 2)
      = Real.exp (-(1 / 2 * u - s / 2 / u) ^ 2) / Real.sqrt Real.pi := by
  have hsqrt : Real.sqrt (4 * Real.pi * u ^ 2) = 2 * Real.sqrt Real.pi * u := by
    have h : 4 * Real.pi * u ^ 2 = (2 * Real.sqrt Real.pi * u) ^ 2 := by
      rw [mul_pow, mul_pow, Real.sq_sqrt Real.pi_pos.le]
      norm_num
    rw [h]
    exact Real.sqrt_sq (mul_nonneg (mul_nonneg zero_le_two (Real.sqrt_nonneg _)) hu.le)
  have hexp : -(s - u ^ 2) ^ 2 / (4 * u ^ 2) = -(1 / 2 * u - s / 2 / u) ^ 2 := by
    field_simp
    ring
  rw [areaWindow, hsqrt, hexp]
  field_simp

/-- The map `u ↦ u²` sends `(0, ∞)` onto itself. -/
private theorem image_sq_Ioi : (fun u : ℝ => u ^ 2) '' Set.Ioi 0 = Set.Ioi 0 := by
  ext t
  constructor
  · rintro ⟨u, hu, rfl⟩
    exact pow_pos hu 2
  · intro ht
    exact ⟨Real.sqrt t, Real.sqrt_pos.mpr ht, Real.sq_sqrt (le_of_lt ht)⟩

/-- The map `u ↦ u²` has derivative `2 u`, here within `(0, ∞)`. -/
private theorem hasDerivWithinAt_sq_Ioi (u : ℝ) :
    HasDerivWithinAt (fun u : ℝ => u ^ 2) (2 * u) (Set.Ioi 0) u := by
  simpa using (hasDerivAt_pow 2 u).hasDerivWithinAt

/-- The map `u ↦ u²` is injective on `(0, ∞)`. -/
private theorem injOn_sq_Ioi : Set.InjOn (fun u : ℝ => u ^ 2) (Set.Ioi 0) :=
  fun _ hu _ hv h => (sq_eq_sq₀ (le_of_lt hu) (le_of_lt hv)).mp h

/-- The substitution `t = u²` on `(0, ∞)` preserves integrability:
`g` is integrable on `(0, ∞)` if and only if `u ↦ 2 u g(u²)` is. -/
private theorem integrableOn_Ioi_iff_comp_sq (g : ℝ → ℝ) :
    IntegrableOn g (Set.Ioi 0) ↔ IntegrableOn (fun u : ℝ => 2 * u * g (u ^ 2)) (Set.Ioi 0) := by
  have h := integrableOn_image_iff_integrableOn_abs_deriv_smul measurableSet_Ioi
    (fun u _ => hasDerivWithinAt_sq_Ioi u) injOn_sq_Ioi g
  rw [image_sq_Ioi] at h
  rw [h]
  refine integrableOn_congr_fun (fun u hu => ?_) measurableSet_Ioi
  have hu' : (0 : ℝ) ≤ 2 * u := mul_nonneg zero_le_two (le_of_lt hu)
  simp only [abs_of_nonneg hu', smul_eq_mul]

/-- The substitution `t = u²` on `(0, ∞)`: `∫_0^∞ g(t) dt = ∫_0^∞ 2 u g(u²) du`. -/
private theorem integral_Ioi_eq_integral_comp_sq (g : ℝ → ℝ) :
    ∫ t in Set.Ioi (0 : ℝ), g t = ∫ u in Set.Ioi (0 : ℝ), 2 * u * g (u ^ 2) := by
  have h := integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi
    (fun u _ => hasDerivWithinAt_sq_Ioi u) injOn_sq_Ioi g
  rw [image_sq_Ioi] at h
  rw [h]
  refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
  have hu' : (0 : ℝ) ≤ 2 * u := mul_nonneg zero_le_two (le_of_lt hu)
  simp only [abs_of_nonneg hu', smul_eq_mul]

/-- The window is integrable in its centre over `(0, ∞)`, for every real `s`. -/
theorem integrableOn_areaWindow (s : ℝ) : IntegrableOn (areaWindow s) (Set.Ioi 0) := by
  rw [integrableOn_Ioi_iff_comp_sq]
  rcases le_total 0 s with hs | hs
  · have h : IntegrableOn
        (fun u : ℝ => Real.exp (-(1 / 2 * u - s / 2 / u) ^ 2) / Real.sqrt Real.pi)
        (Set.Ioi 0) :=
      (integrableOn_exp_neg_sq_mul_sub_div one_half_pos (div_nonneg hs zero_le_two)).div_const _
    exact h.congr_fun (fun u hu => (two_mul_mul_areaWindow_sq s hu).symm) measurableSet_Ioi
  · have hc : 0 ≤ -s / 2 := div_nonneg (neg_nonneg.mpr hs) zero_le_two
    have hpt : ∀ u ∈ Set.Ioi (0 : ℝ),
        Real.exp s * Real.exp (-(1 / 2 * u - -s / 2 / u) ^ 2) / Real.sqrt Real.pi
          = 2 * u * areaWindow s (u ^ 2) := by
      intro u hu
      have hu0 : u ≠ 0 := ne_of_gt hu
      rw [two_mul_mul_areaWindow_sq s hu, ← Real.exp_add]
      congr 2
      field_simp
      ring
    have h : IntegrableOn
        (fun u : ℝ =>
          Real.exp s * Real.exp (-(1 / 2 * u - -s / 2 / u) ^ 2) / Real.sqrt Real.pi)
        (Set.Ioi 0) :=
      ((integrableOn_exp_neg_sq_mul_sub_div one_half_pos hc).const_mul _).div_const _
    exact h.congr_fun hpt measurableSet_Ioi

/-- For every real `s`, the substitution `t = u²` gives
`∫_0^∞ areaWindow s t dt = [∫_0^∞ exp(-(u / 2 - (s / 2) / u)²) du] / √π`. -/
private theorem integral_areaWindow_eq (s : ℝ) :
    ∫ t in Set.Ioi (0 : ℝ), areaWindow s t
      = (∫ u in Set.Ioi (0 : ℝ), Real.exp (-(1 / 2 * u - s / 2 / u) ^ 2)) / Real.sqrt Real.pi := by
  rw [integral_Ioi_eq_integral_comp_sq, ← integral_div]
  exact setIntegral_congr_fun measurableSet_Ioi fun u hu => two_mul_mul_areaWindow_sq s hu

/-- **(5.66), first identity.** For `s ≥ 0`,
`∫_0^∞ exp(-(s - s_b)² / (4 s_b)) ds_b / (4π s_b)^{1/2} = 1`. -/
theorem integral_areaWindow {s : ℝ} (hs : 0 ≤ s) :
    ∫ t in Set.Ioi (0 : ℝ), areaWindow s t = 1 := by
  rw [integral_areaWindow_eq,
    integral_exp_neg_sq_mul_sub_div one_half_pos (div_nonneg hs zero_le_two)]
  field_simp

/-- For `s ≤ 0` the integral of the window over its centre is `e^{s}`. So the first identity of
(5.66) needs `s ≥ 0`. -/
theorem integral_areaWindow_of_nonpos {s : ℝ} (hs : s ≤ 0) :
    ∫ t in Set.Ioi (0 : ℝ), areaWindow s t = Real.exp s := by
  have hc : 0 ≤ -s / 2 := div_nonneg (neg_nonneg.mpr hs) zero_le_two
  -- For `u > 0`, `(u / 2 - (s / 2) / u)² = (u / 2 - (-s / 2) / u)² - s`.
  have hpt : ∀ u ∈ Set.Ioi (0 : ℝ), Real.exp (-(1 / 2 * u - s / 2 / u) ^ 2)
      = Real.exp s * Real.exp (-(1 / 2 * u - -s / 2 / u) ^ 2) := by
    intro u hu
    have hu0 : u ≠ 0 := ne_of_gt hu
    rw [← Real.exp_add]
    congr 1
    field_simp
    ring
  rw [integral_areaWindow_eq, setIntegral_congr_fun measurableSet_Ioi hpt, integral_const_mul,
    integral_exp_neg_sq_mul_sub_div one_half_pos hc]
  field_simp

/-- **(5.66), second identity, for a finite spectrum.** For states with areas `sᵢ ≥ 0`,
`∫_0^∞ [∑ᵢ e^{-sᵢ} f_b(sᵢ)] ds_b / (4π s_b)^{1/2} = ∑ᵢ e^{-sᵢ}`. The bracket is
`Tr(C_b† C_b)` by (5.23b) and (5.25), in an eigenbasis of the area, and the right side is `Z`. -/
theorem integral_sum_exp_neg_mul_areaWindow {ι : Type*} [Fintype ι] (s : ι → ℝ)
    (hs : ∀ i, 0 ≤ s i) :
    ∫ t in Set.Ioi (0 : ℝ), ∑ i, Real.exp (-s i) * areaWindow (s i) t = gibbsZ s := by
  rw [integral_finsetSum _ fun i _ => (integrableOn_areaWindow (s i)).const_mul _]
  simp only [integral_const_mul, integral_areaWindow (hs _), mul_one, gibbsZ]

end QuantGrav
