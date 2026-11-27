/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.FiniteDim
public import QuantGrav.Hypotheses
public import Mathlib.Analysis.InnerProductSpace.Trace

/-!
# Condition 5 of Appendix E on a bounded spectrum is finite dimension

Paper: arXiv:2611.34924v1, App E.1, condition 5 with (E.5); App E.2, (E.7b); App E.3, (E.15),
(E.17); Sec 5.2, (5.21d), (5.39c).

This file is the third item of B4 in `handoff.md`, Section 14.2: formalise "axiom 5 on a bounded
spectrum with the ordinary trace implies finite dimension", and record the circle with (5.39c).

## The paper's statements

* Condition 5 of App E.1 requires every closed pairing of filtered preparations to have a finite
  amplitude, and (E.5) gives `ζ_L(cl(F_g† F_h)) = ∫ g* h dν` for a positive measure `ν`. In
  App E.2 this becomes (E.7b): the spectral projection of a bounded interval `I` has finite
  trace `ν(I)`.
* In the paper's realization, (E.15a), closing is the ordinary trace: `ζ_L(cl a) = Tr_{H_Σ} a`,
  the sum of the diagonal matrix elements.
* App E.3 verifies condition 5 for the causal diamond by citing `dim H_D < ∞` from (5.39c): the
  boost generator then has bounded spectrum, the filter `g(K)` is the identity for `g = 1` on
  that spectrum, and (E.17) bounds `|Tr_{H_D} a|` by `d_D ‖a‖`.

## What is proved

For the ordinary trace, the closed amplitude of the identity over a finite orthonormal family is
the size of the family. So:

* `finiteDimensional_of_card_orthonormal_le`, `finrank_le_of_card_orthonormal_le`,
  `finiteDimensional_iff_exists_card_orthonormal_le`: a space is finite-dimensional exactly when
  the sizes of its finite orthonormal families are bounded, and its dimension is at most any
  such bound. This is "the identity has finite ordinary trace".
* `norm_sum_inner_apply_le`, `norm_sum_inner_apply_le_finrank`, `norm_trace_le_finrank_mul`:
  (E.17). The sum of the diagonal matrix elements of a bounded operator over `n` orthonormal
  vectors is at most `n ‖a‖`, hence at most `d ‖a‖` in dimension `d`; and `|Tr a| ≤ d ‖a‖`.
* `DiamondSetup.finiteDimensional_diamondSpace_of_trace_area_proj_le`: under the area bound
  (5.21d), the spectral projection of the area onto `(-∞, A_*]` is the identity on `H_D`. On
  `H_D` it is the projection onto the bounded interval `[0, A_*]`, because by the same bound
  `H_D` has no area below zero. If its ordinary trace over `H_D` is finite, which is (E.7b) for
  that interval, then `H_D` is finite-dimensional.
* `DiamondSetup.finiteDimensional_diamondSpace_iff_exists_trace_area_proj_le`: the two are
  equivalent.

## What this means

Under the area bound, the instance of (E.7b) for the interval that contains the spectrum, with
the ordinary trace of (E.15a), is equivalent to `dim H_D < ∞`. That instance follows from
condition 5, and (E.17) is the way back from `dim H_D < ∞` to condition 5. App E.3 obtains
condition 5 from `dim H_D < ∞`, and here condition 5 gives `dim H_D < ∞` back. So for the
diamond the condition and the conclusion of Sec 5.2 are one statement, and Appendix E cannot
support Sec 5.2 independently. This is not an error in the paper: App E.3 presents the step as a
verification of its axioms, not as a derivation of finite dimension.

The paper's conditions concern the boost generator `K`. Here the area stands in for it, through
`K = A / (8πG)` of (5.22), register entry H6. The filter `F_g = g(K)` is not constructed. The
statements start from the point where the spectrum is bounded and the filter is a spectral
projection that acts as the identity. Only the upper half of the area bound is used in the
proofs, and finite dimension gives bounded partial traces with no bound on the area at all.
-/

public section

namespace QuantGrav

open Module
open scoped ComplexInnerProductSpace

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- If every finite orthonormal family has at most `Z` vectors, the space is finite-dimensional.
With the ordinary trace of (E.15a), the size of the family is the closed amplitude of the
identity on it, so the hypothesis says that the identity has finite trace. -/
theorem finiteDimensional_of_card_orthonormal_le {Z : ℝ}
    (hZ : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → (n : ℝ) ≤ Z) :
    FiniteDimensional ℂ H := by
  refine finiteDimensional_of_sum_sq_norm_le (ContinuousLinearMap.id ℂ H) (c := 1) (Z := Z)
    one_pos (fun v => ?_) fun n e he => ?_
  · rw [ContinuousLinearMap.id_apply, one_mul]
  · calc ∑ i, ‖ContinuousLinearMap.id ℂ H (e i)‖ ^ 2 = n := by simp [he.1]
      _ ≤ Z := hZ n e he

/-- Under the same hypothesis the dimension is at most `Z`. -/
theorem finrank_le_of_card_orthonormal_le {Z : ℝ}
    (hZ : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → (n : ℝ) ≤ Z) :
    (finrank ℂ H : ℝ) ≤ Z := by
  have := finiteDimensional_of_card_orthonormal_le hZ
  exact hZ _ _ (stdOrthonormalBasis ℂ H).orthonormal

/-- A space is finite-dimensional exactly when the sizes of its finite orthonormal families are
bounded: the identity has finite ordinary trace exactly in finite dimension. -/
theorem finiteDimensional_iff_exists_card_orthonormal_le :
    FiniteDimensional ℂ H ↔
      ∃ Z : ℝ, ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → (n : ℝ) ≤ Z := by
  constructor
  · intro hfin
    refine ⟨finrank ℂ H, fun n e he => ?_⟩
    have hn : n ≤ finrank ℂ H := by simpa using he.linearIndependent.fintype_card_le_finrank
    exact_mod_cast hn
  · rintro ⟨Z, hZ⟩
    exact finiteDimensional_of_card_orthonormal_le hZ

/-- The sum of the diagonal matrix elements of a bounded operator over `n` orthonormal vectors
is at most `n ‖a‖` in absolute value. -/
theorem norm_sum_inner_apply_le (a : H →L[ℂ] H) (n : ℕ) (e : Fin n → H)
    (he : Orthonormal ℂ e) : ‖∑ i, ⟪e i, a (e i)⟫‖ ≤ n * ‖a‖ := by
  calc ‖∑ i, ⟪e i, a (e i)⟫‖ ≤ ∑ i, ‖⟪e i, a (e i)⟫‖ := norm_sum_le _ _
    _ ≤ ∑ _i : Fin n, ‖a‖ := by
        refine Finset.sum_le_sum fun i _ => ?_
        have h1 : ‖⟪e i, a (e i)⟫‖ ≤ ‖e i‖ * ‖a (e i)‖ := norm_inner_le_norm _ _
        have h2 : ‖a (e i)‖ ≤ ‖a‖ * ‖e i‖ := a.le_opNorm _
        rw [he.1 i] at h1 h2
        linarith
    _ = n * ‖a‖ := by simp

/-- In a space of dimension `d`, the sum of the diagonal matrix elements of a bounded operator
over an orthonormal family is at most `d ‖a‖` in absolute value. For the trace itself see
`norm_trace_le_finrank_mul`. -/
theorem norm_sum_inner_apply_le_finrank [FiniteDimensional ℂ H] (a : H →L[ℂ] H) (n : ℕ)
    (e : Fin n → H) (he : Orthonormal ℂ e) :
    ‖∑ i, ⟪e i, a (e i)⟫‖ ≤ finrank ℂ H * ‖a‖ := by
  have hn : n ≤ finrank ℂ H := by simpa using he.linearIndependent.fintype_card_le_finrank
  have hn' : (n : ℝ) ≤ finrank ℂ H := by exact_mod_cast hn
  exact (norm_sum_inner_apply_le a n e he).trans (mul_le_mul_of_nonneg_right hn' (norm_nonneg a))

/-- **(E.17).** In a space of dimension `d`, `|Tr a| ≤ d ‖a‖` for every bounded operator `a`. -/
theorem norm_trace_le_finrank_mul [FiniteDimensional ℂ H] (a : H →L[ℂ] H) :
    ‖LinearMap.trace ℂ H (a : H →ₗ[ℂ] H)‖ ≤ finrank ℂ H * ‖a‖ := by
  rw [LinearMap.trace_eq_sum_inner (a : H →ₗ[ℂ] H) (stdOrthonormalBasis ℂ H)]
  exact norm_sum_inner_apply_le a _ _ (stdOrthonormalBasis ℂ H).orthonormal

end

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

namespace DiamondSetup

/-- Under the area bound at `ℓ`, the spectral projection of the area onto `(-∞, A_*]` fixes
every vector of `H_D`, so its partial trace over an orthonormal family in `H_D` is the size of
the family. -/
private theorem sum_sq_norm_area_proj_eq_card (S : DiamondSetup H) {ℓ : ℝ}
    (hA : S.AreaBoundAt ℓ) (n : ℕ) (e : Fin n → H) (he : Orthonormal ℂ e)
    (hmem : ∀ i, e i ∈ S.diamondSpace ℓ) :
    ∑ i, ‖S.area.proj (S.areaBound ℓ) (e i)‖ ^ 2 = n := by
  have h : ∀ i, ‖S.area.proj (S.areaBound ℓ) (e i)‖ ^ 2 = 1 := fun i => by
    rw [(hA (e i) (hmem i)).1, he.1 i, one_pow]
  simp [h]

/-- **Condition 5 on a bounded spectrum gives finite dimension.** Under the area bound (5.21d)
at `ℓ`, suppose the spectral projection of the area onto `(-∞, A_*]`, with `A_*` the bound, has
partial traces at most `ν` over the finite orthonormal families in `H_D`. Then `H_D` is
finite-dimensional.

For an orthogonal projection `P`, such as those of a spectral family, the diagonal matrix element
`⟨e, P e⟩` is `‖P e‖²`; that identity is how the trace is written here, and it is not proved in
this file. On `H_D` the projection onto `(-∞, A_*]` is the projection onto the bounded interval
`[0, A_*]`. So the hypothesis is (E.7b) for an interval that contains the spectrum, with the
ordinary trace of (E.15a). -/
theorem finiteDimensional_diamondSpace_of_trace_area_proj_le (S : DiamondSetup H) {ℓ ν : ℝ}
    (hA : S.AreaBoundAt ℓ)
    (hν : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → (∀ i, e i ∈ S.diamondSpace ℓ) →
      ∑ i, ‖S.area.proj (S.areaBound ℓ) (e i)‖ ^ 2 ≤ ν) :
    FiniteDimensional ℂ (S.diamondSpace ℓ) := by
  refine finiteDimensional_of_card_orthonormal_le (Z := ν) fun n e' he' => ?_
  have he : Orthonormal ℂ fun i => (e' i : H) :=
    he'.comp_linearIsometry (S.diamondSpace ℓ).subtypeₗᵢ
  have hmem : ∀ i, (e' i : H) ∈ S.diamondSpace ℓ := fun i => (e' i).property
  calc (n : ℝ) = ∑ i, ‖S.area.proj (S.areaBound ℓ) (e' i : H)‖ ^ 2 :=
        (S.sum_sq_norm_area_proj_eq_card hA n _ he hmem).symm
    _ ≤ ν := hν n _ he hmem

/-- **The circle with (5.39c).** Under the area bound (5.21d) at `ℓ`, `H_D` is finite-dimensional
exactly when the spectral projection of the area onto `(-∞, A_*]`, which on `H_D` is the
projection onto the bounded interval `[0, A_*]`, has bounded partial traces over `H_D`. The first
statement is the conclusion of Sec 5.2, (5.39c). The second is the instance of (E.7b) for that
interval, with the ordinary trace; it follows from condition 5 of App E.1. -/
theorem finiteDimensional_diamondSpace_iff_exists_trace_area_proj_le (S : DiamondSetup H)
    {ℓ : ℝ} (hA : S.AreaBoundAt ℓ) :
    FiniteDimensional ℂ (S.diamondSpace ℓ) ↔
      ∃ ν : ℝ, ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e →
        (∀ i, e i ∈ S.diamondSpace ℓ) →
        ∑ i, ‖S.area.proj (S.areaBound ℓ) (e i)‖ ^ 2 ≤ ν := by
  constructor
  · intro hfin
    refine ⟨finrank ℂ (S.diamondSpace ℓ), fun n e he hmem => ?_⟩
    have hn : n ≤ finrank ℂ (S.diamondSpace ℓ) := by
      simpa using
        (he.codRestrict (S.diamondSpace ℓ) hmem).linearIndependent.fintype_card_le_finrank
    rw [S.sum_sq_norm_area_proj_eq_card hA n e he hmem]
    exact_mod_cast hn
  · rintro ⟨ν, hν⟩
    exact S.finiteDimensional_diamondSpace_of_trace_area_proj_le hA hν

end DiamondSetup

end

end QuantGrav
