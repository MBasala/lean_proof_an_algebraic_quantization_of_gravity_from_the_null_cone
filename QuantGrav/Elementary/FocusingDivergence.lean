/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Probability.ProductMeasure
import QuantGrav.Elementary.GaussianQuadraticForm
import QuantGrav.Elementary.PairAmplitude

/-!
# A model of the focusing: Gaussian radial modes with the scalings of the pair example

Paper: arXiv:2611.34924v1, (4.7), (4.22), (4.32), (C.16b), (D.40), (D.41).

Break attempt B1 of `handoff.md`, Section 14. This file is a model. It takes two scalings from
the paper and asks what they give for a positive quadratic form of infinitely many modes.

* Variance. In the paper's example of a graviton pair, the Gaussian state of the radial modes
  of one angular harmonic of one polarization has `(Δq_k)² = 1 / (2 s k)`, with
  `s = 𝒜 / (4 G ℏ)`: (4.32). The paper says there that this is how the squared amplitude of one
  graviton depends on wavelength, and before (D.41) that the symplectic form fixes
  `s |k| |h_I|²` for one graviton at a given radial profile. The general Gaussian state (4.7)
  has free widths, and Sec 5.1 does not specify them.
* Weight. For one graviton of radial frequency `k`, the paper gives the shear term of its
  quadratic cost (D.40) as `k² |h_I|² ∝ |k| / s`, at large angular momentum: (D.41). Read as a
  weight on `q_k²`, this is growth like `k²`. That reading is an inference. (D.40) is not the
  focusing `Ξ_y` of (4.22) and (C.16b): it is summed over harmonics, has weight `v² / 8` where
  `Ξ_y` has `v / 4`, is of second order, and has a second term. And `Ξ_y` is quadratic only
  within the first polarization; the second enters with a factor `e^{2 z¹}`.

Here modes are counted from zero, so mode `k` of this file is the paper's radial mode `k + 1`.
`radialVariance s k` is `1 / (2 s (k + 1))`. The weights are any `a k` with
`a k ≥ c (k + 1)²` for a constant `c > 0`; a second set of statements needs only `a k ≥ c`.
The model focusing of the first `N` modes is `∑ k < N, a k (q k)²`.

* `le_sum_mul_radialVariance`: its mean is at least `c N (N + 1) / (4 s)`.
* `tendsto_sum_mul_radialVariance_atTop`, `tendsto_sum_mul_radialVariance_atTop_of_le`: the
  mean diverges as `N → ∞`, for weights growing as `k²`, and already for weights bounded below
  by a positive constant, where the divergence is that of the harmonic series.
* `measureReal_focusing_le_le`: for every `x > 0`, the probability that the model focusing of
  the first `N` modes is at most `x` is at most `e (1 + c N (N + 1) / (2 s x)) ^ (-1/2)`.
* `ae_tendsto_focusing_atTop`, `ae_tendsto_focusing_atTop_of_le`: with all modes included the
  model focusing is infinite almost surely.

What is not here. Three links to the paper are not established, and the paper's text does not
settle them.

* That the state `Ω_𝒜` of Sec 5.1 has the variances of (4.32).
* That the focusing in the paper's clock, with all modes included and no subtraction, has
  weights growing like `k²` in these coordinates. The paper does not give its canonical
  coordinates. In App D.3 it counts the cost of a state by occupation numbers, in the sentence
  before (D.45), and under that count a Gaussian state costs nothing.
* That the clock is bounded below by such a form. See `Diamond/ClockDivergence.lean`.

See finding F11 in `FIDELITY.md`.
-/

public section

namespace QuantGrav

open MeasureTheory ProbabilityTheory Filter Topology
open scoped NNReal

/-- The variance of radial mode `k + 1` in the Gaussian state of (4.32): `1 / (2 s (k + 1))`,
as a nonnegative real. Modes are counted from zero in this file. -/
noncomputable def radialVariance (s : ℝ) (k : ℕ) : ℝ≥0 :=
  Real.toNNReal (1 / (2 * s * ((k : ℝ) + 1)))

/-- For `s > 0` the variance of mode `k` is `1 / (2 s (k + 1))`. -/
theorem coe_radialVariance {s : ℝ} (hs : 0 < s) (k : ℕ) :
    (radialVariance s k : ℝ) = 1 / (2 * s * ((k : ℝ) + 1)) := by
  rw [radialVariance]
  exact Real.coe_toNNReal _ (by positivity)

/-- With variances `1 / (2 s (k + 1))` and weights `a k ≥ c (k + 1)²`, the mean of the focusing
of the first `N` modes is at least `c N (N + 1) / (4 s)`. -/
theorem le_sum_mul_radialVariance {s c : ℝ} (hs : 0 < s) (a : ℕ → ℝ)
    (ha : ∀ k : ℕ, c * ((k : ℝ) + 1) ^ 2 ≤ a k) (N : ℕ) :
    c * N * (N + 1) / (4 * s) ≤ ∑ k ∈ Finset.range N, a k * (radialVariance s k : ℝ) := by
  induction N with
  | zero => simp
  | succ n ih =>
    -- The new term is at least `c (n + 1) / (2 s)`, which is the increment of the lower bound.
    have hterm : c * ((n : ℝ) + 1) / (2 * s) ≤ a n * (radialVariance s n : ℝ) := by
      have heq : c * ((n : ℝ) + 1) / (2 * s)
          = c * ((n : ℝ) + 1) ^ 2 * (1 / (2 * s * ((n : ℝ) + 1))) := by
        field_simp
      rw [coe_radialVariance hs, heq]
      exact mul_le_mul_of_nonneg_right (ha n) (by positivity)
    have hstep : c * ((n + 1 : ℕ) : ℝ) * (((n + 1 : ℕ) : ℝ) + 1) / (4 * s)
        = c * (n : ℝ) * ((n : ℝ) + 1) / (4 * s) + c * ((n : ℝ) + 1) / (2 * s) := by
      push_cast
      field_simp
      ring
    rw [Finset.sum_range_succ, hstep]
    exact add_le_add ih hterm

/-- With variances `1 / (2 s (k + 1))` and weights `a k ≥ c (k + 1)²`, `c > 0`, the mean of the
focusing diverges as the number of modes grows. -/
theorem tendsto_sum_mul_radialVariance_atTop {s c : ℝ} (hs : 0 < s) (hc : 0 < c) (a : ℕ → ℝ)
    (ha : ∀ k : ℕ, c * ((k : ℝ) + 1) ^ 2 ≤ a k) :
    Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (radialVariance s k : ℝ)) atTop atTop := by
  -- The lower bound `c N (N + 1) / (4 s)` is at least `c / (4 s) * N`, which tends to infinity.
  have hlin : Tendsto (fun N : ℕ => c / (4 * s) * (N : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop.const_mul_atTop (by positivity)
  refine tendsto_atTop_mono (fun N => ?_) hlin
  refine le_trans ?_ (le_sum_mul_radialVariance hs a ha N)
  have hN : (0 : ℝ) ≤ (N : ℝ) := N.cast_nonneg
  rw [div_mul_eq_mul_div]
  refine div_le_div_of_nonneg_right ?_ (by positivity)
  exact le_mul_of_one_le_right (mul_nonneg hc.le hN) (by linarith)

/-- With variances `1 / (2 s (k + 1))`, the mean of the focusing diverges already when the
weights are bounded below by a positive constant: it is then at least a multiple of the
harmonic series. -/
theorem tendsto_sum_mul_radialVariance_atTop_of_le {s c : ℝ} (hs : 0 < s) (hc : 0 < c)
    (a : ℕ → ℝ) (ha : ∀ k, c ≤ a k) :
    Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (radialVariance s k : ℝ)) atTop atTop := by
  -- The sum is at least `c / (2 s)` times the harmonic sum, which tends to infinity.
  have hharm : Tendsto (fun N : ℕ => c / (2 * s) * ∑ k ∈ Finset.range N, 1 / ((k : ℝ) + 1))
      atTop atTop :=
    tendsto_harmonic_atTop.const_mul_atTop (by positivity)
  refine tendsto_atTop_mono (fun N => ?_) hharm
  rw [Finset.mul_sum]
  refine Finset.sum_le_sum fun k _ => ?_
  have heq : c / (2 * s) * (1 / ((k : ℝ) + 1)) = c * (1 / (2 * s * ((k : ℝ) + 1))) := by
    field_simp
  rw [coe_radialVariance hs, heq]
  exact mul_le_mul_of_nonneg_right (ha k) (by positivity)

/-- For independent centred Gaussian modes with variances `1 / (2 s (k + 1))` and weights
`a k ≥ c (k + 1)²`, `c ≥ 0`: for every `x > 0`, the probability that the model focusing of the
first `N` modes is at most `x` is at most `e (1 + c N (N + 1) / (2 s x)) ^ (-1/2)`. -/
theorem measureReal_focusing_le_le {s c x : ℝ} (hs : 0 < s) (hc : 0 ≤ c) (hx : 0 < x)
    (a : ℕ → ℝ) (ha : ∀ k : ℕ, c * ((k : ℝ) + 1) ^ 2 ≤ a k) (N : ℕ) :
    (Measure.infinitePi fun k => gaussianReal 0 (radialVariance s k)).real
        {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x}
      ≤ Real.exp 1 * (1 + c * N * (N + 1) / (2 * s * x)) ^ (-(1 / 2 : ℝ)) := by
  have ha0 : ∀ k, 0 ≤ a k := fun k =>
    (by positivity : (0 : ℝ) ≤ c * ((k : ℝ) + 1) ^ 2).trans (ha k)
  refine (measureReal_infinitePi_sum_range_mul_sq_le_le a (radialVariance s) ha0 hx N).trans ?_
  -- `t ↦ t ^ (-1/2)` is antitone on the positive reals, so compare the two bases.
  refine mul_le_mul_of_nonneg_left
    (Real.rpow_le_rpow_of_nonpos (by positivity) ?_ (by norm_num)) (Real.exp_pos 1).le
  have heq : c * N * (N + 1) / (2 * s * x) = 2 / x * (c * N * (N + 1) / (4 * s)) := by
    field_simp
    ring
  rw [heq]
  gcongr
  exact le_sum_mul_radialVariance hs a ha N

/-- **The model focusing is infinite almost surely.** For independent centred Gaussian modes
with the variances `1 / (2 s (k + 1))` of (4.32) and weights `a k ≥ c (k + 1)²`, `c > 0`, the
growth read off from (D.41), the partial sums of `∑ a k (q k)²` tend to infinity almost
surely. -/
theorem ae_tendsto_focusing_atTop {s c : ℝ} (hs : 0 < s) (hc : 0 < c) (a : ℕ → ℝ)
    (ha : ∀ k : ℕ, c * ((k : ℝ) + 1) ^ 2 ≤ a k) :
    ∀ᵐ q ∂(Measure.infinitePi fun k => gaussianReal 0 (radialVariance s k)),
      Tendsto (fun N => ∑ k ∈ Finset.range N, a k * q k ^ 2) atTop atTop := by
  have ha0 : ∀ k, 0 ≤ a k := fun k =>
    (by positivity : (0 : ℝ) ≤ c * ((k : ℝ) + 1) ^ 2).trans (ha k)
  exact ae_tendsto_sum_mul_sq_atTop a (radialVariance s) ha0
    (tendsto_sum_mul_radialVariance_atTop hs hc a ha)

/-- The same conclusion when the weights are only bounded below by a positive constant. -/
theorem ae_tendsto_focusing_atTop_of_le {s c : ℝ} (hs : 0 < s) (hc : 0 < c) (a : ℕ → ℝ)
    (ha : ∀ k, c ≤ a k) :
    ∀ᵐ q ∂(Measure.infinitePi fun k => gaussianReal 0 (radialVariance s k)),
      Tendsto (fun N => ∑ k ∈ Finset.range N, a k * q k ^ 2) atTop atTop := by
  have ha0 : ∀ k, 0 ≤ a k := fun k => hc.le.trans (ha k)
  exact ae_tendsto_sum_mul_sq_atTop a (radialVariance s) ha0
    (tendsto_sum_mul_radialVariance_atTop_of_le hs hc a ha)

end QuantGrav
