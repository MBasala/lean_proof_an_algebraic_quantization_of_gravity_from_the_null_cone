/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Probability.ProductMeasure
import QuantGrav.Elementary.GaussianExpSq
import QuantGrav.Elementary.OneAddSumLeProd

/-!
# Positive quadratic forms of independent Gaussian variables

This file is mathematics only. It uses nothing from the paper. It was written for break attempt
B1 of `handoff.md`, Section 14, which asks whether a positive quadratic form of infinitely many
Gaussian modes can be finite.

Let `q k` be independent centred Gaussian variables with variances `v k`, and let `a k ≥ 0`. The
quadratic form is `Q = ∑ k, a k * q k ^ 2`, with mean `∑ k, a k * v k`.

* `integral_exp_neg_sum_mul_sq_pi`: for finitely many modes and `b k ≥ 0`, the mean of
  `exp (-∑ b k (q k)²)` is the product of the factors `(1 + 2 b k v k) ^ (-1/2)`. It rests on
  G2, `integral_exp_neg_mul_sq_gaussianReal`.
* `measureReal_sum_mul_sq_le_le` (G3): for finitely many modes and `c > 0`,
  `P (Q ≤ c) ≤ e (1 + (2 / c) ∑ a k v k) ^ (-1/2)`. It rests on G1,
  `one_add_sum_le_prod_one_add`.
* `ae_tendsto_sum_mul_sq_atTop`: for infinitely many modes, if `∑ a k v k` diverges then the
  partial sums of `Q` tend to infinity almost surely. So `Q` is infinite almost surely.
-/

public section

namespace QuantGrav

open MeasureTheory ProbabilityTheory Filter Topology
open scoped NNReal

/-- For finitely many independent centred Gaussian variables `q k` of variances `v k` and
`b k ≥ 0`, the mean of `exp (-∑ b k (q k)²)` is the product of the factors
`(1 + 2 b k v k) ^ (-1/2)`. -/
theorem integral_exp_neg_sum_mul_sq_pi {ι : Type*} [Fintype ι] (b : ι → ℝ) (v : ι → ℝ≥0)
    (hb : ∀ k, 0 ≤ b k) :
    ∫ q : ι → ℝ, Real.exp (-∑ k, b k * q k ^ 2) ∂(Measure.pi fun k => gaussianReal 0 (v k))
      = ∏ k, (1 + 2 * b k * v k) ^ (-(1 / 2 : ℝ)) := by
  have h : ∀ q : ι → ℝ,
      Real.exp (-∑ k, b k * q k ^ 2) = ∏ k, Real.exp (-(b k * q k ^ 2)) := fun q => by
    rw [← Finset.sum_neg_distrib, Real.exp_sum]
  simp_rw [h]
  rw [integral_fintype_prod_eq_prod fun k x => Real.exp (-(b k * x ^ 2))]
  exact Finset.prod_congr rfl fun k _ => integral_exp_neg_mul_sq_gaussianReal (v k) (hb k)

/-- **G3.** For finitely many independent centred Gaussian variables `q k` of variances `v k`,
weights `a k ≥ 0` and any `c > 0`, the probability that the quadratic form
`∑ a k (q k)²` is at most `c` is at most `e (1 + (2 / c) ∑ a k v k) ^ (-1/2)`. -/
theorem measureReal_sum_mul_sq_le_le {ι : Type*} [Fintype ι] (a : ι → ℝ) (v : ι → ℝ≥0)
    (ha : ∀ k, 0 ≤ a k) {c : ℝ} (hc : 0 < c) :
    (Measure.pi fun k => gaussianReal 0 (v k)).real {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c}
      ≤ Real.exp 1 * (1 + 2 / c * ∑ k, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)) := by
  have hS : MeasurableSet {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c} :=
    (isClosed_le (by fun_prop) continuous_const).measurableSet
  have hb : ∀ k, 0 ≤ a k / c := fun k => div_nonneg (ha k) hc.le
  -- The dominating function `exp (1 - Q / c)` is continuous and bounded, hence integrable.
  have hcont : Continuous fun q : ι → ℝ => Real.exp (-∑ k, a k / c * q k ^ 2) := by fun_prop
  have hint : Integrable (fun q : ι → ℝ => Real.exp 1 * Real.exp (-∑ k, a k / c * q k ^ 2))
      (Measure.pi fun k => gaussianReal 0 (v k)) := by
    refine (Integrable.of_bound hcont.aestronglyMeasurable 1 (.of_forall fun q => ?_)).const_mul _
    rw [Real.norm_eq_abs, Real.abs_exp, Real.exp_le_one_iff, neg_nonpos]
    exact Finset.sum_nonneg fun k _ => mul_nonneg (hb k) (sq_nonneg _)
  -- The indicator of `{Q ≤ c}` is at most `exp (1 - Q / c)`.
  have hpt : ∀ q : ι → ℝ, {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c}.indicator 1 q
      ≤ Real.exp 1 * Real.exp (-∑ k, a k / c * q k ^ 2) := by
    intro q
    by_cases hq : q ∈ {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c}
    · have hdiv : ∑ k, a k / c * q k ^ 2 = (∑ k, a k * q k ^ 2) / c := by
        rw [Finset.sum_div]
        exact Finset.sum_congr rfl fun k _ => by ring
      have hle : (∑ k, a k * q k ^ 2) / c ≤ 1 := (div_le_one hc).2 hq
      rw [Set.indicator_of_mem hq, Pi.one_apply, ← Real.exp_add, hdiv]
      exact Real.one_le_exp (by linarith)
    · rw [Set.indicator_of_notMem hq]
      positivity
  -- By G1, one plus the sum of the terms `2 (a k / c) v k` is at most the product of the
  -- factors `1 + 2 (a k / c) v k`.
  have hnn : ∀ k ∈ Finset.univ, 0 ≤ 2 * (a k / c) * (v k : ℝ) := fun k _ =>
    mul_nonneg (mul_nonneg zero_le_two (hb k)) (v k).coe_nonneg
  have hle : 1 + 2 / c * ∑ k, a k * (v k : ℝ) ≤ ∏ k, (1 + 2 * (a k / c) * (v k : ℝ)) := by
    have hsum : 2 / c * ∑ k, a k * (v k : ℝ) = ∑ k, 2 * (a k / c) * (v k : ℝ) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun k _ => by ring
    rw [hsum]
    exact one_add_sum_le_prod_one_add Finset.univ _ hnn
  have hpos : 0 < 1 + 2 / c * ∑ k, a k * (v k : ℝ) :=
    add_pos_of_pos_of_nonneg one_pos (mul_nonneg (div_pos two_pos hc).le
      (Finset.sum_nonneg fun k _ => mul_nonneg (ha k) (v k).coe_nonneg))
  calc (Measure.pi fun k => gaussianReal 0 (v k)).real {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c}
    _ = ∫ q, {q : ι → ℝ | ∑ k, a k * q k ^ 2 ≤ c}.indicator 1 q
          ∂(Measure.pi fun k => gaussianReal 0 (v k)) := (integral_indicator_one hS).symm
    _ ≤ ∫ q : ι → ℝ, Real.exp 1 * Real.exp (-∑ k, a k / c * q k ^ 2)
          ∂(Measure.pi fun k => gaussianReal 0 (v k)) :=
      integral_mono_of_nonneg
        (.of_forall fun q => Set.indicator_nonneg (fun _ _ => zero_le_one) q) hint
        (.of_forall hpt)
    _ = Real.exp 1 * ∏ k, (1 + 2 * (a k / c) * (v k : ℝ)) ^ (-(1 / 2 : ℝ)) := by
      rw [integral_const_mul, integral_exp_neg_sum_mul_sq_pi _ v hb]
    _ = Real.exp 1 * (∏ k, (1 + 2 * (a k / c) * (v k : ℝ))) ^ (-(1 / 2 : ℝ)) := by
      rw [Real.finsetProd_rpow _ _ fun k hk => by linarith [hnn k hk]]
    _ ≤ Real.exp 1 * (1 + 2 / c * ∑ k, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)) :=
      mul_le_mul_of_nonneg_left (Real.rpow_le_rpow_of_nonpos hpos hle (by norm_num))
        (Real.exp_pos 1).le

/-- For independent centred Gaussian variables `q k` of variances `v k`, indexed by the natural
numbers, weights `a k ≥ 0` and any `c > 0`, the probability that the `N`-th partial sum of
`∑ a k (q k)²` is at most `c` is at most `e (1 + (2 / c) ∑ k < N, a k v k) ^ (-1/2)`. This is
G3 for the first `N` coordinates of the infinite product measure. -/
theorem measureReal_infinitePi_sum_range_mul_sq_le_le (a : ℕ → ℝ) (v : ℕ → ℝ≥0)
    (ha : ∀ k, 0 ≤ a k) {c : ℝ} (hc : 0 < c) (N : ℕ) :
    (Measure.infinitePi fun k => gaussianReal 0 (v k)).real
        {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c}
      ≤ Real.exp 1 * (1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)) := by
  have hT : MeasurableSet
      {y : ↥(Finset.range N) → ℝ | ∑ k : ↥(Finset.range N), a k * y k ^ 2 ≤ c} :=
    (isClosed_le (by fun_prop) continuous_const).measurableSet
  have hset : {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c}
      = (Finset.range N).restrict ⁻¹'
        {y : ↥(Finset.range N) → ℝ | ∑ k : ↥(Finset.range N), a k * y k ^ 2 ≤ c} := by
    ext q
    rw [Set.mem_preimage, Set.mem_ofPred_eq, Set.mem_ofPred_eq,
      ← Finset.sum_coe_sort (Finset.range N) fun k => a k * q k ^ 2]
    rfl
  rw [measureReal_def, hset, ← Measure.map_apply (Finset.measurable_restrict _) hT,
    Measure.infinitePi_map_restrict, ← measureReal_def,
    ← Finset.sum_coe_sort (Finset.range N) fun k => a k * (v k : ℝ)]
  exact measureReal_sum_mul_sq_le_le (fun k : ↥(Finset.range N) => a k) (fun k => v k)
    (fun k => ha k) hc

/-- For independent centred Gaussian variables `q k` of variances `v k`, indexed by the natural
numbers, and weights `a k ≥ 0`: if the series `∑ a k v k` of the means diverges, then for every
`c > 0` the event that all partial sums of `∑ a k (q k)²` are at most `c` has probability
zero. -/
theorem measure_forall_sum_range_mul_sq_le_eq_zero (a : ℕ → ℝ) (v : ℕ → ℝ≥0)
    (ha : ∀ k, 0 ≤ a k)
    (hdiv : Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (v k : ℝ)) atTop atTop)
    {c : ℝ} (hc : 0 < c) :
    (Measure.infinitePi fun k => gaussianReal 0 (v k))
      {q : ℕ → ℝ | ∀ N, ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c} = 0 := by
  -- The bound of G3 for the first `N` modes tends to zero as `N` grows.
  have hlim : Tendsto
      (fun N => Real.exp 1 *
        (1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)))
      atTop (𝓝 0) := by
    have h1 : Tendsto (fun N => 1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ))
        atTop atTop :=
      tendsto_atTop_add_const_left _ _ (hdiv.const_mul_atTop (div_pos two_pos hc))
    have h2 := ((tendsto_rpow_neg_atTop (y := 1 / 2) (by norm_num)).comp h1).const_mul
      (Real.exp 1)
    rwa [mul_zero] at h2
  -- The event lies in `{Q N ≤ c}` for every `N`, so its probability is below every bound.
  have hle : ∀ N, (Measure.infinitePi fun k => gaussianReal 0 (v k)).real
      {q : ℕ → ℝ | ∀ N, ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c}
      ≤ Real.exp 1 * (1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)) := by
    intro N
    refine (measureReal_mono ?_).trans (measureReal_infinitePi_sum_range_mul_sq_le_le a v ha hc N)
    exact fun q hq => hq N
  rw [← measureReal_eq_zero_iff]
  exact le_antisymm (ge_of_tendsto' hlim hle) measureReal_nonneg

/-- For infinitely many independent centred Gaussian variables `q k` of variances `v k` and
weights `a k ≥ 0`: if the series `∑ a k v k` of the means diverges, then almost surely the
partial sums of `∑ a k (q k)²` tend to infinity. So the quadratic form is infinite almost
surely. -/
theorem ae_tendsto_sum_mul_sq_atTop (a : ℕ → ℝ) (v : ℕ → ℝ≥0) (ha : ∀ k, 0 ≤ a k)
    (hdiv : Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (v k : ℝ)) atTop atTop) :
    ∀ᵐ q ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)),
      Tendsto (fun N => ∑ k ∈ Finset.range N, a k * q k ^ 2) atTop atTop := by
  -- Almost surely, for every natural `n` some partial sum exceeds `n + 1`.
  have hae : ∀ᵐ q ∂(Measure.infinitePi fun k => gaussianReal 0 (v k)),
      ∀ n : ℕ, ¬ ∀ N, ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ (n : ℝ) + 1 :=
    ae_all_iff.2 fun n => measure_eq_zero_iff_ae_notMem.1
      (measure_forall_sum_range_mul_sq_le_eq_zero a v ha hdiv (by positivity))
  filter_upwards [hae] with q hq
  -- The partial sums are monotone because the terms are nonnegative, and unbounded by `hq`.
  refine tendsto_atTop_atTop_of_monotone (fun m n hmn => ?_) fun b => ?_
  · exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.range_mono hmn)
      fun k _ _ => mul_nonneg (ha k) (sq_nonneg _)
  · obtain ⟨n, hn⟩ := exists_nat_ge b
    obtain ⟨N, hN⟩ := not_forall.1 (hq n)
    exact ⟨N, by linarith [not_le.1 hN]⟩

end QuantGrav
