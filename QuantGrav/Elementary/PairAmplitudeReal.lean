/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.PSeries
import Mathlib.NumberTheory.ZetaValues
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# The real part of the pair amplitude

Paper: arXiv:2611.34924v1, (4.33).

The pair amplitude of (4.33) is `(1 / (2 s²)) ∑_{k ≥ 1} e^{-2ik/s} / k²`. `PairAmplitudeLog.lean`
bounds its imaginary part. This file gives its real part in closed form: for `s ≥ 1 / π` it is
`(1 / (2 s²)) (π² / 6 - π / s + 1 / s²)`.

The closed form comes from the Fourier series of the Bernoulli polynomial `B₂(x) = x² - x + 1/6`
on `[0, 1]`, Mathlib's `hasSum_one_div_nat_pow_mul_cos` with `k = 1`. At `x = θ / (2π)` it reads
`∑_{k ≥ 1} cos(k θ) / k² = π² / 6 - π θ / 2 + θ² / 4` for `0 ≤ θ ≤ 2π`, and `cos(k θ) / k²` is the
real part of `exp(-i θ k) / k²`. The pair amplitude has `θ = 2 / s`, so the range `s ≥ 1 / π` is
`θ = 2 / s ≤ 2π`. The series is `2π`-periodic in `θ` and the polynomial is not, so the closed
form is special to this range; nothing is stated outside it.

Mode numbers are written `k + 1` with `k : ℕ`, so no statement relies on a value for division by
zero. The dilogarithm is not defined; all statements are about the sums themselves.

* `hasSum_cos_div_sq`: for `0 ≤ θ ≤ 2π`, `∑_{k ≥ 1} cos(k θ) / k² = π² / 6 - π θ / 2 + θ² / 4`.
* `re_tsum_cexp_div_sq`: for `0 ≤ θ ≤ 2π`,
  `Re ∑_{k ≥ 1} exp(-i θ k) / k² = π² / 6 - π θ / 2 + θ² / 4`.
* `re_pair_amplitude`: for `s ≥ 1 / π`,
  `Re ((1 / (2 s²)) ∑_{k ≥ 1} exp(-2 i k / s) / k²) = (1 / (2 s²)) (π² / 6 - π / s + 1 / s²)`.
-/

public section

namespace QuantGrav

/-- For `0 ≤ θ ≤ 2π`, `∑_{k ≥ 1} cos(k θ) / k² = π² / 6 - π θ / 2 + θ² / 4`. This is the Fourier
series of the Bernoulli polynomial `B₂(x) = x² - x + 1/6` on `[0, 1]`, at `x = θ / (2π)`. -/
theorem hasSum_cos_div_sq (θ : ℝ) (h0 : 0 ≤ θ) (h1 : θ ≤ 2 * Real.pi) :
    HasSum (fun k : ℕ ↦ Real.cos (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2)
      (Real.pi ^ 2 / 6 - Real.pi * θ / 2 + θ ^ 2 / 4) := by
  have hx : θ / (2 * Real.pi) ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨by positivity, (div_le_one (by positivity)).mpr h1⟩
  -- Mathlib's series runs over all `n : ℕ`. Its `n = 0` term is `1 / 0 ^ 2 * cos 0`, which is `0`
  -- in Lean; `hasSum_nat_add_iff'` removes it, leaving the sum over `n + 1`.
  have h := (hasSum_nat_add_iff' 1).mpr (hasSum_one_div_nat_pow_mul_cos one_ne_zero hx)
  have hB : (Polynomial.map (algebraMap ℚ ℝ) (Polynomial.bernoulli (2 * 1))).eval
      (θ / (2 * Real.pi)) = (θ / (2 * Real.pi)) ^ 2 - θ / (2 * Real.pi) + 6⁻¹ :=
    bernoulliFun_two _
  rw [hB, Finset.sum_range_one] at h
  convert h using 1
  · ext k
    have harg : 2 * Real.pi * ((k + 1 : ℕ) : ℝ) * (θ / (2 * Real.pi)) = ((k : ℝ) + 1) * θ := by
      push_cast
      field_simp
    rw [harg]
    push_cast
    ring
  · norm_num [Nat.factorial]
    field_simp
    ring

/-- For `0 ≤ θ ≤ 2π`, the real part of `∑_{k ≥ 1} exp(-i θ k) / k²` is
`π² / 6 - π θ / 2 + θ² / 4`. -/
theorem re_tsum_cexp_div_sq (θ : ℝ) (h0 : 0 ≤ θ) (h1 : θ ≤ 2 * Real.pi) :
    (∑' k : ℕ, Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2).re
      = Real.pi ^ 2 / 6 - Real.pi * θ / 2 + θ ^ 2 / 4 := by
  have hterm : ∀ k : ℕ,
      Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2 =
      Complex.exp (((-(((k : ℝ) + 1) * θ) : ℝ) : ℂ) * Complex.I) /
        ((((k : ℝ) + 1) ^ 2 : ℝ) : ℂ) := by
    intro k
    push_cast
    ring_nf
  have hsummable : Summable (fun k : ℕ ↦
      Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2) := by
    refine Summable.of_norm_bounded (g := fun k : ℕ ↦ 1 / ((k : ℝ) + 1) ^ 2) ?_ ?_
    · exact mod_cast (summable_nat_add_iff 1).mpr
        ((Real.summable_one_div_nat_pow (p := 2)).mpr one_lt_two)
    · intro k
      rw [hterm, norm_div, Complex.norm_exp_ofReal_mul_I, Complex.norm_real,
        Real.norm_of_nonneg (by positivity)]
  have hre : ∀ k : ℕ,
      (Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2).re =
      Real.cos (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2 := by
    intro k
    rw [hterm, Complex.div_ofReal_re, Complex.exp_ofReal_mul_I_re, Real.cos_neg]
  rw [Complex.re_tsum hsummable, tsum_congr hre]
  exact (hasSum_cos_div_sq θ h0 h1).tsum_eq

/-- For `s ≥ 1 / π`, the real part of the pair amplitude
`(1 / (2 s²)) ∑_{k ≥ 1} exp(-2 i k / s) / k²` is `(1 / (2 s²)) (π² / 6 - π / s + 1 / s²)`. -/
theorem re_pair_amplitude (s : ℝ) (hs : 1 / Real.pi ≤ s) :
    (1 / (2 * (s : ℂ) ^ 2)
        * ∑' k : ℕ, Complex.exp (-(2 * Complex.I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2).re
      = 1 / (2 * s ^ 2) * (Real.pi ^ 2 / 6 - Real.pi / s + 1 / s ^ 2) := by
  have hpi : 0 < Real.pi := Real.pi_pos
  have hs0 : 0 < s := (one_div_pos.mpr hpi).trans_le hs
  have hθ0 : 0 ≤ 2 / s := by positivity
  have hθ1 : 2 / s ≤ 2 * Real.pi := by
    rw [div_le_iff₀ hs0]
    have h := (div_le_iff₀ hpi).mp hs
    linarith
  have key := re_tsum_cexp_div_sq (2 / s) hθ0 hθ1
  have hexp : ∀ k : ℕ, Complex.exp (-(2 * Complex.I * ((k : ℂ) + 1) / s))
      = Complex.exp (-(Complex.I * ((2 / s : ℝ) : ℂ) * ((k : ℂ) + 1))) := by
    intro k
    congr 1
    push_cast
    ring
  have hpre : (1 / (2 * (s : ℂ) ^ 2)) = ((1 / (2 * s ^ 2) : ℝ) : ℂ) := by norm_cast
  simp_rw [hexp]
  rw [hpre, Complex.re_ofReal_mul, key]
  ring

end QuantGrav
