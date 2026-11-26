/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Tactic.Linarith

/-!
# The inequality `1 + ∑ x ≤ ∏ (1 + x)` and its matrix form

This file is mathematics only. It uses nothing from the paper. It is lemma G1 of break attempt
B1 in `handoff.md`, Section 14.

* `one_add_sum_le_prod_one_add`: for `x i ≥ 0`, `1 + ∑ x i ≤ ∏ (1 + x i)`.
* `one_add_trace_le_det_one_add`: for a positive semidefinite real matrix `A`,
  `1 + tr A ≤ det (1 + A)`. This is the first statement applied to the eigenvalues of `A`.
-/

public section

namespace QuantGrav

/-- **G1.** For nonnegative `x i`, `1 + ∑ x i ≤ ∏ (1 + x i)`. -/
theorem one_add_sum_le_prod_one_add {ι : Type*} (s : Finset ι) (x : ι → ℝ)
    (hx : ∀ i ∈ s, 0 ≤ x i) : 1 + ∑ i ∈ s, x i ≤ ∏ i ∈ s, (1 + x i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
    have hxs : ∀ i ∈ s, 0 ≤ x i := fun i hi ↦ hx i (Finset.mem_insert_of_mem hi)
    have hxa : 0 ≤ x a := hx a (Finset.mem_insert_self a s)
    have hsum : 0 ≤ ∑ i ∈ s, x i := Finset.sum_nonneg hxs
    rw [Finset.sum_insert ha, Finset.prod_insert ha]
    linarith [mul_le_mul_of_nonneg_left (ih hxs) (add_nonneg zero_le_one hxa),
      mul_nonneg hxa hsum]

/-- **G1**, matrix form. For a positive semidefinite real matrix `A`,
`1 + tr A ≤ det (1 + A)`. -/
theorem one_add_trace_le_det_one_add {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℝ} (hA : A.PosSemidef) : 1 + A.trace ≤ (1 + A).det := by
  have hH : A.IsHermitian := hA.isHermitian
  -- The trace of `A` is the sum of its eigenvalues.
  have htr : A.trace = ∑ i, hH.eigenvalues i := by
    simpa only [RCLike.ofReal_real_eq_id, id_eq] using hH.trace_eq_sum_eigenvalues
  -- `1 + A` is unitarily similar to the diagonal matrix with entries `1 + λ i`, where `λ i` are
  -- the eigenvalues of `A`, so its determinant is the product of the `1 + λ i`.
  have hdet : (1 + A).det = ∏ i, (1 + hH.eigenvalues i) := by
    conv_lhs => rw [hH.spectral_theorem]
    rw [← map_one (Unitary.conjStarAlgAut ℝ (Matrix n n ℝ) hH.eigenvectorUnitary), ← map_add,
      Unitary.conjStarAlgAut_apply,
      Matrix.det_conj_of_mul_eq_one (Unitary.coe_mul_star_self _) (Unitary.coe_star_mul_self _),
      ← Matrix.diagonal_one, Matrix.diagonal_add, Matrix.det_diagonal]
    simp only [Function.comp_apply, RCLike.ofReal_real_eq_id, id_eq]
  rw [htr, hdet]
  exact one_add_sum_le_prod_one_add Finset.univ _ fun i _ ↦ hA.eigenvalues_nonneg i

end QuantGrav
