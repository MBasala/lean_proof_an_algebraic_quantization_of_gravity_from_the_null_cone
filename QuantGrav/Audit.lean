/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.ClockDivergence
public import QuantGrav.Diamond.ClockHypotheses
public import QuantGrav.Diamond.ClosedCuts
public import QuantGrav.Diamond.FiniteDim
public import QuantGrav.Diamond.OrderOfExhaustion
public import QuantGrav.Elementary.ClockLowerBound
public import QuantGrav.Elementary.ClockWeight
public import QuantGrav.Elementary.ClockWeightIntegral
public import QuantGrav.Elementary.FocusingDivergence
public import QuantGrav.Elementary.GaussianExpSq
public import QuantGrav.Elementary.GaussianModeLimits
public import QuantGrav.Elementary.GaussianQuadraticForm
public import QuantGrav.Elementary.LogCoefficient
public import QuantGrav.Elementary.LogIntegralLimit
public import QuantGrav.Elementary.MonotoneLogGrowth
public import QuantGrav.Elementary.OneAddSumLeProd
public import QuantGrav.Elementary.PairAmplitude
public import QuantGrav.Elementary.PairAmplitudeLog
public import QuantGrav.Elementary.PairAmplitudeReal
public import QuantGrav.Entropy.BandCounting
public import QuantGrav.Entropy.ClockMoments
public import QuantGrav.Entropy.ClockTraceAsymptotics
public import QuantGrav.Entropy.GibbsAccounting
public import QuantGrav.Entropy.LogLevelsModel
public import QuantGrav.Entropy.MeanAreaGrowth
public import QuantGrav.Entropy.SenComparison
public import QuantGrav.OperatorAlgebra.BoostBound
public import QuantGrav.OperatorAlgebra.CutSums

/-!
# Axiom audit

Each headline theorem is listed here with the exact output of `#print axioms`, pinned by
`#guard_msgs`. The build fails if any of them starts depending on a different set of axioms,
so this file is the committed record required by `handoff.md`, Section 8.

The only axioms allowed are Lean's three standard ones: `propext`, `Classical.choice`,
`Quot.sound`. A theorem may use fewer.
-/

/-- info: 'QuantGrav.clock_weight_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_weight_le

/-- info: 'QuantGrav.clock_weight_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_weight_eq_iff

/-- info: 'QuantGrav.log_coefficient_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_coefficient_eq_iff

/-- info: 'QuantGrav.q_of_growth_exponent_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.q_of_growth_exponent_iff

/-- info: 'QuantGrav.log_coefficient_roundtrip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_coefficient_roundtrip

/-- info: 'QuantGrav.log_coefficient_of_ratio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_coefficient_of_ratio

/-- info: 'QuantGrav.ratio_sq_of_q' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.ratio_sq_of_q

/-- info: 'QuantGrav.summable_norm_pair_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.summable_norm_pair_phase

/-- info: 'QuantGrav.hasSum_pair_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.hasSum_pair_amplitude

/-- info: 'QuantGrav.cubic_term_partial_pair_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cubic_term_partial_pair_sum

/-- info: 'QuantGrav.abs_harmonic_sub_log_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.abs_harmonic_sub_log_le

/-- info: 'QuantGrav.tendsto_harmonic_atTop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_harmonic_atTop

/-- info: 'QuantGrav.hasSum_sin_div_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.hasSum_sin_div_sq

/-- info: 'QuantGrav.abs_im_tsum_cexp_div_sq_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.abs_im_tsum_cexp_div_sq_sub_le

/-- info: 'QuantGrav.abs_im_pair_amplitude_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.abs_im_pair_amplitude_sub_le

/-- info: 'QuantGrav.finiteDimensional_of_sum_sq_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.finiteDimensional_of_sum_sq_norm_le

/-- info: 'QuantGrav.finrank_le_of_sum_sq_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.finrank_le_of_sum_sq_norm_le

/-- info: 'QuantGrav.sum_sq_norm_le_finrank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sum_sq_norm_le_finrank

/-- info: 'QuantGrav.finiteDimensional_iff_exists_sum_sq_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.finiteDimensional_iff_exists_sum_sq_norm_le

/-- info: 'QuantGrav.hasSum_inner_cut' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.hasSum_inner_cut

/-- info: 'QuantGrav.summable_norm_inner_cut' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.summable_norm_inner_cut

/-- info: 'QuantGrav.tsum_norm_inner_cut_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tsum_norm_inner_cut_le

/-- info: 'QuantGrav.tsum_norm_inner_cut_le_of_norm_le_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tsum_norm_inner_cut_le_of_norm_le_one

/-- info: 'QuantGrav.norm_inner_truncation_error_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.norm_inner_truncation_error_le

/-- info: 'QuantGrav.tendsto_inner_evolveCut' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_inner_evolveCut

/-- info: 'QuantGrav.tendsto_inner_evolveCut_starProjection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_inner_evolveCut_starProjection

/-- info: 'QuantGrav.compression_mul' depends on axioms: [propext] -/
#guard_msgs in
#print axioms QuantGrav.compression_mul

/-- info: 'QuantGrav.integral_clock_weight_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_clock_weight_le

/-- info: 'QuantGrav.setIntegral_clock_tail_le_integral_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.setIntegral_clock_tail_le_integral_div

/-- info: 'QuantGrav.setIntegral_clock_tail_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.setIntegral_clock_tail_le

/-- info: 'QuantGrav.norm_exp_smul_apply_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.norm_exp_smul_apply_sub_le

/-- info: 'QuantGrav.norm_inner_apply_sub_inner_apply_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.norm_inner_apply_sub_inner_apply_le

/-- info: 'QuantGrav.norm_inner_exp_apply_sub_inner_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.norm_inner_exp_apply_sub_inner_le

/--
info: 'QuantGrav.DiamondSetup.clock_proj_area_proj_comm_of_mem_fixedArea' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.clock_proj_area_proj_comm_of_mem_fixedArea

/-- info: 'QuantGrav.DiamondSetup.areaBound_clockLowerBound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.areaBound_clockLowerBound

/-- info: 'QuantGrav.DiamondSetup.H13.h1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H13.h1

/-- info: 'QuantGrav.DiamondSetup.H1_iff_tendsto_norm_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H1_iff_tendsto_norm_sq

/-- info: 'QuantGrav.DiamondSetup.H1.exists_diamondProj_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H1.exists_diamondProj_ne_zero

/--
info: 'QuantGrav.DiamondSetup.H14.clock_proj_eq_zero_of_lt_clockLowerBound' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H14.clock_proj_eq_zero_of_lt_clockLowerBound

/-- info: 'QuantGrav.DiamondSetup.exists_setup_not_H1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.exists_setup_not_H1

/--
info: 'QuantGrav.DiamondSetup.exists_setup_H1_H13_H14_diamondSpace_eq_top' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.exists_setup_H1_H13_H14_diamondSpace_eq_top

/-- info: 'QuantGrav.DiamondSetup.fixedAreaDiamondSpace_eq_map' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.fixedAreaDiamondSpace_eq_map

/-- info: 'QuantGrav.DiamondSetup.H14.h14a' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H14.h14a

/-- info: 'QuantGrav.DiamondSetup.H14a.fixedAreaDiamondSpace_eq_bot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.H14a.fixedAreaDiamondSpace_eq_bot

/-- info: 'QuantGrav.DiamondSetup.exists_setup_H1_H13_not_H14' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.exists_setup_H1_H13_not_H14

/-- info: 'QuantGrav.Sen.cLocal_pure_gravity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.Sen.cLocal_pure_gravity

/-- info: 'QuantGrav.Sen.mixedCoeff_four' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.Sen.mixedCoeff_four

/-- info: 'QuantGrav.Sen.mcCoeff_four' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.Sen.mcCoeff_four

/-- info: 'QuantGrav.Sen.singletCoeff_four' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.Sen.singletCoeff_four

/-- info: 'QuantGrav.fixed_mass_coeff_eq_sen_mixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.fixed_mass_coeff_eq_sen_mixed

/-- info: 'QuantGrav.fixed_mass_coeff_sub_sen_mc' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.fixed_mass_coeff_sub_sen_mc

/-- info: 'QuantGrav.fixed_mass_coeff_sub_sen_singlet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.fixed_mass_coeff_sub_sen_singlet

/-- info: 'QuantGrav.entropy_coeff_eq_sen_local_add_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.entropy_coeff_eq_sen_local_add_one

/-- info: 'QuantGrav.trace_log_prefactor_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.trace_log_prefactor_eq

/-- info: 'QuantGrav.focusing_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.focusing_nonneg

/-- info: 'QuantGrav.clock_reading_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_reading_ge

/-- info: 'QuantGrav.sq_integral_le_measure_mul_integral_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_integral_le_measure_mul_integral_sq

/-- info: 'QuantGrav.clock_mean_ge_area_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_mean_ge_area_div

/-- info: 'QuantGrav.clock_mean_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_mean_ge

/-- info: 'QuantGrav.clock_mean_ge_of_focusing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_mean_ge_of_focusing

/-- info: 'QuantGrav.clock_mean_eq_of_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.clock_mean_eq_of_const

/-- info: 'QuantGrav.exists_orthonormal_sum_sq_norm_gt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.exists_orthonormal_sum_sq_norm_gt

/-- info: 'QuantGrav.open_gluing_id_and_unbounded_partial_traces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.open_gluing_id_and_unbounded_partial_traces

/-- info: 'QuantGrav.cut_amplitude_le_neg_rank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cut_amplitude_le_neg_rank

/-- info: 'QuantGrav.tendsto_cut_amplitude_atBot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_cut_amplitude_atBot

/-- info: 'QuantGrav.not_tendsto_cut_amplitude_nhds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.not_tendsto_cut_amplitude_nhds

/-- info: 'QuantGrav.finiteDimensional_of_cut_amplitude_bddBelow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.finiteDimensional_of_cut_amplitude_bddBelow

/-- info: 'QuantGrav.hasSum_cos_div_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.hasSum_cos_div_sq

/-- info: 'QuantGrav.re_tsum_cexp_div_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.re_tsum_cexp_div_sq

/-- info: 'QuantGrav.re_pair_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.re_pair_amplitude

/-- info: 'QuantGrav.closedAmplitude_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.closedAmplitude_one

/-- info: 'QuantGrav.IsIncreasingExhaustion.tendsto_sum_inner_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.IsIncreasingExhaustion.tendsto_sum_inner_smul

/-- info: 'QuantGrav.IsIncreasingExhaustion.tendsto_open_cut_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.IsIncreasingExhaustion.tendsto_open_cut_sum

/-- info: 'QuantGrav.basisFlip_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.basisFlip_apply

/-- info: 'QuantGrav.closedAmplitude_basisFlip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.closedAmplitude_basisFlip

/-- info: 'QuantGrav.flipCutAmplitude_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.flipCutAmplitude_eq

/-- info: 'QuantGrav.flipCutAmplitude_five_limits' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.flipCutAmplitude_five_limits

/-- info: 'QuantGrav.isIncreasingExhaustion_five_routes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.isIncreasingExhaustion_five_routes

/-- info: 'QuantGrav.flipCutResponse_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.flipCutResponse_eq

/-- info: 'QuantGrav.flipCutAmplitude_eq_trace_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.flipCutAmplitude_eq_trace_mul

/-- info: 'QuantGrav.abs_flipCutResponse_le_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.abs_flipCutResponse_le_iff

/-- info: 'QuantGrav.integral_momentSum_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_momentSum_zero

/-- info: 'QuantGrav.firstMomentOf_momentSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.firstMomentOf_momentSum

/-- info: 'QuantGrav.secondMomentOf_momentSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.secondMomentOf_momentSum

/-- info: 'QuantGrav.reading_eq_sq_div_add_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.reading_eq_sq_div_add_integral

/-- info: 'QuantGrav.momentSum_one_eq_div_add_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.momentSum_one_eq_div_add_integral

/-- info: 'QuantGrav.hasDerivAt_log_integral_momentSum_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.hasDerivAt_log_integral_momentSum_div

/-- info: 'QuantGrav.sum_sq_reading_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sum_sq_reading_bounds

/-- info: 'QuantGrav.firstMomentOf_rpow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.firstMomentOf_rpow

/-- info: 'QuantGrav.secondMomentOf_rpow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.secondMomentOf_rpow

/-- info: 'QuantGrav.eq_sq_mul_two_sub_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.eq_sq_mul_two_sub_iff

/-- info: 'QuantGrav.sq_eq_div_two_sub_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_eq_div_two_sub_iff

/-- info: 'QuantGrav.powerLaw_moment_ratios' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.powerLaw_moment_ratios

/-- info: 'QuantGrav.sq_le_and_le_of_sq_eq_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_le_and_le_of_sq_eq_div

/-- info: 'QuantGrav.moment_ratios_of_q' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.moment_ratios_of_q

/-- info: 'QuantGrav.one_add_sum_le_prod_one_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.one_add_sum_le_prod_one_add

/-- info: 'QuantGrav.one_add_trace_le_det_one_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.one_add_trace_le_det_one_add

/-- info: 'QuantGrav.integral_exp_neg_mul_sq_gaussianReal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_exp_neg_mul_sq_gaussianReal

/-- info: 'QuantGrav.integral_exp_neg_sum_mul_sq_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_exp_neg_sum_mul_sq_pi

/-- info: 'QuantGrav.measureReal_sum_mul_sq_le_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.measureReal_sum_mul_sq_le_le

/-- info: 'QuantGrav.measureReal_infinitePi_sum_range_mul_sq_le_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.measureReal_infinitePi_sum_range_mul_sq_le_le

/-- info: 'QuantGrav.measure_forall_sum_range_mul_sq_le_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.measure_forall_sum_range_mul_sq_le_eq_zero

/-- info: 'QuantGrav.ae_tendsto_sum_mul_sq_atTop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.ae_tendsto_sum_mul_sq_atTop

/-- info: 'QuantGrav.le_sum_mul_radialVariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.le_sum_mul_radialVariance

/-- info: 'QuantGrav.tendsto_sum_mul_radialVariance_atTop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_sum_mul_radialVariance_atTop

/-- info: 'QuantGrav.tendsto_sum_mul_radialVariance_atTop_of_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_sum_mul_radialVariance_atTop_of_le

/-- info: 'QuantGrav.measureReal_focusing_le_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.measureReal_focusing_le_le

/-- info: 'QuantGrav.ae_tendsto_focusing_atTop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.ae_tendsto_focusing_atTop

/-- info: 'QuantGrav.ae_tendsto_focusing_atTop_of_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.ae_tendsto_focusing_atTop_of_le

/-- info: 'QuantGrav.tendsto_integral_div_add_fixed_modes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_integral_div_add_fixed_modes

/-- info: 'QuantGrav.mul_one_sub_le_integral_div_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.mul_one_sub_le_integral_div_add

/-- info: 'QuantGrav.tendsto_integral_div_add_all_modes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_integral_div_add_all_modes

/-- info: 'QuantGrav.proj_apply_eq_zero_of_forall_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.proj_apply_eq_zero_of_forall_exists

/--
info: 'QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_forall_exists' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_forall_exists

/-- info: 'QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_modes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_modes

/--
info: 'QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_gaussian_modes' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_gaussian_modes

/--
info: 'QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_radial_modes' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.diamondProj_Ω_eq_zero_of_radial_modes

/--
info: 'QuantGrav.DiamondSetup.not_H1_of_forall_diamondProj_Ω_eq_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
-/
#guard_msgs in
#print axioms QuantGrav.DiamondSetup.not_H1_of_forall_diamondProj_Ω_eq_zero

/-- info: 'QuantGrav.gibbsZ_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_nonneg

/-- info: 'QuantGrav.gibbsZ_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_pos

/-- info: 'QuantGrav.gibbsWeight_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsWeight_pos

/-- info: 'QuantGrav.gibbsWeight_mul_gibbsZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsWeight_mul_gibbsZ

/-- info: 'QuantGrav.sum_gibbsWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sum_gibbsWeight

/-- info: 'QuantGrav.gibbsEntropy_eq_mean_add_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsEntropy_eq_mean_add_log

/-- info: 'QuantGrav.card_eq_gibbsZ_mul_mean_exp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_eq_gibbsZ_mul_mean_exp

/-- info: 'QuantGrav.gibbsZ_mul_exp_mean_le_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_mul_exp_mean_le_card

/-- info: 'QuantGrav.gibbsEntropy_le_log_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsEntropy_le_log_card

/-- info: 'QuantGrav.sum_card_levelFiber' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sum_card_levelFiber

/-- info: 'QuantGrav.card_levelValues_le_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_levelValues_le_card

/-- info: 'QuantGrav.card_le_card_levelValues_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_le_card_levelValues_mul

/-- info: 'QuantGrav.gibbsEntropy_le_log_card_levelValues_add_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsEntropy_le_log_card_levelValues_add_log

/-- info: 'QuantGrav.gibbsZ_mul_exp_mean_le_card_levelValues_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_mul_exp_mean_le_card_levelValues_mul

/-- info: 'QuantGrav.inv_card_le_sum_sq_gibbsWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.inv_card_le_sum_sq_gibbsWeight

/-- info: 'QuantGrav.sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq

/-- info: 'QuantGrav.levelBand_subset_levelsBelow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.levelBand_subset_levelsBelow

/-- info: 'QuantGrav.gibbsProb_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsProb_nonneg

/-- info: 'QuantGrav.gibbsProb_mul_gibbsZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsProb_mul_gibbsZ

/-- info: 'QuantGrav.card_levelsBelow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_levelsBelow_le

/-- info: 'QuantGrav.gibbsProb_levelBand_mul_le_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsProb_levelBand_mul_le_card

/-- info: 'QuantGrav.card_levelBand_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_levelBand_le

/-- info: 'QuantGrav.card_le_card_image_mul_of_card_levelFiber_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_le_card_image_mul_of_card_levelFiber_le

/-- info: 'QuantGrav.gibbsProb_levelBand_mul_le_card_image_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsProb_levelBand_mul_le_card_image_mul

/-- info: 'QuantGrav.tendsto_log_card_levelsBelow_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_card_levelsBelow_div

/-- info: 'QuantGrav.tendsto_log_card_image_levelsBelow_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_card_image_levelsBelow_div

/-- info: 'QuantGrav.logLevels_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.logLevels_nonneg

/-- info: 'QuantGrav.logLevels_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.logLevels_le

/-- info: 'QuantGrav.logLevels_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.logLevels_injective

/-- info: 'QuantGrav.card_levelFiber_logLevels_le_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_levelFiber_logLevels_le_one

/-- info: 'QuantGrav.gibbsZ_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_logLevels

/-- info: 'QuantGrav.gibbsZ_logLevels_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.gibbsZ_logLevels_le

/-- info: 'QuantGrav.log_le_gibbsZ_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_le_gibbsZ_logLevels

/-- info: 'QuantGrav.card_levelsBelow_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.card_levelsBelow_logLevels

/-- info: 'QuantGrav.tendsto_log_gibbsZ_logLevels_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_gibbsZ_logLevels_div

/-- info: 'QuantGrav.exists_le_gibbsProb_levelBand_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.exists_le_gibbsProb_levelBand_logLevels

/-- info: 'QuantGrav.tendsto_log_card_levelsBelow_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_card_levelsBelow_logLevels

/-- info: 'QuantGrav.tendsto_log_card_image_levelsBelow_logLevels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_card_image_levelsBelow_logLevels

/-- info: 'QuantGrav.tendsto_integral_div_div_log_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_integral_div_div_log_div

/-- info: 'QuantGrav.tendsto_integral_div_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_integral_div_div_log

/-- info: 'QuantGrav.integral_pos_of_integral_pos_of_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_pos_of_integral_pos_of_le

/-- info: 'QuantGrav.intervalIntegrable_sub_integral_div_integral_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.intervalIntegrable_sub_integral_div_integral_div

/-- info: 'QuantGrav.log_integral_div_sub_log_integral_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_integral_div_sub_log_integral_div

/-- info: 'QuantGrav.log_eq_integral_add_log_sub_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.log_eq_integral_add_log_sub_log

/-- info: 'QuantGrav.tendsto_log_div_log_of_tendsto_integral_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_div_log_of_tendsto_integral_div

/-- info: 'QuantGrav.tendsto_log_div_log_div_of_tendsto_integral_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_div_log_div_of_tendsto_integral_div

/-- info: 'QuantGrav.cutoffZ_eq_momentSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffZ_eq_momentSum

/-- info: 'QuantGrav.cutoffZ_mul_cutoffMeanReading_eq_momentSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffZ_mul_cutoffMeanReading_eq_momentSum

/-- info: 'QuantGrav.cutoffZ_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffZ_nonneg

/-- info: 'QuantGrav.cutoffZ_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffZ_pos

/-- info: 'QuantGrav.monotone_cutoffZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.monotone_cutoffZ

/-- info: 'QuantGrav.integral_cutoffZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.integral_cutoffZ

/-- info: 'QuantGrav.firstMomentOf_cutoffZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.firstMomentOf_cutoffZ

/-- info: 'QuantGrav.cutoffEntropy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffEntropy_eq

/-- info: 'QuantGrav.tendsto_integral_cutoffZ_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_integral_cutoffZ_div

/-- info: 'QuantGrav.tendsto_log_cutoffZ_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_cutoffZ_div_log

/-- info: 'QuantGrav.tendsto_sub_div_log_of_tendsto_log_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_sub_div_log_of_tendsto_log_div_log

/-- info: 'QuantGrav.tendsto_log_div_of_tendsto_log_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_div_of_tendsto_log_div_log

/-- info: 'QuantGrav.tendsto_cutoffEntropy_sub_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_cutoffEntropy_sub_div_log

/-- info: 'QuantGrav.tendsto_log_cutoffZ_div_log_cutoffMeanArea' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_cutoffZ_div_log_cutoffMeanArea

/-- info: 'QuantGrav.tendsto_log_cutoffZ_div_cutoffMeanArea' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_cutoffZ_div_cutoffMeanArea

/-- info: 'QuantGrav.sq_gibbsMean_sqrt_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_gibbsMean_sqrt_le

/-- info: 'QuantGrav.sq_cutoffMeanSqrtArea_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sq_cutoffMeanSqrtArea_le

/-- info: 'QuantGrav.cutoffMeanSqrtArea_le_cutoffMeanReading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffMeanSqrtArea_le_cutoffMeanReading

/-- info: 'QuantGrav.cutoffMeanArea_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.cutoffMeanArea_le

/-- info: 'QuantGrav.tendsto_log_cutoffMeanArea_div_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_log_cutoffMeanArea_div_log

/-- info: 'QuantGrav.tendsto_cutoffEntropy_sub_div_log_of_delay' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.tendsto_cutoffEntropy_sub_div_log_of_delay

/-- info: 'QuantGrav.sum_sq_norm_le_div_of_neg_le_cut_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms QuantGrav.sum_sq_norm_le_div_of_neg_le_cut_amplitude
