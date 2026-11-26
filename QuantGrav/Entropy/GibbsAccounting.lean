/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
public import Mathlib.Data.Fintype.BigOperators
public import Mathlib.Data.Fintype.Card
import Mathlib.Algebra.Order.Chebyshev
import Mathlib.Analysis.Convex.SpecificFunctions.Basic

/-!
# Entropy accounting for a thermal state on a finite spectrum

Paper: arXiv:2611.34924v1, Sec 5.2 and 5.3: (5.39), (5.40), (5.50); App D.3: (D.46c), (D.49).

This file is the accounting lemma of break attempt B2 of `handoff.md`, Section 14. The paper's
density operator is `ρ_D = e^{-ŝ} / Z` on the finite-dimensional space `H_D`, with `ŝ` the area
operator in units of `4 G ħ`, and its trace is the ordinary trace on `H_D`: (5.39b), (5.50),
the sentence after (5.56), and (E.15). So in an eigenbasis of `ŝ` every statement about `ρ_D` is
a statement about finite sums.

## Notation

A finite spectrum is a finite family of states `i` with levels `s i`. Equal levels are allowed,
and each state counts once, as in the sentence after (5.56). So the number of states
`Fintype.card ι` is the paper's `d_D = dim H_D`.

* `gibbsZ s` is `∑ᵢ e^{-sᵢ}`, the paper's `Z_{D,1}` of (5.39b).
* `gibbsWeight s i` is `e^{-sᵢ} / Z`, the weight of state `i` in `ρ_D`, (5.39a).
* `gibbsMean s f` is `∑ᵢ pᵢ fᵢ`, the paper's `⟨f(ŝ)⟩`.
* `gibbsEntropy s` is `-∑ᵢ pᵢ log pᵢ`, the paper's `S(ρ_D)`.
* `levelValues s` is the set of distinct levels. In the paper these are the area eigenvalues
  `A_1, …, A_m` of (5.40), in units of `4 G ħ`. `levelFiber s x` is the set of states at level
  `x`, so its cardinality is the multiplicity `dim H_{D, A_j}`. It is written `d_j` below; the
  paper has no symbol for it.

## Results

* `gibbsEntropy_eq_mean_add_log`: (5.50), `S = ⟨s⟩ + log Z`.
* `card_eq_gibbsZ_mul_mean_exp`: (5.39c), `d_D = Z ⟨e^{s}⟩`.
* `gibbsZ_mul_exp_mean_le_card`, `gibbsEntropy_le_log_card`: `Z e^{⟨s⟩} ≤ d_D` and
  `S ≤ log d_D`. For a nonempty family `Z e^{⟨s⟩}` is `e^{S}`, by (5.50).
* `sum_card_levelFiber`, `card_levelValues_le_card`: `d_D = ∑ⱼ dⱼ`, and `m ≤ d_D`, the sentence
  before (5.40).
* `gibbsEntropy_le_log_card_levelValues_add_log`: if every level has multiplicity at most `D`,
  then `S ≤ log m + log D`.
* `gibbsZ_mul_exp_mean_le_card_levelValues_mul`: the same as a lower bound on the number of
  distinct levels, `Z e^{⟨s⟩} ≤ m D`.
* `inv_card_le_sum_sq_gibbsWeight`: `Tr ρ² ≥ 1 / d_D`.
* `sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq`: the Cauchy–Schwarz step of (D.49), in which
  `∑ₐ e^{σₐ}` stands where `d_D` stands in the previous item.

## What this does and does not say

For a nonempty family, (5.50) and the accounting lemma give `log m + log D ≥ ⟨s⟩ + log Z`
whenever every multiplicity is at most `D`. With `log Z = O(log ⟨s⟩)` from (5.62), the right
side is `⟨s⟩` to leading order. So if the multiplicities are small, the number of distinct area
eigenvalues is at least `exp(⟨s⟩ + log Z - log D)`.

The paper does not state this, and gives no eigenvalues. It also does not say that the
multiplicities are small. Its bound (D.46c), `log d(s) ≲ 1 + (s Q_*)^{3/4}`, is on the number of
graviton states at fixed area, at one loop in flat spacetime and with the corner data held
fixed, and App D.3 does not relate `d(s)` to the eigenspaces of (5.40). Nothing here decides
whether the states that carry the entropy sit at many area eigenvalues or at few.
-/

@[expose] public section

namespace QuantGrav

variable {ι : Type*} [Fintype ι]

/-- The thermal trace `Z = ∑ᵢ e^{-sᵢ}` of a finite family of levels. In the paper `sᵢ` is the
area of state `i` in units of `4 G ħ`, and this is `Z_{D,1}` of (5.39b). -/
noncomputable def gibbsZ (s : ι → ℝ) : ℝ :=
  ∑ i, Real.exp (-s i)

/-- The weight `pᵢ = e^{-sᵢ} / Z` of state `i`, the diagonal entry of `ρ_D` of (5.39a) in an
eigenbasis of the area. -/
noncomputable def gibbsWeight (s : ι → ℝ) (i : ι) : ℝ :=
  Real.exp (-s i) / gibbsZ s

/-- The thermal average `∑ᵢ pᵢ fᵢ`. -/
noncomputable def gibbsMean (s f : ι → ℝ) : ℝ :=
  ∑ i, gibbsWeight s i * f i

/-- The entropy `-∑ᵢ pᵢ log pᵢ` of the weights, the von Neumann entropy `S(ρ_D)` of (5.50) in an
eigenbasis of the area. -/
noncomputable def gibbsEntropy (s : ι → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (gibbsWeight s i)

/-- The states at level `x`. Its cardinality is the multiplicity of `x`. -/
noncomputable def levelFiber (s : ι → ℝ) (x : ℝ) : Finset ι :=
  Finset.univ.filter fun i => s i = x

/-- The distinct levels. In the paper these are the area eigenvalues `A_1, …, A_m` of (5.40), in
units of `4 G ħ`. -/
noncomputable def levelValues (s : ι → ℝ) : Finset ℝ :=
  Finset.univ.image s

/-! ### The trace and the weights -/

theorem gibbsZ_nonneg (s : ι → ℝ) : 0 ≤ gibbsZ s := by
  exact Finset.sum_nonneg fun i _ => (Real.exp_pos (-s i)).le

theorem gibbsZ_pos [Nonempty ι] (s : ι → ℝ) : 0 < gibbsZ s := by
  exact Finset.sum_pos (fun i _ => Real.exp_pos (-s i)) Finset.univ_nonempty

theorem gibbsWeight_pos (s : ι → ℝ) (i : ι) : 0 < gibbsWeight s i := by
  have : Nonempty ι := ⟨i⟩
  exact div_pos (Real.exp_pos (-s i)) (gibbsZ_pos s)

theorem gibbsWeight_mul_gibbsZ (s : ι → ℝ) (i : ι) :
    gibbsWeight s i * gibbsZ s = Real.exp (-s i) := by
  have : Nonempty ι := ⟨i⟩
  exact div_mul_cancel₀ (Real.exp (-s i)) (gibbsZ_pos s).ne'

/-- The weights sum to one: `Tr ρ_D = 1`. -/
theorem sum_gibbsWeight [Nonempty ι] (s : ι → ℝ) : ∑ i, gibbsWeight s i = 1 := by
  refine mul_right_cancel₀ (gibbsZ_pos s).ne' ?_
  rw [Finset.sum_mul, one_mul]
  exact Finset.sum_congr rfl fun i _ => gibbsWeight_mul_gibbsZ s i

/-! ### (5.50) and (5.39c) -/

/-- **(5.50).** `S(ρ_D) = ⟨s⟩ + log Z`. -/
theorem gibbsEntropy_eq_mean_add_log (s : ι → ℝ) :
    gibbsEntropy s = gibbsMean s s + Real.log (gibbsZ s) := by
  cases isEmpty_or_nonempty ι
  · simp [gibbsEntropy, gibbsMean, gibbsZ]
  · have hZ : gibbsZ s ≠ 0 := (gibbsZ_pos s).ne'
    have key : ∀ i, Real.negMulLog (gibbsWeight s i) =
        gibbsWeight s i * s i + gibbsWeight s i * Real.log (gibbsZ s) := by
      intro i
      rw [Real.negMulLog, gibbsWeight, Real.log_div (Real.exp_pos (-s i)).ne' hZ, Real.log_exp]
      ring
    rw [gibbsEntropy, gibbsMean, Finset.sum_congr rfl fun i _ => key i, Finset.sum_add_distrib,
      ← Finset.sum_mul, sum_gibbsWeight, one_mul]

/-- **(5.39c).** `d_D = Z ⟨e^{s}⟩`: the number of states is the trace times the average of
`e^{s}`. -/
theorem card_eq_gibbsZ_mul_mean_exp (s : ι → ℝ) :
    (Fintype.card ι : ℝ) = gibbsZ s * gibbsMean s fun i => Real.exp (s i) := by
  cases isEmpty_or_nonempty ι
  · simp [gibbsZ]
  · have hZ : gibbsZ s ≠ 0 := (gibbsZ_pos s).ne'
    have key : ∀ i, gibbsWeight s i * Real.exp (s i) = (gibbsZ s)⁻¹ := by
      intro i
      rw [gibbsWeight, div_mul_eq_mul_div, ← Real.exp_add, neg_add_cancel, Real.exp_zero, one_div]
    rw [gibbsMean, Finset.sum_congr rfl fun i _ => key i, Finset.sum_const, Finset.card_univ,
      nsmul_eq_mul, mul_left_comm, mul_inv_cancel₀ hZ, mul_one]

/-- `Z e^{⟨s⟩} ≤ d_D`. For a nonempty family the left side is `e^{S}`, by (5.50). This is
Jensen's inequality for the exponential applied to (5.39c). -/
theorem gibbsZ_mul_exp_mean_le_card (s : ι → ℝ) :
    gibbsZ s * Real.exp (gibbsMean s s) ≤ Fintype.card ι := by
  cases isEmpty_or_nonempty ι
  · simp [gibbsZ]
  · have hJ : Real.exp (∑ i, gibbsWeight s i • s i) ≤ ∑ i, gibbsWeight s i • Real.exp (s i) :=
      convexOn_exp.map_sum_le (fun i _ => (gibbsWeight_pos s i).le) (sum_gibbsWeight s)
        fun i _ => Set.mem_univ (s i)
    rw [card_eq_gibbsZ_mul_mean_exp s]
    exact mul_le_mul_of_nonneg_left hJ (gibbsZ_nonneg s)

/-- The entropy is at most the logarithm of the number of states: `S(ρ_D) ≤ log d_D`. -/
theorem gibbsEntropy_le_log_card (s : ι → ℝ) :
    gibbsEntropy s ≤ Real.log (Fintype.card ι) := by
  cases isEmpty_or_nonempty ι
  · simp [gibbsEntropy]
  · have hZ : 0 < gibbsZ s := gibbsZ_pos s
    have h := Real.log_le_log (mul_pos hZ (Real.exp_pos (gibbsMean s s)))
      (gibbsZ_mul_exp_mean_le_card s)
    rwa [Real.log_mul hZ.ne' (Real.exp_pos (gibbsMean s s)).ne', Real.log_exp, add_comm,
      ← gibbsEntropy_eq_mean_add_log] at h

/-! ### Distinct levels and multiplicities, (5.40) -/

/-- `d_D = ∑ⱼ dⱼ`: the number of states is the sum of the multiplicities of the distinct
levels. This is the dimension count of (5.40). -/
theorem sum_card_levelFiber (s : ι → ℝ) :
    ∑ x ∈ levelValues s, (levelFiber s x).card = Fintype.card ι := by
  rw [← Finset.card_univ]
  exact (Finset.card_eq_sum_card_image s Finset.univ).symm

/-- The sentence before (5.40): there are at most `d_D` distinct levels. -/
theorem card_levelValues_le_card (s : ι → ℝ) : (levelValues s).card ≤ Fintype.card ι := by
  rw [← Finset.card_univ]
  exact Finset.card_image_le

/-- If every level has multiplicity at most `D`, then `d_D ≤ m D`. -/
theorem card_le_card_levelValues_mul (s : ι → ℝ) {D : ℕ}
    (hD : ∀ x, (levelFiber s x).card ≤ D) :
    Fintype.card ι ≤ (levelValues s).card * D := by
  rw [mul_comm, ← Finset.card_univ]
  exact Finset.card_le_mul_card_image (f := s) Finset.univ D fun x _ => hD x

/-- **The accounting lemma of B2.** If every level has multiplicity at most `D`, the entropy is
at most `log m + log D`, where `m` is the number of distinct levels. -/
theorem gibbsEntropy_le_log_card_levelValues_add_log (s : ι → ℝ) {D : ℕ}
    (hD : ∀ x, (levelFiber s x).card ≤ D) :
    gibbsEntropy s ≤ Real.log (levelValues s).card + Real.log D := by
  cases isEmpty_or_nonempty ι
  · have h0 : gibbsEntropy s = 0 := by simp [gibbsEntropy]
    rw [h0]
    exact add_nonneg (Real.log_natCast_nonneg _) (Real.log_natCast_nonneg _)
  · have hle : Fintype.card ι ≤ (levelValues s).card * D := card_le_card_levelValues_mul s hD
    have hcard : 0 < Fintype.card ι := Fintype.card_pos
    obtain ⟨hm, hD0⟩ := Nat.mul_ne_zero_iff.mp (hcard.trans_le hle).ne'
    calc gibbsEntropy s
        ≤ Real.log (Fintype.card ι) := gibbsEntropy_le_log_card s
      _ ≤ Real.log ((levelValues s).card * D) :=
        Real.log_le_log (Nat.cast_pos.mpr hcard) (mod_cast hle)
      _ = Real.log (levelValues s).card + Real.log D :=
        Real.log_mul (Nat.cast_ne_zero.mpr hm) (Nat.cast_ne_zero.mpr hD0)

/-- The accounting lemma as a lower bound on the number of distinct levels:
`Z e^{⟨s⟩} ≤ m D`. For a nonempty family the left side is `e^{S}`, by (5.50). -/
theorem gibbsZ_mul_exp_mean_le_card_levelValues_mul (s : ι → ℝ) {D : ℕ}
    (hD : ∀ x, (levelFiber s x).card ≤ D) :
    gibbsZ s * Real.exp (gibbsMean s s) ≤ (levelValues s).card * D := by
  calc gibbsZ s * Real.exp (gibbsMean s s)
      ≤ (Fintype.card ι : ℝ) := gibbsZ_mul_exp_mean_le_card s
    _ ≤ (levelValues s).card * D := mod_cast card_le_card_levelValues_mul s hD

/-! ### Second moments: (D.49) -/

/-- `Tr ρ_D² ≥ 1 / d_D`, for the ordinary trace. -/
theorem inv_card_le_sum_sq_gibbsWeight [Nonempty ι] (s : ι → ℝ) :
    (Fintype.card ι : ℝ)⁻¹ ≤ ∑ i, gibbsWeight s i ^ 2 := by
  have hcard : (0 : ℝ) < Fintype.card ι := Nat.cast_pos.mpr Fintype.card_pos
  have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := gibbsWeight s)
  rw [sum_gibbsWeight, one_pow, Finset.card_univ] at h
  exact (inv_le_iff_one_le_mul₀' hcard).mpr h

/-- **The Cauchy–Schwarz step of (D.49).** For weights `kₐ` and areas `σₐ`,
`(∑ₐ kₐ)² ≤ (∑ₐ e^{σₐ}) (∑ₐ e^{-σₐ} kₐ²)`. The paper's (D.48) writes `Z_1` and `Z_{2,cyc}` as
integrals over `s` of sums over `a = 1, …, d(s)`. With one finite sum over labels in their
place, `Z_1 = ∑ₐ kₐ` and `Z_{2,cyc} = ∑ₐ e^{-σₐ} kₐ²`, this is
`Z_{2,cyc} / Z_1² ≥ 1 / ∑ₐ e^{σₐ}`, and the paper's denominator is `∫ ds e^{s} d(s)`. The sum
`∑ₐ e^{σₐ}` stands where the number of states stands in `inv_card_le_sum_sq_gibbsWeight`. The
paper's `kₐ ≥ 0` is not needed. -/
theorem sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq {κ : Type*} (t : Finset κ) (σ k : κ → ℝ) :
    (∑ a ∈ t, k a) ^ 2 ≤ (∑ a ∈ t, Real.exp (σ a)) * ∑ a ∈ t, Real.exp (-σ a) * k a ^ 2 := by
  have h := Finset.sum_mul_sq_le_sq_mul_sq t (fun a => Real.exp (σ a / 2))
    fun a => Real.exp (-σ a / 2) * k a
  have h1 : ∀ a, Real.exp (σ a / 2) * (Real.exp (-σ a / 2) * k a) = k a := by
    intro a
    rw [← mul_assoc, ← Real.exp_add, neg_div, add_neg_cancel, Real.exp_zero, one_mul]
  have h2 : ∀ a, Real.exp (σ a / 2) ^ 2 = Real.exp (σ a) := by
    intro a
    rw [sq, ← Real.exp_add, add_halves]
  have h3 : ∀ a, (Real.exp (-σ a / 2) * k a) ^ 2 = Real.exp (-σ a) * k a ^ 2 := by
    intro a
    rw [mul_pow, sq (Real.exp (-σ a / 2)), ← Real.exp_add, add_halves]
  simpa only [h1, h2, h3] using h

end QuantGrav
