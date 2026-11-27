/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.Calculus.FDeriv.Defs
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.Calculus.FDeriv.Linear
import Mathlib.Analysis.LocallyConvex.SeparatingDual

/-!
# The Poisson bracket of a constant Poisson tensor, for linear functions

This file is the optional Lean item of break attempt B6 in `handoff.md`, Section 14.8: the
finite-dimensional core of the two steps left open by finding F14 of `FIDELITY.md`.

On a real normed space `E`, a constant Poisson tensor is a bilinear form `P` on the dual, and
the bracket of two functions is `{F, G}(x) = P(dF(x), dG(x))`. With a constant symplectic form
this is the pairing of the gradients by the inverse of the form; no symplectic form appears in
this file, only `P`. Linear means continuous linear throughout.

* `constPoissonBracket_linear`: the bracket of two linear functions is the constant `P ℓ m`.
* `constPoissonBracket_comp_eq_zero`, `constPoissonBracket_pi_comp_eq_zero`: a linear function
  whose bracket with each of a family of linear functions vanishes has vanishing bracket with
  every differentiable function of them.
* `forall_comp_eq_zero_iff_apply_eq_zero`, `comp_add_smul_of_apply_eq_zero`: if the bracket with
  `ℓ` is the derivative along a vector `v`, the condition says that the linear functions vanish
  on `v`, and then every function of them is unchanged by the translations `x ↦ x + t v`.
* `constPoissonBracket_eq_fderiv_apply`, `hasDerivAt_comp_add_smul`: those translations are the
  flow of `ℓ`, in the sense that along them the derivative of a differentiable function is its
  bracket with `ℓ`.

Every statement has `ℓ` in the first slot of the bracket. For the other order apply them to
`P.flip`, or use antisymmetry of `P` where it holds.

What this does and does not cover. It applies to a phase space with coordinates in which the
symplectic form is constant, and to a function `ℓ` that is linear in those coordinates. For the
paper, whether the smeared area density is such a function, and whether the ingredients of the
clock are functions of coordinates that Poisson-commute with it, is the subject of B6 and is not
decided here. The quantum counterpart, that conjugation by a Weyl operator translates Weyl
symbols, is not formalized.
-/

@[expose] public section

namespace QuantGrav

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F' : Type*} [NormedAddCommGroup F'] [NormedSpace ℝ F']

/-- The Poisson bracket of two functions for a constant Poisson tensor `P`, a bilinear form on
the dual of `E`: `{F, G}(x) = P(dF(x), dG(x))`. Antisymmetry, continuity and nondegeneracy of
`P` are not required. Where a function is not differentiable its derivative is zero by Mathlib's
convention, so the bracket is zero there. -/
noncomputable def constPoissonBracket (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ)
    (F G : E → ℝ) (x : E) : ℝ :=
  P (fderiv ℝ F x) (fderiv ℝ G x)

/-- The bracket of two linear functions is the pairing of their gradients, at every point. -/
theorem constPoissonBracket_linear (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ)
    (ℓ m : E →L[ℝ] ℝ) (x : E) : constPoissonBracket P ℓ m x = P ℓ m := by
  rw [constPoissonBracket, ContinuousLinearMap.fderiv, ContinuousLinearMap.fderiv]

/-- A linear function `ℓ` whose bracket with every linear function of `M y` vanishes has
vanishing bracket with every differentiable function of `M y`. -/
theorem constPoissonBracket_comp_eq_zero (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ)
    (ℓ : E →L[ℝ] ℝ) (M : E →L[ℝ] F') (hM : ∀ L : F' →L[ℝ] ℝ, P ℓ (L.comp M) = 0)
    {g : F' → ℝ} {x : E} (hg : DifferentiableAt ℝ g (M x)) :
    constPoissonBracket P ℓ (fun y => g (M y)) x = 0 := by
  -- The chain rule: the derivative of `y ↦ g (M y)` at `x` is `dg(M x) ∘ M`.
  have h : fderiv ℝ (fun y => g (M y)) x = (fderiv ℝ g (M x)).comp M :=
    (hg.hasFDerivAt.comp x M.hasFDerivAt).fderiv
  rw [constPoissonBracket, h, ContinuousLinearMap.fderiv]
  exact hM _

/-- The same for finitely many linear functions `m k`: if `{ℓ, m k} = 0` for every `k`, then
`{ℓ, g(m_1, …, m_r)} = 0` for every differentiable `g`. -/
theorem constPoissonBracket_pi_comp_eq_zero {κ : Type*} [Finite κ]
    (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ) (ℓ : E →L[ℝ] ℝ) (m : κ → E →L[ℝ] ℝ)
    (hm : ∀ k, P ℓ (m k) = 0) {g : (κ → ℝ) → ℝ} {x : E}
    (hg : DifferentiableAt ℝ g fun k => m k x) :
    constPoissonBracket P ℓ (fun y => g fun k => m k y) x = 0 := by
  cases nonempty_fintype κ
  classical
  refine constPoissonBracket_comp_eq_zero P ℓ (ContinuousLinearMap.pi m) (fun L => ?_) hg
  -- A linear function `L` of the `m k` is their combination with the coefficients `L e_k`.
  have hL : L.comp (ContinuousLinearMap.pi m) = ∑ k, L (Pi.single k 1) • m k := by
    ext y
    have hy : (fun k => m k y) = ∑ k, m k y • Pi.single (M := fun _ => ℝ) k 1 :=
      pi_eq_sum_univ' _
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.coe_pi', sum_apply,
      smul_apply, smul_eq_mul]
    rw [hy, map_sum]
    exact Finset.sum_congr rfl fun k _ => by rw [map_smul, smul_eq_mul, mul_comm]
  rw [hL, map_sum]
  exact Finset.sum_eq_zero fun k _ => by rw [map_smul, hm, smul_zero]

/-- If the bracket with `ℓ` is the derivative along the vector `v`, then `ℓ` has vanishing
bracket with every linear function of `M y` exactly when `M v = 0`. -/
theorem forall_comp_eq_zero_iff_apply_eq_zero
    (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ) (ℓ : E →L[ℝ] ℝ) (v : E)
    (hP : ∀ α : E →L[ℝ] ℝ, P ℓ α = α v) (M : E →L[ℝ] F') :
    (∀ L : F' →L[ℝ] ℝ, P ℓ (L.comp M) = 0) ↔ M v = 0 := by
  simp only [hP, ContinuousLinearMap.comp_apply]
  -- Hahn–Banach: a vector on which every continuous linear functional vanishes is zero.
  exact (SeparatingDual.eq_zero_iff_forall_dual_eq_zero (R := ℝ) (M v)).symm

/-- If the bracket with `ℓ` is the derivative along the vector `v`, then `{ℓ, G}(x)` is the
derivative of `G` at `x` in the direction `v`, for every function `G`. -/
theorem constPoissonBracket_eq_fderiv_apply
    (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ) (ℓ : E →L[ℝ] ℝ) (v : E)
    (hP : ∀ α : E →L[ℝ] ℝ, P ℓ α = α v) (G : E → ℝ) (x : E) :
    constPoissonBracket P ℓ G x = fderiv ℝ G x v := by
  rw [constPoissonBracket, ContinuousLinearMap.fderiv, hP]

/-- If the bracket with `ℓ` is the derivative along the vector `v`, the translations
`t ↦ x + t v` are the flow of `ℓ`: along them the derivative of a differentiable `G` is the
bracket `{ℓ, G}`. -/
theorem hasDerivAt_comp_add_smul
    (P : (E →L[ℝ] ℝ) →ₗ[ℝ] (E →L[ℝ] ℝ) →ₗ[ℝ] ℝ) (ℓ : E →L[ℝ] ℝ) (v : E)
    (hP : ∀ α : E →L[ℝ] ℝ, P ℓ α = α v) {G : E → ℝ} (x : E) (t : ℝ)
    (hG : DifferentiableAt ℝ G (x + t • v)) :
    HasDerivAt (fun s : ℝ => G (x + s • v)) (constPoissonBracket P ℓ G (x + t • v)) t := by
  rw [constPoissonBracket_eq_fderiv_apply P ℓ v hP]
  have h1 : HasDerivAt (fun s : ℝ => x + s • v) v t := by
    simpa using ((hasDerivAt_id t).smul_const v).const_add x
  exact hG.hasFDerivAt.comp_hasDerivAt t h1

/-- If `M v = 0`, every function of `M y` is unchanged by the translations `x ↦ x + t v`. This
is linearity of `M` only. -/
theorem comp_add_smul_of_apply_eq_zero (M : E →L[ℝ] F') {v : E} (hv : M v = 0) (g : F' → ℝ)
    (x : E) (t : ℝ) : g (M (x + t • v)) = g (M x) := by
  rw [map_add, map_smul, hv, smul_zero, add_zero]

end QuantGrav
