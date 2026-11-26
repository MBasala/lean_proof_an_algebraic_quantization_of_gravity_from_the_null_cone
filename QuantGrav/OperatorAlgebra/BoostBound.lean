module

public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.InnerProductSpace.Adjoint
public import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Linear
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.SpecialFunctions.Exponential

/-!
# The boost bound for a bounded self-adjoint generator (WP2-g)

Paper: arXiv:2611.34924v1, (5.32) with (D.22), (D.23).

The paper's step "use `|e^{ix} - 1| ≤ |x|`" is realised here for a bounded self-adjoint operator
without a spectral decomposition. For a bounded self-adjoint `A` on a complex Hilbert space, the
curve `t ↦ exp(itA) Ψ` has derivative `exp(itA) (i A Ψ)`, whose norm is `‖A Ψ‖` for every real `t`
because `exp(itA)` is unitary. The mean value inequality then bounds the displacement of `Ψ`.

* `exp_smul_mem_unitary`, `norm_exp_smul_apply`: `exp(itA)` is unitary and preserves norms.
* `hasDerivAt_exp_smul_apply`: the derivative of `t ↦ exp(itA) Ψ`.
* `norm_exp_smul_apply_sub_le`: `‖exp(iθA) Ψ - Ψ‖ ≤ |θ| ‖A Ψ‖`.
* `norm_inner_apply_sub_inner_apply_le`: expectation values of a bounded `O` in two vectors differ
  by at most `‖O‖ (‖ξ‖ + ‖ψ‖) ‖ξ - ψ‖`.
* `norm_inner_exp_apply_sub_inner_le`: for a unit vector `Ψ`, the expectation value of `O` changes
  by at most `2 ‖O‖ |θ| ‖A Ψ‖` under `Ψ ↦ exp(iθA) Ψ`.

Mapping to the paper: `A = (1 ⊗ (ŝ* − s₀)) / (2π)` on the doubled space, `θ = η`, `Ψ = Ψ_P`. For
these, `‖A Ψ_P‖² = Tr[ρ_P (ŝ − s₀)²] / (4π²)`, so the bound of
`norm_inner_exp_apply_sub_inner_le` is `(|η| / π) ‖O‖ √Tr[ρ_P (ŝ − s₀)²]`. This mapping is prose
only: the doubled space and `Ψ_P` are not defined in Lean.
-/

public section

namespace QuantGrav

open InnerProductSpace

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- For a bounded self-adjoint `A` and real `t`, the operator `exp(itA)` is unitary. -/
theorem exp_smul_mem_unitary (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) (t : ℝ) :
    NormedSpace.exp (((t : ℂ) * Complex.I) • A) ∈ unitary (H →L[ℂ] H) := by
  have h : ((t : ℂ) * Complex.I) • A ∈ skewAdjoint (H →L[ℂ] H) := by
    rw [skewAdjoint.mem_iff, star_smul, hA.star_eq, ← neg_smul]
    congr 1
    simp
  let +nondep : NormedAlgebra ℚ (H →L[ℂ] H) := .restrictScalars ℚ ℂ _
  exact NormedSpace.exp_mem_unitary_of_mem_skewAdjoint h

/-- For a bounded self-adjoint `A` and real `t`, the operator `exp(itA)` preserves norms. -/
theorem norm_exp_smul_apply (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) (t : ℝ) (v : H) :
    ‖NormedSpace.exp (((t : ℂ) * Complex.I) • A) v‖ = ‖v‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary (exp_smul_mem_unitary A hA t) v

/-- For a bounded `A`, the curve `t ↦ exp(itA) Ψ` in the real variable `t` has derivative
`exp(itA) (i A Ψ)`. -/
theorem hasDerivAt_exp_smul_apply (A : H →L[ℂ] H) (Ψ : H) (t : ℝ) :
    HasDerivAt (fun s : ℝ => NormedSpace.exp (((s : ℂ) * Complex.I) • A) Ψ)
      (NormedSpace.exp (((t : ℂ) * Complex.I) • A) (Complex.I • A Ψ)) t := by
  have h := hasDerivAt_exp_smul_const (Complex.I • A) (t : ℂ)
  have h2 := ((ContinuousLinearMap.apply ℂ H Ψ).hasFDerivAt.comp_hasDerivAt (t : ℂ) h).scomp t
    Complex.ofRealCLM.hasDerivAt
  simpa only [Function.comp_def, ContinuousLinearMap.apply_apply, smul_smul,
    mul_apply_eq_comp, smul_apply, Complex.ofRealCLM_apply,
    Complex.ofReal_one, one_smul] using h2

/-- For a bounded self-adjoint `A` and real `θ`, `‖exp(iθA) Ψ - Ψ‖ ≤ |θ| ‖A Ψ‖`. -/
theorem norm_exp_smul_apply_sub_le (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) (θ : ℝ) (Ψ : H) :
    ‖NormedSpace.exp (((θ : ℂ) * Complex.I) • A) Ψ - Ψ‖ ≤ |θ| * ‖A Ψ‖ := by
  have h := (convex_univ (𝕜 := ℝ) (E := ℝ)).norm_image_sub_le_of_norm_hasDerivWithin_le
    (f := fun s : ℝ => NormedSpace.exp (((s : ℂ) * Complex.I) • A) Ψ)
    (f' := fun s : ℝ => NormedSpace.exp (((s : ℂ) * Complex.I) • A) (Complex.I • A Ψ))
    (C := ‖A Ψ‖) (x := 0) (y := θ)
    (fun s _ => (hasDerivAt_exp_smul_apply A Ψ s).hasDerivWithinAt)
    (fun s _ => by rw [norm_exp_smul_apply A hA, norm_smul, Complex.norm_I, one_mul])
    (Set.mem_univ _) (Set.mem_univ _)
  rw [mul_comm |θ|]
  simpa only [Complex.ofReal_zero, zero_mul, zero_smul, NormedSpace.exp_zero,
    one_apply_eq_self, sub_zero, Real.norm_eq_abs] using h

omit [CompleteSpace H] in
/-- For a bounded `O` and vectors `ξ`, `ψ`:
`‖⟨ξ, O ξ⟩ - ⟨ψ, O ψ⟩‖ ≤ ‖O‖ (‖ξ‖ + ‖ψ‖) ‖ξ - ψ‖`. -/
theorem norm_inner_apply_sub_inner_apply_le (O : H →L[ℂ] H) (ξ ψ : H) :
    ‖⟪ξ, O ξ⟫_ℂ - ⟪ψ, O ψ⟫_ℂ‖ ≤ ‖O‖ * (‖ξ‖ + ‖ψ‖) * ‖ξ - ψ‖ := by
  have hsplit : ⟪ξ, O ξ⟫_ℂ - ⟪ψ, O ψ⟫_ℂ = ⟪ξ - ψ, O ξ⟫_ℂ + ⟪ψ, O (ξ - ψ)⟫_ℂ := by
    rw [inner_sub_left, map_sub, inner_sub_right]
    ring
  have h1 : ‖⟪ξ - ψ, O ξ⟫_ℂ‖ ≤ ‖ξ - ψ‖ * (‖O‖ * ‖ξ‖) :=
    (norm_inner_le_norm _ _).trans
      (mul_le_mul_of_nonneg_left (O.le_opNorm ξ) (norm_nonneg _))
  have h2 : ‖⟪ψ, O (ξ - ψ)⟫_ℂ‖ ≤ ‖ψ‖ * (‖O‖ * ‖ξ - ψ‖) :=
    (norm_inner_le_norm _ _).trans
      (mul_le_mul_of_nonneg_left (O.le_opNorm (ξ - ψ)) (norm_nonneg _))
  calc ‖⟪ξ, O ξ⟫_ℂ - ⟪ψ, O ψ⟫_ℂ‖
      = ‖⟪ξ - ψ, O ξ⟫_ℂ + ⟪ψ, O (ξ - ψ)⟫_ℂ‖ := by rw [hsplit]
    _ ≤ ‖⟪ξ - ψ, O ξ⟫_ℂ‖ + ‖⟪ψ, O (ξ - ψ)⟫_ℂ‖ := norm_add_le _ _
    _ ≤ ‖ξ - ψ‖ * (‖O‖ * ‖ξ‖) + ‖ψ‖ * (‖O‖ * ‖ξ - ψ‖) := add_le_add h1 h2
    _ = ‖O‖ * (‖ξ‖ + ‖ψ‖) * ‖ξ - ψ‖ := by ring

/-- For a bounded self-adjoint `A`, bounded `O`, real `θ` and a unit vector `Ψ`, the expectation
value of `O` changes by at most `2 ‖O‖ |θ| ‖A Ψ‖` when `Ψ` is replaced by `exp(iθA) Ψ`. -/
theorem norm_inner_exp_apply_sub_inner_le (A O : H →L[ℂ] H) (hA : IsSelfAdjoint A) (θ : ℝ)
    (Ψ : H) (hΨ : ‖Ψ‖ = 1) :
    ‖⟪NormedSpace.exp (((θ : ℂ) * Complex.I) • A) Ψ,
          O (NormedSpace.exp (((θ : ℂ) * Complex.I) • A) Ψ)⟫_ℂ - ⟪Ψ, O Ψ⟫_ℂ‖
      ≤ 2 * ‖O‖ * (|θ| * ‖A Ψ‖) := by
  have h := norm_inner_apply_sub_inner_apply_le O
    (NormedSpace.exp (((θ : ℂ) * Complex.I) • A) Ψ) Ψ
  rw [norm_exp_smul_apply A hA, hΨ] at h
  calc _ ≤ ‖O‖ * (1 + 1) * ‖NormedSpace.exp (((θ : ℂ) * Complex.I) • A) Ψ - Ψ‖ := h
    _ ≤ ‖O‖ * (1 + 1) * (|θ| * ‖A Ψ‖) :=
        mul_le_mul_of_nonneg_left (norm_exp_smul_apply_sub_le A hA θ Ψ)
          (mul_nonneg (norm_nonneg _) (by norm_num))
    _ = 2 * ‖O‖ * (|θ| * ‖A Ψ‖) := by ring

end QuantGrav
