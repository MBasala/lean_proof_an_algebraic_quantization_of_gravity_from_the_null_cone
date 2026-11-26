/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Elementary.MonotoneLogGrowth
public import QuantGrav.Entropy.ClockMoments
public import QuantGrav.Entropy.GibbsAccounting

/-!
# The trace as the maximum clock reading grows: (5.57b), (5.58), (5.62), (5.65)

Paper: arXiv:2611.34924v1, Sec 5.3: (5.50), (5.54b), (5.56) to (5.59), (5.62), (5.65).

This file is Track A item 4 of `handoff.md`, Section 14.3: (5.58) and (5.65) as asymptotic
statements, conditional on the limit `q` existing.

## Setting

A spectrum is a family of states `i` with clock readings `u i` and areas `s i`, in units of
`4 G ħ`. It may be infinite, but only finitely many states have reading at most `ℓ`, for every
`ℓ`. This is the hypothesis `[∀ ℓ, Fintype {i // u i ≤ ℓ}]`, and in the paper it is the finite
dimension of the diamond with maximum reading `ℓ`. The paper varies "only the upper limit `ℓ`
in the clock projector", so one spectrum serves for every `ℓ`.

For each `ℓ` the states with `u i ≤ ℓ` form a finite spectrum in the sense of
`QuantGrav/Entropy/GibbsAccounting.lean`, with its thermal state `e^{-s} / Z`:

* `cutoffZ u s ℓ` is `Z(ℓ) = ∑_{u_i ≤ ℓ} e^{-s_i}` of (5.56);
* `cutoffMeanReading u s ℓ` is `⟨u⟩_ℓ`;
* `cutoffMeanArea u s ℓ` is `⟨s⟩_ℓ`;
* `cutoffEntropy u s ℓ` is the entropy `S` of that thermal state.

## Results

* `integral_cutoffZ`, `firstMomentOf_cutoffZ`: (5.56), `∫_0^ℓ Z = Z(ℓ) (ℓ - ⟨u⟩_ℓ)`, for a
  spectrum with finitely many states below each reading.
* `cutoffEntropy_eq`: (5.50) at each `ℓ`, `S = ⟨s⟩_ℓ + log Z(ℓ)`.
* `tendsto_integral_cutoffZ_div`: (5.57b). If `⟨u⟩_ℓ / ℓ → q`, then
  `(1 / ℓ) ∫_0^ℓ Z = [1 - q + o(1)] Z(ℓ)`.
* `tendsto_log_cutoffZ_div_log`: (5.58). If `⟨u⟩_ℓ / ℓ → q < 1`, then
  `log Z(ℓ) = [q / (1 - q) + o(1)] log ℓ`.
* `tendsto_cutoffEntropy_sub_div_log`: (5.65). If also `log ⟨s⟩_ℓ / log ℓ → 2`, then
  `S - ⟨s⟩_ℓ = [q / (2 (1 - q)) + o(1)] log ⟨s⟩_ℓ`.
* `tendsto_log_cutoffZ_div_log_cutoffMeanArea`: (5.62). Under the same hypotheses,
  `log Z(ℓ) = [q / (2 (1 - q)) + o(1)] log ⟨s⟩_ℓ`, which gives the paper's
  `log Z / ⟨s⟩ = O(log ⟨s⟩ / ⟨s⟩)`.
* `tendsto_log_cutoffZ_div_cutoffMeanArea`: in particular `log Z(ℓ) / ⟨s⟩_ℓ → 0`.

The readings are assumed nonnegative wherever an integral from `0` appears, and the spectrum
nonempty in the limit theorems. No sign condition is put on the areas; Lean's `Real.log` is the
logarithm of the absolute value, so the hypothesis on `log ⟨s⟩_ℓ` already forces `⟨s⟩_ℓ` to be
large in absolute value.

## What this does and does not say

Two limits are hypotheses. The first is the existence of `q = lim ⟨u⟩_ℓ / ℓ` with `q < 1`,
(5.54b). The second is `log ⟨s⟩_ℓ = [2 + o(1)] log ℓ`, which is (5.59): there `⟨s⟩ = π r_h² /
(G ħ)` and the ratio `ℓ / r_h` is held fixed. The paper argues for both from (5.53); neither is
proved here. Given the two limits, (5.58), (5.62) and (5.65) follow, with no further input.

The paper defines `q` in (5.54b) as a limit as the black hole grows, `r_h / ℓ_P → ∞`. Here the
limit is in the maximum reading `ℓ` of one fixed spectrum. That is the limit the paper uses
under the integral of (5.58), where the right side of (5.57a) is said to tend to `q / (1 - q)`.
The theorems are stated with `log ℓ`; (5.58) has `log (ℓ / ℓ_0)`, and the two forms are
equivalent (`tendsto_log_div_log_div_of_tendsto_integral_div`).
-/

@[expose] public section

namespace QuantGrav

open Filter Topology MeasureTheory

variable {ι : Type*}

/-- The restriction of a function on the states to the states with clock reading at most
`ℓ`. -/
abbrev belowReading (u : ι → ℝ) (ℓ : ℝ) (f : ι → ℝ) : {i // u i ≤ ℓ} → ℝ :=
  fun i => f i

section

variable (u s : ι → ℝ) [∀ ℓ : ℝ, Fintype {i // u i ≤ ℓ}]

/-- The thermal trace `Z(ℓ) = ∑_{u_i ≤ ℓ} e^{-s_i}` of (5.56), as a function of the maximum
clock reading `ℓ`. -/
noncomputable def cutoffZ (ℓ : ℝ) : ℝ :=
  gibbsZ (belowReading u ℓ s)

/-- The mean clock reading `⟨u⟩_ℓ` in the thermal state on the states with reading at most
`ℓ`. -/
noncomputable def cutoffMeanReading (ℓ : ℝ) : ℝ :=
  gibbsMean (belowReading u ℓ s) (belowReading u ℓ u)

/-- The mean area `⟨s⟩_ℓ` in the thermal state on the states with reading at most `ℓ`. -/
noncomputable def cutoffMeanArea (ℓ : ℝ) : ℝ :=
  gibbsMean (belowReading u ℓ s) (belowReading u ℓ s)

/-- The entropy of the thermal state on the states with reading at most `ℓ`. -/
noncomputable def cutoffEntropy (ℓ : ℝ) : ℝ :=
  gibbsEntropy (belowReading u ℓ s)

/-! ### The dictionary to finite spectra, and (5.56) -/

/-- A sum over the states with reading at most `t` is the sum over the states with reading at
most `ℓ ≥ t` of the terms with reading at most `t`. -/
private theorem sum_belowReading_eq_sum_ite {t ℓ : ℝ} (h : t ≤ ℓ) (f : ι → ℝ) :
    ∑ i : {i // u i ≤ t}, f i = ∑ j : {i // u i ≤ ℓ}, if u j ≤ t then f j else 0 := by
  -- The states with reading at most `ℓ`, as a finite set of states.
  obtain ⟨B, hB⟩ : ∃ B : Finset ι, ∀ x, x ∈ B ↔ u x ≤ ℓ :=
    ⟨(Finset.univ : Finset {i // u i ≤ ℓ}).map (Function.Embedding.subtype _), fun x => by simp⟩
  have hA : ∀ x, x ∈ B.filter (fun i => u i ≤ t) ↔ u x ≤ t := fun x => by
    rw [Finset.mem_filter, hB]
    exact ⟨fun h' => h'.2, fun h' => ⟨h'.trans h, h'⟩⟩
  have h1 : ∑ a ∈ B.filter (fun i => u i ≤ t), f a = ∑ i : {i // u i ≤ t}, f i :=
    Finset.sum_subtype _ hA f
  have h2 : ∑ a ∈ B, (if u a ≤ t then f a else 0)
      = ∑ j : {i // u i ≤ ℓ}, if u j ≤ t then f j else 0 :=
    Finset.sum_subtype B hB _
  rw [← h1, ← h2, Finset.sum_filter]

/-- Below a cutoff `ℓ`, the trace is the counting function of the finite spectrum of states
with reading at most `ℓ`. -/
theorem cutoffZ_eq_momentSum {t ℓ : ℝ} (h : t ≤ ℓ) :
    cutoffZ u s t
      = momentSum (belowReading u ℓ u) (fun i => Real.exp (-belowReading u ℓ s i)) 0 t := by
  simp only [cutoffZ, gibbsZ, momentSum, pow_zero, one_mul]
  exact sum_belowReading_eq_sum_ite u h fun i => Real.exp (-s i)

/-- Below a cutoff `ℓ`, `Z(t) ⟨u⟩_t` is the first moment sum of the finite spectrum of states
with reading at most `ℓ`. -/
theorem cutoffZ_mul_cutoffMeanReading_eq_momentSum {t ℓ : ℝ} (h : t ≤ ℓ) :
    cutoffZ u s t * cutoffMeanReading u s t
      = momentSum (belowReading u ℓ u) (fun i => Real.exp (-belowReading u ℓ s i)) 1 t := by
  -- `Z(t) ⟨u⟩_t = ∑_{u_i ≤ t} u_i e^{-s_i}`, also when no state has reading at most `t`.
  have key : cutoffZ u s t * cutoffMeanReading u s t
      = ∑ i : {i // u i ≤ t}, u i * Real.exp (-s i) := by
    rw [cutoffZ, cutoffMeanReading, gibbsMean, Finset.mul_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [← mul_assoc, mul_comm (gibbsZ _), gibbsWeight_mul_gibbsZ, mul_comm]
  rw [key]
  simp only [momentSum, pow_one]
  exact sum_belowReading_eq_sum_ite u h fun i => u i * Real.exp (-s i)

theorem cutoffZ_nonneg (ℓ : ℝ) : 0 ≤ cutoffZ u s ℓ := by
  exact gibbsZ_nonneg _

/-- The trace is positive once the cutoff has reached some state. -/
theorem cutoffZ_pos {i : ι} {ℓ : ℝ} (h : u i ≤ ℓ) : 0 < cutoffZ u s ℓ := by
  have : Nonempty {i // u i ≤ ℓ} := ⟨⟨i, h⟩⟩
  exact gibbsZ_pos _

/-- The trace is nondecreasing in the maximum reading. -/
theorem monotone_cutoffZ : Monotone (cutoffZ u s) := by
  intro t t' h
  rw [cutoffZ_eq_momentSum u s h, cutoffZ_eq_momentSum u s (le_refl t')]
  simp only [momentSum, pow_zero, one_mul]
  refine Finset.sum_le_sum fun j _ => ?_
  split_ifs with h1 h2 h2
  · exact le_rfl
  · exact absurd (h1.trans h) h2
  · exact (Real.exp_pos _).le
  · exact le_rfl

/-- **(5.56).** For nonnegative readings and `ℓ ≥ 0`: `∫_0^ℓ Z = Z(ℓ) (ℓ - ⟨u⟩_ℓ)`. -/
theorem integral_cutoffZ (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    ∫ t in (0 : ℝ)..ℓ, cutoffZ u s t = cutoffZ u s ℓ * (ℓ - cutoffMeanReading u s ℓ) := by
  -- On `[0, ℓ]` the trace is the counting function of the finite spectrum below `ℓ`.
  have hcongr : ∫ t in (0 : ℝ)..ℓ, cutoffZ u s t
      = ∫ t in (0 : ℝ)..ℓ,
        momentSum (belowReading u ℓ u) (fun i => Real.exp (-belowReading u ℓ s i)) 0 t := by
    refine intervalIntegral.integral_congr fun t ht => ?_
    rw [Set.uIcc_of_le hℓ] at ht
    exact cutoffZ_eq_momentSum u s ht.2
  have h0 := cutoffZ_eq_momentSum u s (le_refl ℓ)
  have h1 := cutoffZ_mul_cutoffMeanReading_eq_momentSum u s (le_refl ℓ)
  -- (5.56) for that finite spectrum.
  have hfm := firstMomentOf_momentSum (belowReading u ℓ u)
    (fun i => Real.exp (-belowReading u ℓ s i)) (fun j => hu j) hℓ
  rw [firstMomentOf, ← h0, ← h1, ← hcongr] at hfm
  linarith

/-- (5.56) in the form `ℓ Z(ℓ) - ∫_0^ℓ Z = Z(ℓ) ⟨u⟩_ℓ`. -/
theorem firstMomentOf_cutoffZ (hu : ∀ i, 0 ≤ u i) {ℓ : ℝ} (hℓ : 0 ≤ ℓ) :
    firstMomentOf (cutoffZ u s) ℓ = cutoffZ u s ℓ * cutoffMeanReading u s ℓ := by
  rw [firstMomentOf, integral_cutoffZ u s hu hℓ]
  ring

/-- **(5.50) at each `ℓ`.** `S = ⟨s⟩_ℓ + log Z(ℓ)`. -/
theorem cutoffEntropy_eq (ℓ : ℝ) :
    cutoffEntropy u s ℓ = cutoffMeanArea u s ℓ + Real.log (cutoffZ u s ℓ) := by
  exact gibbsEntropy_eq_mean_add_log _

/-! ### (5.57b) and (5.58) -/

/-- **(5.57b).** If the mean reading satisfies `⟨u⟩_ℓ / ℓ → q`, then
`(1 / ℓ) ∫_0^ℓ Z = [1 - q + o(1)] Z(ℓ)`. -/
theorem tendsto_integral_cutoffZ_div [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {q : ℝ}
    (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q)) :
    Tendsto (fun ℓ => (∫ t in (0 : ℝ)..ℓ, cutoffZ u s t) / ℓ / cutoffZ u s ℓ) atTop
      (𝓝 (1 - q)) := by
  obtain ⟨i₀⟩ : Nonempty ι := inferInstance
  have h1 : Tendsto (fun ℓ => 1 - cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 (1 - q)) :=
    tendsto_const_nhds.sub hq
  refine h1.congr' ?_
  -- Once `ℓ ≥ 1` and `ℓ` has reached the state `i₀`, both `ℓ` and `Z(ℓ)` are positive.
  filter_upwards [eventually_ge_atTop (max (u i₀) 1)] with ℓ hℓ
  have hℓ0 : 0 < ℓ := zero_lt_one.trans_le ((le_max_right _ _).trans hℓ)
  have hZ : cutoffZ u s ℓ ≠ 0 := (cutoffZ_pos u s ((le_max_left _ _).trans hℓ)).ne'
  rw [integral_cutoffZ u s hu hℓ0.le, mul_div_assoc, mul_div_cancel_left₀ _ hZ, sub_div,
    div_self hℓ0.ne']

/-- **(5.58), conditional on the limit `q`.** If `⟨u⟩_ℓ / ℓ → q` with `q < 1`, then
`log Z(ℓ) = [q / (1 - q) + o(1)] log ℓ`. -/
theorem tendsto_log_cutoffZ_div_log [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {q : ℝ} (hq1 : q < 1)
    (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q)) :
    Tendsto (fun ℓ => Real.log (cutoffZ u s ℓ) / Real.log ℓ) atTop (𝓝 (q / (1 - q))) := by
  obtain ⟨i₀⟩ : Nonempty ι := inferInstance
  refine tendsto_log_div_log_of_tendsto_integral_div (monotone_cutoffZ u s)
    ⟨u i₀, cutoffZ_pos u s (le_refl (u i₀))⟩ hq1 ?_
  simpa only [div_div] using tendsto_integral_cutoffZ_div u s hu hq

end

/-! ### (5.62) and (5.65) -/

/-- The step from (5.58) to (5.65), for any three functions of `ℓ`. If `S = m + log Z`,
`log Z = [κ + o(1)] log ℓ` and `log m = [2 + o(1)] log ℓ`, then
`S - m = [κ / 2 + o(1)] log m`. -/
theorem tendsto_sub_div_log_of_tendsto_log_div_log {S m Z : ℝ → ℝ} {κ : ℝ}
    (hS : ∀ ℓ, S ℓ = m ℓ + Real.log (Z ℓ))
    (hZ : Tendsto (fun ℓ => Real.log (Z ℓ) / Real.log ℓ) atTop (𝓝 κ))
    (hm : Tendsto (fun ℓ => Real.log (m ℓ) / Real.log ℓ) atTop (𝓝 2)) :
    Tendsto (fun ℓ => (S ℓ - m ℓ) / Real.log (m ℓ)) atTop (𝓝 (κ / 2)) := by
  refine (hZ.div hm two_ne_zero).congr' ?_
  -- For `ℓ > 1`, `log ℓ ≠ 0` cancels. If `log (m ℓ) = 0`, both sides are `0`.
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with ℓ hℓ
  rw [hS ℓ, add_sub_cancel_left]
  exact div_div_div_cancel_right₀ (Real.log_pos hℓ).ne' _ _

/-- A consequence of (5.58), for any two functions of `ℓ`. If `log Z = [κ + o(1)] log ℓ` and
`log m = [2 + o(1)] log ℓ`, then `log Z / m → 0`. The paper's (5.62) is the sharper
`log Z = O(log m)`, which is the content of `tendsto_sub_div_log_of_tendsto_log_div_log`. -/
theorem tendsto_log_div_of_tendsto_log_div_log {m Z : ℝ → ℝ} {κ : ℝ}
    (hZ : Tendsto (fun ℓ => Real.log (Z ℓ) / Real.log ℓ) atTop (𝓝 κ))
    (hm : Tendsto (fun ℓ => Real.log (m ℓ) / Real.log ℓ) atTop (𝓝 2)) :
    Tendsto (fun ℓ => Real.log (Z ℓ) / m ℓ) atTop (𝓝 0) := by
  -- `log ℓ / m ℓ → 0`: eventually `log (m ℓ) > log ℓ > 0`, so `|m ℓ| > ℓ`, and `log ℓ / ℓ → 0`.
  have hlogm : Tendsto (fun ℓ : ℝ => Real.log ℓ / m ℓ) atTop (𝓝 0) := by
    have hlogid : Tendsto (fun ℓ : ℝ => Real.log ℓ / ℓ) atTop (𝓝 0) := by
      simpa using Real.tendsto_pow_log_div_mul_add_atTop 1 0 1 one_ne_zero
    refine squeeze_zero_norm' ?_ hlogid
    filter_upwards [hm.eventually (lt_mem_nhds (one_lt_two (α := ℝ))),
      eventually_gt_atTop (1 : ℝ)] with ℓ h1 hℓ
    have hℓ0 : 0 < ℓ := zero_lt_one.trans hℓ
    have hlog : 0 < Real.log ℓ := Real.log_pos hℓ
    have hlt : Real.log ℓ < Real.log (m ℓ) := (one_lt_div hlog).mp h1
    -- `Real.log` is the logarithm of the absolute value, and `Real.log 0 = 0`.
    have hm0 : m ℓ ≠ 0 := by
      intro h0
      rw [h0, Real.log_zero] at hlt
      exact lt_asymm hlog hlt
    have habs : ℓ ≤ |m ℓ| := by
      rw [← Real.log_abs (m ℓ)] at hlt
      exact ((Real.log_lt_log_iff hℓ0 (abs_pos.mpr hm0)).mp hlt).le
    rw [Real.norm_eq_abs, abs_div, abs_of_pos hlog]
    exact div_le_div_of_nonneg_left hlog.le hℓ0 habs
  have h := hZ.mul hlogm
  rw [mul_zero] at h
  refine h.congr' ?_
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with ℓ hℓ
  exact div_mul_div_cancel₀ (Real.log_pos hℓ).ne'

section

variable (u s : ι → ℝ) [∀ ℓ : ℝ, Fintype {i // u i ≤ ℓ}]

/-- **(5.65), conditional on two limits.** If `⟨u⟩_ℓ / ℓ → q` with `q < 1`, and
`log ⟨s⟩_ℓ = [2 + o(1)] log ℓ`, then the entropy of the thermal state satisfies
`S - ⟨s⟩_ℓ = [q / (2 (1 - q)) + o(1)] log ⟨s⟩_ℓ`. -/
theorem tendsto_cutoffEntropy_sub_div_log [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {q : ℝ}
    (hq1 : q < 1) (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q))
    (hm : Tendsto (fun ℓ => Real.log (cutoffMeanArea u s ℓ) / Real.log ℓ) atTop (𝓝 2)) :
    Tendsto (fun ℓ => (cutoffEntropy u s ℓ - cutoffMeanArea u s ℓ)
      / Real.log (cutoffMeanArea u s ℓ)) atTop (𝓝 (q / (2 * (1 - q)))) := by
  have hκ : q / (2 * (1 - q)) = q / (1 - q) / 2 := by rw [div_div, mul_comm]
  rw [hκ]
  exact tendsto_sub_div_log_of_tendsto_log_div_log (cutoffEntropy_eq u s)
    (tendsto_log_cutoffZ_div_log u s hu hq1 hq) hm

/-- **(5.62), conditional on two limits.** Under the same hypotheses,
`log Z(ℓ) = [q / (2 (1 - q)) + o(1)] log ⟨s⟩_ℓ`. The paper states (5.62) as
`log Z / ⟨s⟩ = O(log ⟨s⟩ / ⟨s⟩)`, which this limit gives. By (5.50) it is the same statement as
`tendsto_cutoffEntropy_sub_div_log`. -/
theorem tendsto_log_cutoffZ_div_log_cutoffMeanArea [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {q : ℝ}
    (hq1 : q < 1) (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q))
    (hm : Tendsto (fun ℓ => Real.log (cutoffMeanArea u s ℓ) / Real.log ℓ) atTop (𝓝 2)) :
    Tendsto (fun ℓ => Real.log (cutoffZ u s ℓ) / Real.log (cutoffMeanArea u s ℓ)) atTop
      (𝓝 (q / (2 * (1 - q)))) := by
  refine (tendsto_cutoffEntropy_sub_div_log u s hu hq1 hq hm).congr fun ℓ => ?_
  rw [cutoffEntropy_eq, add_sub_cancel_left]

/-- Under the same hypotheses, `log Z(ℓ) / ⟨s⟩_ℓ → 0`: the trace is subleading to the area
term. This is weaker than (5.62); see `tendsto_log_cutoffZ_div_log_cutoffMeanArea`. -/
theorem tendsto_log_cutoffZ_div_cutoffMeanArea [Nonempty ι] (hu : ∀ i, 0 ≤ u i) {q : ℝ}
    (hq1 : q < 1) (hq : Tendsto (fun ℓ => cutoffMeanReading u s ℓ / ℓ) atTop (𝓝 q))
    (hm : Tendsto (fun ℓ => Real.log (cutoffMeanArea u s ℓ) / Real.log ℓ) atTop (𝓝 2)) :
    Tendsto (fun ℓ => Real.log (cutoffZ u s ℓ) / cutoffMeanArea u s ℓ) atTop (𝓝 0) := by
  exact tendsto_log_div_of_tendsto_log_div_log (tendsto_log_cutoffZ_div_log u s hu hq1 hq) hm

end

end QuantGrav
