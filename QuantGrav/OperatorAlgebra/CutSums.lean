/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.InnerProductSpace.Adjoint
public import Mathlib.Analysis.InnerProductSpace.l2Space
public import Mathlib.Analysis.InnerProductSpace.Projection.Submodule
import Mathlib.Analysis.MeanInequalities
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NoncommRing

/-!
# WP2-c, WP2-d, WP2-e: sums over intermediate states

Paper: arXiv:2611.34924v1, (4.29), (4.30), (4.31), (C.21).

Everything here holds for arbitrary bounded operators on Hilbert spaces. Nothing is specific to
the paper's theory.

* `hasSum_inner_cut`: the resolution of the identity in a Hilbert basis on the cut, the
  mathematical content of (4.29). That the physical cut amplitude is given by such a sum is
  hypothesis H3, and is not addressed here.
* `summable_norm_inner_cut`, `tsum_norm_inner_cut_le`, `tsum_norm_inner_cut_le_of_norm_le_one`:
  the sum over intermediate states converges absolutely, with the bound of (4.30).
* `evolve`, `evolveCut`, `norm_inner_truncation_error_le`: the truncation error bound (4.31).
* `tendsto_inner_evolveCut`: if the truncating operators converge strongly to the identity
  (hypothesis H5, an explicit argument), the truncated amplitude converges to the full one.
  `tendsto_inner_evolveCut_starProjection` discharges H5 for orthogonal projections onto
  increasing subspaces with dense union.
* `compression_mul`: the algebraic identity (C.21).
-/

public section

namespace QuantGrav

open Filter Finset Topology
open scoped ComplexInnerProductSpace

section Cut

variable {ι H H₁ H₂ : Type*}
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
  [NormedAddCommGroup H₁] [InnerProductSpace ℂ H₁]
  [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [CompleteSpace H₂]

/-- **WP2-c**, the mathematical content of paper (4.29). For bounded `U₁ : H₁ → H`,
`U₂ : H → H₂` and a Hilbert basis `b` of the intermediate space `H`, the matrix element
`⟨φ, U₂ U₁ ψ⟩` is the sum over `i` of `⟨φ, U₂ b_i⟩ ⟨b_i, U₁ ψ⟩`. -/
theorem hasSum_inner_cut (b : HilbertBasis ι ℂ H) (U₁ : H₁ →L[ℂ] H) (U₂ : H →L[ℂ] H₂)
    (φ : H₂) (ψ : H₁) :
    HasSum (fun i => ⟪φ, U₂ (b i)⟫ * ⟪b i, U₁ ψ⟫) ⟪φ, U₂ (U₁ ψ)⟫ := by
  have h := b.hasSum_inner_mul_inner (ContinuousLinearMap.adjoint U₂ φ) (U₁ ψ)
  simpa only [ContinuousLinearMap.adjoint_inner_left] using h

omit [CompleteSpace H] in
/-- Cauchy-Schwarz over a Hilbert basis, the step behind (4.30): the products
`‖⟨b_i, x⟩‖ ‖⟨b_i, y⟩‖` are summable with sum at most `‖x‖ ‖y‖`. -/
theorem summable_and_tsum_norm_inner_mul_le (b : HilbertBasis ι ℂ H) (x y : H) :
    (Summable fun i => ‖⟪b i, x⟫‖ * ‖⟪b i, y⟫‖) ∧
      ∑' i, ‖⟪b i, x⟫‖ * ‖⟪b i, y⟫‖ ≤ ‖x‖ * ‖y‖ := by
  have hx : Summable fun i => ‖⟪b i, x⟫‖ ^ (2 : ℝ) := by
    simpa only [Real.rpow_two] using b.summable_norm_inner_sq x
  have hy : Summable fun i => ‖⟪b i, y⟫‖ ^ (2 : ℝ) := by
    simpa only [Real.rpow_two] using b.summable_norm_inner_sq y
  have h := Real.summable_and_inner_le_Lp_mul_Lq_tsum_of_nonneg Real.HolderConjugate.two_two
    (fun i => norm_nonneg ⟪b i, x⟫) (fun i => norm_nonneg ⟪b i, y⟫) hx hy
  refine ⟨h.1, h.2.trans_eq ?_⟩
  simp only [Real.rpow_two, b.tsum_norm_inner_sq, ← Real.sqrt_eq_rpow,
    Real.sqrt_sq (norm_nonneg _)]

/-- **WP2-c**, paper (4.30): the sum over intermediate states in (4.29) converges absolutely.
This holds for any bounded operators. -/
theorem summable_norm_inner_cut (b : HilbertBasis ι ℂ H) (U₁ : H₁ →L[ℂ] H) (U₂ : H →L[ℂ] H₂)
    (φ : H₂) (ψ : H₁) :
    Summable fun i => ‖⟪φ, U₂ (b i)⟫ * ⟪b i, U₁ ψ⟫‖ := by
  have h := (summable_and_tsum_norm_inner_mul_le b (ContinuousLinearMap.adjoint U₂ φ) (U₁ ψ)).1
  refine h.congr fun i => ?_
  rw [norm_mul, norm_inner_symm (b i), ContinuousLinearMap.adjoint_inner_left]

/-- **WP2-c**, paper (4.30) for bounded operators: the absolute sum over intermediate states is
at most `‖U₂† φ‖ ‖U₁ ψ‖`. -/
theorem tsum_norm_inner_cut_le (b : HilbertBasis ι ℂ H) (U₁ : H₁ →L[ℂ] H) (U₂ : H →L[ℂ] H₂)
    (φ : H₂) (ψ : H₁) :
    ∑' i, ‖⟪φ, U₂ (b i)⟫ * ⟪b i, U₁ ψ⟫‖ ≤ ‖ContinuousLinearMap.adjoint U₂ φ‖ * ‖U₁ ψ‖ := by
  have h := (summable_and_tsum_norm_inner_mul_le b (ContinuousLinearMap.adjoint U₂ φ) (U₁ ψ)).2
  refine le_of_eq_of_le (tsum_congr fun i => ?_) h
  rw [norm_mul, ← ContinuousLinearMap.adjoint_inner_left, norm_inner_symm]

/-- **WP2-c**, paper (4.30) as stated: if `U₁` and `U₂` have norm at most one, as unitary time
evolutions do, the absolute sum over intermediate states is at most `‖φ‖ ‖ψ‖`. -/
theorem tsum_norm_inner_cut_le_of_norm_le_one (b : HilbertBasis ι ℂ H) (U₁ : H₁ →L[ℂ] H)
    (U₂ : H →L[ℂ] H₂) (hU₁ : ‖U₁‖ ≤ 1) (hU₂ : ‖U₂‖ ≤ 1) (φ : H₂) (ψ : H₁) :
    ∑' i, ‖⟪φ, U₂ (b i)⟫ * ⟪b i, U₁ ψ⟫‖ ≤ ‖φ‖ * ‖ψ‖ := by
  refine (tsum_norm_inner_cut_le b U₁ U₂ φ ψ).trans ?_
  have h1 : ‖ContinuousLinearMap.adjoint U₂ φ‖ ≤ ‖φ‖ := by
    refine ((ContinuousLinearMap.adjoint U₂).le_opNorm φ).trans ?_
    rw [LinearIsometryEquiv.norm_map]
    exact mul_le_of_le_one_left (norm_nonneg φ) hU₂
  have h2 : ‖U₁ ψ‖ ≤ ‖ψ‖ :=
    (U₁.le_opNorm ψ).trans (mul_le_of_le_one_left (norm_nonneg ψ) hU₁)
  exact mul_le_mul h1 h2 (norm_nonneg _) (norm_nonneg _)

end Cut

section Truncation

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- The state reaching cut `n`: `evolve U ψ n = U (n - 1) ⋯ U 0 ψ`. In the paper's numbering
this is `U_n ⋯ U_1 |ψ⟩`. -/
def evolve (U : ℕ → H →L[ℂ] H) (ψ : H) : ℕ → H
  | 0 => ψ
  | n + 1 => U n (evolve U ψ n)

/-- The state reaching cut `n` when cut `j + 1` keeps only the range of `P j`:
`evolveCut U P ψ n = P (n - 1) U (n - 1) ⋯ P 0 U 0 ψ`. -/
def evolveCut (U P : ℕ → H →L[ℂ] H) (ψ : H) : ℕ → H
  | 0 => ψ
  | n + 1 => P n (U n (evolveCut U P ψ n))

/-- The truncated state differs from the full one by at most the sum of the components removed at
each cut, when no `U n` or `P n` increases norms. -/
theorem norm_evolve_sub_evolveCut_le (U P : ℕ → H →L[ℂ] H) (hU : ∀ n, ‖U n‖ ≤ 1)
    (hP : ∀ n, ‖P n‖ ≤ 1) (ψ : H) (n : ℕ) :
    ‖evolve U ψ n - evolveCut U P ψ n‖
      ≤ ∑ j ∈ range n, ‖evolve U ψ (j + 1) - P j (evolve U ψ (j + 1))‖ := by
  induction n with
  | zero => simp [evolve, evolveCut]
  | succ n ih =>
    rw [Finset.sum_range_succ]
    have hsplit : evolve U ψ (n + 1) - evolveCut U P ψ (n + 1)
        = (evolve U ψ (n + 1) - P n (evolve U ψ (n + 1)))
          + P n (U n (evolve U ψ n - evolveCut U P ψ n)) := by
      simp only [evolve, evolveCut, map_sub]
      abel
    have hstep : ‖P n (U n (evolve U ψ n - evolveCut U P ψ n))‖
        ≤ ‖evolve U ψ n - evolveCut U P ψ n‖ := by
      refine ((P n).le_opNorm _).trans ?_
      refine (mul_le_of_le_one_left (norm_nonneg _) (hP n)).trans ?_
      exact ((U n).le_opNorm _).trans (mul_le_of_le_one_left (norm_nonneg _) (hU n))
    rw [hsplit]
    refine (norm_add_le _ _).trans ?_
    linarith

/-- **WP2-d**, paper (4.31). With `m + 1` evolution steps and `m` truncated cuts, the amplitude
`⟨φ, U_m ⋯ U_0 ψ⟩` differs from the truncated amplitude `⟨φ, U_m P_{m-1} U_{m-1} ⋯ P_0 U_0 ψ⟩`
by at most `‖φ‖` times the sum over cuts of the norm of the component removed there. -/
theorem norm_inner_truncation_error_le (U P : ℕ → H →L[ℂ] H) (hU : ∀ n, ‖U n‖ ≤ 1)
    (hP : ∀ n, ‖P n‖ ≤ 1) (φ ψ : H) (m : ℕ) :
    ‖⟪φ, U m (evolve U ψ m)⟫ - ⟪φ, U m (evolveCut U P ψ m)⟫‖
      ≤ ‖φ‖ * ∑ j ∈ range m, ‖evolve U ψ (j + 1) - P j (evolve U ψ (j + 1))‖ := by
  rw [← inner_sub_right, ← map_sub]
  refine (norm_inner_le_norm _ _).trans ?_
  refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg φ)
  refine ((U m).le_opNorm _).trans ?_
  refine (mul_le_of_le_one_left (norm_nonneg _) (hU m)).trans ?_
  exact norm_evolve_sub_evolveCut_le U P hU hP ψ m

/-- **WP2-d**, the sentence after paper (4.31). Let the truncating operators `P a n` depend on a
parameter `a`, and suppose that along a filter they converge strongly to the identity on every
cut (hypothesis H5). Then the truncated amplitude converges to the full amplitude. -/
theorem tendsto_inner_evolveCut {α : Type*} {l : Filter α} (U : ℕ → H →L[ℂ] H)
    (P : α → ℕ → H →L[ℂ] H) (hU : ∀ n, ‖U n‖ ≤ 1) (hP : ∀ a n, ‖P a n‖ ≤ 1)
    (hlim : ∀ (n : ℕ) (x : H), Tendsto (fun a => P a n x) l (𝓝 x)) (φ ψ : H) (m : ℕ) :
    Tendsto (fun a => ⟪φ, U m (evolveCut U (P a) ψ m)⟫) l (𝓝 ⟪φ, U m (evolve U ψ m)⟫) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  have hbound : Tendsto
      (fun a => ‖φ‖ * ∑ j ∈ range m, ‖evolve U ψ (j + 1) - P a j (evolve U ψ (j + 1))‖)
      l (𝓝 0) := by
    have hsum : Tendsto
        (fun a => ∑ j ∈ range m, ‖evolve U ψ (j + 1) - P a j (evolve U ψ (j + 1))‖)
        l (𝓝 (∑ _j ∈ range m, (0 : ℝ))) := by
      refine tendsto_finsetSum _ fun j _ => ?_
      have h := (tendsto_iff_norm_sub_tendsto_zero.mp (hlim j (evolve U ψ (j + 1))))
      simpa only [norm_sub_rev] using h
    simpa using hsum.const_mul ‖φ‖
  refine squeeze_zero (fun a => norm_nonneg _) (fun a => ?_) hbound
  rw [norm_sub_rev]
  exact norm_inner_truncation_error_le U (P a) hU (hP a) φ ψ m

/-- **WP2-d** with H5 discharged in the standard case: if on every cut the truncations are the
orthogonal projections onto an increasing sequence of subspaces with dense union, the truncated
amplitude converges to the full amplitude. -/
theorem tendsto_inner_evolveCut_starProjection (U : ℕ → H →L[ℂ] H) (hU : ∀ n, ‖U n‖ ≤ 1)
    (V : ℕ → ℕ → Submodule ℂ H) [∀ k n, (V k n).HasOrthogonalProjection]
    (hmono : ∀ n, Monotone fun k => V k n)
    (hdense : ∀ n, ⊤ ≤ (⨆ k, V k n).topologicalClosure) (φ ψ : H) (m : ℕ) :
    Tendsto (fun k => ⟪φ, U m (evolveCut U (fun n => (V k n).starProjection) ψ m)⟫) atTop
      (𝓝 ⟪φ, U m (evolve U ψ m)⟫) :=
  tendsto_inner_evolveCut U (fun k n => (V k n).starProjection) hU
    (fun k n => (V k n).starProjection_norm_le)
    (fun n x => Submodule.starProjection_tendsto_self (fun k => V k n) (hmono n) x (hdense n))
    φ ψ m

end Truncation

/-- **WP2-e**, paper (C.21). For an idempotent `P` in any ring,
`P X Y P = (P X P)(P Y P) + P X (1 - P) Y P`. -/
theorem compression_mul {R : Type*} [Ring R] (P X Y : R) (hP : P * P = P) :
    P * X * Y * P = P * X * P * (P * Y * P) + P * X * (1 - P) * Y * P := by
  have h : P * X * P * (P * Y * P) = P * X * (P * P) * Y * P := by noncomm_ring
  rw [h, hP]
  noncomm_ring

end QuantGrav
