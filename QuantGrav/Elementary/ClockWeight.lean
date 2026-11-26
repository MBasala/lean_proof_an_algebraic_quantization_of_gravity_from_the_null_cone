module

public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# WP1-c: the clock weight bound

Paper: arXiv:2611.34924v1, sentence above (5.17) and the sentence above (C.14).

The wavefunction `Ψ_L = L (L + û)⁻¹ Ω` weights a clock reading `u ≥ 0` by `(L / (L + u))²`
relative to `Ω`, so the expected clock reading in `Ψ_L` integrates `u * (L / (L + u))²` against
the distribution of readings in `Ω`. The paper bounds this weight pointwise by `L / 4`.

This file proves only the pointwise bound. The step from the pointwise bound to
`⟨Ψ_L| û |Ψ_L⟩ ≤ L / 4` (integration against a probability measure) and the Markov step in
(5.17) are not formalized here; see `FIDELITY.md`, entry WP1-c.
-/

public section

namespace QuantGrav

/-- **WP1-c**, paper (5.17) / (C.14). For `L > 0` and a clock reading `u ≥ 0`, the weight
`u * (L / (L + u))²` is at most `L / 4`. -/
theorem clock_weight_le (L u : ℝ) (hL : 0 < L) (hu : 0 ≤ u) :
    u * (L / (L + u)) ^ 2 ≤ L / 4 := by
  have h : 0 < L + u := add_pos_of_pos_of_nonneg hL hu
  rw [div_pow, mul_div_assoc', div_le_div_iff₀ (pow_pos h 2) (by norm_num)]
  nlinarith [mul_nonneg hL.le (sq_nonneg (L - u))]

/-- The bound `clock_weight_le` is attained exactly at `u = L`. Not stated in the paper; recorded
to show the constant `1 / 4` is sharp. -/
theorem clock_weight_eq_iff (L u : ℝ) (hL : 0 < L) (hu : 0 ≤ u) :
    u * (L / (L + u)) ^ 2 = L / 4 ↔ u = L := by
  have h : 0 < L + u := add_pos_of_pos_of_nonneg hL hu
  rw [div_pow, mul_div_assoc', div_eq_div_iff (pow_pos h 2).ne' (by norm_num)]
  constructor
  · intro H
    have h0 : L * (L - u) ^ 2 = 0 := by linear_combination -H
    have h1 : (L - u) ^ 2 = 0 := by
      rcases mul_eq_zero.mp h0 with h2 | h2
      · exact absurd h2 hL.ne'
      · exact h2
    have h3 : L - u = 0 := pow_eq_zero_iff (two_ne_zero) |>.mp h1
    linarith
  · rintro rfl
    ring

end QuantGrav
