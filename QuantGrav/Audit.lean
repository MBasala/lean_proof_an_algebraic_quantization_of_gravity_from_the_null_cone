module

public import QuantGrav.Elementary.ClockWeight
public import QuantGrav.Elementary.LogCoefficient

/-!
# Axiom audit

Each headline theorem is listed here with the exact output of `#print axioms`, pinned by
`#guard_msgs`. The build fails if any of them starts depending on a different set of axioms,
so this file is the committed record required by `handoff.md`, Section 8.

The only axioms allowed are Lean's three standard ones: `propext`, `Classical.choice`,
`Quot.sound`.
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
