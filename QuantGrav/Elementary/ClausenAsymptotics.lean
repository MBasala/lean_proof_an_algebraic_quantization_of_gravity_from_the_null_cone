/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Complex.AbelLimit
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds
import Mathlib.MeasureTheory.Integral.DominatedConvergence

/-!
# Small-angle asymptotics of the Clausen sum `∑_{k ≥ 1} sin(k θ) / k²`

WP1-b (second half). Paper: arXiv:2611.34924v1, the paragraph after (4.34), with `θ = 2 / s`.
The paper displays none of the statements below; `PairAmplitudeLog.lean` puts the last one in
the paper's variables.

The imaginary part of `∑_{k ≥ 1} exp(-i θ k) / k²` is `-∑_{k ≥ 1} sin(k θ) / k²`, minus the
Clausen function `Cl₂(θ)`. Mode numbers are written `k + 1` with `k : ℕ`, so no statement relies
on a value for division by zero. The dilogarithm and the Clausen function are not defined; all
statements are about the sums themselves.

* `hasSum_pow_mul_cos_div`: for `0 ≤ r < 1`,
  `∑_{k ≥ 1} r^k cos(k t) / k = -(1/2) log(1 - 2 r cos t + r²)`
  (real part of the Taylor series of `-log(1 - z)` at `z = r e^{it}`).
* `hasSum_pow_mul_sin_div_sq`: for `0 ≤ r < 1`,
  `∑_{k ≥ 1} r^k sin(k θ) / k² = -(1/2) ∫₀^θ log(1 - 2 r cos t + r²) dt` (termwise integration).
* `hasSum_sin_div_sq`: for `0 < θ ≤ 1`,
  `∑_{k ≥ 1} sin(k θ) / k² = -(1/2) ∫₀^θ log(2 - 2 cos t) dt`
  (limit `r → 1⁻`: Abel's limit theorem on the left, dominated convergence on the right).
* `abs_log_two_sub_two_cos_sub_le`: for `0 < t ≤ 1`, `|log(2 - 2 cos t) - 2 log t| ≤ t² / 4`.
* `abs_im_tsum_cexp_div_sq_sub_le`: for `0 < θ ≤ 1`,
  `|Im ∑_{k ≥ 1} exp(-i θ k) / k² - (θ log θ - θ)| ≤ θ³ / 24`.

The restriction `θ ≤ 1` is what the elementary bounds on `cos` used here need; the identity in
`hasSum_sin_div_sq` holds on a larger interval, which is not proved in this file.
-/

public section

namespace QuantGrav

open Filter Topology MeasureTheory Set

/-- For `0 ≤ r < 1` and real `t`,
`∑_{k ≥ 1} r^k cos(k t) / k = -(1/2) log(1 - 2 r cos t + r²)`. -/
theorem hasSum_pow_mul_cos_div (r t : ℝ) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    HasSum (fun k : ℕ ↦ r ^ (k + 1) * Real.cos (((k : ℝ) + 1) * t) / ((k : ℝ) + 1))
      (-(1 / 2) * Real.log (1 - 2 * r * Real.cos t + r ^ 2)) := by
  set z : ℂ := (r : ℂ) * Complex.exp ((t : ℂ) * Complex.I) with hz
  have hnorm : ‖z‖ = r := by
    rw [hz, norm_mul, Complex.norm_exp_ofReal_mul_I, mul_one, Complex.norm_real,
      Real.norm_of_nonneg hr0]
  have h := Complex.hasSum_re
    (Complex.hasSum_taylorSeries_neg_log' (z := z) (by rw [hnorm]; exact hr1))
  convert h using 1
  · ext k
    have hpow : z ^ (k + 1) = ((r ^ (k + 1) : ℝ) : ℂ) *
        Complex.exp (((((k : ℝ) + 1) * t : ℝ) : ℂ) * Complex.I) := by
      rw [hz, mul_pow, ← Complex.exp_natCast_mul]
      push_cast
      ring_nf
    have hden : ((k : ℂ) + 1) = (((k : ℝ) + 1 : ℝ) : ℂ) := by
      push_cast
      rfl
    rw [hpow, hden, Complex.div_ofReal_re, Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re]
  · rw [Complex.neg_re, Complex.log_re]
    have hsq : ‖1 - z‖ ^ 2 = 1 - 2 * r * Real.cos t + r ^ 2 := by
      rw [Complex.sq_norm, Complex.normSq_apply]
      have hre : (1 - z).re = 1 - r * Real.cos t := by
        rw [Complex.sub_re, Complex.one_re, hz, Complex.re_ofReal_mul,
          Complex.exp_ofReal_mul_I_re]
      have him : (1 - z).im = -(r * Real.sin t) := by
        rw [Complex.sub_im, Complex.one_im, hz, Complex.im_ofReal_mul,
          Complex.exp_ofReal_mul_I_im, zero_sub]
      rw [hre, him]
      nlinarith [Real.sin_sq_add_cos_sq t]
    rw [← hsq, Real.log_pow]
    push_cast
    ring

/-- For `0 ≤ r < 1` and real `θ`,
`∑_{k ≥ 1} r^k sin(k θ) / k² = ∫₀^θ -(1/2) log(1 - 2 r cos t + r²) dt`. -/
theorem hasSum_pow_mul_sin_div_sq (r θ : ℝ) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    HasSum (fun k : ℕ ↦ r ^ (k + 1) * Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2)
      (∫ t in (0 : ℝ)..θ, -(1 / 2) * Real.log (1 - 2 * r * Real.cos t + r ^ 2)) := by
  have h := intervalIntegral.hasSum_integral_of_dominated_convergence (μ := volume)
    (a := 0) (b := θ)
    (F := fun (k : ℕ) (t : ℝ) ↦ r ^ (k + 1) * Real.cos (((k : ℝ) + 1) * t) / ((k : ℝ) + 1))
    (f := fun t ↦ -(1 / 2) * Real.log (1 - 2 * r * Real.cos t + r ^ 2))
    (fun k _ ↦ r ^ (k + 1)) ?_ ?_ ?_ ?_ ?_
  · convert h using 1
    ext k
    have hk : ((k : ℝ) + 1) ≠ 0 := by positivity
    simp_rw [mul_div_assoc]
    rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_div,
      intervalIntegral.integral_comp_mul_left (fun x ↦ Real.cos x) hk, integral_cos]
    simp only [mul_zero, Real.sin_zero, sub_zero, smul_eq_mul]
    field_simp
  · intro k
    exact Continuous.aestronglyMeasurable (by fun_prop)
  · intro k
    refine .of_forall fun t _ ↦ ?_
    have hk : (1 : ℝ) ≤ (k : ℝ) + 1 := by linarith [Nat.cast_nonneg (α := ℝ) k]
    rw [Real.norm_eq_abs, abs_div, abs_mul, abs_pow, abs_of_nonneg hr0,
      abs_of_pos (by linarith : (0 : ℝ) < (k : ℝ) + 1), div_le_iff₀ (by linarith)]
    have h1 := Real.abs_cos_le_one (((k : ℝ) + 1) * t)
    have h2 : 0 ≤ r ^ (k + 1) := pow_nonneg hr0 _
    nlinarith [abs_nonneg (Real.cos (((k : ℝ) + 1) * t))]
  · exact .of_forall fun t _ ↦
      (summable_nat_add_iff 1).mpr (summable_geometric_of_lt_one hr0 hr1)
  · exact intervalIntegrable_const
  · exact .of_forall fun t _ ↦ hasSum_pow_mul_cos_div r t hr0 hr1

/-- For `0 < t ≤ 1`, `t² (1 - 5 t² / 48) ≤ 2 - 2 cos t ≤ t²`. -/
theorem two_sub_two_cos_bounds (t : ℝ) (ht0 : 0 < t) (ht1 : t ≤ 1) :
    t ^ 2 * (1 - 5 * t ^ 2 / 48) ≤ 2 - 2 * Real.cos t ∧ 2 - 2 * Real.cos t ≤ t ^ 2 := by
  have h1 := Real.cos_bound (x := t) (by rw [abs_of_pos ht0]; exact ht1)
  rw [abs_of_pos ht0] at h1
  have h2 := (abs_le.mp h1).2
  have h3 := Real.one_sub_sq_div_two_le_cos (x := t)
  constructor <;> nlinarith

/-- For `0 < t ≤ 1`, `|log(2 - 2 cos t) - 2 log t| ≤ t² / 4`. -/
theorem abs_log_two_sub_two_cos_sub_le (t : ℝ) (ht0 : 0 < t) (ht1 : t ≤ 1) :
    |Real.log (2 - 2 * Real.cos t) - 2 * Real.log t| ≤ t ^ 2 / 4 := by
  obtain ⟨hlo, hhi⟩ := two_sub_two_cos_bounds t ht0 ht1
  have ht2 : 0 < t ^ 2 := by positivity
  have ht2' : t ^ 2 ≤ 1 := by nlinarith
  have hy : 0 < 1 - 5 * t ^ 2 / 48 := by linarith
  have hpos : 0 < 2 - 2 * Real.cos t := lt_of_lt_of_le (mul_pos ht2 hy) hlo
  have hlogsq : Real.log (t ^ 2) = 2 * Real.log t := by
    rw [Real.log_pow]
    norm_num
  have hup : Real.log (2 - 2 * Real.cos t) ≤ 2 * Real.log t := by
    rw [← hlogsq]
    exact Real.log_le_log hpos hhi
  have hdown : 2 * Real.log t - t ^ 2 / 4 ≤ Real.log (2 - 2 * Real.cos t) := by
    have h1 : Real.log (t ^ 2 * (1 - 5 * t ^ 2 / 48)) ≤ Real.log (2 - 2 * Real.cos t) :=
      Real.log_le_log (mul_pos ht2 hy) hlo
    rw [Real.log_mul ht2.ne' hy.ne', hlogsq] at h1
    have h2 := Real.one_sub_inv_le_log_of_pos hy
    have h3 : (1 - 5 * t ^ 2 / 48)⁻¹ ≤ 1 + t ^ 2 / 4 := by
      rw [inv_le_iff_one_le_mul₀ hy]
      nlinarith [mul_nonneg ht2.le (sub_nonneg.mpr ht2')]
    linarith
  rw [abs_le]
  constructor <;> linarith

/-- For `1/2 < r < 1` and `0 < t ≤ 1`,
`|log(1 - 2 r cos t + r²)| ≤ log 4 + 2 |log t|`. This is the integrable majorant, uniform in
`r`, used to pass to the limit `r → 1⁻` under the integral. -/
theorem abs_log_one_sub_two_mul_cos_add_sq_le (r t : ℝ) (hr : r ∈ Set.Ioo (1 / 2 : ℝ) 1)
    (ht0 : 0 < t) (ht1 : t ≤ 1) :
    |Real.log (1 - 2 * r * Real.cos t + r ^ 2)| ≤ Real.log 4 + 2 * |Real.log t| := by
  obtain ⟨hlo, -⟩ := two_sub_two_cos_bounds t ht0 ht1
  have ht2 : 0 < t ^ 2 := by positivity
  have ht2' : t ^ 2 ≤ 1 := by nlinarith
  have hlogsq : Real.log (t ^ 2) = 2 * Real.log t := by
    rw [Real.log_pow]
    norm_num
  have ha : t ^ 2 * (43 / 48) ≤ 2 - 2 * Real.cos t := by
    nlinarith [mul_nonneg ht2.le (sub_nonneg.mpr ht2')]
  have hb : 1 / 2 * (2 - 2 * Real.cos t) ≤ r * (2 - 2 * Real.cos t) :=
    mul_le_mul_of_nonneg_right hr.1.le (by nlinarith)
  have hg1 : t ^ 2 / 4 ≤ 1 - 2 * r * Real.cos t + r ^ 2 := by
    nlinarith [sq_nonneg (1 - r)]
  have hg2 : 1 - 2 * r * Real.cos t + r ^ 2 ≤ 4 := by
    have hc : 0 ≤ r * (1 + Real.cos t) :=
      mul_nonneg (by linarith [hr.1]) (by linarith [Real.neg_one_le_cos t])
    nlinarith [hr.1, hr.2]
  have hgpos : 0 < 1 - 2 * r * Real.cos t + r ^ 2 := by linarith [div_pos ht2 four_pos]
  have hlog_up := Real.log_le_log hgpos hg2
  have hlog_lo := Real.log_le_log (by positivity) hg1
  rw [Real.log_div ht2.ne' (by norm_num), hlogsq] at hlog_lo
  rw [abs_le]
  constructor
  · linarith [neg_abs_le (Real.log t)]
  · linarith [abs_nonneg (Real.log t)]

/-- For `0 < θ ≤ 1`, `∑_{k ≥ 1} sin(k θ) / k² = -(1/2) ∫₀^θ log(2 - 2 cos t) dt`. -/
theorem hasSum_sin_div_sq (θ : ℝ) (h0 : 0 < θ) (h1 : θ ≤ 1) :
    HasSum (fun k : ℕ ↦ Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2)
      (-(1 / 2) * ∫ t in (0 : ℝ)..θ, Real.log (2 - 2 * Real.cos t)) := by
  have hsum : Summable (fun k : ℕ ↦ Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2) := by
    refine Summable.of_norm_bounded (g := fun k : ℕ ↦ 1 / ((k : ℝ) + 1) ^ 2) ?_ ?_
    · have := (summable_nat_add_iff 1).mpr
        ((Real.summable_one_div_nat_pow (p := 2)).mpr one_lt_two)
      simpa using this
    · intro k
      rw [Real.norm_eq_abs, abs_div, abs_of_pos (by positivity : (0 : ℝ) < ((k : ℝ) + 1) ^ 2)]
      gcongr
      exact Real.abs_sin_le_one _
  have hL := Real.tendsto_tsum_powerSeries_nhdsWithin_lt hsum.hasSum.tendsto_sum_nat
  have hL' : Tendsto (fun r : ℝ ↦ r * ∑' k : ℕ,
      Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2 * r ^ k) (𝓝[<] 1)
      (𝓝 (1 * ∑' k : ℕ, Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2)) :=
    (tendsto_nhdsWithin_of_tendsto_nhds tendsto_id).mul hL
  have hR : Tendsto (fun r : ℝ ↦ ∫ t in (0 : ℝ)..θ, Real.log (1 - 2 * r * Real.cos t + r ^ 2))
      (𝓝[<] 1) (𝓝 (∫ t in (0 : ℝ)..θ, Real.log (2 - 2 * Real.cos t))) := by
    refine intervalIntegral.tendsto_integral_filter_of_dominated_convergence
      (fun t ↦ Real.log 4 + 2 * |Real.log t|) ?_ ?_ ?_ ?_
    · exact .of_forall fun r ↦ (Real.measurable_log.comp (by fun_prop)).aestronglyMeasurable
    · filter_upwards [Ioo_mem_nhdsLT (show (1 / 2 : ℝ) < 1 by norm_num)] with r hr
      refine .of_forall fun t ht ↦ ?_
      rw [uIoc_of_le h0.le] at ht
      rw [Real.norm_eq_abs]
      exact abs_log_one_sub_two_mul_cos_add_sq_le r t hr ht.1 (ht.2.trans h1)
    · exact intervalIntegrable_const.add
        (intervalIntegral.intervalIntegrable_log'.abs.const_mul 2)
    · refine .of_forall fun t ht ↦ ?_
      rw [uIoc_of_le h0.le] at ht
      obtain ⟨hlo, -⟩ := two_sub_two_cos_bounds t ht.1 (ht.2.trans h1)
      have ht2 : 0 < t ^ 2 := pow_pos ht.1 2
      have ht2' : t ^ 2 ≤ 1 := by nlinarith [ht.1, ht.2.trans h1]
      have hpos : 2 - 2 * Real.cos t ≠ 0 :=
        (lt_of_lt_of_le (mul_pos ht2 (by linarith)) hlo).ne'
      have hc : Tendsto (fun r : ℝ ↦ 1 - 2 * r * Real.cos t + r ^ 2) (𝓝 1)
          (𝓝 (1 - 2 * 1 * Real.cos t + 1 ^ 2)) :=
        Continuous.tendsto (by fun_prop) 1
      have hc' : Tendsto (fun r : ℝ ↦ 1 - 2 * r * Real.cos t + r ^ 2) (𝓝[<] 1)
          (𝓝 (2 - 2 * Real.cos t)) := by
        convert hc.mono_left nhdsWithin_le_nhds using 2
        ring
      exact hc'.log hpos
  have heq : ∀ᶠ r : ℝ in 𝓝[<] 1,
      r * ∑' k : ℕ, Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2 * r ^ k =
      -(1 / 2) * ∫ t in (0 : ℝ)..θ, Real.log (1 - 2 * r * Real.cos t + r ^ 2) := by
    filter_upwards [Ioo_mem_nhdsLT (show (0 : ℝ) < 1 by norm_num)] with r hr
    have h := (hasSum_pow_mul_sin_div_sq r θ hr.1.le hr.2).tsum_eq
    rw [intervalIntegral.integral_const_mul] at h
    rw [← h, ← tsum_mul_left]
    refine tsum_congr fun k ↦ ?_
    ring
  have hfin := tendsto_nhds_unique (hL'.congr' heq) (hR.const_mul (-(1 / 2)))
  rw [one_mul] at hfin
  rw [← hfin]
  exact hsum.hasSum

/-- For `0 < θ ≤ 1`, `t ↦ log(2 - 2 cos t)` is interval integrable on `[0, θ]`. -/
theorem intervalIntegrable_log_two_sub_two_cos (θ : ℝ) (h0 : 0 < θ) (h1 : θ ≤ 1) :
    IntervalIntegrable (fun t ↦ Real.log (2 - 2 * Real.cos t)) volume 0 θ := by
  refine IntervalIntegrable.mono_fun' (g := fun t ↦ 2 * |Real.log t| + t ^ 2 / 4) ?_ ?_ ?_
  · exact (intervalIntegral.intervalIntegrable_log'.abs.const_mul 2).add
      (Continuous.intervalIntegrable (by fun_prop) _ _)
  · exact (Real.measurable_log.comp (by fun_prop)).aestronglyMeasurable
  · rw [uIoc_of_le h0.le]
    refine (ae_restrict_iff' measurableSet_Ioc).mpr (.of_forall fun t ht ↦ ?_)
    have h := abs_le.mp (abs_log_two_sub_two_cos_sub_le t ht.1 (ht.2.trans h1))
    change ‖Real.log (2 - 2 * Real.cos t)‖ ≤ 2 * |Real.log t| + t ^ 2 / 4
    rw [Real.norm_eq_abs, abs_le]
    constructor
    · linarith [neg_abs_le (Real.log t), h.1]
    · linarith [le_abs_self (Real.log t), h.2]

/-- For `0 < θ ≤ 1`, the imaginary part of `∑_{k ≥ 1} exp(-i θ k) / k²` differs from
`θ log θ - θ` by at most `θ³ / 24`. -/
theorem abs_im_tsum_cexp_div_sq_sub_le (θ : ℝ) (h0 : 0 < θ) (h1 : θ ≤ 1) :
    |(∑' k : ℕ, Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2).im
        - (θ * Real.log θ - θ)| ≤ θ ^ 3 / 24 := by
  have hterm : ∀ k : ℕ,
      Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2 =
      Complex.exp (((-(((k : ℝ) + 1) * θ) : ℝ) : ℂ) * Complex.I) /
        ((((k : ℝ) + 1) ^ 2 : ℝ) : ℂ) := by
    intro k
    push_cast
    ring_nf
  have hsummable : Summable (fun k : ℕ ↦
      Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2) := by
    refine Summable.of_norm_bounded (g := fun k : ℕ ↦ 1 / ((k : ℝ) + 1) ^ 2) ?_ ?_
    · have := (summable_nat_add_iff 1).mpr
        ((Real.summable_one_div_nat_pow (p := 2)).mpr one_lt_two)
      simpa using this
    · intro k
      rw [hterm, norm_div, Complex.norm_exp_ofReal_mul_I, Complex.norm_real,
        Real.norm_of_nonneg (by positivity)]
  have him : ∀ k : ℕ,
      (Complex.exp (-(Complex.I * θ * ((k : ℂ) + 1))) / ((k : ℂ) + 1) ^ 2).im =
      -(Real.sin (((k : ℝ) + 1) * θ) / ((k : ℝ) + 1) ^ 2) := by
    intro k
    rw [hterm, Complex.div_ofReal_im, Complex.exp_ofReal_mul_I_im, Real.sin_neg, neg_div]
  rw [Complex.im_tsum hsummable]
  simp_rw [him]
  rw [tsum_neg, (hasSum_sin_div_sq θ h0 h1).tsum_eq]
  have hlog : ∫ t in (0 : ℝ)..θ, Real.log t = θ * Real.log θ - θ := by
    rw [integral_log]
    simp
  have hint := intervalIntegrable_log_two_sub_two_cos θ h0 h1
  have hdiff : -(-(1 / 2) * ∫ t in (0 : ℝ)..θ, Real.log (2 - 2 * Real.cos t)) -
      (θ * Real.log θ - θ) =
      1 / 2 * ∫ t in (0 : ℝ)..θ, (Real.log (2 - 2 * Real.cos t) - 2 * Real.log t) := by
    rw [intervalIntegral.integral_sub hint
      (intervalIntegral.intervalIntegrable_log'.const_mul 2),
      intervalIntegral.integral_const_mul, hlog]
    ring
  rw [hdiff, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 2)]
  have hbound : |∫ t in (0 : ℝ)..θ, (Real.log (2 - 2 * Real.cos t) - 2 * Real.log t)| ≤
      ∫ t in (0 : ℝ)..θ, t ^ 2 / 4 := by
    rw [← Real.norm_eq_abs]
    refine intervalIntegral.norm_integral_le_of_norm_le h0.le (.of_forall fun t ht ↦ ?_)
      (Continuous.intervalIntegrable (by fun_prop) _ _)
    rw [Real.norm_eq_abs]
    exact abs_log_two_sub_two_cos_sub_le t ht.1 (ht.2.trans h1)
  have hval : ∫ t in (0 : ℝ)..θ, t ^ 2 / 4 = θ ^ 3 / 12 := by
    rw [intervalIntegral.integral_div, integral_pow]
    norm_num
    ring
  rw [hval] at hbound
  linarith

end QuantGrav
