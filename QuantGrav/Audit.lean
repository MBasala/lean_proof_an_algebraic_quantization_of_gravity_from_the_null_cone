module

public import QuantGrav.Diamond.FiniteDim
public import QuantGrav.Elementary.ClockWeight
public import QuantGrav.Elementary.ClockWeightIntegral
public import QuantGrav.Elementary.LogCoefficient
public import QuantGrav.Elementary.PairAmplitude
public import QuantGrav.Elementary.PairAmplitudeLog
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
