module

public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# WP1-d and WP1-e: arithmetic of the logarithmic coefficient

Paper: arXiv:2611.34924v1, (5.58), (5.61), (5.65), (5.67c), (5.68), (5.69), footnote 23.

`q` is the paper's limiting ratio of the mean clock reading to the maximum reading `ℓ(D)`
(5.54b). The paper's entropy formula (5.65) has logarithmic coefficient `q / (2 (1 - q))`.

How the paper obtains `q = 257 / 302`, as read from the text around (5.66) to (5.68):

* (5.67c) imports a one-loop coefficient `c = 106 / 45` for `log Tr(C_b† C_b)` in `log s_b`.
* "In (5.66) the measure adds a factor of 1/2 to the power": `log Z` grows as
  `(c + 1/2) log s`.
* "Using `s_* ∝ ℓ²` in (5.58)": `log Z` grows as `2 (c + 1/2) log ℓ`, and (5.58) says it grows
  as `(q / (1 - q)) log ℓ`. Hence `q / (1 - q) = 2 (c + 1/2)`.
* (5.69) then subtracts the same `1/2` (change of variables from area to mass) and reports
  `q / (2 (1 - q)) - 1/2 = 106 / 45`.

`log_coefficient_roundtrip` records that the last two steps return the imported `c` for every
`c`: the value `106 / 45` in (5.69) is the input of (5.67c), not an independent output of `q`.
The physical content is therefore in hypothesis H7 (the coefficient in (5.67c)) and in the two
Jacobian arguments, none of which is formalized in this file.
-/

public section

namespace QuantGrav

/-- **WP1-d**, paper (5.68) and (5.69). For real `q ≠ 1`, the fixed-mass logarithmic coefficient
`q / (2 (1 - q)) - 1 / 2` equals `106 / 45` exactly when `q = 257 / 302`. -/
theorem log_coefficient_eq_iff (q : ℝ) (hq : q ≠ 1) :
    q / (2 * (1 - q)) - 1 / 2 = 106 / 45 ↔ q = 257 / 302 := by
  have h : 1 - q ≠ 0 := sub_ne_zero.mpr (Ne.symm hq)
  constructor
  · intro H
    field_simp at H
    linarith
  · rintro rfl
    norm_num

/-- The derivation step the paper actually uses for (5.68): `q / (1 - q)` equals the growth
exponent `2 (106 / 45 + 1 / 2)` of `Z(ℓ)` in `ℓ` exactly when `q = 257 / 302`. -/
theorem q_of_growth_exponent_iff (q : ℝ) (hq : q ≠ 1) :
    q / (1 - q) = 2 * (106 / 45 + 1 / 2) ↔ q = 257 / 302 := by
  have h : 1 - q ≠ 0 := sub_ne_zero.mpr (Ne.symm hq)
  constructor
  · intro H
    field_simp at H
    linarith
  · rintro rfl
    norm_num

/-- The step from (5.67c) through (5.68) to (5.69) returns its input. If `q` is defined from an
imported one-loop coefficient `c` by `q / (1 - q) = 2 (c + 1 / 2)`, then the fixed-mass
coefficient `q / (2 (1 - q)) - 1 / 2` is `c`, for every `c`. -/
theorem log_coefficient_roundtrip (q c : ℝ) (hq : q ≠ 1)
    (h : q / (1 - q) = 2 * (c + 1 / 2)) :
    q / (2 * (1 - q)) - 1 / 2 = c := by
  have h1 : 1 - q ≠ 0 := sub_ne_zero.mpr (Ne.symm hq)
  have h2 : q / (2 * (1 - q)) = q / (1 - q) / 2 := by
    field_simp
  rw [h2, h]
  ring

/-- **WP1-e**, paper (5.61), footnote 23. With `x = (1 - ε) r_h / ℓ` and `x² ≠ 1`, the relation
`q = 2 x² / (1 + x²)` gives logarithmic coefficient `x² / (1 - x²)`. -/
theorem log_coefficient_of_ratio (q x : ℝ) (hx : x ^ 2 ≠ 1)
    (hq : q = 2 * x ^ 2 / (1 + x ^ 2)) :
    q / (2 * (1 - q)) = x ^ 2 / (1 - x ^ 2) := by
  have h1 : (1 : ℝ) + x ^ 2 ≠ 0 := by positivity
  have h2 : (1 : ℝ) - x ^ 2 ≠ 0 := sub_ne_zero.mpr (Ne.symm hx)
  have h3 : 1 - q = (1 - x ^ 2) / (1 + x ^ 2) := by
    rw [hq]
    field_simp
    ring
  rw [h3, hq]
  field_simp

/-- Consequence of footnote 23 together with (5.68), not stated in the paper: the relation
`q = 2 x² / (1 + x²)` and the value `q = 257 / 302` hold together exactly when
`x² = 257 / 347`. The paper treats `ℓ(D) / r_h`, hence `x`, as a fixed free ratio; see H8. -/
theorem ratio_sq_of_q (x : ℝ) :
    2 * x ^ 2 / (1 + x ^ 2) = 257 / 302 ↔ x ^ 2 = 257 / 347 := by
  have h1 : (1 : ℝ) + x ^ 2 ≠ 0 := by positivity
  rw [div_eq_div_iff h1 (by norm_num)]
  constructor <;> intro H <;> linarith

end QuantGrav
