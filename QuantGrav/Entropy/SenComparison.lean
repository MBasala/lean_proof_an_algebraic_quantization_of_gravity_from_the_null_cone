module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# Comparison of the paper's logarithmic coefficient with Sen's (handoff Step 5)

Paper: arXiv:2611.34924v1, (5.65), (5.67c), (5.68), (5.69).
Sen: arXiv:1205.0971v2, "Logarithmic Corrections to Schwarzschild and Other Non-extremal Black
Hole Entropy in Different Dimensions", equations (1.1), (1.2), (1.4), (1.5), read from the
arXiv HTML rendering on 2026-11-26.

Sen gives the coefficient of `ln a` in the entropy of a non-extremal black hole of size `a`
(horizon area `A_H ∼ a^(D-2)`) in three ensembles, all counting states per unit interval of
mass:

* microcanonical (1.1): the angular momenta along the Cartan generators are fixed;
* mixed (1.4): all angular momenta are summed;
* singlet (1.5): only rotationally invariant states are counted.

The definitions below transcribe those formulas. The theorems evaluate them in four dimensions
for pure gravity and compare them with the paper's numbers. In four dimensions `ln A_H` is
`2 ln a`, so a coefficient of `log s` in the paper is half the corresponding coefficient of
`ln a` in Sen's paper.

What the theorems show:

* the paper's fixed-mass coefficient `106 / 45` of `log s_b` in (5.69) is Sen's mixed-ensemble
  coefficient, and differs from his microcanonical and singlet coefficients by `1/2` and `3/2`;
* in four dimensions without gauge fields Sen's mixed-ensemble coefficient is the local
  coefficient `C_local` alone, for every value of `C_local`;
* the prefactor of `log(s_b^(1/2))` in the paper's (5.67c) evaluates to `212 / 45`, Sen's
  `C_local` for pure gravity.

This file is arithmetic. It does not address whether the Lorentzian trace of the paper has the
logarithmic term (5.67c), which is hypothesis H7.
-/

@[expose] public section

namespace QuantGrav

namespace Sen

/-- Sen (1.2): the local coefficient `C_local` for an uncharged black hole in four dimensions,
with `nS` scalars, `nV` vectors, `nF` Dirac fermions and `n32` spin-3/2 fields minimally
coupled to gravity. The `424` is the graviton loop. -/
def cLocal (nS nV nF n32 : ℚ) : ℚ :=
  (2 * nS - 26 * nV + 7 * nF - 233 / 2 * n32 + 424) / 90

/-- Sen, after (1.1): the number of Cartan generators of the rotation group in `D` space-time
dimensions, `N_C = [(D - 1) / 2]`. -/
def numCartan (D : ℕ) : ℕ :=
  (D - 1) / 2

/-- Sen, after (1.5): the number of generators of the rotation group in `D` space-time
dimensions, `N_R = (D - 1)(D - 2) / 2`. -/
def numRotations (D : ℕ) : ℕ :=
  (D - 1) * (D - 2) / 2

/-- Sen (1.1): the coefficient of `ln a` in the microcanonical entropy, for local coefficient
`C` and `nV` gauge fields. -/
def mcCoeff (D : ℕ) (C nV : ℚ) : ℚ :=
  C - ((D : ℚ) - 4) / 2 - ((D : ℚ) - 2) / 2 * numCartan D - ((D : ℚ) - 4) / 2 * nV

/-- Sen (1.4): the coefficient of `ln a` in the mixed ensemble, where all angular momenta are
summed at fixed mass. -/
def mixedCoeff (D : ℕ) (C nV : ℚ) : ℚ :=
  C - ((D : ℚ) - 4) / 2 - ((D : ℚ) - 4) / 2 * nV

/-- Sen (1.5): the coefficient of `ln a` in the entropy of rotationally invariant states. -/
def singletCoeff (D : ℕ) (C nV : ℚ) : ℚ :=
  C - ((D : ℚ) - 4) / 2 - ((D : ℚ) - 2) / 2 * numRotations D - ((D : ℚ) - 4) / 2 * nV

/-- Sen, after (1.5): for pure gravity `C_local = 212 / 45`. -/
theorem cLocal_pure_gravity : cLocal 0 0 0 0 = 212 / 45 := by
  norm_num [cLocal]

/-- In four dimensions without gauge fields Sen's mixed-ensemble coefficient is `C_local`
itself: neither fixing the mass nor the zero modes adds a logarithm. -/
theorem mixedCoeff_four (C : ℚ) : mixedCoeff 4 C 0 = C := by
  norm_num [mixedCoeff]

/-- In four dimensions without gauge fields Sen's microcanonical coefficient is `C_local - 1`. -/
theorem mcCoeff_four (C : ℚ) : mcCoeff 4 C 0 = C - 1 := by
  norm_num [mcCoeff, numCartan]

/-- In four dimensions without gauge fields Sen's singlet coefficient is `C_local - 3`. For
pure gravity this is the `(212 / 45 - 3) ln a` stated after Sen (1.5). -/
theorem singletCoeff_four (C : ℚ) : singletCoeff 4 C 0 = C - 3 := by
  norm_num [singletCoeff, numRotations]

end Sen

/-- The paper's fixed-mass coefficient `106 / 45` of `log s_b` in (5.69) is half of Sen's
mixed-ensemble coefficient of `ln a` for pure gravity in four dimensions. Since `log s_b` is
`2 ln a` up to a constant, the two agree. -/
theorem fixed_mass_coeff_eq_sen_mixed :
    (106 / 45 : ℚ) = Sen.mixedCoeff 4 (Sen.cLocal 0 0 0 0) 0 / 2 := by
  norm_num [Sen.mixedCoeff, Sen.cLocal]

/-- The paper's fixed-mass coefficient exceeds Sen's microcanonical coefficient, in units of
`log s_b`, by `1 / 2`. -/
theorem fixed_mass_coeff_sub_sen_mc :
    (106 / 45 : ℚ) - Sen.mcCoeff 4 (Sen.cLocal 0 0 0 0) 0 / 2 = 1 / 2 := by
  norm_num [Sen.mcCoeff, Sen.cLocal, Sen.numCartan]

/-- The paper's fixed-mass coefficient exceeds Sen's singlet coefficient, in units of
`log s_b`, by `3 / 2`. -/
theorem fixed_mass_coeff_sub_sen_singlet :
    (106 / 45 : ℚ) - Sen.singletCoeff 4 (Sen.cLocal 0 0 0 0) 0 / 2 = 3 / 2 := by
  norm_num [Sen.singletCoeff, Sen.cLocal, Sen.numRotations]

/-- The coefficient `257 / 90` of `log s` in the paper's entropy formula (5.65), which is
`q / (2 (1 - q))` at `q = 257 / 302`, corresponds to `C_local + 1` in units of `ln a`. It is
none of Sen's three coefficients. -/
theorem entropy_coeff_eq_sen_local_add_one :
    (257 / 90 : ℚ) = (Sen.cLocal 0 0 0 0 + 1) / 2 := by
  norm_num [Sen.cLocal]

/-- The prefactor of `log(s_b^(1/2))` in the paper's (5.67c),
`53 / (45 (4π)²) · 8π · ∫_S R[q] dA` with `∫_S R[q] dA = 8π`, equals `212 / 45`, which is Sen's
`C_local` for pure gravity. -/
theorem trace_log_prefactor_eq :
    (53 : ℝ) / (45 * (4 * Real.pi) ^ 2) * (8 * Real.pi * (8 * Real.pi)) = 212 / 45 := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  field_simp
  ring

end QuantGrav
