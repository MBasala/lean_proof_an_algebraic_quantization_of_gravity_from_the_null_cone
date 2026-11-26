/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
public import Mathlib.Analysis.PSeries
public import Mathlib.Analysis.SpecialFunctions.ExpDeriv
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Complex.RealDeriv
import Mathlib.Analysis.Complex.Trigonometric
import Mathlib.NumberTheory.Harmonic.Bounds
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# WP1-a and WP1-b (first half): the graviton pair sum and its expansion in `G_N`

Paper: arXiv:2611.34924v1, (4.32), (4.33), (4.34).

With `s = 𝒜 / (4 G_N ℏ)` and the variance `(Δq_k)² = 1 / (2 s k)` of radial mode `k ≥ 1`, the
connected pair amplitude is `2 ∑_k (Δq_k)⁴ e^{-2ik/s}`. Mode numbers are written `k + 1` with
`k : ℕ`, so no statement relies on a value for division by zero.

* `hasSum_pair_amplitude`, `summable_norm_pair_phase`: the sum converges absolutely and equals
  `(1 / (2 s²)) ∑_k e^{-2ik/s} / k²` (4.33). The dilogarithm is not defined; the right-hand side
  is left as a sum.
* `cubic_term_partial_pair_sum`: at fixed corner area, `1 / s = κ G` with `κ = 4ℏ / 𝒜`. The cubic
  Taylor term in `G` of the sum truncated at `N` modes is `-(i / s³) ∑_{k ≤ N} 1 / k` (4.34).
* `abs_harmonic_sub_log_le`, `tendsto_harmonic_atTop`: that coefficient is `log N + O(1)` and
  diverges.

The Wick contraction that produces the summand `2 (Δq_k)⁴ e^{-2ik/s}` from the operator
expression on the left of (4.33) is not formalized. The finite resummed term is in
`ClausenAsymptotics.lean`.
-/

public section

namespace QuantGrav

open Complex Filter Finset

/-- The phase factor of mode `k + 1` has norm one, so the summand of (4.33) has norm
`1 / (k + 1)²`. -/
theorem norm_pair_phase_div_sq (s : ℝ) (k : ℕ) :
    ‖cexp (-(2 * I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2‖ = 1 / ((k : ℝ) + 1) ^ 2 := by
  have h1 : -(2 * I * ((k : ℂ) + 1) / s) = ((-(2 * ((k : ℝ) + 1) / s) : ℝ) : ℂ) * I := by
    push_cast
    ring
  have h2 : ((k : ℂ) + 1) = (((k : ℝ) + 1 : ℝ) : ℂ) := by push_cast; rfl
  rw [norm_div, h1, norm_exp_ofReal_mul_I, norm_pow, h2, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (by positivity)]

/-- **WP1-a**, the sentence after (4.33): the pair sum converges absolutely for every `s`. -/
theorem summable_norm_pair_phase (s : ℝ) :
    Summable fun k : ℕ => ‖cexp (-(2 * I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2‖ := by
  simp_rw [norm_pair_phase_div_sq]
  have h := (summable_nat_add_iff 1).2 (Real.summable_one_div_nat_pow (p := 2) |>.2 one_lt_two)
  refine h.congr fun k => ?_
  push_cast
  rfl

/-- **WP1-a**, paper (4.32), (4.33). With `(Δq_k)² = 1 / (2 s k)` and `s > 0`, the series
`2 ∑_{k ≥ 1} (Δq_k)⁴ e^{-2ik/s}` converges to `(1 / (2 s²)) ∑_{k ≥ 1} e^{-2ik/s} / k²`. -/
theorem hasSum_pair_amplitude (s : ℝ) (hs : 0 < s) :
    HasSum
      (fun k : ℕ => 2 * (1 / (2 * (s : ℂ) * ((k : ℂ) + 1))) ^ 2
        * cexp (-(2 * I * ((k : ℂ) + 1) / s)))
      (1 / (2 * (s : ℂ) ^ 2)
        * ∑' k : ℕ, cexp (-(2 * I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2) := by
  have hsum : Summable fun k : ℕ => cexp (-(2 * I * ((k : ℂ) + 1) / s)) / ((k : ℂ) + 1) ^ 2 :=
    (summable_norm_pair_phase s).of_norm
  have hs' : (s : ℂ) ≠ 0 := by exact_mod_cast hs.ne'
  refine (hsum.hasSum.mul_left (1 / (2 * (s : ℂ) ^ 2))).congr_fun fun k => ?_
  have hk : (k : ℂ) + 1 ≠ 0 := by exact_mod_cast (Nat.succ_ne_zero k)
  field_simp

/-- Derivative of a finite sum of quadratic polynomials times exponentials, as a function of a
real variable. The derivative has the same shape with new coefficients. -/
theorem hasDerivAt_sum_quadratic_mul_cexp (u : Finset ℕ) (a p0 p1 p2 : ℕ → ℂ) (x : ℝ) :
    HasDerivAt
      (fun g : ℝ => ∑ k ∈ u, (p0 k + p1 k * g + p2 k * (g : ℂ) ^ 2) * cexp (a k * g))
      (∑ k ∈ u, ((p1 k + a k * p0 k) + (2 * p2 k + a k * p1 k) * x + a k * p2 k * (x : ℂ) ^ 2)
        * cexp (a k * x)) x := by
  refine HasDerivAt.fun_sum fun k _ => ?_
  have hc : HasDerivAt (fun z : ℂ => (p0 k + p1 k * z + p2 k * z ^ 2) * cexp (a k * z))
      ((p1 k + p2 k * (2 * (x : ℂ))) * cexp (a k * x)
        + (p0 k + p1 k * x + p2 k * (x : ℂ) ^ 2) * (cexp (a k * x) * a k)) (x : ℂ) := by
    have hpoly : HasDerivAt (fun z : ℂ => p0 k + p1 k * z + p2 k * z ^ 2)
        (p1 k + p2 k * (2 * (x : ℂ))) (x : ℂ) := by
      have h1 : HasDerivAt (fun z : ℂ => p1 k * z) (p1 k) (x : ℂ) := by
        simpa using (hasDerivAt_id (x : ℂ)).const_mul (p1 k)
      have h2 : HasDerivAt (fun z : ℂ => p2 k * z ^ 2) (p2 k * (2 * (x : ℂ))) (x : ℂ) := by
        simpa using (hasDerivAt_pow 2 (x : ℂ)).const_mul (p2 k)
      exact (h1.const_add (p0 k)).add h2
    have hexp : HasDerivAt (fun z : ℂ => cexp (a k * z)) (cexp (a k * x) * a k) (x : ℂ) := by
      simpa using ((hasDerivAt_id (x : ℂ)).const_mul (a k)).cexp
    exact hpoly.mul hexp
  convert hc.comp_ofReal using 1
  ring

/-- The function-level form of `hasDerivAt_sum_quadratic_mul_cexp`. -/
theorem deriv_sum_quadratic_mul_cexp (u : Finset ℕ) (a p0 p1 p2 : ℕ → ℂ) :
    deriv (fun g : ℝ => ∑ k ∈ u, (p0 k + p1 k * g + p2 k * (g : ℂ) ^ 2) * cexp (a k * g))
      = fun g : ℝ => ∑ k ∈ u, ((p1 k + a k * p0 k) + (2 * p2 k + a k * p1 k) * g
          + a k * p2 k * (g : ℂ) ^ 2) * cexp (a k * g) :=
  funext fun x => (hasDerivAt_sum_quadratic_mul_cexp u a p0 p1 p2 x).deriv

/-- Third derivative at zero of `g ↦ ∑ k, p k * g² * exp (a k * g)`: it is `∑ k, 6 * a k * p k`. -/
theorem iteratedDeriv_three_sum_sq_mul_cexp (u : Finset ℕ) (a p : ℕ → ℂ) :
    iteratedDeriv 3 (fun g : ℝ => ∑ k ∈ u, p k * (g : ℂ) ^ 2 * cexp (a k * g)) 0
      = ∑ k ∈ u, 6 * a k * p k := by
  have h0 : (fun g : ℝ => ∑ k ∈ u, p k * (g : ℂ) ^ 2 * cexp (a k * g))
      = fun g : ℝ => ∑ k ∈ u, ((fun _ => 0) k + (fun _ => 0) k * g + p k * (g : ℂ) ^ 2)
          * cexp (a k * g) := by
    funext g
    refine Finset.sum_congr rfl fun k _ => ?_
    ring
  rw [h0, iteratedDeriv_succ, iteratedDeriv_succ, iteratedDeriv_one,
    deriv_sum_quadratic_mul_cexp, deriv_sum_quadratic_mul_cexp, deriv_sum_quadratic_mul_cexp]
  refine Finset.sum_congr rfl fun k _ => ?_
  simp only [ofReal_zero, mul_zero, Complex.exp_zero]
  ring

/-- **WP1-b**, paper (4.34). At fixed corner area write `1 / s = κ G`. For the pair sum truncated
at `N` radial modes, `(1 / (2 s²)) ∑_{k = 1}^{N} e^{-2ik/s} / k²`, the cubic Taylor term in `G` at
`G = 0` is `-(i / s³) ∑_{k = 1}^{N} 1 / k`. -/
theorem cubic_term_partial_pair_sum (κ G : ℝ) (N : ℕ) :
    (G : ℂ) ^ 3 / 6 * iteratedDeriv 3
        (fun g : ℝ => ((κ : ℂ) * g) ^ 2 / 2
          * ∑ k ∈ range N, cexp (-(2 * I * ((k : ℂ) + 1) * ((κ : ℂ) * g))) / ((k : ℂ) + 1) ^ 2) 0
      = -(I * ((κ : ℂ) * G) ^ 3 * ∑ k ∈ range N, 1 / ((k : ℂ) + 1)) := by
  have h0 : (fun g : ℝ => ((κ : ℂ) * g) ^ 2 / 2
        * ∑ k ∈ range N, cexp (-(2 * I * ((k : ℂ) + 1) * ((κ : ℂ) * g))) / ((k : ℂ) + 1) ^ 2)
      = fun g : ℝ => ∑ k ∈ range N, ((κ : ℂ) ^ 2 / (2 * ((k : ℂ) + 1) ^ 2)) * (g : ℂ) ^ 2
          * cexp (-(2 * I * ((k : ℂ) + 1) * κ) * g) := by
    funext g
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun k _ => ?_
    have hk : (k : ℂ) + 1 ≠ 0 := by exact_mod_cast (Nat.succ_ne_zero k)
    have he : -(2 * I * ((k : ℂ) + 1) * ((κ : ℂ) * g)) = -(2 * I * ((k : ℂ) + 1) * κ) * g := by
      ring
    rw [he]
    field_simp
  rw [h0, iteratedDeriv_three_sum_sq_mul_cexp, Finset.mul_sum, Finset.mul_sum,
    ← Finset.sum_neg_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  have hk : (k : ℂ) + 1 ≠ 0 := by exact_mod_cast (Nat.succ_ne_zero k)
  field_simp

/-- **WP1-b**, paper (4.34): the coefficient `∑_{k = 1}^{N} 1 / k` is `log N + O(1)`. Explicitly,
it lies within `1` of `log N` for `N ≥ 1`. -/
theorem abs_harmonic_sub_log_le (N : ℕ) (hN : 1 ≤ N) :
    |∑ k ∈ range N, 1 / ((k : ℝ) + 1) - Real.log N| ≤ 1 := by
  have hH : ((harmonic N : ℚ) : ℝ) = ∑ k ∈ range N, 1 / ((k : ℝ) + 1) := by
    simp [harmonic]
  have hN' : (0 : ℝ) < N := by exact_mod_cast hN
  have hlo : Real.log N ≤ harmonic N :=
    (Real.log_le_log hN' (by push_cast; linarith)).trans (log_add_one_le_harmonic N)
  have hhi := harmonic_le_one_add_log N
  rw [← hH, abs_le]
  constructor <;> linarith

/-- **WP1-b**, paper (4.34): the coefficient `∑_{k = 1}^{N} 1 / k` of the cubic term diverges as
the mode cutoff `N` is removed. This is Mathlib's divergence of the harmonic series. -/
theorem tendsto_harmonic_atTop :
    Tendsto (fun N : ℕ => ∑ k ∈ range N, 1 / ((k : ℝ) + 1)) atTop atTop :=
  Real.tendsto_sum_range_one_div_nat_succ_atTop

end QuantGrav
