/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.FiniteDim
public import QuantGrav.OperatorAlgebra.CutSums
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Closed cuts: what open gluing does not give, and a weaker hypothesis that suffices

Paper: arXiv:2611.34924v1, (4.29), (4.30), (5.30c), (5.37), (5.38), (D.24).

Notation. `C : H → K` is bounded with `c ‖v‖² ≤ ‖C v‖²`, `c > 0`; in the paper `C = C_b` on
`H_D` and `c = e^{-s_*} m_{b,D}` (5.30c). A cut `P` is a finite orthonormal family `e`, with
partial trace `T_P = ∑ i, ‖C (e i)‖² = Tr(P C_b† C_b)`. The closed amplitude of (5.38) is
`Z_P[X] = T_P (Δ_P - δ/2)`, where `Δ_P` is the response `⟨Δ_η O⟩_P` on the cut and
`δ = δ_η > 0`. Here `Δ_P` is just a real number attached to the cut.

Results.

* `open_gluing_id_and_unbounded_partial_traces`: on an infinite-dimensional Hilbert space the
  identity satisfies the open-gluing statements (4.29), (4.30), as every bounded operator does,
  while its partial traces are unbounded. So open gluing cannot imply H3a.
* `cut_amplitude_le_neg_rank`: on a cut with `Δ_P ≤ δ/2 - γ`, `γ ≥ 0`,
  `Z_P[X] ≤ -(c γ) rank P`.
* `tendsto_cut_amplitude_atBot`, `not_tendsto_cut_amplitude_nhds`: along any family of such
  cuts with a fixed margin `γ > 0`, whose ranks grow without bound, `Z_P[X]` tends to `-∞`. It
  has no finite limit at all, positive or not.
* `finiteDimensional_of_cut_amplitude_bddBelow`: hypothesis H3c. If the closed amplitudes are
  bounded below on such cuts of unbounded rank, the space is finite-dimensional. This is weaker
  than H3b, which asks them to converge to `Z[X]`, and it does not use H4, the positivity of
  `Z[X]`.
* `sum_sq_norm_le_div_of_neg_le_cut_amplitude`: on such a cut a lower bound on the closed
  amplitude is an upper bound on the partial trace. So H3c is H3a restricted to these cuts.

The margin. The paper's (5.37b) reads `|⟨Δ_η O⟩_P| ≤ δ_η / 2`, and the sentence after (D.25)
makes the bound of (5.32) less than `|δ_η| / 2`, the same for every finite union of cycles. So
the paper's cuts have a margin `γ > 0`, which the paper does not name. With `γ = 0` the
conclusions of the last three items fail; see `QuantGrav/Diamond/OrderOfExhaustion.lean`.

The observation that boundedness below already suffices was made independently in an external
audit of the paper; see `notes/external-audits-2026-11-26.md`. The proofs here are ours.
-/

public section

namespace QuantGrav

open Filter Topology
open scoped ComplexInnerProductSpace

variable {H K : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K]

/-- The contrapositive of `finiteDimensional_of_sum_sq_norm_le`: on an infinite-dimensional
space an operator bounded below by `c > 0` has unbounded partial traces. -/
theorem exists_orthonormal_sum_sq_norm_gt (C : H →L[ℂ] K) {c : ℝ} (hc : 0 < c)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2) (hinf : ¬FiniteDimensional ℂ H) (Z : ℝ) :
    ∃ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e ∧ Z < ∑ i, ‖C (e i)‖ ^ 2 := by
  by_contra h
  push Not at h
  exact hinf (finiteDimensional_of_sum_sq_norm_le C hc hlow h)

/-- Open gluing does not imply H3a. On an infinite-dimensional Hilbert space, the identity
operator satisfies (4.29) and (4.30) in every Hilbert basis, yet its partial traces over finite
orthonormal families are unbounded. The second conjunct is the bound of (4.30); that the series
of norms is summable is `summable_norm_inner_cut`. -/
theorem open_gluing_id_and_unbounded_partial_traces [CompleteSpace H] {ι : Type*}
    (b : HilbertBasis ι ℂ H) (φ ψ : H) (hinf : ¬FiniteDimensional ℂ H) :
    HasSum (fun i => ⟪φ, b i⟫ * ⟪b i, ψ⟫) ⟪φ, ψ⟫ ∧
      ∑' i, ‖⟪φ, b i⟫ * ⟪b i, ψ⟫‖ ≤ ‖φ‖ * ‖ψ‖ ∧
      ∀ Z : ℝ, ∃ (n : ℕ) (e : Fin n → H),
        Orthonormal ℂ e ∧ Z < ∑ i, ‖(1 : H →L[ℂ] H) (e i)‖ ^ 2 := by
  have hone : ‖(1 : H →L[ℂ] H)‖ ≤ 1 := ContinuousLinearMap.norm_id_le
  refine ⟨?_, ?_, ?_⟩
  · exact hasSum_inner_cut b 1 1 φ ψ
  · exact tsum_norm_inner_cut_le_of_norm_le_one b 1 1 hone hone φ ψ
  · refine exists_orthonormal_sum_sq_norm_gt 1 one_pos (fun v => ?_) hinf
    rw [one_mul]
    exact le_refl _

/-- The counting step in the sentence before (D.24), where the paper has
`Tr(P C_b† C_b) ≥ (k + N) e^{-s_*} m_{b,D}`: the partial trace over a finite orthonormal family
of `n` vectors is at least `c n`. -/
theorem mul_card_le_sum_sq_norm (C : H →L[ℂ] K) {c : ℝ}
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2) (n : ℕ) (e : Fin n → H)
    (he : Orthonormal ℂ e) : c * n ≤ ∑ i, ‖C (e i)‖ ^ 2 := by
  calc c * n = ∑ i : Fin n, c * ‖e i‖ ^ 2 := by simp [he.1, mul_comm]
    _ ≤ ∑ i, ‖C (e i)‖ ^ 2 := Finset.sum_le_sum fun i _ => hlow (e i)

/-- On a cut whose response is at most `δ / 2 - γ`, with a margin `γ ≥ 0`, the closed amplitude
of (5.38), `T_P (Δ_P - δ/2)`, is at most `-(c γ)` times the rank of the cut. For `γ = 0` this is
the paper's `Z_P[X] ≤ 0`. -/
theorem cut_amplitude_le_neg_rank (C : H →L[ℂ] K) {c γ : ℝ} (hγ : 0 ≤ γ)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2) (n : ℕ) (e : Fin n → H) (he : Orthonormal ℂ e)
    {δ Δ : ℝ} (hΔ : Δ ≤ δ / 2 - γ) :
    (∑ i, ‖C (e i)‖ ^ 2) * (Δ - δ / 2) ≤ -(c * γ) * n := by
  have hT := mul_card_le_sum_sq_norm C hlow n e he
  have hT0 : 0 ≤ ∑ i, ‖C (e i)‖ ^ 2 := Finset.sum_nonneg fun i _ => sq_nonneg _
  have h1 : (∑ i, ‖C (e i)‖ ^ 2) * (Δ - δ / 2) ≤ (∑ i, ‖C (e i)‖ ^ 2) * (-γ) :=
    mul_le_mul_of_nonneg_left (by linarith) hT0
  have h2 : (c * n) * γ ≤ (∑ i, ‖C (e i)‖ ^ 2) * γ :=
    mul_le_mul_of_nonneg_right hT hγ
  linarith

/-- On a cut with response at most `δ / 2 - γ`, `γ > 0`, a lower bound `-B` on the closed
amplitude is an upper bound `B / γ` on the partial trace. So on such cuts hypothesis H3c is
hypothesis H3a restricted to them. No orthonormality is needed. -/
theorem sum_sq_norm_le_div_of_neg_le_cut_amplitude (C : H →L[ℂ] K) {γ δ B : ℝ} (hγ : 0 < γ)
    (n : ℕ) (e : Fin n → H) {Δ : ℝ} (hΔ : Δ ≤ δ / 2 - γ)
    (hB : -B ≤ (∑ i, ‖C (e i)‖ ^ 2) * (Δ - δ / 2)) :
    ∑ i, ‖C (e i)‖ ^ 2 ≤ B / γ := by
  have hT0 : 0 ≤ ∑ i, ‖C (e i)‖ ^ 2 := Finset.sum_nonneg fun i _ => sq_nonneg _
  have h1 : (∑ i, ‖C (e i)‖ ^ 2) * (Δ - δ / 2) ≤ (∑ i, ‖C (e i)‖ ^ 2) * (-γ) :=
    mul_le_mul_of_nonneg_left (by linarith) hT0
  rw [le_div_iff₀ hγ]
  linarith

/-- In infinite dimension, cuts with a uniform margin force the closed amplitude to `-∞`: along
any family of cuts with responses at most `δ / 2 - γ`, `γ > 0`, and ranks tending to infinity,
`T_P (Δ_P - δ/2)` tends to `-∞`.

The paper's own cuts are of this kind. The sentence after (D.25) chooses `Δs` and `r` so that
the upper bound of (5.32) is less than `|δ_η| / 2` for every finite union of cycles; with `β`
that bound, `γ = δ_η / 2 - β`. The margin is needed: with responses equal to `δ / 2` the closed
amplitude can stay at zero in infinite dimension, as `twoFamilyCut (3 * n) n` shows in
`QuantGrav/Diamond/OrderOfExhaustion.lean`. -/
theorem tendsto_cut_amplitude_atBot {α : Type*} {l : Filter α} (C : H →L[ℂ] K) {c γ : ℝ}
    (hc : 0 < c) (hγ : 0 < γ) (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2) (n : α → ℕ)
    (e : ∀ a, Fin (n a) → H) (he : ∀ a, Orthonormal ℂ (e a)) {δ : ℝ} (Δ : α → ℝ)
    (hΔ : ∀ a, Δ a ≤ δ / 2 - γ) (hn : Tendsto (fun a => (n a : ℝ)) l atTop) :
    Tendsto (fun a => (∑ i, ‖C (e a i)‖ ^ 2) * (Δ a - δ / 2)) l atBot := by
  have hpos : 0 < c * γ := mul_pos hc hγ
  have hg : Tendsto (fun a => -(c * γ * (n a : ℝ))) l atBot :=
    tendsto_neg_atTop_atBot.comp (hn.const_mul_atTop hpos)
  refine tendsto_atBot_mono (fun a => ?_) hg
  have h := cut_amplitude_le_neg_rank C hγ.le hlow (n a) (e a) (he a) (hΔ a)
  linarith

/-- Along such a family of cuts the closed amplitude has no finite limit, so in particular it
cannot converge to the uncut amplitude `Z[X]`, whatever its sign. -/
theorem not_tendsto_cut_amplitude_nhds {α : Type*} {l : Filter α} [l.NeBot] (C : H →L[ℂ] K)
    {c γ : ℝ} (hc : 0 < c) (hγ : 0 < γ) (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2)
    (n : α → ℕ) (e : ∀ a, Fin (n a) → H) (he : ∀ a, Orthonormal ℂ (e a)) {δ : ℝ} (Δ : α → ℝ)
    (hΔ : ∀ a, Δ a ≤ δ / 2 - γ) (hn : Tendsto (fun a => (n a : ℝ)) l atTop) (z : ℝ) :
    ¬Tendsto (fun a => (∑ i, ‖C (e a i)‖ ^ 2) * (Δ a - δ / 2)) l (𝓝 z) :=
  not_tendsto_nhds_of_tendsto_atBot
    (tendsto_cut_amplitude_atBot C hc hγ hlow n e he Δ hΔ hn) z

/-- **H3c suffices.** Suppose that, if `H` were infinite-dimensional, there would be cuts of
arbitrarily large rank with response at most `δ / 2 - γ`, for a fixed margin `γ > 0`, on which
the closed amplitude `T_P (Δ_P - δ/2)` is at least `-B`. Then `H` is finite-dimensional.

In the paper the cuts of large rank come from (D.24), (D.25), and their responses are bounded
by (5.32), by an amount chosen less than `|δ_η| / 2` and the same for every cut; that gives the
margin. The lower bound `-B` is hypothesis H3c. It is weaker than H3b, convergence of the
closed amplitudes to `Z[X]`, and it does not need H4, the positivity of `Z[X]`. It is not weaker
than H3a: on these cuts it bounds the partial trace by `B / γ`
(`sum_sq_norm_le_div_of_neg_le_cut_amplitude`), so it is H3a restricted to them. Here `Δ` is a
real number with an upper bound; nothing ties it to the cut. -/
theorem finiteDimensional_of_cut_amplitude_bddBelow (C : H →L[ℂ] K) {c γ δ B : ℝ} (hc : 0 < c)
    (hγ : 0 < γ) (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2)
    (hcuts : ¬FiniteDimensional ℂ H → ∀ N : ℕ, ∃ (n : ℕ) (e : Fin n → H) (Δ : ℝ),
      N ≤ n ∧ Orthonormal ℂ e ∧ Δ ≤ δ / 2 - γ ∧ -B ≤ (∑ i, ‖C (e i)‖ ^ 2) * (Δ - δ / 2)) :
    FiniteDimensional ℂ H := by
  by_contra hinf
  have hcγ : 0 < c * γ := mul_pos hc hγ
  obtain ⟨N, hN⟩ := exists_nat_gt (B / (c * γ))
  obtain ⟨n, e, Δ, hNn, he, hΔ, hB⟩ := hcuts hinf N
  have h := cut_amplitude_le_neg_rank C hγ.le hlow n e he hΔ
  have hn : (N : ℝ) ≤ n := by exact_mod_cast hNn
  have h4 : B < N * (c * γ) := (div_lt_iff₀ hcγ).mp hN
  nlinarith

end QuantGrav
