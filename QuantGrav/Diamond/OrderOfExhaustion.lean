/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.InnerProductSpace.l2Space
public import Mathlib.Analysis.Real.Sqrt
public import Mathlib.Logic.Equiv.Bool
import QuantGrav.OperatorAlgebra.CutSums
import Mathlib.Order.Filter.AtTopBot.Archimedean
import Mathlib.Order.Filter.AtTopBot.Field
import Mathlib.Order.Filter.AtTopBot.Finset
import Mathlib.Tactic.Ring
import Mathlib.Tactic.SplitIfs

/-!
# Order of exhaustion: open gluing does not determine the closed amplitude (H3b)

Paper: arXiv:2611.34924v1, (4.29), (4.30), (5.31), (5.37a), (5.37b), (5.38).

This file is a model. It shows that closed partial sums over cuts depend on the order in which
the cut exhausts the basis. The open-gluing statements (4.29), (4.30) are proved in
`QuantGrav/OperatorAlgebra/CutSums.lean` for bounded operators on any Hilbert space, so they
hold in the model. Hence they do not determine the closed amplitude. That the closed partial
sums converge to the uncut amplitude is register entry H3b.

Notation. For a Hilbert basis `b`, a finite set `P` of its labels (the cut) and bounded
operators `C`, `A`, `B`,
`closedAmplitude b C A B P = ∑_{i,j ∈ P} ⟨C b_i, A C b_j⟩ · conj ⟨b_i, B b_j⟩`.
This is the numerator of the paper's (5.31) for a product observable `A ⊗ B̄`: `A` acts on the
copy prepared by `C`, and the time-reflected copy carries complex-conjugate matrix elements.
With no insertion it is the partial trace `∑_{i ∈ P} ‖C b_i‖²`, the denominator of (5.31)
(`closedAmplitude_one`).

The model. `H` has a Hilbert basis `b` indexed by `ℕ × Bool`: two countable orthonormal
families, `(k, false)` and `(k, true)`. `basisFlip b` is the unitary `F` that swaps them,
`F b (k, a) = b (k, !a)`. The preparation is `C = √w · 1`, so the weight is `C† C = w`. The
insertion is `δ F ⊗ F̄ - δ/2`, standing in for `X = Δ_η O - δ_η/2` of (5.37a), and
`flipCutAmplitude b w δ r n` is its closed amplitude, as in (5.38), on the cut
`twoFamilyCut r n`: the first `r` labels of the first family and the first `n` of the second.
A pair of labels `i`, `j` of the cut contributes `w` to the `F ⊗ F̄` term if `i` is the partner
of `j`, and `0` otherwise (`closedAmplitude_basisFlip`). For `n ≤ r` exactly `2 n` labels of
the cut have their partner in the cut (`card_filter_partner_mem_twoFamilyCut`), and the cut has
`r + n` labels (`card_twoFamilyCut`). So the closed amplitude is
`δ · 2 w n - (δ/2) · w (r + n) = (w δ / 2) (3 n - r)`.
The response on the cut, standing in for `⟨Δ_η O⟩_P` of (5.37b), is `flipCutResponse b w δ r n`:
the closed amplitude of `δ F ⊗ F̄` divided by the partial trace, `2 n δ / (r + n)`.

A sequence of cuts `P 0, P 1, …` is an increasing exhaustion (`IsIncreasingExhaustion`) if
`P m ⊆ P n` for `m ≤ n` and every label lies in some `P n`. The paper's cuts grow in this way:
they are finite unions of cycles of basis labels, and the paragraph that supposes `H_D` infinite
dimensional, two paragraphs before (5.37), states that `P → 1` strongly as the cycles are
included.

Results.

* `IsIncreasingExhaustion.tendsto_sum_inner_smul`: along an increasing exhaustion the cut
  projections `x ↦ ∑_{i ∈ P n} ⟨b_i, x⟩ b_i` converge strongly to the identity.
* `IsIncreasingExhaustion.tendsto_open_cut_sum`: along an increasing exhaustion the open cut
  sums of (4.29) converge to the uncut matrix element. The limit does not depend on the
  exhaustion.
* `flipCutAmplitude_eq`: for `n ≤ r` the closed amplitude is `(w δ / 2) (3 n - r)`.
* `flipCutAmplitude_five_limits`: along the routes `(r, n) = (n, n)`, `(3 n + 1, n + 1)`,
  `(3 n, n)`, `(3 n + 2, n)` and `(7 n, n)` the closed amplitude tends to `+∞`, equals `w δ`,
  equals `0`, equals `-(w δ)`, and tends to `-∞`.
* `isIncreasingExhaustion_five_routes`: each of these five routes is an increasing exhaustion.
  So the first two results apply to all five.
* `flipCutResponse_eq`, `flipCutAmplitude_eq_trace_mul`: on a nonempty cut with `n ≤ r` the
  response is `2 n δ / (r + n)`, and the closed amplitude has the form of (5.38), the partial
  trace times the response minus `δ / 2`.
* `abs_flipCutResponse_le_iff`: the paper's condition (5.37b) on a cut, `|⟨Δ_η O⟩_P| ≤ δ_η / 2`,
  holds exactly when `3 n ≤ r`. So the nonempty cuts of the last three routes satisfy it, and
  their closed amplitudes are `0`, `-(w δ)` and tending to `-∞`. Those of the first two routes
  do not satisfy it.

The margin. (5.37b) as displayed is not strict, and the three routes meet it differently. The
route `(3 n, n)` has response exactly `δ / 2`. The route `(3 n + 2, n)` has response
`2 n δ / (4 n + 2)`, which tends to `δ / 2`. Only the route `(7 n, n)` stays a fixed distance
below the threshold, with response `δ / 4`. The paper's own cuts have a bound strictly below
`δ_η / 2` that is the same for every cut (the sentence after (D.25)), and for cuts with such a
margin `tendsto_cut_amplitude_atBot` of `QuantGrav/Diamond/ClosedCuts.lean` gives the limit
`-∞` in every order. So the dependence on the order shown by the five routes is among cuts that
have no uniform margin or that violate (5.37b). It does not occur among cuts built as the paper
builds them.

If the first family is read as the states inside the paper's narrow area interval and the second
as the states outside it, then `twoFamilyCut (3 n) n` and `twoFamilyCut (7 n) n` are unions of
`n` cycles of lengths `4` and `8` in the sense of that paragraph: each cycle has one label
outside the interval. Length `4` is the boundary case; the paper takes the cycle length as
large as its bound needs. This reading is not part of any formal statement.

In the model there is no uncut amplitude for the partial sums to converge to: `C† C = w` has
infinite trace. The model shows that, without a uniform margin, the closed partial sums have no
limit independent of the exhaustion. It does not say which hypothesis fails in the paper's own
setting.

The model is a simplification of one described in an external audit of the paper; see
`notes/external-audits-2026-11-26.md`, section 1.2 A. There the insertion arises from a boost.
Here `δ F ⊗ F̄ - δ/2` is put in directly. The model does not realise the paper's dynamics or
constraints.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology
open scoped ComplexInnerProductSpace

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- The closed amplitude over a finite cut `P` of basis labels with a product insertion
`A ⊗ B̄`: `∑_{i,j ∈ P} ⟨C b_i, A C b_j⟩ · conj ⟨b_i, B b_j⟩`. -/
noncomputable def closedAmplitude {ι K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K]
    (b : HilbertBasis ι ℂ H) (C : H →L[ℂ] K) (A : K →L[ℂ] K) (B : H →L[ℂ] H)
    (P : Finset ι) : ℂ :=
  ∑ i ∈ P, ∑ j ∈ P, ⟪C (b i), A (C (b j))⟫ * (starRingEnd ℂ) ⟪b i, B (b j)⟫

omit [CompleteSpace H] in
/-- With no insertion the closed amplitude is the partial trace. -/
theorem closedAmplitude_one {ι K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K]
    (b : HilbertBasis ι ℂ H) (C : H →L[ℂ] K) (P : Finset ι) :
    closedAmplitude b C 1 1 P = ((∑ i ∈ P, ‖C (b i)‖ ^ 2 : ℝ) : ℂ) := by
  classical
  have hterm : ∀ i j : ι, ⟪C (b i), (1 : K →L[ℂ] K) (C (b j))⟫
      * (starRingEnd ℂ) ⟪b i, (1 : H →L[ℂ] H) (b j)⟫
      = if i = j then ⟪C (b i), C (b i)⟫ else 0 := by
    intro i j
    rw [one_apply_eq_self, one_apply_eq_self, orthonormal_iff_ite.mp b.orthonormal i j]
    split_ifs with hij
    · rw [hij, map_one, mul_one]
    · rw [map_zero, mul_zero]
  unfold closedAmplitude
  rw [Complex.ofReal_sum]
  refine Finset.sum_congr rfl fun i hi => ?_
  rw [Finset.sum_congr rfl fun j _ => hterm i j, Finset.sum_ite_eq, ite_eq_left hi,
    inner_self_eq_norm_sq_to_K, Complex.ofReal_pow]
  rfl

/-- A sequence of finite cuts is an increasing exhaustion if it is increasing and every label
lies in some cut. -/
def IsIncreasingExhaustion {ι : Type*} (P : ℕ → Finset ι) : Prop :=
  Monotone P ∧ ∀ i, ∃ n, i ∈ P n

/-- An increasing exhaustion eventually contains every finite set of labels. -/
theorem IsIncreasingExhaustion.tendsto_atTop {ι : Type*} {P : ℕ → Finset ι}
    (hP : IsIncreasingExhaustion P) : Tendsto P atTop atTop :=
  tendsto_atTop_finset_of_monotone hP.1 hP.2

omit [CompleteSpace H] in
/-- Along an increasing exhaustion the cut projections converge strongly to the identity:
`∑_{i ∈ P n} ⟨b_i, x⟩ b_i → x`. -/
theorem IsIncreasingExhaustion.tendsto_sum_inner_smul {ι : Type*} {P : ℕ → Finset ι}
    (hP : IsIncreasingExhaustion P) (b : HilbertBasis ι ℂ H) (x : H) :
    Tendsto (fun n => ∑ i ∈ P n, ⟪b i, x⟫ • b i) atTop (𝓝 x) := by
  have h : HasSum (fun i => ⟪b i, x⟫ • b i) x := by
    simpa only [b.repr_apply_apply] using b.hasSum_repr x
  exact h.comp hP.tendsto_atTop

/-- Open gluing along an increasing exhaustion, paper (4.29): for bounded `U₁`, `U₂` the open
cut sums converge to the uncut matrix element `⟨φ, U₂ U₁ ψ⟩`. The limit is the same for every
increasing exhaustion. -/
theorem IsIncreasingExhaustion.tendsto_open_cut_sum {ι H₁ H₂ : Type*} [NormedAddCommGroup H₁]
    [InnerProductSpace ℂ H₁] [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [CompleteSpace H₂]
    {P : ℕ → Finset ι} (hP : IsIncreasingExhaustion P) (b : HilbertBasis ι ℂ H)
    (U₁ : H₁ →L[ℂ] H) (U₂ : H →L[ℂ] H₂) (φ : H₂) (ψ : H₁) :
    Tendsto (fun n => ∑ i ∈ P n, ⟪φ, U₂ (b i)⟫ * ⟪b i, U₁ ψ⟫) atTop (𝓝 ⟪φ, U₂ (U₁ ψ)⟫) :=
  (hasSum_inner_cut b U₁ U₂ φ ψ).comp hP.tendsto_atTop

/-- The cut with the first `r` labels of the first family and the first `n` of the second. -/
def twoFamilyCut (r n : ℕ) : Finset (ℕ × Bool) :=
  (Finset.range r ×ˢ {false}) ∪ (Finset.range n ×ˢ {true})

/-- Membership in `twoFamilyCut`. -/
theorem mem_twoFamilyCut {r n k : ℕ} {a : Bool} :
    (k, a) ∈ twoFamilyCut r n ↔ (a = false ∧ k < r) ∨ (a = true ∧ k < n) := by
  simp only [twoFamilyCut, Finset.mem_union, Finset.mem_product, Finset.mem_range,
    Finset.mem_singleton, and_comm]

/-- `twoFamilyCut` is increasing in both sizes. -/
theorem twoFamilyCut_subset {r r' n n' : ℕ} (hr : r ≤ r') (hn : n ≤ n') :
    twoFamilyCut r n ⊆ twoFamilyCut r' n' := by
  rintro ⟨k, a⟩ h
  rw [mem_twoFamilyCut] at h ⊢
  rcases h with ⟨ha, hk⟩ | ⟨ha, hk⟩
  · exact Or.inl ⟨ha, hk.trans_le hr⟩
  · exact Or.inr ⟨ha, hk.trans_le hn⟩

/-- The cuts `twoFamilyCut (r n) (s n)` form an increasing exhaustion when `r` and `s` are
increasing, `s n ≤ r n`, and `s` is unbounded. -/
theorem isIncreasingExhaustion_twoFamilyCut {r s : ℕ → ℕ} (hr : Monotone r) (hs : Monotone s)
    (hrs : ∀ n, s n ≤ r n) (hunb : ∀ k, ∃ n, k < s n) :
    IsIncreasingExhaustion fun n => twoFamilyCut (r n) (s n) := by
  refine ⟨fun m n hmn => twoFamilyCut_subset (hr hmn) (hs hmn), ?_⟩
  rintro ⟨k, a⟩
  obtain ⟨n, hn⟩ := hunb k
  refine ⟨n, mem_twoFamilyCut.mpr ?_⟩
  cases a
  · exact Or.inl ⟨rfl, hn.trans_le (hrs n)⟩
  · exact Or.inr ⟨rfl, hn⟩

/-- A sum over `twoFamilyCut r n` is the sum over the first `r` labels of the first family plus
the sum over the first `n` labels of the second. -/
theorem sum_twoFamilyCut {M : Type*} [AddCommMonoid M] (r n : ℕ) (f : ℕ × Bool → M) :
    ∑ i ∈ twoFamilyCut r n, f i
      = ∑ k ∈ Finset.range r, f (k, false) + ∑ k ∈ Finset.range n, f (k, true) := by
  have hdisj : Disjoint (Finset.range r ×ˢ ({false} : Finset Bool))
      (Finset.range n ×ˢ ({true} : Finset Bool)) := by
    rw [Finset.disjoint_left]
    rintro ⟨k, a⟩ h₁ h₂
    rw [Finset.mem_product, Finset.mem_singleton] at h₁ h₂
    exact Bool.false_ne_true (h₁.2.symm.trans h₂.2)
  rw [twoFamilyCut, Finset.sum_union hdisj, Finset.sum_product, Finset.sum_product]
  simp only [Finset.sum_singleton]

/-- The cut `twoFamilyCut r n` has `r + n` labels. -/
theorem card_twoFamilyCut (r n : ℕ) : (twoFamilyCut r n).card = r + n := by
  rw [Finset.card_eq_sum_ones, sum_twoFamilyCut, Finset.sum_const, Finset.sum_const,
    Finset.card_range, Finset.card_range, smul_eq_mul, smul_eq_mul, mul_one, mul_one]

/-- For `n ≤ r`, the labels of `twoFamilyCut r n` whose partner in the other family is also in
the cut are the first `n` labels of each family. -/
theorem filter_partner_mem_twoFamilyCut {r n : ℕ} (hnr : n ≤ r) :
    {j ∈ twoFamilyCut r n | (j.1, !j.2) ∈ twoFamilyCut r n} = twoFamilyCut n n := by
  ext ⟨k, a⟩
  rw [Finset.mem_filter, mem_twoFamilyCut, mem_twoFamilyCut, mem_twoFamilyCut]
  cases a
  · simp only [Bool.not_false, true_and, false_and, or_false, false_or, reduceCtorEq]
    omega
  · simp only [Bool.not_true, true_and, false_and, or_false, false_or, reduceCtorEq]
    omega

/-- For `n ≤ r`, exactly `2 n` labels of `twoFamilyCut r n` have their partner in the other
family also in the cut. -/
theorem card_filter_partner_mem_twoFamilyCut {r n : ℕ} (hnr : n ≤ r) :
    ({j ∈ twoFamilyCut r n | (j.1, !j.2) ∈ twoFamilyCut r n}).card = 2 * n := by
  rw [filter_partner_mem_twoFamilyCut hnr, card_twoFamilyCut, two_mul]

/-- The unitary that swaps the two families of a Hilbert basis indexed by `ℕ × Bool`. -/
noncomputable def basisFlip (b : HilbertBasis (ℕ × Bool) ℂ H) : H →L[ℂ] H :=
  LinearIsometry.toContinuousLinearMap (LinearIsometryEquiv.toLinearIsometry
    (b.repr.trans (b.reindex (Equiv.prodCongr (Equiv.refl ℕ) Equiv.boolNot)).repr.symm))

/-- `basisFlip` sends `b (k, a)` to `b (k, !a)`. -/
theorem basisFlip_apply (b : HilbertBasis (ℕ × Bool) ℂ H) (k : ℕ) (a : Bool) :
    basisFlip b (b (k, a)) = b (k, !a) := by
  change (b.reindex (Equiv.prodCongr (Equiv.refl ℕ) Equiv.boolNot)).repr.symm
    (b.repr (b (k, a))) = b (k, !a)
  rw [b.repr_self, HilbertBasis.repr_symm_single, HilbertBasis.reindex_apply]
  rfl

/-- The matrix elements of `basisFlip b` in the basis `b`: `⟨b_i, F b_j⟩` is `1` if `i` is the
partner of `j` in the other family, and `0` otherwise. -/
theorem inner_basisFlip (b : HilbertBasis (ℕ × Bool) ℂ H) (i j : ℕ × Bool) :
    ⟪b i, basisFlip b (b j)⟫ = if i = (j.1, !j.2) then 1 else 0 := by
  obtain ⟨k, a⟩ := j
  rw [basisFlip_apply]
  exact orthonormal_iff_ite.mp b.orthonormal i (k, !a)

/-- With weight `W = w` and insertion `F ⊗ F̄`, the closed amplitude over a cut `P` is `w` times
the number of labels of `P` whose partner is also in `P`. -/
theorem closedAmplitude_basisFlip (b : HilbertBasis (ℕ × Bool) ℂ H) {w : ℝ} (hw : 0 ≤ w)
    (P : Finset (ℕ × Bool)) :
    closedAmplitude b (((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (basisFlip b) (basisFlip b) P
      = ((w * ({j ∈ P | (j.1, !j.2) ∈ P}).card : ℝ) : ℂ) := by
  have hterm : ∀ i j : ℕ × Bool,
      ⟪(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i),
          basisFlip b ((((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b j))⟫
        * (starRingEnd ℂ) ⟪b i, basisFlip b (b j)⟫
      = if i = (j.1, !j.2) then (w : ℂ) else 0 := by
    intro i j
    rw [smul_apply, smul_apply, one_apply_eq_self, one_apply_eq_self, map_smul, inner_smul_left,
      inner_smul_right, inner_basisFlip, Complex.conj_ofReal]
    split_ifs with hij
    · rw [map_one, mul_one, mul_one, ← Complex.ofReal_mul, Real.mul_self_sqrt hw]
    · rw [map_zero, mul_zero]
  unfold closedAmplitude
  calc ∑ i ∈ P, ∑ j ∈ P,
        ⟪(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i),
            basisFlip b ((((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b j))⟫
          * (starRingEnd ℂ) ⟪b i, basisFlip b (b j)⟫
      = ∑ i ∈ P, ∑ j ∈ P, if i = (j.1, !j.2) then (w : ℂ) else 0 :=
        Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => hterm i j
    _ = ∑ j ∈ P, ∑ i ∈ P, if i = (j.1, !j.2) then (w : ℂ) else 0 := Finset.sum_comm
    _ = ∑ j ∈ P, if (j.1, !j.2) ∈ P then (w : ℂ) else 0 :=
        Finset.sum_congr rfl fun j _ => Finset.sum_ite_eq' P (j.1, !j.2) fun _ => (w : ℂ)
    _ = ((w * ({j ∈ P | (j.1, !j.2) ∈ P}).card : ℝ) : ℂ) := by
        rw [← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul, Complex.ofReal_mul,
          Complex.ofReal_natCast, mul_comm]

omit [CompleteSpace H] in
/-- With weight `W = w`, the partial trace over a cut `P` is `w` times the number of labels. -/
theorem sum_sq_norm_sqrt_smul_one (b : HilbertBasis (ℕ × Bool) ℂ H) {w : ℝ} (hw : 0 ≤ w)
    (P : Finset (ℕ × Bool)) :
    ∑ i ∈ P, ‖(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i)‖ ^ 2 = w * P.card := by
  have hterm : ∀ i : ℕ × Bool,
      ‖(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i)‖ ^ 2 = w := by
    intro i
    rw [smul_apply, one_apply_eq_self, norm_smul, b.orthonormal.1 i, mul_one, Complex.norm_real,
      Real.norm_eq_abs, sq_abs, Real.sq_sqrt hw]
  rw [Finset.sum_congr rfl fun i _ => hterm i, Finset.sum_const, nsmul_eq_mul, mul_comm]

/-- The closed amplitude of the model: weight `W = w`, insertion `δ F ⊗ F̄ - δ/2`, on the cut
`twoFamilyCut r n`. -/
noncomputable def flipCutAmplitude (b : HilbertBasis (ℕ × Bool) ℂ H) (w δ : ℝ) (r n : ℕ) : ℝ :=
  δ * (closedAmplitude b (((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (basisFlip b)
      (basisFlip b) (twoFamilyCut r n)).re
    - δ / 2 * ∑ i ∈ twoFamilyCut r n, ‖(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i)‖ ^ 2

/-- For `n ≤ r` the model's closed amplitude is `(w δ / 2) (3 n - r)`. -/
theorem flipCutAmplitude_eq (b : HilbertBasis (ℕ × Bool) ℂ H) {w : ℝ} (hw : 0 ≤ w) (δ : ℝ)
    {r n : ℕ} (hnr : n ≤ r) : flipCutAmplitude b w δ r n = w * δ / 2 * (3 * (n : ℝ) - r) := by
  unfold flipCutAmplitude
  rw [closedAmplitude_basisFlip b hw, Complex.ofReal_re, sum_sq_norm_sqrt_smul_one b hw,
    card_filter_partner_mem_twoFamilyCut hnr, card_twoFamilyCut]
  push_cast
  ring

/-- The response of the model on the cut `twoFamilyCut r n`, standing in for `⟨Δ_η O⟩_P` of
(5.37b): the closed amplitude of `δ F ⊗ F̄` divided by the partial trace, as in (5.31). -/
noncomputable def flipCutResponse (b : HilbertBasis (ℕ × Bool) ℂ H) (w δ : ℝ) (r n : ℕ) : ℝ :=
  δ * (closedAmplitude b (((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (basisFlip b)
      (basisFlip b) (twoFamilyCut r n)).re
    / ∑ i ∈ twoFamilyCut r n, ‖(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i)‖ ^ 2

/-- For `n ≤ r` and a nonempty cut the model's response is `2 n δ / (r + n)`. -/
theorem flipCutResponse_eq (b : HilbertBasis (ℕ × Bool) ℂ H) {w : ℝ} (hw : 0 < w) (δ : ℝ)
    {r n : ℕ} (hnr : n ≤ r) (hr : 0 < r) :
    flipCutResponse b w δ r n = 2 * n * δ / (r + n) := by
  have hw' : w ≠ 0 := hw.ne'
  have hrn : (r : ℝ) + n ≠ 0 := by positivity
  unfold flipCutResponse
  rw [closedAmplitude_basisFlip b hw.le, Complex.ofReal_re, sum_sq_norm_sqrt_smul_one b hw.le,
    card_filter_partner_mem_twoFamilyCut hnr, card_twoFamilyCut]
  push_cast
  field_simp

/-- Paper (5.38) in the model: on a nonempty cut with `n ≤ r` the closed amplitude is the
partial trace times the response minus `δ / 2`. -/
theorem flipCutAmplitude_eq_trace_mul (b : HilbertBasis (ℕ × Bool) ℂ H) {w : ℝ} (hw : 0 < w)
    (δ : ℝ) {r n : ℕ} (hnr : n ≤ r) (hr : 0 < r) :
    flipCutAmplitude b w δ r n
      = (∑ i ∈ twoFamilyCut r n, ‖(((Real.sqrt w : ℝ) : ℂ) • (1 : H →L[ℂ] H)) (b i)‖ ^ 2)
        * (flipCutResponse b w δ r n - δ / 2) := by
  have hrn : (r : ℝ) + n ≠ 0 := by positivity
  rw [flipCutAmplitude_eq b hw.le δ hnr, flipCutResponse_eq b hw δ hnr hr,
    sum_sq_norm_sqrt_smul_one b hw.le, card_twoFamilyCut]
  push_cast
  field_simp
  ring

/-- The paper's condition (5.37b) on a cut, `|⟨Δ_η O⟩_P| ≤ δ_η / 2`, holds on a nonempty cut of
the model with `n ≤ r` exactly when `3 n ≤ r`. -/
theorem abs_flipCutResponse_le_iff (b : HilbertBasis (ℕ × Bool) ℂ H) {w δ : ℝ} (hw : 0 < w)
    (hδ : 0 < δ) {r n : ℕ} (hnr : n ≤ r) (hr : 0 < r) :
    |flipCutResponse b w δ r n| ≤ δ / 2 ↔ 3 * n ≤ r := by
  have hrn : (0 : ℝ) < (r : ℝ) + n := by positivity
  rw [flipCutResponse_eq b hw δ hnr hr, abs_of_nonneg (by positivity), div_le_iff₀ hrn]
  constructor
  · intro h
    have h' : (3 : ℝ) * n ≤ r := by nlinarith
    exact_mod_cast h'
  · intro h
    have h' : (3 : ℝ) * n ≤ r := by exact_mod_cast h
    nlinarith [mul_nonneg hδ.le (sub_nonneg.mpr h')]

/-- Five routes that all exhaust the labels give five different limits of the closed amplitude:
`+∞`, `w δ`, `0`, `-(w δ)` and `-∞`. -/
theorem flipCutAmplitude_five_limits (b : HilbertBasis (ℕ × Bool) ℂ H) {w δ : ℝ} (hw : 0 < w)
    (hδ : 0 < δ) :
    Tendsto (fun n : ℕ => flipCutAmplitude b w δ n n) atTop atTop ∧
      (∀ n : ℕ, flipCutAmplitude b w δ (3 * n + 1) (n + 1) = w * δ) ∧
      (∀ n : ℕ, flipCutAmplitude b w δ (3 * n) n = 0) ∧
      (∀ n : ℕ, flipCutAmplitude b w δ (3 * n + 2) n = -(w * δ)) ∧
      Tendsto (fun n : ℕ => flipCutAmplitude b w δ (7 * n) n) atTop atBot := by
  have hpos : 0 < w * δ := mul_pos hw hδ
  refine ⟨?_, fun n => ?_, fun n => ?_, fun n => ?_, ?_⟩
  · have h : (fun n : ℕ => flipCutAmplitude b w δ n n) = fun n : ℕ => w * δ * (n : ℝ) := by
      funext n
      rw [flipCutAmplitude_eq b hw.le δ le_rfl]
      ring
    rw [h]
    exact tendsto_natCast_atTop_atTop.const_mul_atTop hpos
  · rw [flipCutAmplitude_eq b hw.le δ (by omega)]
    push_cast
    ring
  · rw [flipCutAmplitude_eq b hw.le δ (by omega)]
    push_cast
    ring
  · rw [flipCutAmplitude_eq b hw.le δ (by omega)]
    push_cast
    ring
  · have h : (fun n : ℕ => flipCutAmplitude b w δ (7 * n) n)
        = fun n : ℕ => -(2 * (w * δ) * (n : ℝ)) := by
      funext n
      rw [flipCutAmplitude_eq b hw.le δ (by omega)]
      push_cast
      ring
    rw [h]
    exact tendsto_neg_atTop_atBot.comp
      (tendsto_natCast_atTop_atTop.const_mul_atTop (mul_pos two_pos hpos))

/-- Each of the five routes of `flipCutAmplitude_five_limits` is an increasing exhaustion of the
labels. So along each of them the cut projections converge strongly to the identity and the
open cut sums converge to the uncut matrix element, by
`IsIncreasingExhaustion.tendsto_sum_inner_smul` and
`IsIncreasingExhaustion.tendsto_open_cut_sum`. -/
theorem isIncreasingExhaustion_five_routes :
    IsIncreasingExhaustion (fun n : ℕ => twoFamilyCut n n) ∧
      IsIncreasingExhaustion (fun n : ℕ => twoFamilyCut (3 * n + 1) (n + 1)) ∧
      IsIncreasingExhaustion (fun n : ℕ => twoFamilyCut (3 * n) n) ∧
      IsIncreasingExhaustion (fun n : ℕ => twoFamilyCut (3 * n + 2) n) ∧
      IsIncreasingExhaustion (fun n : ℕ => twoFamilyCut (7 * n) n) := by
  have hid : Monotone fun n : ℕ => n := monotone_id
  have hunb : ∀ k : ℕ, ∃ n : ℕ, k < n := fun k => ⟨k + 1, k.lt_succ_self⟩
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact isIncreasingExhaustion_twoFamilyCut hid hid (fun _ => le_rfl) hunb
  · exact isIncreasingExhaustion_twoFamilyCut (r := fun n => 3 * n + 1) (s := fun n => n + 1)
      (monotone_nat_of_le_succ fun n => by omega) (monotone_nat_of_le_succ fun n => by omega)
      (fun n => by omega) fun k => ⟨k, k.lt_succ_self⟩
  · exact isIncreasingExhaustion_twoFamilyCut (r := fun n => 3 * n) (s := fun n => n)
      (monotone_nat_of_le_succ fun n => by omega) hid (fun n => by omega) hunb
  · exact isIncreasingExhaustion_twoFamilyCut (r := fun n => 3 * n + 2) (s := fun n => n)
      (monotone_nat_of_le_succ fun n => by omega) hid (fun n => by omega) hunb
  · exact isIncreasingExhaustion_twoFamilyCut (r := fun n => 7 * n) (s := fun n => n)
      (monotone_nat_of_le_succ fun n => by omega) hid (fun n => by omega) hunb

end QuantGrav
