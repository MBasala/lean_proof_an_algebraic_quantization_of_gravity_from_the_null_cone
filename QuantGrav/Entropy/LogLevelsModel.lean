/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Entropy.BandCounting
public import Mathlib.NumberTheory.Harmonic.Defs
public import Mathlib.Algebra.Order.Floor.Defs
import Mathlib.NumberTheory.Harmonic.Bounds

/-!
# A spectrum with one state per level that satisfies footnote 24

Paper: arXiv:2611.34924v1, Sec 5.3: (5.50), (5.62), footnote 24 with (5.63), (5.64);
App D.3: (D.46c).

This file is the consistency model of break attempt B2 of `handoff.md`, Section 14. The
suspected tension was this. Footnote 24 says that about `e^{s}` orthogonal states lie below area
`s`, while (D.46c) bounds the number of graviton states at fixed area by
`exp[C (1 + (s Q_*)^{3/4})]`. With the ordinary trace the first count can only come from the
number of distinct area eigenvalues. Is that compatible with the paper's other statements about
the trace?

It is. The model is the spectrum `log 1, log 2, …, log (N + 1)`: one state per level, so every
multiplicity is one. Its largest level is `σ = log (N + 1)`, in the role of the paper's `s_*`.

## Results

* `gibbsZ_logLevels`: the trace is the harmonic number `H_{N+1}`, so
  `log (N + 2) ≤ Z ≤ 1 + σ` (`log_le_gibbsZ_logLevels`, `gibbsZ_logLevels_le`). In particular
  `log Z = o(σ)` (`tendsto_log_gibbsZ_logLevels_div`), as in (5.62).
* `card_levelFiber_logLevels_le_one`: every level has multiplicity at most one.
* `card_levelsBelow_logLevels`: exactly `min (N + 1) ⌊e^{c}⌋` states have level at most `c`.
* `exists_le_gibbsProb_levelBand_logLevels`: every band `((a - δ) σ, a σ]` with `0 < δ < a ≤ 1`
  has probability bounded below by a positive constant eventually. This is the property the
  paper draws from (5.63).
* `tendsto_log_card_levelsBelow_logLevels`, `tendsto_log_card_image_levelsBelow_logLevels`:
  hence `log N(a σ) / σ → a`, which is (5.64), and the same for the number of distinct levels.

## What this does and does not say

This is a model of the accounting only. It has no geometry, no clock and no gravitons. It shows
that an ordinary trace with weights `e^{-sᵢ}`, `log Z = o(s_*)`, multiplicity one, bands of
positive probability, and the count (5.64) are compatible. So the statements of footnote 24 do
not contradict a bound on the multiplicities such as (D.46c). In the model the number of levels
at most `c` is `⌊e^{c}⌋`. That a count of this size is forced when the multiplicities are small
is `tendsto_log_card_image_levelsBelow_div` in `BandCounting.lean`, not a result of this file.

Only a lower bound on the band probabilities is proved here. Their limits were checked
numerically and are not proved: the probability of `sᵢ ≤ a σ` tends to `a`, which is (5.63) with
exponent one, where the paper's exponent is `q / (2 (1 - q))`. Whether the area operator of the
paper has a spectrum of this kind is not addressed here or in the paper.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology

/-- The levels `log 1, log 2, …, log (N + 1)`: state `k` has level `log (k + 1)`. -/
noncomputable def logLevels (N : ℕ) : Fin (N + 1) → ℝ :=
  fun k => Real.log ((k : ℕ) + 1)

theorem logLevels_nonneg (N : ℕ) (k : Fin (N + 1)) : 0 ≤ logLevels N k := by
  have h : (0 : ℝ) ≤ (k : ℕ) := Nat.cast_nonneg _
  exact Real.log_nonneg (by linarith)

/-- Every level is at most `σ = log (N + 1)`. -/
theorem logLevels_le (N : ℕ) (k : Fin (N + 1)) : logLevels N k ≤ Real.log (N + 1) := by
  have h : ((k : ℕ) : ℝ) ≤ N := Nat.cast_le.mpr k.is_le
  exact Real.log_le_log (by positivity) (by linarith)

theorem logLevels_injective (N : ℕ) : Function.Injective (logLevels N) := by
  intro j k h
  have hj : (0 : ℝ) < (j : ℕ) + 1 := by positivity
  have hk : (0 : ℝ) < (k : ℕ) + 1 := by positivity
  have h' : ((j : ℕ) : ℝ) + 1 = (k : ℕ) + 1 := Real.log_injOn_pos hj hk h
  exact Fin.ext (Nat.cast_injective (R := ℝ) (add_right_cancel h'))

/-- Every level has multiplicity at most one. -/
theorem card_levelFiber_logLevels_le_one (N : ℕ) (x : ℝ) :
    (levelFiber (logLevels N) x).card ≤ 1 := by
  refine Finset.card_le_one.mpr fun j hj k hk => logLevels_injective N ?_
  rw [levelFiber, Finset.mem_filter] at hj hk
  exact hj.2.trans hk.2.symm

/-- The weight of state `k` in the trace is `1 / (k + 1)`. -/
private theorem exp_neg_logLevels (N : ℕ) (k : Fin (N + 1)) :
    Real.exp (-logLevels N k) = (((k : ℕ) : ℝ) + 1)⁻¹ := by
  rw [logLevels, Real.exp_neg, Real.exp_log (by positivity)]

/-- The harmonic number as a sum of real reciprocals. -/
private theorem cast_harmonic (n : ℕ) :
    (harmonic n : ℝ) = ∑ i ∈ Finset.range n, ((i : ℝ) + 1)⁻¹ := by
  simp [harmonic]

/-- The trace is the harmonic number `H_{N+1} = 1 + 1/2 + … + 1/(N + 1)`. -/
theorem gibbsZ_logLevels (N : ℕ) : gibbsZ (logLevels N) = (harmonic (N + 1) : ℝ) := by
  rw [cast_harmonic, ← Fin.sum_univ_eq_sum_range (fun i => ((i : ℝ) + 1)⁻¹) (N + 1), gibbsZ]
  exact Finset.sum_congr rfl fun k _ => exp_neg_logLevels N k

theorem gibbsZ_logLevels_le (N : ℕ) : gibbsZ (logLevels N) ≤ 1 + Real.log (N + 1) := by
  rw [gibbsZ_logLevels]
  exact_mod_cast harmonic_le_one_add_log (N + 1)

theorem log_le_gibbsZ_logLevels (N : ℕ) : Real.log (N + 2) ≤ gibbsZ (logLevels N) := by
  rw [gibbsZ_logLevels]
  have h := log_add_one_le_harmonic (N + 1)
  have e : ((N + 1 + 1 : ℕ) : ℝ) = (N : ℝ) + 2 := by push_cast; ring
  rwa [e] at h

/-- State `k` has level at most `c` exactly when `k + 1 ≤ ⌊e^{c}⌋`. -/
private theorem logLevels_le_iff (N : ℕ) (k : Fin (N + 1)) (c : ℝ) :
    logLevels N k ≤ c ↔ (k : ℕ) < ⌊Real.exp c⌋₊ := by
  rw [logLevels, Real.log_le_iff_le_exp (by positivity), ← Nat.add_one_le_iff,
    Nat.le_floor_iff (Real.exp_pos c).le, Nat.cast_add_one]

/-- State `k` has level above `b` exactly when `⌊e^{b}⌋ < k + 1`. -/
private theorem lt_logLevels_iff (N : ℕ) (k : Fin (N + 1)) (b : ℝ) :
    b < logLevels N k ↔ ⌊Real.exp b⌋₊ ≤ (k : ℕ) := by
  rw [logLevels, Real.lt_log_iff_exp_lt (by positivity), ← Nat.lt_add_one_iff,
    Nat.floor_lt (Real.exp_pos b).le, Nat.cast_add_one]

/-- Exactly `min (N + 1) ⌊e^{c}⌋` states have level at most `c`: the number of states below a
level grows like its exponential. -/
theorem card_levelsBelow_logLevels (N : ℕ) (c : ℝ) :
    (levelsBelow (logLevels N) c).card = min (N + 1) ⌊Real.exp c⌋₊ := by
  have h : levelsBelow (logLevels N) c
      = Finset.univ.filter fun k : Fin (N + 1) => (k : ℕ) < ⌊Real.exp c⌋₊ := by
    ext k
    simp only [levelsBelow, Finset.mem_filter, Finset.mem_univ, true_and, logLevels_le_iff]
  rw [h, Fin.card_filter_val_lt]

/-- The scale `σ = log (N + 1)` is nonnegative. -/
private theorem log_natCast_add_one_nonneg (N : ℕ) : 0 ≤ Real.log ((N : ℝ) + 1) :=
  Real.log_nonneg (by linarith [Nat.cast_nonneg (α := ℝ) N])

/-- The scale `σ = log (N + 1)` tends to infinity. -/
private theorem tendsto_log_natCast_add_one :
    Tendsto (fun N : ℕ => Real.log ((N : ℝ) + 1)) atTop atTop :=
  Real.tendsto_log_atTop.comp (tendsto_atTop_add_const_right atTop 1 tendsto_natCast_atTop_atTop)

/-- The trace is at least one, the weight of the state at level `log 1 = 0`. -/
private theorem one_le_gibbsZ_logLevels (N : ℕ) : 1 ≤ gibbsZ (logLevels N) := by
  have h : Real.exp (-logLevels N 0) ≤ gibbsZ (logLevels N) :=
    Finset.single_le_sum (f := fun k => Real.exp (-logLevels N k))
      (fun k _ => (Real.exp_pos _).le) (Finset.mem_univ 0)
  rwa [exp_neg_logLevels, Fin.val_zero, Nat.cast_zero, zero_add, inv_one] at h

/-- `log Z = o(σ)`, as in (5.62). -/
theorem tendsto_log_gibbsZ_logLevels_div :
    Tendsto (fun N : ℕ => Real.log (gibbsZ (logLevels N)) / Real.log (N + 1)) atTop (𝓝 0) := by
  have hσ : Tendsto (fun N : ℕ => 1 + Real.log ((N : ℝ) + 1)) atTop atTop :=
    tendsto_atTop_add_const_left atTop 1 tendsto_log_natCast_add_one
  have hlim : Tendsto
      (fun N : ℕ => Real.log (1 + Real.log ((N : ℝ) + 1)) / Real.log ((N : ℝ) + 1))
      atTop (𝓝 0) := by
    refine ((Real.tendsto_pow_log_div_mul_add_atTop 1 (-1) 1 one_ne_zero).comp hσ).congr
      fun N => ?_
    simp only [Function.comp_apply, pow_one, one_mul, add_neg_cancel_comm]
  refine squeeze_zero (fun N => ?_) (fun N => ?_) hlim
  · exact div_nonneg (Real.log_nonneg (one_le_gibbsZ_logLevels N))
      (log_natCast_add_one_nonneg N)
  · exact div_le_div_of_nonneg_right
      (Real.log_le_log (zero_lt_one.trans_le (one_le_gibbsZ_logLevels N))
        (gibbsZ_logLevels_le N))
      (log_natCast_add_one_nonneg N)

/-- The trace weight of the band `(b, c]` is `H_{⌊e^{c}⌋} - H_{⌊e^{b}⌋}`, written as a sum, when
`c` is at most the largest level. -/
private theorem sum_levelBand_logLevels (N : ℕ) (b : ℝ) {c : ℝ} (hc : c ≤ Real.log (N + 1)) :
    ∑ k ∈ levelBand (logLevels N) b c, Real.exp (-logLevels N k)
      = ∑ j ∈ Finset.Ico ⌊Real.exp b⌋₊ ⌊Real.exp c⌋₊, ((j : ℝ) + 1)⁻¹ := by
  have hM : ⌊Real.exp c⌋₊ ≤ N + 1 := by
    refine Nat.floor_le_of_le ?_
    have h1 : Real.exp c ≤ Real.exp (Real.log ((N : ℝ) + 1)) := Real.exp_le_exp.mpr hc
    rwa [Real.exp_log (by positivity), ← Nat.cast_add_one] at h1
  have hmap : (levelBand (logLevels N) b c).map Fin.valEmbedding
      = Finset.Ico ⌊Real.exp b⌋₊ ⌊Real.exp c⌋₊ := by
    ext j
    simp only [Finset.mem_map, levelBand, Finset.mem_filter, Finset.mem_univ, true_and,
      lt_logLevels_iff, logLevels_le_iff, Fin.valEmbedding_apply, Finset.mem_Ico]
    constructor
    · rintro ⟨k, hk, rfl⟩
      exact hk
    · intro hj
      exact ⟨⟨j, by omega⟩, hj, rfl⟩
  rw [← hmap, Finset.sum_map]
  exact Finset.sum_congr rfl fun k _ => exp_neg_logLevels N k

/-- The trace weight of the band `(b, c]` is at least `c - b - 1`, by the two bounds on the
harmonic numbers. -/
private theorem sub_sub_one_le_sum_levelBand_logLevels (N : ℕ) {b c : ℝ} (hb : 0 ≤ b)
    (hbc : b ≤ c) (hc : c ≤ Real.log (N + 1)) :
    c - b - 1 ≤ ∑ k ∈ levelBand (logLevels N) b c, Real.exp (-logLevels N k) := by
  rw [sum_levelBand_logLevels N b hc,
    Finset.sum_Ico_eq_sub _ (Nat.floor_le_floor (Real.exp_le_exp.mpr hbc)),
    ← cast_harmonic, ← cast_harmonic]
  have h1 := log_le_harmonic_floor (Real.exp c) (Real.exp_pos c).le
  have h2 := harmonic_floor_le_one_add_log (Real.exp b) (Real.one_le_exp hb)
  rw [Real.log_exp] at h1 h2
  linarith

/-- The band `((a - δ) σ, a σ]` has probability at least `δ / 2` once `σ ≥ (2 + δ) / δ`. -/
private theorem half_le_gibbsProb_levelBand_logLevels {a δ : ℝ} (hδ : 0 < δ) (hδa : δ < a)
    (ha : a ≤ 1) (N : ℕ) (hN : (2 + δ) / δ ≤ Real.log (N + 1)) :
    δ / 2 ≤ gibbsProb (logLevels N)
      (levelBand (logLevels N) ((a - δ) * Real.log (N + 1)) (a * Real.log (N + 1))) := by
  have hσ0 : 0 ≤ Real.log ((N : ℝ) + 1) := log_natCast_add_one_nonneg N
  have hsum := sub_sub_one_le_sum_levelBand_logLevels N
    (mul_nonneg (sub_pos.mpr hδa).le hσ0)
    (mul_le_mul_of_nonneg_right (sub_le_self a hδ.le) hσ0)
    (mul_le_of_le_one_left hσ0 ha)
  rw [← gibbsProb_mul_gibbsZ] at hsum
  have hZ := gibbsZ_logLevels_le N
  have hP := gibbsProb_nonneg (logLevels N)
    (levelBand (logLevels N) ((a - δ) * Real.log (N + 1)) (a * Real.log (N + 1)))
  have hN' : 2 + δ ≤ Real.log ((N : ℝ) + 1) * δ := (div_le_iff₀ hδ).mp hN
  have h1 := mul_le_mul_of_nonneg_left hZ hP
  by_contra hlt
  have h2 := mul_lt_mul_of_pos_right (not_le.mp hlt)
    (show (0 : ℝ) < 1 + Real.log ((N : ℝ) + 1) by linarith)
  linarith

/-- Every band `((a - δ) σ, a σ]` with `0 < δ < a ≤ 1` has probability bounded below by a
positive constant for all large `N`. This is what (5.63) provides in the paper. -/
theorem exists_le_gibbsProb_levelBand_logLevels {a δ : ℝ} (hδ : 0 < δ) (hδa : δ < a)
    (ha : a ≤ 1) :
    ∃ p, 0 < p ∧ ∀ᶠ N : ℕ in atTop,
      p ≤ gibbsProb (logLevels N)
        (levelBand (logLevels N) ((a - δ) * Real.log (N + 1)) (a * Real.log (N + 1))) := by
  refine ⟨δ / 2, half_pos hδ, ?_⟩
  filter_upwards [tendsto_log_natCast_add_one.eventually_ge_atTop ((2 + δ) / δ)] with N hN
  exact half_le_gibbsProb_levelBand_logLevels hδ hδa ha N hN

/-- **(5.64) in the model.** The number of states with level at most `a σ` is
`exp[a σ + o(σ)]`, for `0 < a ≤ 1`. -/
theorem tendsto_log_card_levelsBelow_logLevels {a : ℝ} (ha : 0 < a) (ha1 : a ≤ 1) :
    Tendsto (fun N : ℕ =>
      Real.log ((levelsBelow (logLevels N) (a * Real.log (N + 1))).card) / Real.log (N + 1))
      atTop (𝓝 a) := by
  refine tendsto_log_card_levelsBelow_div (fun N => logLevels N)
    (fun N : ℕ => Real.log (N + 1)) ha tendsto_log_natCast_add_one
    tendsto_log_gibbsZ_logLevels_div fun δ hδ hδa => ?_
  exact exists_le_gibbsProb_levelBand_logLevels hδ hδa ha1

/-- The same count for the distinct levels: all of the `exp[a σ + o(σ)]` states below `a σ` are
at different levels. -/
theorem tendsto_log_card_image_levelsBelow_logLevels {a : ℝ} (ha : 0 < a) (ha1 : a ≤ 1) :
    Tendsto (fun N : ℕ =>
      Real.log (((levelsBelow (logLevels N) (a * Real.log (N + 1))).image (logLevels N)).card)
        / Real.log (N + 1))
      atTop (𝓝 a) := by
  refine tendsto_log_card_image_levelsBelow_div (fun N => logLevels N)
    (fun N : ℕ => Real.log (N + 1)) ha tendsto_log_natCast_add_one
    tendsto_log_gibbsZ_logLevels_div
    (fun δ hδ hδa => exists_le_gibbsProb_levelBand_logLevels hδ hδa ha1)
    (fun _ => 1) (fun N x _ => card_levelFiber_logLevels_le_one N x) ?_
  simp

end QuantGrav
