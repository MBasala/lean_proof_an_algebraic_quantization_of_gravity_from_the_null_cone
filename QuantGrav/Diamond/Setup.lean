/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.CStarAlgebra.Basic
public import Mathlib.Analysis.InnerProductSpace.Adjoint
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# Setup for the causal-diamond Hilbert space

Paper: arXiv:2611.34924v1, Sec 4.2, Sec 4.3, (5.1), (5.2), (5.21), (C.11) to (C.17).

This file fixes the objects that the hypotheses H1, H13 and H14 and the later statements about
`H_D` talk about. It contains definitions, basic consequences of the definitions, and a model.
It states none of the numbered hypotheses as a proposition. The fields of `DiamondSetup` are
themselves assumptions, and every theorem about a `DiamondSetup` is conditional on them.

## Modelling decision

The paper's clock `û` is an unbounded operator defined by a quadratic form, and `P_D` is the
spectral projection `1_{[0, ℓ(D)]}(û)` (5.2). The pinned Mathlib has unbounded operators
(`LinearPMap`) but no spectral theorem for them, so `P_D` cannot be defined from an operator
here. The clock is therefore represented by the family of its spectral projections
`ℓ ↦ 1_{(-∞, ℓ]}(û)`, and likewise the area operator by `a ↦ 1_{(-∞, a]}(Â)`. A
`SpectralFamily` is such a family: orthogonal projections, increasing, strongly continuous from
the right. It is not required to increase to the identity. In the paper the clock acts on a
closed subspace `M` of `K_𝒜` (C.13) and its projections extend by zero off `M`. Here the limit
of the clock's projections is a projection on `H_ω` whose range meets `K_𝒜` in `M`. Whether `M`
contains `Ω_𝒜`, or is all of `K_𝒜`, is what H1 and H13 assert.

## What is taken as given

Four inputs deserve a warning. The first and third are register entry H16, the fourth is H17.

* `clock` lives on the whole space `H_ω`. The paper constructs the clock on the fixed-area
  space `K_𝒜` only, (4.26), (4.27), (C.11), (C.13), and then applies its spectral projection on
  `H_ω` in (5.2). How the clock acts outside `K_𝒜` is not specified in the paper. So the paper's
  construction determines only `fixedAreaDiamondSpace`, the part of `H_D` inside `K_𝒜`.
* That a spectral family exists at all for the clock presupposes that the operators of Sec 4.3
  exist as positive self-adjoint operators, that the regularized forms are closed (C.11), and
  that their monotone limit defines a self-adjoint operator on `M` (C.13).
* `commute` is asserted in the paper, in the sentence after (5.2), before (5.20) and before
  (5.21). On `K_𝒜` it follows from the other fields
  (`clock_proj_area_proj_comm_of_mem_fixedArea`), because the area is a number there. Off
  `K_𝒜` no argument is given.
* `area` is a full resolution of the identity on `H_ω`. The paper introduces `Â` as the
  generator of the corner boost acting on prepared states, (4.12) to (4.15), before `H_ω` is
  built, and applies the spectral theorem to it. That the boost is implemented on `H_ω` by a
  self-adjoint generator, for the pure extension `ω` chosen by an existence argument, is
  presupposed.

## What is not here

The algebra of observables, its representation on `H_ω`, cyclicity of `Ω_𝒜`, irreducibility
(4.17) and the Fock structure of `K_𝒜` (4.10) are not part of the structure, so (5.20) cannot
be stated on it. The regularized clocks, the vector `Ψ_L`, the auxiliary operators of (4.26)
and (5.21a), (5.21b), and the conditional probability (5.3) have no counterpart either.

## The model

`DiamondSetup.ofProjections` builds a `DiamondSetup` from two projections `Q ≤ P`: `K_𝒜` is the
range of `P`, the clock reads one value on the range of `Q` and is undefined elsewhere, and the
area takes one value on `K_𝒜` and a larger one on its complement. It shows that the fields are
mutually consistent. It is not a model of the paper's theory.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology
open scoped ComplexInnerProductSpace

/-- An increasing, right-continuous family of orthogonal projections on a Hilbert space, to be
read as `t ↦ 1_{(-∞, t]}(T)` for a self-adjoint operator `T`. The family need not increase to
the identity and need not decrease to zero; those are separate conditions. So this is weaker
than a resolution of the identity. -/
structure SpectralFamily (H : Type*) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H] where
  /-- The projection `1_{(-∞, t]}(T)`. -/
  proj : ℝ → H →L[ℂ] H
  /-- Each member is an orthogonal projection: idempotent and self-adjoint. -/
  isStarProjection : ∀ t, IsStarProjection (proj t)
  /-- The ranges increase: for `s ≤ t`, `1_{(-∞, s]} 1_{(-∞, t]} = 1_{(-∞, s]}`. -/
  proj_mul_proj_of_le : ∀ {s t : ℝ}, s ≤ t → proj s * proj t = proj s
  /-- Strong continuity from the right, which is what closing the interval at `t` means. -/
  tendsto_proj_nhdsGT : ∀ (t : ℝ) (x : H), Tendsto (fun s => proj s x) (𝓝[>] t) (𝓝 (proj t x))

namespace SpectralFamily

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- The range of `proj t`: the vectors with spectral support in `(-∞, t]`. -/
def space (F : SpectralFamily H) (t : ℝ) : Submodule ℂ H :=
  LinearMap.range (F.proj t : H →ₗ[ℂ] H)

/-- `F.Exhausts x`: the projections `proj t x` converge to `x` as `t → ∞`. Equivalently, `x`
lies in the closure of the union of the subspaces `F.space t`. -/
def Exhausts (F : SpectralFamily H) (x : H) : Prop :=
  Tendsto (fun t => F.proj t x) atTop (𝓝 x)

/-- Applying a member of the family twice is the same as applying it once. -/
theorem proj_proj (F : SpectralFamily H) (t : ℝ) (x : H) :
    F.proj t (F.proj t x) = F.proj t x := by
  have h := (F.isStarProjection t).isIdempotentElem.eq
  rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, h]

/-- For `s ≤ t`, `proj s (proj t x) = proj s x`. -/
theorem proj_proj_of_le (F : SpectralFamily H) {s t : ℝ} (h : s ≤ t) (x : H) :
    F.proj s (F.proj t x) = F.proj s x := by
  rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, F.proj_mul_proj_of_le h]

/-- The other order of `proj_mul_proj_of_le`, obtained by taking adjoints. -/
theorem proj_mul_proj_of_le' (F : SpectralFamily H) {s t : ℝ} (h : s ≤ t) :
    F.proj t * F.proj s = F.proj s := by
  have h1 := congrArg star (F.proj_mul_proj_of_le h)
  rwa [star_mul, (F.isStarProjection t).isSelfAdjoint.star_eq,
    (F.isStarProjection s).isSelfAdjoint.star_eq] at h1

/-- For `s ≤ t`, `proj t (proj s x) = proj s x`. -/
theorem proj_proj_of_le' (F : SpectralFamily H) {s t : ℝ} (h : s ≤ t) (x : H) :
    F.proj t (F.proj s x) = F.proj s x := by
  rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, F.proj_mul_proj_of_le' h]

/-- A vector is in `F.space t` exactly when `proj t` fixes it. -/
theorem mem_space_iff (F : SpectralFamily H) (t : ℝ) (x : H) :
    x ∈ F.space t ↔ F.proj t x = x := by
  rw [space, LinearMap.mem_range]
  constructor
  · rintro ⟨y, rfl⟩
    exact F.proj_proj t y
  · intro h
    exact ⟨x, h⟩

/-- Members of the family do not increase norms. -/
theorem norm_proj_apply_le (F : SpectralFamily H) (t : ℝ) (x : H) : ‖F.proj t x‖ ≤ ‖x‖ := by
  refine ((F.proj t).le_opNorm x).trans ?_
  exact mul_le_of_le_one_left (norm_nonneg x) (F.isStarProjection t).norm_le

/-- The weight `‖proj t x‖` is nondecreasing in `t`. -/
theorem norm_proj_apply_mono (F : SpectralFamily H) {s t : ℝ} (h : s ≤ t) (x : H) :
    ‖F.proj s x‖ ≤ ‖F.proj t x‖ := by
  rw [← F.proj_proj_of_le h x]
  exact F.norm_proj_apply_le s _

/-- Pythagoras for a member of the family: `‖x‖² = ‖proj t x‖² + ‖x - proj t x‖²`. -/
theorem norm_sq_eq_add (F : SpectralFamily H) (t : ℝ) (x : H) :
    ‖x‖ ^ 2 = ‖F.proj t x‖ ^ 2 + ‖x - F.proj t x‖ ^ 2 := by
  have hsa : ContinuousLinearMap.adjoint (F.proj t) = F.proj t :=
    ContinuousLinearMap.isSelfAdjoint_iff'.mp (F.isStarProjection t).isSelfAdjoint
  have h1 := ContinuousLinearMap.adjoint_inner_left (F.proj t) x (F.proj t x)
  rw [hsa, F.proj_proj] at h1
  have horth : ⟪F.proj t x, x - F.proj t x⟫ = 0 := by
    rw [inner_sub_right, h1, sub_self]
  have h := norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero _ _ horth
  have hx : F.proj t x + (x - F.proj t x) = x := by abel
  rw [hx] at h
  rw [sq, sq, sq]
  exact h

/-- The spectral family of an operator that takes the single value `c` on the range of the
projection `Q` and is undefined off it: `Q` from `c` on, zero below `c`. -/
noncomputable def ofProj (Q : H →L[ℂ] H) (hQ : IsStarProjection Q) (c : ℝ) :
    SpectralFamily H where
  proj t := if c ≤ t then Q else 0
  isStarProjection t := by
    split_ifs
    · exact hQ
    · exact IsStarProjection.zero _
  proj_mul_proj_of_le {s t} hst := by
    by_cases hs : c ≤ s
    · have ht : c ≤ t := hs.trans hst
      simp only [hs, ht, ↓reduceIte]
      exact hQ.isIdempotentElem.eq
    · simp only [hs, ↓reduceIte, zero_mul]
  tendsto_proj_nhdsGT t x := by
    by_cases ht : c ≤ t
    · refine Tendsto.congr' ?_ tendsto_const_nhds
      filter_upwards [self_mem_nhdsWithin] with s hs
      have hs' : c ≤ s := ht.trans (le_of_lt hs)
      simp only [ht, hs', ↓reduceIte]
    · refine Tendsto.congr' ?_ tendsto_const_nhds
      have hlt : t < c := not_le.mp ht
      filter_upwards [nhdsWithin_le_nhds (Iio_mem_nhds hlt)] with s hs
      have hs' : ¬c ≤ s := not_le.mpr hs
      simp only [ht, hs', ↓reduceIte]

/-- The spectral family of an operator that takes the value `A` on the range of the projection
`P` and the value `A' ≥ A` on its orthogonal complement. -/
noncomputable def twoStep (P : H →L[ℂ] H) (hP : IsStarProjection P) (A A' : ℝ)
    (hAA' : A ≤ A') : SpectralFamily H where
  proj a := if A' ≤ a then 1 else if A ≤ a then P else 0
  isStarProjection a := by
    split_ifs
    · exact IsStarProjection.one _
    · exact hP
    · exact IsStarProjection.zero _
  proj_mul_proj_of_le {s t} hst := by
    by_cases hs' : A' ≤ s
    · have ht' : A' ≤ t := hs'.trans hst
      simp only [hs', ht', ↓reduceIte, mul_one]
    · by_cases hs : A ≤ s
      · have ht : A ≤ t := hs.trans hst
        by_cases ht' : A' ≤ t
        · simp only [hs', hs, ht', ↓reduceIte, mul_one]
        · simp only [hs', hs, ht', ht, ↓reduceIte]
          exact hP.isIdempotentElem.eq
      · simp only [hs', hs, ↓reduceIte, zero_mul]
  tendsto_proj_nhdsGT t x := by
    refine Tendsto.congr' ?_ tendsto_const_nhds
    by_cases ht' : A' ≤ t
    · filter_upwards [self_mem_nhdsWithin] with s hs
      have hs' : A' ≤ s := ht'.trans (le_of_lt hs)
      simp only [ht', hs', ↓reduceIte]
    · have hlt' : t < A' := not_le.mp ht'
      by_cases ht : A ≤ t
      · filter_upwards [self_mem_nhdsWithin, nhdsWithin_le_nhds (Iio_mem_nhds hlt')]
          with s hs hs2
        have h1 : ¬A' ≤ s := not_le.mpr hs2
        have h2 : A ≤ s := ht.trans (le_of_lt hs)
        simp only [ht', ht, h1, h2, ↓reduceIte]
      · have hlt : t < A := not_le.mp ht
        filter_upwards [nhdsWithin_le_nhds (Iio_mem_nhds hlt)] with s hs
        have h2 : ¬A ≤ s := not_le.mpr hs
        have h1 : ¬A' ≤ s := fun h => h2 (hAA'.trans h)
        simp only [ht', ht, h1, h2, ↓reduceIte]

end SpectralFamily

/-- The data of Sec 5.1 and Sec 5.2 of the paper on the GNS Hilbert space `H = H_ω`: the
fixed-area subspace `K_𝒜`, the incoming Gaussian state `Ω_𝒜`, and the spectral projections of
the clock and of the area operator. See the module docstring for which fields the paper
constructs and which it only asserts. -/
structure DiamondSetup (H : Type*) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H] where
  /-- The fixed-area space `K_𝒜`, as a subspace of `H_ω`. Paper: (4.8) to (4.10); it is embedded
  isometrically in `H_ω` by the paragraph after (4.16). -/
  fixedArea : Submodule ℂ H
  /-- `K_𝒜` is a closed subspace of `H_ω`. Paper: `K_𝒜` is defined as a completion, in the
  sentence after (4.8), and its embedding in `H_ω` preserves inner products. -/
  isClosed_fixedArea : IsClosed (fixedArea : Set H)
  /-- The corner area `𝒜` of the fixed-area sector. -/
  area₀ : ℝ
  /-- Paper: `𝒜 = 4π b²` with `b ≫ ℓ_P`, Sec 5.1; "at positive corner area", App C.2. -/
  area₀_pos : 0 < area₀
  /-- The cap parameter `ε`: each null generator runs from `v = ε` to `v = 1` (3.27). Paper:
  fixed with `0 < ε < 1` in the sentence after (3.18). -/
  ε : ℝ
  /-- `0 < ε`. -/
  ε_pos : 0 < ε
  /-- `ε < 1`. -/
  ε_lt_one : ε < 1
  /-- The incoming Gaussian state `Ω_𝒜`. Paper: (4.7). In Sec 5.1 it is the Gaussian centred on
  spherically symmetric data with `𝒜 = 4π b²`. Only that it is a unit vector of `K_𝒜` is
  recorded here. -/
  Ω : H
  /-- `Ω_𝒜` lies in `K_𝒜`. Paper: (4.7), (4.8). -/
  Ω_mem : Ω ∈ fixedArea
  /-- `Ω_𝒜` is normalized. Paper: "normalizing each factor yields" (4.7). -/
  norm_Ω : ‖Ω‖ = 1
  /-- The spectral projections `ℓ ↦ 1_{[0, ℓ]}(û)` of the clock, on `H_ω`. Paper: (5.2) with
  (4.26), (4.27), (C.11), (C.13). The paper constructs the clock on `K_𝒜` only; see the module
  docstring. -/
  clock : SpectralFamily H
  /-- The clock has no readings below zero. Paper: the focusing term (4.22) is nonnegative,
  (4.27) is a squared norm, and the interval in (5.2) starts at `0`. -/
  clock_proj_of_neg : ∀ t < 0, clock.proj t = 0
  /-- The clock maps `K_𝒜` to itself. Paper: "Each factor in (4.26) acts within `K_𝒜`, so the
  clock preserves the corner area on incoming wavefunctions". -/
  clock_proj_mem : ∀ (t : ℝ), ∀ x ∈ fixedArea, clock.proj t x ∈ fixedArea
  /-- The spectral projections `a ↦ 1_{(-∞, a]}(Â)` of the area operator, on `H_ω`. Paper:
  (4.12) to (4.15), where the spectral theorem is applied to `Â`. That `Â` is a self-adjoint
  operator on `H_ω` is presupposed there; see the module docstring. -/
  area : SpectralFamily H
  /-- The spectral projections of `Â` increase to the identity. Paper: the intervals in (4.15)
  cover the spectrum. -/
  area_exhausts : ∀ x : H, area.Exhausts x
  /-- The spectral projections of `Â` decrease to zero at `-∞`. Same source as
  `area_exhausts`. Positivity of `Â` is not assumed here: the lower bound in (5.21d) is part of
  hypothesis H14. -/
  area_tendsto_atBot : ∀ x : H, Tendsto (fun a => area.proj a x) atBot (𝓝 0)
  /-- The clock commutes with the area operator. Paper: asserted in the sentence after (5.2),
  before (5.20) and before (5.21). -/
  commute : ∀ t a : ℝ, Commute (clock.proj t) (area.proj a)
  /-- Vectors of `K_𝒜` have no area below `𝒜`. Paper: "Every occupation number state in
  (4.10a) has corner area `𝒜`"; `Â = 𝒜 1` before (4.24). -/
  area_proj_of_lt : ∀ a < area₀, ∀ x ∈ fixedArea, area.proj a x = 0
  /-- Vectors of `K_𝒜` have no area above `𝒜`. Same source as `area_proj_of_lt`. -/
  area_proj_area₀ : ∀ x ∈ fixedArea, area.proj area₀ x = x

namespace DiamondSetup

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- The projection `P_D = 1_{[0, ℓ]}(û)` for a causal diamond of maximum clock reading
`ℓ = ℓ(D)`. Paper: (5.2). -/
def diamondProj (S : DiamondSetup H) (ℓ : ℝ) : H →L[ℂ] H :=
  S.clock.proj ℓ

/-- The Hilbert space `H_D = P_D H_ω` of a causal diamond of maximum clock reading `ℓ`.
Paper: (5.1). Outside `K_𝒜` it depends on how the clock is extended to `H_ω`, which the paper
does not specify. -/
def diamondSpace (S : DiamondSetup H) (ℓ : ℝ) : Submodule ℂ H :=
  S.clock.space ℓ

/-- The part of `H_D` inside the fixed-area space: `P_D(𝒜) K_𝒜`. Paper: App C.3, after (C.20)
and after (C.22). This is the part that the paper's construction of the clock determines. -/
def fixedAreaDiamondSpace (S : DiamondSetup H) (ℓ : ℝ) : Submodule ℂ H :=
  S.diamondSpace ℓ ⊓ S.fixedArea

/-- The largest area allowed by a maximum clock reading `ℓ`: `4π ℓ² / (1 - ε)²`.
Paper: (5.21d). -/
noncomputable def areaBound (S : DiamondSetup H) (ℓ : ℝ) : ℝ :=
  4 * Real.pi * ℓ ^ 2 / (1 - S.ε) ^ 2

/-- The paper's lower bound on the clock reading at area `𝒜`: `(1 - ε) (𝒜 / 4π)^(1/2)`.
Paper: footnote 8 and (5.21c). The classical clock attains it at zero shear and uniform area
density (the last sentence of App D.3). The paper does not claim the quantum clock attains
it. -/
noncomputable def clockLowerBound (S : DiamondSetup H) : ℝ :=
  (1 - S.ε) * Real.sqrt (S.area₀ / (4 * Real.pi))

/-- A vector is in `H_D` exactly when `P_D` fixes it. -/
theorem mem_diamondSpace_iff (S : DiamondSetup H) (ℓ : ℝ) (x : H) :
    x ∈ S.diamondSpace ℓ ↔ S.diamondProj ℓ x = x :=
  S.clock.mem_space_iff ℓ x

/-- `P_D` maps into `H_D`. -/
theorem diamondProj_apply_mem (S : DiamondSetup H) (ℓ : ℝ) (x : H) :
    S.diamondProj ℓ x ∈ S.diamondSpace ℓ :=
  (S.mem_diamondSpace_iff ℓ _).mpr (S.clock.proj_proj ℓ x)

/-- A larger maximum reading gives a larger diamond space. -/
theorem diamondSpace_mono (S : DiamondSetup H) {ℓ ℓ' : ℝ} (h : ℓ ≤ ℓ') :
    S.diamondSpace ℓ ≤ S.diamondSpace ℓ' := by
  intro x hx
  rw [mem_diamondSpace_iff] at hx ⊢
  have h1 : S.clock.proj ℓ' (S.clock.proj ℓ x) = S.clock.proj ℓ x :=
    S.clock.proj_proj_of_le' h x
  have h2 : S.clock.proj ℓ x = x := hx
  change S.clock.proj ℓ' x = x
  rw [← h2, h1]

/-- `fixedAreaDiamondSpace` is the image of `K_𝒜` under `P_D`, which is how App C.3 writes it,
`P_D(𝒜) K_𝒜`. The identification uses that the clock maps `K_𝒜` to itself. -/
theorem fixedAreaDiamondSpace_eq_map (S : DiamondSetup H) (ℓ : ℝ) :
    S.fixedAreaDiamondSpace ℓ = Submodule.map (S.clock.proj ℓ : H →ₗ[ℂ] H) S.fixedArea := by
  ext x
  simp only [fixedAreaDiamondSpace, Submodule.mem_inf, Submodule.mem_map]
  constructor
  · rintro ⟨hxD, hxK⟩
    exact ⟨x, hxK, (S.mem_diamondSpace_iff ℓ x).mp hxD⟩
  · rintro ⟨y, hyK, rfl⟩
    exact ⟨S.diamondProj_apply_mem ℓ y, S.clock_proj_mem ℓ y hyK⟩

/-- The two constants are consistent: the largest area allowed by the reading
`clockLowerBound` is `𝒜`. -/
theorem areaBound_clockLowerBound (S : DiamondSetup H) :
    S.areaBound S.clockLowerBound = S.area₀ := by
  have hε : (1 - S.ε) ≠ 0 := (sub_pos.mpr S.ε_lt_one).ne'
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hA : 0 ≤ S.area₀ / (4 * Real.pi) :=
    div_nonneg S.area₀_pos.le (mul_nonneg (by norm_num) Real.pi_pos.le)
  unfold areaBound clockLowerBound
  rw [mul_pow, Real.sq_sqrt hA]
  field_simp

/-- On `K_𝒜` the clock and area projections commute. The proof uses only `clock_proj_mem`,
`area_proj_of_lt` and `area_proj_area₀`, not the field `commute`: the area is a number on
`K_𝒜`. So `commute` has content only off `K_𝒜`. -/
theorem clock_proj_area_proj_comm_of_mem_fixedArea (S : DiamondSetup H) (t a : ℝ) {x : H}
    (hx : x ∈ S.fixedArea) :
    S.clock.proj t (S.area.proj a x) = S.area.proj a (S.clock.proj t x) := by
  have key : ∀ y ∈ S.fixedArea, S.area₀ ≤ a → S.area.proj a y = y := by
    intro y hy ha
    have h1 := S.area.proj_proj_of_le' ha y
    rwa [S.area_proj_area₀ y hy] at h1
  by_cases ha : a < S.area₀
  · rw [S.area_proj_of_lt a ha x hx, S.area_proj_of_lt a ha _ (S.clock_proj_mem t x hx),
      map_zero]
  · have ha' : S.area₀ ≤ a := not_lt.mp ha
    rw [key x hx ha', key _ (S.clock_proj_mem t x hx) ha']

/-- A model of `DiamondSetup` from two projections `Q ≤ P` on any Hilbert space with a unit
vector `Ω` in the range of `P`. `K_𝒜` is the range of `P`. The clock reads `u₀ ≥ 0` on the
range of `Q` and is undefined elsewhere. The area is `A > 0` on `K_𝒜` and `A' > A` on its
complement. It shows the fields of `DiamondSetup` are consistent. It is not a model of the
paper's theory. -/
noncomputable def ofProjections (P Q : H →L[ℂ] H) (hP : IsStarProjection P)
    (hQ : IsStarProjection Q) (hQP : Q * P = Q) (Ω : H) (hΩ : ‖Ω‖ = 1) (hPΩ : P Ω = Ω)
    (A A' u₀ ε : ℝ) (hA : 0 < A) (hAA' : A < A') (hu₀ : 0 ≤ u₀) (hε : 0 < ε) (hε' : ε < 1) :
    DiamondSetup H where
  fixedArea := LinearMap.range (P : H →ₗ[ℂ] H)
  isClosed_fixedArea := by
    have h : ((LinearMap.range (P : H →ₗ[ℂ] H) : Submodule ℂ H) : Set H) = {x | P x = x} := by
      ext x
      simp only [SetLike.mem_coe, LinearMap.mem_range, Set.mem_ofPred_eq]
      constructor
      · rintro ⟨y, rfl⟩
        change P (P y) = P y
        rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def,
          hP.isIdempotentElem.eq]
      · intro h
        exact ⟨x, h⟩
    rw [h]
    exact isClosed_eq P.continuous continuous_id
  area₀ := A
  area₀_pos := hA
  ε := ε
  ε_pos := hε
  ε_lt_one := hε'
  Ω := Ω
  Ω_mem := LinearMap.mem_range.mpr ⟨Ω, hPΩ⟩
  norm_Ω := hΩ
  clock := SpectralFamily.ofProj Q hQ u₀
  clock_proj_of_neg t ht := by
    have h : ¬u₀ ≤ t := not_le.mpr (ht.trans_le hu₀)
    simp only [SpectralFamily.ofProj, h, ↓reduceIte]
  clock_proj_mem t x _ := by
    by_cases h : u₀ ≤ t
    · have hPQ : P * Q = Q := by
        have h1 := congrArg star hQP
        rwa [star_mul, hP.isSelfAdjoint.star_eq, hQ.isSelfAdjoint.star_eq] at h1
      simp only [SpectralFamily.ofProj, h, ↓reduceIte]
      refine LinearMap.mem_range.mpr ⟨Q x, ?_⟩
      change P (Q x) = Q x
      rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, hPQ]
    · simp only [SpectralFamily.ofProj, h, ↓reduceIte, zero_apply]
      exact Submodule.zero_mem _
  area := SpectralFamily.twoStep P hP A A' hAA'.le
  area_exhausts x := by
    refine Tendsto.congr' ?_ tendsto_const_nhds
    filter_upwards [eventually_ge_atTop A'] with a ha
    simp [SpectralFamily.twoStep, ha]
  area_tendsto_atBot x := by
    refine Tendsto.congr' ?_ tendsto_const_nhds
    filter_upwards [eventually_lt_atBot A] with a ha
    have h1 : ¬A ≤ a := not_le.mpr ha
    have h2 : ¬A' ≤ a := fun h => h1 (hAA'.le.trans h)
    simp [SpectralFamily.twoStep, h1, h2]
  commute t a := by
    have hPQ : P * Q = Q := by
      have h1 := congrArg star hQP
      rwa [star_mul, hP.isSelfAdjoint.star_eq, hQ.isSelfAdjoint.star_eq] at h1
    have hcomm : Commute Q P := by
      rw [Commute, SemiconjBy, hQP, hPQ]
    by_cases ht : u₀ ≤ t
    · by_cases ha' : A' ≤ a
      · simp only [SpectralFamily.ofProj, SpectralFamily.twoStep, ht, ha', ↓reduceIte]
        exact Commute.one_right Q
      · by_cases ha : A ≤ a
        · simp only [SpectralFamily.ofProj, SpectralFamily.twoStep, ht, ha', ha, ↓reduceIte]
          exact hcomm
        · simp only [SpectralFamily.ofProj, SpectralFamily.twoStep, ht, ha', ha, ↓reduceIte]
          exact Commute.zero_right Q
    · simp only [SpectralFamily.ofProj, ht, ↓reduceIte]
      exact Commute.zero_left _
  area_proj_of_lt a ha x _ := by
    have h1 : ¬A ≤ a := not_le.mpr ha
    have h2 : ¬A' ≤ a := fun h => h1 (hAA'.le.trans h)
    simp [SpectralFamily.twoStep, h1, h2]
  area_proj_area₀ x hx := by
    obtain ⟨y, rfl⟩ := hx
    have h2 : ¬A' ≤ A := not_le.mpr hAA'
    simp only [SpectralFamily.twoStep, h2, le_refl, ↓reduceIte]
    change P (P y) = P y
    rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def,
      hP.isIdempotentElem.eq]

end DiamondSetup

end QuantGrav
