/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.ClockHypotheses
public import QuantGrav.Elementary.OccupationCount

/-!
# Finite dimension at fixed resolution from a bound on the cost

Paper: arXiv:2611.34924v1, App D.3, (D.40) to (D.46); Sec 4.2, (4.10).

This file holds statements L2 and L3 of break attempt B5 in `handoff.md`, Section 14.7, and the
discrete half of L4. The question of B5 is whether, with finitely many modes, a bound on the
clock reading already gives a finite-dimensional `H_D`, without any statement about closing a
cut.

* `finrank_le_card_of_le_closure_span` (L2): a subspace inside the closed span of `N` vectors
  has dimension at most `N`.
* `finrank_le_of_le_closure_span_occupations`,
  `DiamondSetup.finiteDimensional_diamondSpace_of_le_closure_span_occupations` and
  `DiamondSetup.finiteDimensional_fixedAreaDiamondSpace_of_le_closure_span_occupations` (L3): if
  every vector of `H_D`, or of its fixed-area part, lies in the closed span of vectors labelled
  by an occupation vector of bounded cost and by one of finitely many states of the remaining
  degrees of freedom, then it is finite-dimensional, with an explicit bound. This uses the
  count of `QuantGrav/Elementary/OccupationCount.lean` and nothing about cuts: none of the
  register entries H3a, H3b, H3c, H4.
* `not_finiteDimensional_span_range_of_infinite`, `DiamondSetup.exists_setup_H1_diamondSpace_eq`
  and `DiamondSetup.exists_setup_H1_diamondSpace_eq_closure_span_occupations` (L4, discrete): the
  hypothesis that the remaining degrees of freedom have finitely many states cannot be dropped
  from L3. With infinitely many orthonormal states of those degrees of freedom there is a setup
  that satisfies H1 and the hypothesis of L3 and in which `H_D` is infinite-dimensional.

The hypotheses are about the closed span, because `H_D` is a closed subspace. For the finite
families of L2 and L3 the closed span is the span, so this changes nothing there. It matters for
the comparison with L4, where the family is infinite: in a complete space a closed subspace
inside the algebraic span of an orthonormal family is finite-dimensional however many vectors
the family has, so with the algebraic span the finiteness of the label set would look
unnecessary. That remark is not formalized.

Nothing in L3 ties the family of vectors, the costs or the bound to the setup: the step from a
bounded clock reading to the inclusion is entirely in the hypothesis, and it is not formalized.
In the paper the only link between `Q_*` and the maximum reading is a bound asserted, without
derivation and for flat spacetime, in the sentence after (D.46). The bound of the cost by `Q_*`
is introduced after (D.40) by specifying the integrated inward expansion at the edge of the cap,
not by bounding the clock. The remaining degrees of freedom are the corner variables on `S`
(Sec 4.2), which App D.3 holds fixed. Why the bound on the clock reading does not obviously
leave them finitely many states is the subject of `QuantGrav/Diamond/ConfigurationOnly.lean`.
-/

public section

namespace QuantGrav

open Module

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- The span of a finite set of vectors is closed, so it is its own closure. -/
private theorem topologicalClosure_span_eq_of_finite {s : Set H} (hs : s.Finite) :
    (Submodule.span ℂ s).topologicalClosure = Submodule.span ℂ s := by
  have hfin : FiniteDimensional ℂ (Submodule.span ℂ s) := FiniteDimensional.span_of_finite ℂ hs
  exact (Submodule.span ℂ s).isClosed_of_finiteDimensional.submodule_topologicalClosure_eq

/-- **L2.** A subspace contained in the closed span of a finite family of `N` vectors is
finite-dimensional, of dimension at most `N`. The family need not be orthonormal and the
subspace need not be closed. -/
theorem finrank_le_card_of_le_closure_span {κ : Type*} [Fintype κ] (e : κ → H)
    {V : Submodule ℂ H} (hV : V ≤ (Submodule.span ℂ (Set.range e)).topologicalClosure) :
    FiniteDimensional ℂ V ∧ finrank ℂ V ≤ Fintype.card κ := by
  rw [topologicalClosure_span_eq_of_finite (Set.finite_range e)] at hV
  have hfin : FiniteDimensional ℂ (Submodule.span ℂ (Set.range e)) :=
    FiniteDimensional.span_of_finite ℂ (Set.finite_range e)
  exact ⟨Submodule.finiteDimensional_of_le hV,
    (Submodule.finrank_mono hV).trans (finrank_range_le_card e)⟩

/-- A subspace inside the closed span of the vectors `b (a, c)`, with `a` in a finite set `A` and
`c` ranging over a finite type, is finite-dimensional, of dimension at most `|A|` times the
number of labels `c`. -/
private theorem finrank_le_ncard_mul_card_of_le_closure_span {α κ : Type*} [Fintype κ]
    (b : α × κ → H) {A : Set α} (hA : A.Finite) {V : Submodule ℂ H}
    (hV : V ≤ (Submodule.span ℂ (b '' {p | p.1 ∈ A})).topologicalClosure) :
    FiniteDimensional ℂ V ∧ finrank ℂ V ≤ A.ncard * Fintype.card κ := by
  have hset : {p : α × κ | p.1 ∈ A} = A ×ˢ (Set.univ : Set κ) := Set.prod_univ.symm
  have hSfin : {p : α × κ | p.1 ∈ A}.Finite := by
    rw [hset]
    exact hA.prod Set.finite_univ
  have hcard : {p : α × κ | p.1 ∈ A}.ncard = A.ncard * Fintype.card κ := by
    rw [hset, Set.ncard_prod, Set.ncard_univ, Nat.card_eq_fintype_card]
  have himg : (b '' {p | p.1 ∈ A}).Finite := hSfin.image b
  rw [topologicalClosure_span_eq_of_finite himg] at hV
  have hfin : FiniteDimensional ℂ (Submodule.span ℂ (b '' {p | p.1 ∈ A})) :=
    FiniteDimensional.span_of_finite ℂ himg
  refine ⟨Submodule.finiteDimensional_of_le hV, ?_⟩
  calc finrank ℂ V ≤ finrank ℂ (Submodule.span ℂ (b '' {p | p.1 ∈ A})) :=
        Submodule.finrank_mono hV
    _ ≤ (b '' {p | p.1 ∈ A}).ncard := finrank_span_le_ncard _ himg
    _ ≤ {p : α × κ | p.1 ∈ A}.ncard := Set.ncard_image_le hSfin
    _ = A.ncard * Fintype.card κ := hcard

/-- **L3, for any subspace.** Let `b` be a family of vectors labelled by an occupation vector
`n` of `M` modes and by a label `c` from a finite set, the states of the remaining degrees of
freedom. Let the modes have costs `ν i ≥ ν_min > 0`, and let `Q ≥ 0`. If `V` lies in the closed
span of the `b (n, c)` with total cost `∑ᵢ n_i ν_i ≤ Q`, then `V` is finite-dimensional and
`dim V ≤ (1 + Q / ν_min)^M · |labels|`. The family `b` need not be orthonormal. -/
theorem finrank_le_of_le_closure_span_occupations {ι κ : Type*} [Fintype ι] [Fintype κ]
    (b : (ι → ℕ) × κ → H) (ν : ι → ℝ) {νmin Q : ℝ} (hmin : 0 < νmin) (hν : ∀ i, νmin ≤ ν i)
    (hQ : 0 ≤ Q) {V : Submodule ℂ H}
    (hV : V ≤ (Submodule.span ℂ
      (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure) :
    FiniteDimensional ℂ V ∧
      (finrank ℂ V : ℝ) ≤ (1 + Q / νmin) ^ Fintype.card ι * Fintype.card κ := by
  obtain ⟨hfd, hle⟩ :=
    finrank_le_ncard_mul_card_of_le_closure_span b (finite_setOf_sum_mul_le ν hmin hν Q) hV
  refine ⟨hfd, ?_⟩
  have hcount := ncard_setOf_sum_mul_le ν hmin hν hQ
  have hcast : (finrank ℂ V : ℝ)
      ≤ ({n : ι → ℕ | ∑ i, (n i : ℝ) * ν i ≤ Q}.ncard : ℝ) * (Fintype.card κ : ℝ) := by
    exact_mod_cast hle
  exact hcast.trans (mul_le_mul_of_nonneg_right hcount (Nat.cast_nonneg _))

/-- **L4, the discrete form.** The span of an infinite orthonormal family is not
finite-dimensional, and so neither is any subspace that contains it, such as its closure. So in
L3 the set of labels of the remaining degrees of freedom must be finite: infinitely many
orthonormal states at the same cost already give an infinite-dimensional space. -/
theorem not_finiteDimensional_span_range_of_infinite {κ : Type*} [Infinite κ] (e : κ → H)
    (he : Orthonormal ℂ e) : ¬FiniteDimensional ℂ (Submodule.span ℂ (Set.range e)) := by
  intro hfd
  have hfin : Finite κ := (linearIndependent_span he.linearIndependent).finite_of_isNoetherian
  exact not_finite κ

end

section

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

namespace DiamondSetup

/-- **L3 on the diamond.** Let the modes have costs `ν i ≥ ν_min > 0` and let `Q ≥ 0`. If every
vector of `H_D` lies in the closed span of vectors labelled by an occupation vector of `M` modes
with total cost at most `Q` and by one of finitely many states of the remaining degrees of
freedom, then `H_D` is finite-dimensional, with `dim H_D ≤ (1 + Q / ν_min)^M · |labels|`.

Intended reading. It is ours: the paper does not state `hD`. Finitely many modes stands for the
paper's fixed resolution, a phrase it uses in Sec 5.1 and App C.2 without defining it, and not
in App D.3, where all modes are kept and the number of cheap ones is bounded in (D.45a)
(candidate register entry H19). The cost `ν i` is the increase of (D.40) per graviton in mode
`i`, and `Q` is `Q_*`. App D.3 gives both at one corner area, with the corner data held fixed
and at one loop, so the reading fits the fixed-area part of `H_D`, the next theorem, better
than all of `H_D`. The finite set of labels is a hypothesis on the corner sector, which App D.3
does not count. No statement about closing a cut is used, and no field of the setup. -/
theorem finiteDimensional_diamondSpace_of_le_closure_span_occupations (S : DiamondSetup H)
    {ℓ : ℝ} {ι κ : Type*} [Fintype ι] [Fintype κ] (b : (ι → ℕ) × κ → H) (ν : ι → ℝ)
    {νmin Q : ℝ} (hmin : 0 < νmin) (hν : ∀ i, νmin ≤ ν i) (hQ : 0 ≤ Q)
    (hD : S.diamondSpace ℓ ≤ (Submodule.span ℂ
      (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure) :
    FiniteDimensional ℂ (S.diamondSpace ℓ) ∧
      (finrank ℂ (S.diamondSpace ℓ) : ℝ)
        ≤ (1 + Q / νmin) ^ Fintype.card ι * Fintype.card κ :=
  finrank_le_of_le_closure_span_occupations b ν hmin hν hQ hD

/-- **L3 at fixed area.** The same for the part of `H_D` inside the fixed-area space, `P_D K_𝒜`,
which is the part the paper's construction of the clock determines and the part that the count
of App D.3 concerns. That count is made at one corner area, with the corner data held fixed. -/
theorem finiteDimensional_fixedAreaDiamondSpace_of_le_closure_span_occupations
    (S : DiamondSetup H) {ℓ : ℝ} {ι κ : Type*} [Fintype ι] [Fintype κ]
    (b : (ι → ℕ) × κ → H) (ν : ι → ℝ) {νmin Q : ℝ} (hmin : 0 < νmin) (hν : ∀ i, νmin ≤ ν i)
    (hQ : 0 ≤ Q)
    (hD : S.fixedAreaDiamondSpace ℓ ≤ (Submodule.span ℂ
      (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure) :
    FiniteDimensional ℂ (S.fixedAreaDiamondSpace ℓ) ∧
      (finrank ℂ (S.fixedAreaDiamondSpace ℓ) : ℝ)
        ≤ (1 + Q / νmin) ^ Fintype.card ι * Fintype.card κ :=
  finrank_le_of_le_closure_span_occupations b ν hmin hν hQ hD

/-- **A model with a prescribed `H_D`.** A subspace `K` that has an orthogonal projection and
contains a unit vector `Ω` is `H_D`, for every maximum reading `ℓ ≥ 1`, of a setup that
satisfies H1 and whose fixed-area space is the whole space. The setup is
`DiamondSetup.ofProjections` with `P = 1`, with `Q` the orthogonal projection onto `K`, and
with clock reading `1` on `K`. It is not a model of the paper's theory. -/
theorem exists_setup_H1_diamondSpace_eq (K : Submodule ℂ H) [K.HasOrthogonalProjection]
    {Ω : H} (hΩ : ‖Ω‖ = 1) (hΩK : Ω ∈ K) :
    ∃ S : DiamondSetup H, S.H1 ∧ S.fixedArea = ⊤ ∧
      ∀ ℓ : ℝ, 1 ≤ ℓ → S.diamondSpace ℓ = K := by
  have hQΩ : K.starProjection Ω = Ω := Submodule.starProjection_eq_self_iff.mpr hΩK
  have hPΩ : (1 : H →L[ℂ] H) Ω = Ω := rfl
  have h1 := (ofProjections_H1_iff 1 K.starProjection (IsStarProjection.one _)
    isStarProjection_starProjection (mul_one _) Ω hΩ hPΩ 1 2 1 (1 / 2) one_pos one_lt_two
    zero_le_one (by norm_num) (by norm_num)).mpr hQΩ
  refine ⟨_, h1, ?_, fun ℓ hℓ => ?_⟩
  · rw [Submodule.eq_top_iff']
    intro x
    exact LinearMap.mem_range.mpr ⟨x, rfl⟩
  · ext x
    rw [mem_diamondSpace_iff]
    simp only [diamondProj, ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte]
    exact Submodule.starProjection_eq_self_iff

/-- **L4, a model.** Let `b` be an orthonormal family labelled by an occupation vector of
finitely many modes and by a label from an infinite set, and let `Q ≥ 0`. Then there is a setup
that satisfies H1 and in which, for every maximum reading `ℓ ≥ 1`, `H_D` is the closed span of
the `b (n, c)` of total cost at most `Q`, and is infinite-dimensional. The costs `ν` are
arbitrary and play no role: the vectors `b (0, c)` alone are infinitely many.

So everything assumed in L3 can hold while `H_D` is infinite-dimensional, as soon as the
remaining degrees of freedom have infinitely many states. The setup is
`DiamondSetup.ofProjections`, whose clock takes a single value. It shows that the hypotheses
are consistent. It is not a model of the paper's theory. -/
theorem exists_setup_H1_diamondSpace_eq_closure_span_occupations {ι κ : Type*} [Fintype ι]
    [Infinite κ] (b : (ι → ℕ) × κ → H) (hb : Orthonormal ℂ b) (ν : ι → ℝ) {Q : ℝ}
    (hQ : 0 ≤ Q) :
    ∃ S : DiamondSetup H, S.H1 ∧ ∀ ℓ : ℝ, 1 ≤ ℓ →
      S.diamondSpace ℓ
          = (Submodule.span ℂ (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure ∧
        ¬FiniteDimensional ℂ (S.diamondSpace ℓ) := by
  obtain ⟨c₀⟩ : Nonempty κ := inferInstance
  have hmem : ∀ c : κ, b (0, c)
      ∈ (Submodule.span ℂ (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure := by
    intro c
    refine Submodule.le_topologicalClosure _ (Submodule.subset_span ⟨(0, c), ?_, rfl⟩)
    simpa using hQ
  obtain ⟨S, hS1, -, hS⟩ := exists_setup_H1_diamondSpace_eq _ (hb.1 (0, c₀)) (hmem c₀)
  refine ⟨S, hS1, fun ℓ hℓ => ⟨hS ℓ hℓ, ?_⟩⟩
  rw [hS ℓ hℓ]
  intro hfd
  have hle : Submodule.span ℂ (Set.range fun c : κ => b (0, c))
      ≤ (Submodule.span ℂ (b '' {p | ∑ i, (p.1 i : ℝ) * ν i ≤ Q})).topologicalClosure :=
    Submodule.span_le.mpr (by rintro _ ⟨c, rfl⟩; exact hmem c)
  have hfd' := Submodule.finiteDimensional_of_le hle
  exact not_finiteDimensional_span_range_of_infinite _
    (hb.comp (fun c : κ => ((0 : ι → ℕ), c)) fun _ _ h => (Prod.mk.inj h).2) hfd'

end DiamondSetup

end

end QuantGrav
