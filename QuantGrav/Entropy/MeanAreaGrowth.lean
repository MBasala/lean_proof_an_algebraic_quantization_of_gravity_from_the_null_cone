/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Entropy.ClockTraceAsymptotics

/-!
# The mean area grows like the square of the maximum reading: (5.59), and (5.65) again

Paper: arXiv:2611.34924v1, Sec 5.2 and 5.3: (5.21c), (5.30a), (5.53), (5.54a), (5.59), (5.65).

`QuantGrav/Entropy/ClockTraceAsymptotics.lean` proves (5.65) from two limits: the existence of
`q = lim ⟨u⟩_ℓ / ℓ`, and `log ⟨s⟩_ℓ = [2 + o(1)] log ℓ`. The second is the paper's (5.59), where
`⟨s⟩ = π r_h² / (G ħ)` and the ratio `ℓ / r_h` is held fixed. This file derives the second limit
from the first, with `q > 0`, and two further statements of the paper, so that (5.65) is
conditional on named inputs only.

## Setting

As in `ClockTraceAsymptotics.lean`: states `i` with readings `u i` and areas `s i`, finitely many
below each reading. Fix a constant `c > 0`. In the paper `c = π / ((1 - ε)² G ħ)`, so that
`(s / c)^{1/2}` is `(1 - ε) (A / 4π)^{1/2}`, the lower bound on the reading in (5.21c).

* `cutoffMeanSqrtArea u s c ℓ` is `⟨(s / c)^{1/2}⟩_ℓ`.

The two further inputs are

* the area bound, state by state: `0 ≤ s i ≤ c (u i)²`. The upper bound is (5.21c), register
  entry H14; the lower bound says that areas are nonnegative;
* the mean time delay: `(⟨u⟩_ℓ - ⟨(s / c)^{1/2}⟩_ℓ) / ℓ → 0`. This is (5.53), which the paper
  states as `⟨u - (1 - ε) (A / 4π)^{1/2}⟩ = o(r_h)`; since `r_h` is at most a multiple of `ℓ`,
  the form here is implied by it.

The condition `q > 0` cannot be dropped. A spectrum with finitely many states has `q = 0` and
no delay in the limit, and its `log ⟨s⟩_ℓ / log ℓ` tends to `0`, not to `2`.

## Results

* `sq_gibbsMean_sqrt_le`, `sq_cutoffMeanSqrtArea_le`: (5.54a), `⟨A^{1/2}⟩ ≤ ⟨A⟩^{1/2}`, in the
  form `c ⟨(s / c)^{1/2}⟩² ≤ ⟨s⟩`.
* `cutoffMeanSqrtArea_le_cutoffMeanReading`: the mean delay is nonnegative, (5.21c) in mean.
* `cutoffMeanArea_le`: `⟨s⟩_ℓ ≤ c ℓ²`, the bound (5.30a) in mean.
* `tendsto_log_cutoffMeanArea_div_log`: with the area bound, the mean time delay and
  `⟨u⟩_ℓ / ℓ → q > 0`, `log ⟨s⟩_ℓ = [2 + o(1)] log ℓ`. This is what (5.59) is used for.
* `tendsto_cutoffEntropy_sub_div_log_of_delay`: (5.65) from the area bound, the mean time delay
  and the limit `0 < q < 1`.

## What this does and does not say

The area bound, the mean time delay and the limit `q` are hypotheses. The paper argues for the
first from focusing and for the other two from the expansion about Schwarzschild; none of that
is proved here.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology

/-- **(5.54a) for a finite spectrum.** For `f ≥ 0`, `⟨f^{1/2}⟩² ≤ ⟨f⟩` in the thermal state. The
paper obtains it from the concavity of the square root; it is also the Cauchy–Schwarz inequality
for the weights. -/
theorem sq_gibbsMean_sqrt_le {κ : Type*} [Fintype κ] (s f : κ → ℝ) (hf : ∀ i, 0 ≤ f i) :
    gibbsMean s (fun i => Real.sqrt (f i)) ^ 2 ≤ gibbsMean s f := by
  cases isEmpty_or_nonempty κ
  · simp [gibbsMean]
  · have h := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ (fun i => Real.sqrt (gibbsWeight s i))
      fun i => Real.sqrt (gibbsWeight s i) * Real.sqrt (f i)
    have h1 : ∀ i, Real.sqrt (gibbsWeight s i) * (Real.sqrt (gibbsWeight s i) * Real.sqrt (f i))
        = gibbsWeight s i * Real.sqrt (f i) := by
      intro i
      rw [← mul_assoc, Real.mul_self_sqrt (gibbsWeight_pos s i).le]
    have h2 : ∀ i, Real.sqrt (gibbsWeight s i) ^ 2 = gibbsWeight s i := fun i =>
      Real.sq_sqrt (gibbsWeight_pos s i).le
    have h3 : ∀ i, (Real.sqrt (gibbsWeight s i) * Real.sqrt (f i)) ^ 2
        = gibbsWeight s i * f i := by
      intro i
      rw [mul_pow, Real.sq_sqrt (gibbsWeight_pos s i).le, Real.sq_sqrt (hf i)]
    simp only [h1, h2, h3] at h
    rwa [sum_gibbsWeight, one_mul] at h

/-- If `a ℓ² ≤ m(ℓ) ≤ b ℓ²` for all large `ℓ`, with `a > 0` and `b > 0`, then
`log m(ℓ) = [2 + o(1)] log ℓ`. -/
private theorem tendsto_log_div_log_of_sq_le_of_le_sq {m : ℝ → ℝ} {a b : ℝ} (ha : 0 < a)
    (hb : 0 < b) (hlow : ∀ᶠ ℓ in atTop, a * ℓ ^ 2 ≤ m ℓ)
    (hupp : ∀ᶠ ℓ in atTop, m ℓ ≤ b * ℓ ^ 2) :
    Tendsto (fun ℓ => Real.log (m ℓ) / Real.log ℓ) atTop (𝓝 2) := by
  have hlim : ∀ x : ℝ, Tendsto (fun ℓ => Real.log x / Real.log ℓ + 2) atTop (𝓝 2) := by
    intro x
    have h := ((tendsto_const_nhds (x := Real.log x)).div_atTop Real.tendsto_log_atTop).add_const 2
    rwa [zero_add] at h
  have hlog : ∀ {x ℓ : ℝ}, 0 < x → 1 < ℓ →
      Real.log (x * ℓ ^ 2) / Real.log ℓ = Real.log x / Real.log ℓ + 2 := by
    intro x ℓ hx hℓ
    rw [Real.log_mul hx.ne' (pow_ne_zero 2 (zero_lt_one.trans hℓ).ne'), Real.log_pow, add_div,
      mul_div_cancel_right₀ _ (Real.log_pos hℓ).ne', Nat.cast_ofNat]
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' (hlim a) (hlim b) ?_ ?_
  · filter_upwards [hlow, eventually_gt_atTop 1] with ℓ h h1
    have hpos : 0 < a * ℓ ^ 2 := mul_pos ha (pow_pos (zero_lt_one.trans h1) 2)
    rw [← hlog ha h1]
    exact div_le_div_of_nonneg_right (Real.log_le_log hpos h) (Real.log_pos h1).le
  · filter_upwards [hlow, hupp, eventually_gt_atTop 1] with ℓ h h' h1
    have hpos : 0 < a * ℓ ^ 2 := mul_pos ha (pow_pos (zero_lt_one.trans h1) 2)
    rw [← hlog hb h1]
    exact div_le_div_of_nonneg_right (Real.log_le_log (hpos.trans_le h) h') (Real.log_pos h1).le

variable {ι : Type*} (u s : ι → ℝ) [∀ ℓ : ℝ, Fintype {i // u i ≤ ℓ}]

/-- The mean `⟨(s / c)^{1/2}⟩_ℓ` in the thermal state on the states with reading at most `ℓ`. In
the paper `(s / c)^{1/2}` is `(1 - ε) (A / 4π)^{1/2}`, the lower bound on the clock reading in
(5.21c). -/
noncomputable def cutoffMeanSqrtArea (c ℓ : ℝ) : ℝ :=
  gibbsMean (belowReading u ℓ s) (belowReading u ℓ fun i => Real.sqrt (s i / c))

/-- (5.54a) at each `ℓ`: `c ⟨(s / c)^{1/2}⟩_ℓ² ≤ ⟨s⟩_ℓ`, for nonnegative areas. -/
theorem sq_cutoffMeanSqrtArea_le {c : ℝ} (hc : 0 < c) (hs : ∀ i, 0 ≤ s i) (ℓ : ℝ) :
    c * cutoffMeanSqrtArea u s c ℓ ^ 2 ≤ cutoffMeanArea u s ℓ := by
  have h := sq_gibbsMean_sqrt_le (belowReading u ℓ s) (belowReading u ℓ fun i => s i / c)
    fun i => div_nonneg (hs i) hc.le
  have hdiv : gibbsMean (belowReading u ℓ s) (belowReading u ℓ fun i => s i / c)
      = cutoffMeanArea u s ℓ / c := by
    rw [cutoffMeanArea, gibbsMean, gibbsMean, Finset.sum_div]
    exact Finset.sum_congr rfl fun i _ => (mul_div_assoc _ _ _).symm
  rw [hdiv] at h
  exact (le_div_iff₀' hc).mp h

/-- (5.21c) in mean: if `s i ≤ c (u i)²` for every state, with nonnegative readings, then
`⟨(s / c)^{1/2}⟩_ℓ ≤ ⟨u⟩_ℓ`. The difference is the mean time delay of (5.53). -/
theorem cutoffMeanSqrtArea_le_cutoffMeanReading (hu : ∀ i, 0 ≤ u i) {c : ℝ} (hc : 0 < c)
    (hsu : ∀ i, s i ≤ c * u i ^ 2) (ℓ : ℝ) :
    cutoffMeanSqrtArea u s c ℓ ≤ cutoffMeanReading u s ℓ := by
  unfold cutoffMeanSqrtArea cutoffMeanReading gibbsMean
  refine Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_left ?_ (gibbsWeight_pos _ i).le
  exact (Real.sqrt_le_left (hu i)).mpr ((div_le_iff₀' hc).mpr (hsu i))

/-- (5.30a) in mean: if `s i ≤ c (u i)²` for every state, with nonnegative readings, then
`⟨s⟩_ℓ ≤ c ℓ²`. In the paper `c ℓ²` is `s_*`. -/
theorem cutoffMeanArea_le (hu : ∀ i, 0 ≤ u i) {c : ℝ} (hc : 0 ≤ c)
    (hsu : ∀ i, s i ≤ c * u i ^ 2) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    cutoffMeanArea u s ℓ ≤ c * ℓ ^ 2 := by
  have hterm : ∀ i : {i // u i ≤ ℓ}, belowReading u ℓ s i ≤ c * ℓ ^ 2 := fun i =>
    (hsu i).trans (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (hu i) i.property 2) hc)
  cases isEmpty_or_nonempty {i // u i ≤ ℓ}
  · rw [cutoffMeanArea, gibbsMean, Finset.univ_eq_empty, Finset.sum_empty]
    exact mul_nonneg hc (pow_nonneg hℓ 2)
  · calc cutoffMeanArea u s ℓ
        ≤ ∑ i, gibbsWeight (belowReading u ℓ s) i * (c * ℓ ^ 2) :=
          Finset.sum_le_sum fun i _ =>
            mul_le_mul_of_nonneg_left (hterm i) (gibbsWeight_pos _ i).le
      _ = c * ℓ ^ 2 := by rw [← Finset.sum_mul, sum_gibbsWeight, one_mul]

/-- **What (5.59) is used for.** Suppose `0 ≤ s i ≤ c (u i)²` for every state, the mean reading
satisfies `⟨u⟩_ℓ / ℓ → q` with `q > 0`, and the mean time delay satisfies
`(⟨u⟩_ℓ - ⟨(s / c)^{1/2}⟩_ℓ) / ℓ → 0`. Then `log ⟨s⟩_ℓ = [2 + o(1)] log ℓ`. -/
theorem tendsto_log_cutoffMeanArea_div_log [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {c q : ℝ}
    (hc : 0 < c) (hs : ∀ i, 0 ≤ s i) (hsu : ∀ i, s i ≤ c * u i ^ 2) (hq0 : 0 < q)
    (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q))
    (hdelay : Tendsto (fun ℓ => (cutoffMeanReading u s ℓ - cutoffMeanSqrtArea u s c ℓ) / ℓ)
      atTop (𝓝 0)) :
    Tendsto (fun ℓ => Real.log (cutoffMeanArea u s ℓ) / Real.log ℓ) atTop (𝓝 2) := by
  have hA : Tendsto (fun ℓ => cutoffMeanSqrtArea u s c ℓ / ℓ) atTop (𝓝 q) := by
    have h := hq.sub hdelay
    rw [sub_zero] at h
    refine h.congr fun ℓ => ?_
    rw [← sub_div, sub_sub_cancel]
  have hev : ∀ᶠ ℓ in atTop, q / 2 < cutoffMeanSqrtArea u s c ℓ / ℓ :=
    hA.eventually_const_lt (half_lt_self hq0)
  have hpos : 0 < c * (q / 2) ^ 2 := by positivity
  refine tendsto_log_div_log_of_sq_le_of_le_sq hpos hc ?_
    ((eventually_ge_atTop 0).mono fun ℓ hℓ => cutoffMeanArea_le u s hu hc.le hsu hℓ)
  filter_upwards [hev, eventually_gt_atTop 0] with ℓ hqℓ hℓ0
  have hAℓ : q / 2 * ℓ < cutoffMeanSqrtArea u s c ℓ := (lt_div_iff₀ hℓ0).mp hqℓ
  have hsq : (q / 2 * ℓ) ^ 2 ≤ cutoffMeanSqrtArea u s c ℓ ^ 2 :=
    pow_le_pow_left₀ (by positivity) hAℓ.le 2
  calc c * (q / 2) ^ 2 * ℓ ^ 2 = c * (q / 2 * ℓ) ^ 2 := by ring
    _ ≤ c * cutoffMeanSqrtArea u s c ℓ ^ 2 := mul_le_mul_of_nonneg_left hsq hc.le
    _ ≤ cutoffMeanArea u s ℓ := sq_cutoffMeanSqrtArea_le u s hc hs ℓ

/-- **(5.65) from named inputs.** Suppose `0 ≤ s i ≤ c (u i)²` for every state (the area bound
(5.21c)), `⟨u⟩_ℓ / ℓ → q` with `0 < q < 1` (5.54b), and the mean time delay satisfies
`(⟨u⟩_ℓ - ⟨(s / c)^{1/2}⟩_ℓ) / ℓ → 0` (5.53). Then the entropy of the thermal state satisfies
`S - ⟨s⟩_ℓ = [q / (2 (1 - q)) + o(1)] log ⟨s⟩_ℓ`. -/
theorem tendsto_cutoffEntropy_sub_div_log_of_delay [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {c q : ℝ}
    (hc : 0 < c) (hs : ∀ i, 0 ≤ s i) (hsu : ∀ i, s i ≤ c * u i ^ 2) (hq0 : 0 < q) (hq1 : q < 1)
    (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q))
    (hdelay : Tendsto (fun ℓ => (cutoffMeanReading u s ℓ - cutoffMeanSqrtArea u s c ℓ) / ℓ)
      atTop (𝓝 0)) :
    Tendsto (fun ℓ => (cutoffEntropy u s ℓ - cutoffMeanArea u s ℓ)
      / Real.log (cutoffMeanArea u s ℓ)) atTop (𝓝 (q / (2 * (1 - q)))) := by
  exact tendsto_cutoffEntropy_sub_div_log u s hu hq1 hq
    (tendsto_log_cutoffMeanArea_div_log u s hu hc hs hsu hq0 hq hdelay)

end QuantGrav
