/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Elementary.FocusingDivergence
public import QuantGrav.Hypotheses
public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Probability.ProductMeasure
import QuantGrav.Diamond.ClockHypotheses
import QuantGrav.Elementary.GaussianQuadraticForm

/-!
# When the incoming state has no finite clock reading

Paper: arXiv:2611.34924v1, (4.22), (4.26), (4.27), (5.2), (5.19), (5.21), (C.13), (C.16).

Break attempt B1 of `handoff.md`, Section 14. This file holds the Hilbert-space half: a
criterion for `P_D Ω_𝒜 = 0`. The probability half is in
`QuantGrav/Elementary/GaussianQuadraticForm.lean` and
`QuantGrav/Elementary/FocusingDivergence.lean`.

The criterion needs two inputs about a family of projections `F`. In the model, `F` is the
projection onto "the focusing carried by the first `N` modes is at most `c`", for a focusing
that is a function of commuting mode coordinates. That the paper's focusing is of this kind is
an assumption of the model: in the paper it depends on both members of each canonical pair.

* `Ω_𝒜` has almost no weight in the range of `F`: `‖F Ω_𝒜‖ ≤ ε`. For Gaussian modes whose
  focusing has divergent mean, this holds once `N` is large. In the paper it would fail if the
  focusing were counted by occupation numbers, as in App D.3, since a Gaussian state then costs
  nothing.
* Vectors of `H_D` lie almost entirely in the range of `F`: `‖ψ - F ψ‖ ≤ ε ‖ψ‖`. This says that
  a bounded clock reading bounds the focusing. The paper states no such operator inequality.
  Its (5.21) uses positivity of the focusing in the same direction, but to discard the
  focusing and bound the area.

Results.

* `proj_apply_eq_zero_of_forall_exists`: for a projection `E` and a vector `Ω`, if for every
  `ε > 0` there is such an `F`, then `E Ω = 0`.
* `DiamondSetup.diamondProj_Ω_eq_zero_of_forall_exists`,
  `DiamondSetup.diamondProj_Ω_eq_zero_of_modes`: the same for `E = P_D`, and in a form with the
  probabilities `p N c = ‖F N c Ω_𝒜‖²` tending to zero as `N` grows.
* `DiamondSetup.diamondProj_Ω_eq_zero_of_gaussian_modes`,
  `DiamondSetup.diamondProj_Ω_eq_zero_of_radial_modes`: the same with the probabilities given by
  independent Gaussian modes whose focusing has divergent mean, and with the variances of
  (4.32) and weights growing as read off from (D.41).
* `DiamondSetup.not_H1_of_forall_diamondProj_Ω_eq_zero`: if `P_D Ω_𝒜 = 0` for every maximum
  reading, then H1 fails, and the limit in (5.19) is `0`, not `1`.

Nothing here says that the two inputs hold in the paper's theory. That depends on how the
focusing operator of (4.22) is defined when all modes are included, which the paper does not
say; see finding F11 in `FIDELITY.md`.
-/

public section

namespace QuantGrav

open MeasureTheory ProbabilityTheory Filter Topology
open scoped ComplexInnerProductSpace NNReal

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- Let `E` be an orthogonal projection and `Ω` a vector. Suppose that for every `ε > 0` there
is an orthogonal projection `F` with `‖F Ω‖ ≤ ε` and `‖ψ - F ψ‖ ≤ ε ‖ψ‖` for every `ψ` in the
range of `E`. Then `E Ω = 0`. -/
theorem proj_apply_eq_zero_of_forall_exists {E : H →L[ℂ] H}
    (hE : IsStarProjection E) (Ω : H)
    (h : ∀ ε > 0, ∃ F : H →L[ℂ] H, IsStarProjection F ∧ ‖F Ω‖ ≤ ε ∧
      ∀ ψ : H, E ψ = ψ → ‖ψ - F ψ‖ ≤ ε * ‖ψ‖) : E Ω = 0 := by
  by_contra hne
  have hpos : 0 < ‖E Ω‖ := norm_pos_iff.mpr hne
  have hEE : E (E Ω) = E Ω := by
    rw [← ContinuousLinearMap.comp_apply, ← ContinuousLinearMap.mul_def, hE.isIdempotentElem.eq]
  have hden : 0 < 2 * (1 + ‖Ω‖) := by positivity
  obtain ⟨F, hF, hFΩ, hFψ⟩ := h (‖E Ω‖ / (2 * (1 + ‖Ω‖))) (div_pos hpos hden)
  have hsaE : ContinuousLinearMap.adjoint E = E :=
    ContinuousLinearMap.isSelfAdjoint_iff'.mp hE.isSelfAdjoint
  have hsaF : ContinuousLinearMap.adjoint F = F :=
    ContinuousLinearMap.isSelfAdjoint_iff'.mp hF.isSelfAdjoint
  -- `⟪E Ω, E Ω⟫ = ⟪Ω, E Ω⟫`, because `E` is self-adjoint and idempotent.
  have h1 : ⟪E Ω, E Ω⟫ = ⟪Ω, E Ω⟫ := by
    have := ContinuousLinearMap.adjoint_inner_left E (E Ω) Ω
    rwa [hsaE, hEE] at this
  -- `⟪Ω, E Ω⟫ = ⟪F Ω, E Ω⟫ + ⟪Ω, E Ω - F (E Ω)⟫`, because `F` is self-adjoint.
  have h2 : ⟪Ω, E Ω⟫ = ⟪F Ω, E Ω⟫ + ⟪Ω, E Ω - F (E Ω)⟫ := by
    have := ContinuousLinearMap.adjoint_inner_left F (E Ω) Ω
    rw [hsaF] at this
    rw [inner_sub_right, this]
    ring
  have h3 : ‖E Ω‖ ^ 2 ≤ ‖F Ω‖ * ‖E Ω‖ + ‖Ω‖ * ‖E Ω - F (E Ω)‖ := by
    have hnorm : ‖⟪E Ω, E Ω⟫‖ = ‖E Ω‖ ^ 2 := by
      rw [inner_self_eq_norm_sq_to_K, norm_pow, RCLike.norm_ofReal, abs_norm]
    rw [← hnorm, h1, h2]
    exact (norm_add_le _ _).trans (add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _))
  have h4 := hFψ (E Ω) hEE
  have h5 : ‖F Ω‖ * ‖E Ω‖ + ‖Ω‖ * ‖E Ω - F (E Ω)‖
      ≤ ‖E Ω‖ / (2 * (1 + ‖Ω‖)) * ‖E Ω‖ * (1 + ‖Ω‖) := by
    have ha : ‖F Ω‖ * ‖E Ω‖ ≤ ‖E Ω‖ / (2 * (1 + ‖Ω‖)) * ‖E Ω‖ :=
      mul_le_mul_of_nonneg_right hFΩ hpos.le
    have hb : ‖Ω‖ * ‖E Ω - F (E Ω)‖ ≤ ‖Ω‖ * (‖E Ω‖ / (2 * (1 + ‖Ω‖)) * ‖E Ω‖) :=
      mul_le_mul_of_nonneg_left h4 (norm_nonneg Ω)
    nlinarith
  have h6 : ‖E Ω‖ / (2 * (1 + ‖Ω‖)) * ‖E Ω‖ * (1 + ‖Ω‖) = ‖E Ω‖ ^ 2 / 2 := by
    field_simp
  have h7 : ‖E Ω‖ ^ 2 ≤ ‖E Ω‖ ^ 2 / 2 := h3.trans (h5.trans h6.le)
  nlinarith [pow_pos hpos 2]

namespace DiamondSetup

/-- If, for every `ε > 0`, some orthogonal projection `F` has `‖F Ω_𝒜‖ ≤ ε` and
`‖ψ - F ψ‖ ≤ ε ‖ψ‖` for all `ψ` in `H_D`, then `P_D Ω_𝒜 = 0`: the incoming state has no
component with clock reading at most `ℓ`. -/
theorem diamondProj_Ω_eq_zero_of_forall_exists (S : DiamondSetup H) (ℓ : ℝ)
    (h : ∀ ε > 0, ∃ F : H →L[ℂ] H, IsStarProjection F ∧ ‖F S.Ω‖ ≤ ε ∧
      ∀ ψ ∈ S.diamondSpace ℓ, ‖ψ - F ψ‖ ≤ ε * ‖ψ‖) : S.diamondProj ℓ S.Ω = 0 := by
  refine proj_apply_eq_zero_of_forall_exists (S.clock.isStarProjection ℓ) S.Ω fun ε hε => ?_
  obtain ⟨F, hF, hFΩ, hFψ⟩ := h ε hε
  exact ⟨F, hF, hFΩ, fun ψ hψ => hFψ ψ ((S.mem_diamondSpace_iff ℓ ψ).mpr hψ)⟩

/-- The same criterion with the focusing resolved by mode number. `F N c` is to be read as the
projection onto "the focusing carried by the first `N` modes is at most `c`", and `p N c` as
the probability of that event in `Ω_𝒜`. Suppose

* `‖F N c Ω_𝒜‖² = p N c`, the Born rule;
* for every `c`, `p N c → 0` as `N → ∞`: with all modes included the focusing exceeds every
  bound almost surely;
* for every `ε > 0` there is a `c` such that, for all `N`, vectors of `H_D` satisfy
  `‖ψ - F N c ψ‖ ≤ ε ‖ψ‖`: a clock reading of at most `ℓ` bounds the focusing.

Then `P_D Ω_𝒜 = 0`. -/
theorem diamondProj_Ω_eq_zero_of_modes (S : DiamondSetup H) (ℓ : ℝ)
    (F : ℕ → ℝ → H →L[ℂ] H) (hF : ∀ N c, IsStarProjection (F N c)) (p : ℕ → ℝ → ℝ)
    (hborn : ∀ N c, ‖F N c S.Ω‖ ^ 2 = p N c)
    (hp : ∀ c, Filter.Tendsto (fun N => p N c) Filter.atTop (nhds 0))
    (hdom : ∀ ε > 0, ∃ c, ∀ N, ∀ ψ ∈ S.diamondSpace ℓ, ‖ψ - F N c ψ‖ ≤ ε * ‖ψ‖) :
    S.diamondProj ℓ S.Ω = 0 := by
  refine S.diamondProj_Ω_eq_zero_of_forall_exists ℓ fun ε hε => ?_
  obtain ⟨c, hc⟩ := hdom ε hε
  have hev : ∀ᶠ N in Filter.atTop, p N c < ε ^ 2 :=
    (hp c).eventually_lt_const (pow_pos hε 2)
  obtain ⟨N, hN⟩ := hev.exists
  refine ⟨F N c, hF N c, ?_, hc N⟩
  rw [← hborn] at hN
  exact (pow_lt_pow_iff_left₀ (norm_nonneg _) hε.le two_ne_zero).mp hN |>.le

/-- The criterion with Gaussian modes. `F N c` is to be read as the projection onto "the
focusing `∑ k < N, a k (q k)²` of the first `N` modes is at most `c`". Suppose

* in `Ω_𝒜` the modes are independent centred Gaussian variables of variances `v k`, in the
  sense that `‖F N c Ω_𝒜‖²` is the Gaussian probability of that event;
* the weights `a k` are nonnegative and the series `∑ a k v k` of the means diverges;
* for every `ε > 0` there is a `c > 0` such that, for all `N`, vectors of `H_D` satisfy
  `‖ψ - F N c ψ‖ ≤ ε ‖ψ‖`: a clock reading of at most `ℓ` bounds the focusing.

Then `P_D Ω_𝒜 = 0`. -/
theorem diamondProj_Ω_eq_zero_of_gaussian_modes (S : DiamondSetup H) (ℓ : ℝ) (a : ℕ → ℝ)
    (v : ℕ → ℝ≥0) (ha : ∀ k, 0 ≤ a k)
    (hdiv : Tendsto (fun N => ∑ k ∈ Finset.range N, a k * (v k : ℝ)) atTop atTop)
    (F : ℕ → ℝ → H →L[ℂ] H) (hF : ∀ N c, IsStarProjection (F N c))
    (hborn : ∀ N c, ‖F N c S.Ω‖ ^ 2
      = (Measure.infinitePi fun k => gaussianReal 0 (v k)).real
          {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c})
    (hdom : ∀ ε > 0, ∃ c > 0, ∀ N, ∀ ψ ∈ S.diamondSpace ℓ, ‖ψ - F N c ψ‖ ≤ ε * ‖ψ‖) :
    S.diamondProj ℓ S.Ω = 0 := by
  refine S.diamondProj_Ω_eq_zero_of_forall_exists ℓ fun ε hε => ?_
  obtain ⟨c, hc, hcψ⟩ := hdom ε hε
  have hlim : Tendsto
      (fun N => Real.exp 1 *
        (1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ)) ^ (-(1 / 2 : ℝ)))
      atTop (𝓝 0) := by
    have h1 : Tendsto (fun N => 1 + 2 / c * ∑ k ∈ Finset.range N, a k * (v k : ℝ))
        atTop atTop :=
      tendsto_atTop_add_const_left _ _ (hdiv.const_mul_atTop (div_pos two_pos hc))
    have h2 := ((tendsto_rpow_neg_atTop (y := 1 / 2) (by norm_num)).comp h1).const_mul
      (Real.exp 1)
    rwa [mul_zero] at h2
  obtain ⟨N, hN⟩ := (hlim.eventually_lt_const (pow_pos hε 2)).exists
  refine ⟨F N c, hF N c, ?_, hcψ N⟩
  have hp : ‖F N c S.Ω‖ ^ 2 < ε ^ 2 := by
    rw [hborn]
    exact (measureReal_infinitePi_sum_range_mul_sq_le_le a v ha hc N).trans_lt hN
  exact ((pow_lt_pow_iff_left₀ (norm_nonneg _) hε.le two_ne_zero).mp hp).le

/-- The criterion with the scalings of the paper's pair example: variances `1 / (2 s (k + 1))`
as in (4.32) and weights `a k ≥ c₀ (k + 1)²`, `c₀ > 0`, as read off from (D.41). Under the two
inputs of
`diamondProj_Ω_eq_zero_of_gaussian_modes`, `P_D Ω_𝒜 = 0`. -/
theorem diamondProj_Ω_eq_zero_of_radial_modes (S : DiamondSetup H) (ℓ : ℝ) {s c₀ : ℝ}
    (hs : 0 < s) (hc₀ : 0 < c₀) (a : ℕ → ℝ) (ha : ∀ k : ℕ, c₀ * ((k : ℝ) + 1) ^ 2 ≤ a k)
    (F : ℕ → ℝ → H →L[ℂ] H) (hF : ∀ N c, IsStarProjection (F N c))
    (hborn : ∀ N c, ‖F N c S.Ω‖ ^ 2
      = (Measure.infinitePi fun k => gaussianReal 0 (radialVariance s k)).real
          {q : ℕ → ℝ | ∑ k ∈ Finset.range N, a k * q k ^ 2 ≤ c})
    (hdom : ∀ ε > 0, ∃ c > 0, ∀ N, ∀ ψ ∈ S.diamondSpace ℓ, ‖ψ - F N c ψ‖ ≤ ε * ‖ψ‖) :
    S.diamondProj ℓ S.Ω = 0 :=
  S.diamondProj_Ω_eq_zero_of_gaussian_modes ℓ a (radialVariance s)
    (fun k => (mul_nonneg hc₀.le (sq_nonneg _)).trans (ha k))
    (tendsto_sum_mul_radialVariance_atTop hs hc₀ a ha) F hF hborn hdom

/-- If `P_D Ω_𝒜 = 0` for every maximum reading, then H1 fails. In that case the limit in
(5.19) is `0`, not `1`. -/
theorem not_H1_of_forall_diamondProj_Ω_eq_zero (S : DiamondSetup H)
    (h : ∀ ℓ : ℝ, S.diamondProj ℓ S.Ω = 0) : ¬S.H1 := fun hH1 =>
  let ⟨ℓ, hℓ⟩ := hH1.exists_diamondProj_ne_zero
  hℓ (h ℓ)

end DiamondSetup

end QuantGrav
