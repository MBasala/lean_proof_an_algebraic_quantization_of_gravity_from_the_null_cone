/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Algebra.Order.Archimedean.Real.Basic
public import Mathlib.Data.Fintype.BigOperators
public import Mathlib.Data.Set.Card
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Counting occupation numbers under a cost bound

Paper: arXiv:2611.34924v1, App D.3, the sentence before (D.45): at fixed `s` the count `d(s)`
includes only states whose graviton occupation numbers `n_i` satisfy `∑ᵢ n_i ν_i ≤ Q_*`.

This file is statement L1 of break attempt B5 in `handoff.md`, Section 14.7. For finitely many
modes, each with a cost per quantum of at least `ν_min > 0`, only finitely many occupation
vectors have total cost at most `Q`, and for `Q ≥ 0` there are at most `(1 + Q / ν_min)^M` of
them for `M` modes. A sign condition on `Q` is needed: with one mode and `Q < -ν_min` the
bound is negative while the count is zero. The bound counts a box and is not sharp.

The paper's (D.45), (D.46) bound the same count for infinitely many modes, using a bound on the
number of modes of small cost. That is register entry H10 and is not treated here.
-/

public section

namespace QuantGrav

variable {ι : Type*} [Fintype ι]

/-- If the occupation vector `n` has total cost at most `Q`, then each occupation number `n i`
is at most `⌊Q / ν_min⌋₊`. -/
private theorem le_floor_of_sum_mul_le {ν : ι → ℝ} {νmin : ℝ} (hmin : 0 < νmin)
    (hν : ∀ i, νmin ≤ ν i) {Q : ℝ} {n : ι → ℕ} (hn : ∑ i, (n i : ℝ) * ν i ≤ Q) (i : ι) :
    n i ≤ ⌊Q / νmin⌋₊ := by
  refine Nat.le_floor ((le_div_iff₀ hmin).2 ?_)
  calc (n i : ℝ) * νmin
      ≤ (n i : ℝ) * ν i := mul_le_mul_of_nonneg_left (hν i) (Nat.cast_nonneg _)
    _ ≤ ∑ j, (n j : ℝ) * ν j :=
        Finset.single_le_sum (f := fun j ↦ (n j : ℝ) * ν j)
          (fun j _ ↦ mul_nonneg (Nat.cast_nonneg _) (hmin.le.trans (hν j))) (Finset.mem_univ i)
    _ ≤ Q := hn

/-- The occupation vectors of total cost at most `Q` lie in the box of vectors with every entry
in `{0, …, ⌊Q / ν_min⌋₊}`. -/
private theorem setOf_sum_mul_le_subset_piFinset [DecidableEq ι] (ν : ι → ℝ) {νmin : ℝ}
    (hmin : 0 < νmin) (hν : ∀ i, νmin ≤ ν i) (Q : ℝ) :
    {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q} ⊆
      ↑(Fintype.piFinset fun _ : ι ↦ Finset.range (⌊Q / νmin⌋₊ + 1)) :=
  fun _ hn ↦ Finset.mem_coe.2 <| Fintype.mem_piFinset.2 fun i ↦
    Finset.mem_range.2 <| Nat.lt_add_one_of_le <| le_floor_of_sum_mul_le hmin hν hn i

/-- **L1, finiteness.** For finitely many modes with costs `ν i ≥ ν_min > 0`, only finitely many
occupation vectors `n` have total cost `∑ᵢ n_i ν_i` at most `Q`. -/
theorem finite_setOf_sum_mul_le (ν : ι → ℝ) {νmin : ℝ} (hmin : 0 < νmin)
    (hν : ∀ i, νmin ≤ ν i) (Q : ℝ) :
    {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q}.Finite := by
  classical
  exact (Finset.finite_toSet _).subset (setOf_sum_mul_le_subset_piFinset ν hmin hν Q)

/-- **L1, the count.** For `M` modes with costs `ν i ≥ ν_min > 0` and `Q ≥ 0`, at most
`(1 + Q / ν_min)^M` occupation vectors have total cost at most `Q`. The set is finite by
`finite_setOf_sum_mul_le`, so `Set.ncard` is its number of elements. -/
theorem ncard_setOf_sum_mul_le (ν : ι → ℝ) {νmin Q : ℝ} (hmin : 0 < νmin)
    (hν : ∀ i, νmin ≤ ν i) (hQ : 0 ≤ Q) :
    ((Set.ncard {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q} : ℕ) : ℝ)
      ≤ (1 + Q / νmin) ^ Fintype.card ι := by
  classical
  -- The set lies in a box with `⌊Q / ν_min⌋₊ + 1` values for each of the `M` entries.
  have hcard : Set.ncard {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q}
      ≤ (⌊Q / νmin⌋₊ + 1) ^ Fintype.card ι := by
    calc Set.ncard {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q}
        ≤ Set.ncard
            (↑(Fintype.piFinset fun _ : ι ↦ Finset.range (⌊Q / νmin⌋₊ + 1)) : Set (ι → ℕ)) :=
          Set.ncard_le_ncard (setOf_sum_mul_le_subset_piFinset ν hmin hν Q)
            (Finset.finite_toSet _)
      _ = (⌊Q / νmin⌋₊ + 1) ^ Fintype.card ι := by
          rw [Set.ncard_coe_finset, Fintype.card_piFinset, Finset.prod_const, Finset.card_range,
            Finset.card_univ]
  calc ((Set.ncard {n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q} : ℕ) : ℝ)
      ≤ (((⌊Q / νmin⌋₊ + 1) ^ Fintype.card ι : ℕ) : ℝ) := Nat.cast_le.2 hcard
    _ = (1 + (⌊Q / νmin⌋₊ : ℝ)) ^ Fintype.card ι := by
        rw [Nat.cast_pow, Nat.cast_add, Nat.cast_one, add_comm]
    _ ≤ (1 + Q / νmin) ^ Fintype.card ι :=
        pow_le_pow_left₀ (add_nonneg zero_le_one (Nat.cast_nonneg _))
          (add_le_add le_rfl (Nat.floor_le (div_nonneg hQ hmin.le))) _

end QuantGrav
