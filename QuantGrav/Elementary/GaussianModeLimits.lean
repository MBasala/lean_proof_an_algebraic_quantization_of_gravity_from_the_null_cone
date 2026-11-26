/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Probability.ProductMeasure
import QuantGrav.Elementary.GaussianQuadraticForm

/-!
# Two limits that do not commute: the scale `L` and the number of modes

Paper: arXiv:2611.34924v1, (3.27), (3.28), (5.7), (5.8), (5.9), (C.15a), (C.15b).

Break attempt B1 of `handoff.md`, Section 14. This file is a model.

## What the paper does

The paper estimates `1 - ⟨Ω_𝒜|Ψ_L⟩` at zeroth order in the Weyl product as the mean of
`ū / (L + ū)` over the Wigner measure of the incoming Gaussian state, where `ū` is the classical
clock reading: (5.7), (5.9). The Wigner function (C.15a) is written for a finite set of
canonical pairs. The statements that control the focusing are made "at fixed angular and radial
resolution" before (5.8), and "at fixed resolution" twice in App C.2. The paper does not define
the resolution, does not remove it, and states no estimate uniformly in it. Under those
restrictions it shows that the mean tends to `0` as `L → ∞`: (C.15b).

## The model

The modes `q k` are independent centred Gaussian variables with variances `v k`. The focusing
of the first `N` modes is the positive quadratic form `Q_N = ∑ k < N, a k (q k)²`. The reading
is `g (Q_N)` for a nondecreasing nonnegative `g`.

* `tendsto_integral_div_add_fixed_modes`: for a fixed number of modes `N`, the mean of
  `g(Q_N) / (L + g(Q_N))` tends to `0` as `L → ∞`. This is the model's analogue of (C.15b).
* `tendsto_integral_div_add_all_modes`: for a fixed `L > 0`, if the series `∑ a k v k` diverges
  and `g` is unbounded, the same mean tends to `1` as `N → ∞`.

So in the model the limit `L → ∞` taken after `N → ∞` is `1`, and taken before it is `0`. An
estimate at each fixed number of modes does not give the estimate with all modes, unless it is
uniform in the number of modes.

## How the model differs from the paper's integrand

* The paper integrates over both members `(q, p)` of each canonical pair, and the profile of a
  mode along a generator depends on both. The model has one Gaussian variable per mode.
* The paper's focusing (C.16b) is not stated to be diagonal in any basis of modes. It is
  quadratic only within the first polarization. It is defined per generator, so several
  angular harmonics give cross terms at a fixed point of `S`.
* The paper's reading (3.27), (3.28) is a functional of the whole profile `v ↦ Ξ_y(v)`. It is
  weighted by the corner area density, which fluctuates, and averaged over `S`. It is not a
  function of one number. What (3.27) gives is a lower bound by the focusing accumulated up to
  an interior point: `u_*(y) ≥ ϱ_S(y) (1 - v₀) e^{Ξ_y(v₀)}` for `ε ≤ v₀ < 1`, because `Ξ_y` is
  nondecreasing in `v`. The total focusing `Ξ_y(1)` bounds the reading from above; that is
  (5.8).
* The model is the zeroth-order quantity only. The paper's quantity is the operator expectation
  (5.7), with the corrections of (5.10) to (5.14) and the cap `Ξ_*`.
-/

public section

namespace QuantGrav

open MeasureTheory ProbabilityTheory Filter Topology
open scoped NNReal

/-- For a nondecreasing `g`, the function `q ↦ g (∑ k < N, a k (q k)²)` on real sequences is
measurable. -/
theorem measurable_comp_sum_range_mul_sq (a : ℕ → ℝ) {g : ℝ → ℝ} (hg : Monotone g) (N : ℕ) :
    Measurable fun q : ℕ → ℝ => g (∑ k ∈ Finset.range N, a k * q k ^ 2) :=
  hg.measurable.comp (Continuous.measurable (by fun_prop))

/-- For `L > 0` and `t ≥ 0`, the ratio `t / (L + t)` lies between `0` and `1`. -/
theorem div_add_mem_Icc {L t : ℝ} (hL : 0 < L) (ht : 0 ≤ t) : t / (L + t) ∈ Set.Icc (0 : ℝ) 1 :=
  ⟨div_nonneg ht (by linarith), (div_le_one (by linarith)).2 (by linarith)⟩

/-- For `L > 0` and `t ≥ 0`, the norm of the ratio `t / (L + t)` is at most `1`. -/
theorem norm_div_add_le_one {L t : ℝ} (hL : 0 < L) (ht : 0 ≤ t) : ‖t / (L + t)‖ ≤ 1 :=
  (Real.norm_of_nonneg (div_add_mem_Icc hL ht).1).trans_le (div_add_mem_Icc hL ht).2

/-- At a fixed number of modes the mean of `g(Q_N) / (L + g(Q_N))` tends to `0` as `L → ∞`.
Here `Q_N = ∑ k < N, a k (q k)²` for independent centred Gaussian variables `q k` of variances
`v k`, and `g` is nondecreasing and nonnegative. This is the model's analogue of (C.15b),
which the paper states for a finite set of canonical pairs. -/
theorem tendsto_integral_div_add_fixed_modes (a : ℕ → ℝ) (v : ℕ → ℝ≥0) {g : ℝ → ℝ}
    (hg : Monotone g) (hg0 : ∀ x, 0 ≤ g x) (N : ℕ) :
    Tendsto
      (fun L : ℝ => ∫ q, g (∑ k ∈ Finset.range N, a k * q k ^ 2)
          / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2))
        ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)))
      atTop (𝓝 0) := by
  have hmeas := measurable_comp_sum_range_mul_sq a hg N
  -- Dominated convergence in `L`. For `L > 0` the integrand is bounded by the constant `1`,
  -- and at each `q` it tends to `0` as `L → ∞`.
  have h := tendsto_integral_filter_of_dominated_convergence
    (μ := Measure.infinitePi fun k => gaussianReal 0 (v k)) (l := atTop)
    (F := fun (L : ℝ) (q : ℕ → ℝ) => g (∑ k ∈ Finset.range N, a k * q k ^ 2)
      / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2)))
    (f := fun _ => 0) (fun _ => 1)
    (.of_forall fun L => (hmeas.div (measurable_const.add hmeas)).aestronglyMeasurable)
    ((eventually_gt_atTop 0).mono fun L hL => .of_forall fun q =>
      norm_div_add_le_one hL (hg0 _))
    (integrable_const 1)
    (.of_forall fun q =>
      tendsto_const_nhds.div_atTop (tendsto_atTop_add_const_right atTop _ tendsto_id))
  rwa [integral_zero] at h

/-- For `L > 0` the function `t ↦ t / (L + t)` is nondecreasing on `t ≥ 0`. -/
theorem div_add_le_div_add {L s t : ℝ} (hL : 0 < L) (hs : 0 ≤ s) (hst : s ≤ t) :
    s / (L + s) ≤ t / (L + t) := by
  rw [div_le_div_iff₀ (by linarith) (by linarith)]
  nlinarith

/-- For `L > 0`, every `x > 0` and every `N`, the mean of `g(Q_N) / (L + g(Q_N))` is at least
`g x / (L + g x)` times `1 - e (1 + (2 / x) ∑ k < N, a k v k) ^ (-1/2)`. Here
`Q_N = ∑ k < N, a k (q k)²` for independent centred Gaussian variables `q k` of variances `v k`,
the weights `a k` are nonnegative, and `g` is nondecreasing and nonnegative. -/
theorem mul_one_sub_le_integral_div_add (a : ℕ → ℝ) (v : ℕ → ℝ≥0) (ha : ∀ k, 0 ≤ a k)
    {g : ℝ → ℝ} (hg : Monotone g) (hg0 : ∀ x, 0 ≤ g x) {L : ℝ} (hL : 0 < L) {x : ℝ}
    (hx : 0 < x) (N : ℕ) :
    g x / (L + g x) * (1 - Real.exp 1 *
        (1 + 2 / x * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)))
      ≤ ∫ q, g (∑ k ∈ Finset.range N, a k * q k ^ 2)
          / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2))
        ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)) := by
  have hmeas := measurable_comp_sum_range_mul_sq a hg N
  have hS : MeasurableSet {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x} :=
    (isClosed_le (by fun_prop) continuous_const).measurableSet
  have hc : 0 ≤ g x / (L + g x) := (div_add_mem_Icc hL (hg0 x)).1
  -- The integrand is measurable and bounded by `1`, hence integrable.
  have hint : Integrable (fun q : ℕ → ℝ => g (∑ k ∈ Finset.range N, a k * q k ^ 2)
      / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2)))
      (Measure.infinitePi fun k => gaussianReal 0 (v k)) :=
    Integrable.of_bound (hmeas.div (measurable_const.add hmeas)).aestronglyMeasurable 1
      (.of_forall fun q => norm_div_add_le_one hL (hg0 _))
  -- Off the event `{Q_N ≤ x}` the integrand is at least `g x / (L + g x)`, because `g` and
  -- `t ↦ t / (L + t)` are nondecreasing. On the event it is nonnegative.
  have hpt : ∀ q : ℕ → ℝ,
      {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x}ᶜ.indicator
        (fun _ => g x / (L + g x)) q
      ≤ g (∑ k ∈ Finset.range N, a k * q k ^ 2)
        / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2)) := by
    intro q
    by_cases hq : q ∈ {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x}ᶜ
    · rw [Set.indicator_of_mem hq]
      exact div_add_le_div_add hL (hg0 x) (hg (not_le.1 hq).le)
    · rw [Set.indicator_of_notMem hq]
      exact (div_add_mem_Icc hL (hg0 _)).1
  calc g x / (L + g x) * (1 - Real.exp 1 *
        (1 + 2 / x * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)))
    _ ≤ g x / (L + g x) * (1 - (Measure.infinitePi fun k => gaussianReal 0 (v k)).real
          {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x}) :=
      mul_le_mul_of_nonneg_left
        (sub_le_sub_left (measureReal_infinitePi_sum_range_mul_sq_le_le a v ha hx N) 1) hc
    _ = ∫ q, {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ x}ᶜ.indicator
          (fun _ => g x / (L + g x)) q ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)) := by
      rw [integral_indicator_const _ hS.compl, probReal_compl_eq_one_sub hS, smul_eq_mul,
        mul_comm]
    _ ≤ ∫ q, g (∑ k ∈ Finset.range N, a k * q k ^ 2)
          / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2))
        ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)) :=
      integral_mono_of_nonneg
        (.of_forall fun q => Set.indicator_nonneg (fun _ _ => hc) q) hint (.of_forall hpt)

/-- At a fixed `L > 0` the mean of `g(Q_N) / (L + g(Q_N))` tends to `1` as the number of modes
`N` tends to infinity, when the weights `a k` are nonnegative, the series `∑ a k v k` of the
means diverges, and `g` is nondecreasing, nonnegative and unbounded. -/
theorem tendsto_integral_div_add_all_modes (a : ℕ → ℝ) (v : ℕ → ℝ≥0) (ha : ∀ k, 0 ≤ a k)
    (hdiv : Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (v k : ℝ)) atTop atTop)
    {g : ℝ → ℝ} (hg : Monotone g) (hg0 : ∀ x, 0 ≤ g x) (hginf : Tendsto g atTop atTop)
    {L : ℝ} (hL : 0 < L) :
    Tendsto
      (fun N : ℕ => ∫ q, g (∑ k ∈ Finset.range N, a k * q k ^ 2)
          / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2))
        ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)))
      atTop (𝓝 1) := by
  refine tendsto_order.2 ⟨fun b hb => ?_, fun b hb => .of_forall fun N => ?_⟩
  · -- Lower bound: for `b < 1` the mean is eventually above `b`. Because `g` is unbounded,
    -- there is `x > 0` with `g x / (L + g x) > b`.
    obtain ⟨x, hx, hbx⟩ : ∃ x : ℝ, 0 < x ∧ b < g x / (L + g x) := by
      obtain ⟨x, hx0, hx⟩ := ((eventually_gt_atTop (0 : ℝ)).and
        (hginf.eventually_gt_atTop (b * L / (1 - b)))).exists
      refine ⟨x, hx0, ?_⟩
      rw [lt_div_iff₀ (by linarith [hg0 x])]
      rw [div_lt_iff₀ (by linarith)] at hx
      linarith
    -- The lower bound of `mul_one_sub_le_integral_div_add` at this `x` tends to
    -- `g x / (L + g x)` as `N → ∞`, because the series `∑ a k v k` diverges.
    have hlim : Tendsto
        (fun N => g x / (L + g x) * (1 - Real.exp 1 *
          (1 + 2 / x * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ))))
        atTop (𝓝 (g x / (L + g x))) := by
      have h1 : Tendsto (fun N => 1 + 2 / x * ∑ k ∈ Finset.range N, a k * (v k : ℝ))
          atTop atTop :=
        tendsto_atTop_add_const_left _ _ (hdiv.const_mul_atTop (div_pos two_pos hx))
      have h2 := ((((tendsto_rpow_neg_atTop (y := 1 / 2) (by norm_num)).comp h1).const_mul
        (Real.exp 1)).const_sub 1).const_mul (g x / (L + g x))
      rwa [mul_zero, sub_zero, mul_one] at h2
    exact (hlim.eventually_const_lt hbx).mono fun N hN =>
      hN.trans_le (mul_one_sub_le_integral_div_add a v ha hg hg0 hL hx N)
  · -- Upper bound: the integrand is at most `1` and the measure is a probability measure, so
    -- the mean is at most `1` for every `N`.
    have h := norm_integral_le_of_norm_le_const
      (μ := Measure.infinitePi fun k => gaussianReal 0 (v k))
      (f := fun q : ℕ → ℝ => g (∑ k ∈ Finset.range N, a k * q k ^ 2)
        / (L + g (∑ k ∈ Finset.range N, a k * q k ^ 2))) (C := 1)
      (.of_forall fun q => norm_div_add_le_one hL (hg0 _))
    rw [probReal_univ, mul_one] at h
    exact ((Real.le_norm_self _).trans h).trans_lt hb

end QuantGrav
