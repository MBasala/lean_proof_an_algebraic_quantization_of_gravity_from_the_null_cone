/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.FixedResolution
public import Mathlib.MeasureTheory.Function.L2Space
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# One continuous variable restricted to an interval

This file is the continuous-variable model of statement L4 of break attempt B5 in `handoff.md`,
Section 14.7: a setup whose only degree of freedom is one continuous variable `q`, with states in
`L²(ℝ, dq)`, and whose `H_D`, for every maximum reading `ℓ ≥ 1`, is the space of
square-integrable functions that vanish outside `[0, 1]`, which is infinite-dimensional. It has
no graviton modes and no costs. The form of L4 with modes, costs and the inclusion of L3 is the
discrete model of `QuantGrav/Diamond/FixedResolution.lean`; the two are not combined.

* `intervalSpace`: the functions in `L²(ℝ)` that vanish almost everywhere outside `[0, 1]`.
* `isClosed_intervalSpace`, `not_finiteDimensional_intervalSpace`: it is a closed subspace and
  it is not finite-dimensional.
* `DiamondSetup.exists_setup_H1_diamondSpace_eq_intervalSpace`: a setup on `L²(ℝ)` that
  satisfies H1, whose fixed-area space is all of `L²(ℝ)`, and whose `H_D` is `intervalSpace` for
  every maximum reading `ℓ ≥ 1`.

The model is the particle confined to an interval. It shows that an `H_D` which restricts a
continuous variable in configuration only is consistent with H1 and is infinite-dimensional. It
is not a model of the paper's theory. The Hilbert space is the one on which the paper represents
each canonical pair, Sec 4.2: wavefunctions in `L²(ℝ, dq_j)`, with `q̂_j` acting by
multiplication. The operators `q̂` and `e^{-i a p̂ / ħ}` are not constructed here, and the
paper's `K_𝒜` carries infinitely many such pairs, not one.

Two limits of the model. First, `H_D` stops growing at a proper closed subspace of the
fixed-area space, so H13 fails in any setup with the stated properties: the clock has no finite
reading on the functions orthogonal to `intervalSpace`. This is a clock defined only on the
interval space, not a bound on a reading that is a finite function of `q`. A clock such as
`|q|`, with `H_D` the functions that vanish outside `[-ℓ, ℓ]`, would need its own spectral
family and is not built. Second, the file is not connected to the Weyl-pair theorems of
`QuantGrav/Diamond/ConfigurationOnly.lean`: multiplication by `e^{i t q}` and the shifts are not
defined here.
-/

@[expose] public section

namespace QuantGrav

open MeasureTheory

/-- The square-integrable functions on the line that vanish almost everywhere outside the unit
interval `[0, 1]`: the states of one continuous variable `q` that is restricted in
configuration to the interval. -/
def intervalSpace : Submodule ℂ (Lp ℂ 2 (volume : Measure ℝ)) where
  carrier := {f | ∀ᵐ x ∂(volume : Measure ℝ), x ∉ Set.Icc (0 : ℝ) 1 → f x = 0}
  add_mem' := by
    intro f g hf hg
    rw [Set.mem_ofPred_eq] at hf hg ⊢
    filter_upwards [Lp.coeFn_add f g, hf, hg] with x hx hfx hgx hx01
    rw [hx, Pi.add_apply, hfx hx01, hgx hx01, add_zero]
  zero_mem' := by
    rw [Set.mem_ofPred_eq]
    filter_upwards [Lp.coeFn_zero ℂ 2 (volume : Measure ℝ)] with x hx _
    rw [hx, Pi.zero_apply]
  smul_mem' := by
    intro c f hf
    rw [Set.mem_ofPred_eq] at hf ⊢
    filter_upwards [Lp.coeFn_smul c f, hf] with x hx hfx hx01
    rw [hx, Pi.smul_apply, hfx hx01, smul_zero]

/-- Membership in `intervalSpace`: the function vanishes almost everywhere outside `[0, 1]`. -/
theorem mem_intervalSpace_iff (f : Lp ℂ 2 (volume : Measure ℝ)) :
    f ∈ intervalSpace ↔ ∀ᵐ x ∂(volume : Measure ℝ), x ∉ Set.Icc (0 : ℝ) 1 → f x = 0 := by
  rfl

/-- A vector of `L²(ℝ)` lies in `intervalSpace` exactly when its restriction to the complement
of `[0, 1]` is the zero vector of `L²` of that complement. -/
private theorem mem_intervalSpace_iff_restrict_eq_zero (f : Lp ℂ 2 (volume : Measure ℝ)) :
    f ∈ intervalSpace ↔
      LpToLpRestrictCLM ℝ ℂ ℂ (volume : Measure ℝ) 2 (Set.Icc (0 : ℝ) 1)ᶜ f = 0 := by
  rw [mem_intervalSpace_iff, Lp.eq_zero_iff_ae_eq_zero,
    (LpToLpRestrictCLM_coeFn ℂ (Set.Icc (0 : ℝ) 1)ᶜ f).congr_left]
  exact (ae_restrict_iff' measurableSet_Icc.compl).symm

/-- `intervalSpace` is a closed subspace of `L²(ℝ)`. -/
theorem isClosed_intervalSpace :
    IsClosed (intervalSpace : Set (Lp ℂ 2 (volume : Measure ℝ))) := by
  have h : (intervalSpace : Set (Lp ℂ 2 (volume : Measure ℝ))) =
      {f | LpToLpRestrictCLM ℝ ℂ ℂ (volume : Measure ℝ) 2 (Set.Icc (0 : ℝ) 1)ᶜ f = 0} :=
    Set.ext mem_intervalSpace_iff_restrict_eq_zero
  rw [h]
  exact isClosed_eq (ContinuousLinearMap.continuous _) continuous_const

/-- The indicator function of a measurable subset of `[0, 1]` lies in `intervalSpace`. -/
private theorem indicatorConstLp_one_mem_intervalSpace {s : Set ℝ} (hs : MeasurableSet s)
    (hμs : volume s ≠ ⊤) (hsub : s ⊆ Set.Icc (0 : ℝ) 1) :
    indicatorConstLp 2 hs hμs (1 : ℂ) ∈ intervalSpace :=
  (mem_intervalSpace_iff _).mpr
    (indicatorConstLp_coeFn_notMem.mono fun _ hx hx01 => hx fun hxs => hx01 (hsub hxs))

/-- The indicator functions of pairwise disjoint measurable sets of finite, nonzero measure are
linearly independent vectors of `L²(ℝ)`. -/
private theorem linearIndependent_indicatorConstLp_one {ι : Type*} {s : ι → Set ℝ}
    (hs : ∀ i, MeasurableSet (s i)) (hμs : ∀ i, volume (s i) ≠ ⊤) (h0 : ∀ i, volume (s i) ≠ 0)
    (hd : Pairwise fun i j => Disjoint (s i) (s j)) :
    LinearIndependent ℂ fun i => indicatorConstLp 2 (hs i) (hμs i) (1 : ℂ) := by
  refine linearIndependent_of_ne_zero_of_inner_eq_zero (fun i h => ?_) fun i j hij => ?_
  · have hi := L2.inner_indicatorConstLp_one_indicatorConstLp_one (𝕜 := ℂ) (hs i) (hs i)
      (hμs i) (hμs i)
    rw [h, inner_zero_left, Set.inter_self] at hi
    exact (measureReal_ne_zero_iff (hμs i)).mpr (h0 i) (RCLike.ofReal_eq_zero.mp hi.symm)
  · have hi := L2.inner_indicatorConstLp_one_indicatorConstLp_one (𝕜 := ℂ) (hs i) (hs j)
      (hμs i) (hμs j)
    rw [(hd hij).inter_eq, measureReal_empty, RCLike.ofReal_zero] at hi
    exact hi

/-- For natural numbers `m < n`, the intervals `(1 / (m + 2), 1 / (m + 1)]` and
`(1 / (n + 2), 1 / (n + 1)]` are disjoint. -/
private theorem disjoint_Ioc_one_div_of_lt {m n : ℕ} (h : m < n) :
    Disjoint (Set.Ioc (1 / ((m : ℝ) + 2)) (1 / ((m : ℝ) + 1)))
      (Set.Ioc (1 / ((n : ℝ) + 2)) (1 / ((n : ℝ) + 1))) := by
  rw [Set.disjoint_left]
  rintro x ⟨hx1, -⟩ ⟨-, hx2⟩
  have h1 : (m : ℝ) + 1 ≤ n := by exact_mod_cast h
  have h2 : 1 / ((n : ℝ) + 1) ≤ 1 / ((m : ℝ) + 2) :=
    one_div_le_one_div_of_le (by positivity) (by linarith)
  linarith

/-- There is a sequence of linearly independent vectors of `L²(ℝ)` that lie in `intervalSpace`:
the indicator functions of the pairwise disjoint intervals `(1 / (n + 2), 1 / (n + 1)]`, for `n`
a natural number. -/
private theorem exists_linearIndependent_mem_intervalSpace :
    ∃ v : ℕ → Lp ℂ 2 (volume : Measure ℝ),
      (∀ n, v n ∈ intervalSpace) ∧ LinearIndependent ℂ v := by
  have hlt : ∀ n : ℕ, 1 / ((n : ℝ) + 2) < 1 / ((n : ℝ) + 1) := fun n =>
    one_div_lt_one_div_of_lt (by positivity) (by linarith)
  refine ⟨_, fun n => ?_, linearIndependent_indicatorConstLp_one
    (s := fun n : ℕ => Set.Ioc (1 / ((n : ℝ) + 2)) (1 / ((n : ℝ) + 1)))
    (fun _ => measurableSet_Ioc) (fun _ => measure_Ioc_lt_top.ne) (fun n => ?_)
    fun m n hmn => ?_⟩
  · refine indicatorConstLp_one_mem_intervalSpace _ _ fun x hx => ⟨?_, ?_⟩
    · exact (lt_trans (by positivity) hx.1).le
    · refine hx.2.trans ?_
      rw [div_le_one (by positivity)]
      linarith [(Nat.cast_nonneg n : (0 : ℝ) ≤ n)]
  · rw [Real.volume_Ioc]
    exact (ENNReal.ofReal_pos.mpr (sub_pos.mpr (hlt n))).ne'
  · rcases hmn.lt_or_gt with h | h
    · exact disjoint_Ioc_one_div_of_lt h
    · exact (disjoint_Ioc_one_div_of_lt h).symm

/-- **A particle confined to an interval.** The space of square-integrable functions that vanish
outside `[0, 1]` is not finite-dimensional. -/
theorem not_finiteDimensional_intervalSpace : ¬FiniteDimensional ℂ intervalSpace := by
  intro hfd
  obtain ⟨v, hv, hli⟩ := exists_linearIndependent_mem_intervalSpace
  have hli' : LinearIndependent ℂ fun n => (⟨v n, hv n⟩ : intervalSpace) :=
    LinearIndependent.of_comp intervalSpace.subtype hli
  exact Module.Finite.not_linearIndependent_of_infinite _ hli'

namespace DiamondSetup

/-- **L4, the continuous model.** There is a setup on `L²(ℝ, dq)` that satisfies H1, whose
fixed-area space is all of `L²(ℝ, dq)`, and in which, for every maximum reading `ℓ ≥ 1`, `H_D`
is the space of functions that vanish outside `[0, 1]`, and is infinite-dimensional.

The witness is `DiamondSetup.ofProjections`: its clock takes the value `1` on the functions that
vanish outside `[0, 1]` and has no finite reading on the functions orthogonal to them. The
statement records less: H1, the fixed-area space, and the range of the clock projection for
`ℓ ≥ 1`. That projection is multiplication by the indicator of `[0, 1]`, so in the witness the
clock restricts `q` in configuration and does not involve its conjugate. This last point is a
remark: `q̂` and the shifts are not defined here. The witness shows that such a clock is
consistent with H1 and with an infinite-dimensional `H_D`. It is not a model of the paper's
theory. -/
theorem exists_setup_H1_diamondSpace_eq_intervalSpace :
    ∃ S : DiamondSetup (Lp ℂ 2 (volume : Measure ℝ)), S.H1 ∧ S.fixedArea = ⊤ ∧
      ∀ ℓ : ℝ, 1 ≤ ℓ →
        S.diamondSpace ℓ = intervalSpace ∧ ¬FiniteDimensional ℂ (S.diamondSpace ℓ) := by
  have hcomplete : CompleteSpace intervalSpace := isClosed_intervalSpace.completeSpace_coe
  have hΩ : ‖indicatorConstLp (μ := (volume : Measure ℝ)) 2
      (measurableSet_Icc (a := (0 : ℝ)) (b := 1)) measure_Icc_lt_top.ne (1 : ℂ)‖ = 1 := by
    rw [norm_indicatorConstLp two_ne_zero ENNReal.ofNat_ne_top,
      Real.volume_real_Icc_of_le zero_le_one, norm_one, sub_zero, Real.one_rpow, mul_one]
  obtain ⟨S, hS1, hSA, hS⟩ := exists_setup_H1_diamondSpace_eq intervalSpace hΩ
    (indicatorConstLp_one_mem_intervalSpace _ _ subset_rfl)
  refine ⟨S, hS1, hSA, fun ℓ hℓ => ⟨hS ℓ hℓ, ?_⟩⟩
  rw [hS ℓ hℓ]
  exact not_finiteDimensional_intervalSpace

end DiamondSetup

end QuantGrav
