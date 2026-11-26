module

public import QuantGrav.Elementary.ClausenAsymptotics
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# WP1-b (second half): the finite logarithmic term of the pair amplitude

Paper: arXiv:2611.34924v1, the paragraph after (4.34).

The paper says that summing over modes before expanding in `G_N` turns the `log N` divergence of
(4.34) into the finite term `-i log s / s³` of the closed form (4.33). This file states that with
an explicit remainder: for `s ≥ 2`, the imaginary part of `(1 / (2 s²)) ∑_{k ≥ 1} e^{-2ik/s} / k²`
is `(log 2 - 1 - log s) / s³` up to an error of at most `1 / (6 s⁵)`.

It is `abs_im_tsum_cexp_div_sq_sub_le` at `θ = 2 / s`, multiplied by the prefactor `1 / (2 s²)`.
-/

public section

namespace QuantGrav

open Complex

/-- **WP1-b**, the paragraph after paper (4.34). For `s ≥ 2`, the imaginary part of the pair
amplitude `(1 / (2 s²)) ∑_{k ≥ 1} e^{-2ik/s} / k²` equals `-log s / s³ + (log 2 - 1) / s³` up to
an error of at most `1 / (6 s⁵)`. -/
theorem abs_im_pair_amplitude_sub_le (s : ℝ) (hs : 2 ≤ s) :
    |(1 / (2 * (s : ℂ) ^ 2)
          * ∑' k : ℕ, cexp (-(2 * I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2).im
        - (Real.log 2 - 1 - Real.log s) / s ^ 3| ≤ 1 / (6 * s ^ 5) := by
  have hs0 : 0 < s := by linarith
  have hsc : (s : ℂ) ≠ 0 := by exact_mod_cast hs0.ne'
  have hθ0 : 0 < 2 / s := by positivity
  have hθ1 : 2 / s ≤ 1 := by
    rw [div_le_one hs0]
    exact hs
  have key := abs_im_tsum_cexp_div_sq_sub_le (2 / s) hθ0 hθ1
  have hexp : ∀ k : ℕ, cexp (-(2 * I * ((k : ℂ) + 1) / s))
      = cexp (-(I * ((2 / s : ℝ) : ℂ) * ((k : ℂ) + 1))) := by
    intro k
    congr 1
    push_cast
    field_simp
  have hpre : (1 / (2 * (s : ℂ) ^ 2)) = ((1 / (2 * s ^ 2) : ℝ) : ℂ) := by
    push_cast
    rfl
  simp_rw [hexp]
  rw [hpre, Complex.im_ofReal_mul]
  rw [Real.log_div two_ne_zero hs0.ne'] at key
  have hc : 0 < 1 / (2 * s ^ 2) := by positivity
  have hrw : ∀ X : ℝ, 1 / (2 * s ^ 2) * X - (Real.log 2 - 1 - Real.log s) / s ^ 3
      = 1 / (2 * s ^ 2) * (X - (2 / s * (Real.log 2 - Real.log s) - 2 / s)) := by
    intro X
    field_simp
    ring
  rw [hrw, abs_mul, abs_of_pos hc]
  calc 1 / (2 * s ^ 2) * |_ - (2 / s * (Real.log 2 - Real.log s) - 2 / s)|
      ≤ 1 / (2 * s ^ 2) * ((2 / s) ^ 3 / 24) := mul_le_mul_of_nonneg_left key hc.le
    _ = 1 / (6 * s ^ 5) := by
      field_simp
      ring

end QuantGrav
