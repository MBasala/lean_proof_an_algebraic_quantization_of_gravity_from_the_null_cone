/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.ClockHypotheses
public import QuantGrav.Diamond.ClosedCuts
public import QuantGrav.Diamond.FiniteDim
public import QuantGrav.Elementary.ClockLowerBound
public import QuantGrav.Elementary.ClockWeight
public import QuantGrav.Elementary.ClockWeightIntegral
public import QuantGrav.Elementary.LogCoefficient
public import QuantGrav.Elementary.PairAmplitude
public import QuantGrav.Elementary.PairAmplitudeLog
public import QuantGrav.Elementary.PairAmplitudeReal
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
