module

/-!
# Hypothesis register

Physical and analytic inputs of arXiv:2611.34924v1 that this development does not prove.

Rule (handoff.md, WP0): an input enters Lean only as a structure field or an explicit theorem
argument, so that it is visible in the signature of every theorem that uses it. This file
declares no constants. An entry gets a formal statement here only once the objects it mentions
(`H_D`, the clock operator, `Ψ_L`, the cut amplitudes) have reviewed definitions; until then it
is prose with a status line, because a formal statement over a wrong definition would be worse
than none.

Locations were checked against the PDF text on 2026-11-26 unless marked "not re-read".
`FIDELITY.md` holds the longer notes and the paper's own support for each entry.

| ID  | Statement | Paper location | Status |
|-----|-----------|----------------|--------|
| H1  | `‖Ψ_L - Ω_A‖ → 0` as `L → ∞`. By (C.14) this is the same as `Ω_A` lying in the closure `M` of the form domain of the clock operator | (5.7), (5.16), fn 18, (C.13) to (C.16d) | prose only |
| H2  | Amplitude maps `U_M` are unitary | (4.18), not re-read | prose only |
| H3  | The sum over cut states converges to the uncut amplitude, with insertions held fixed, along the net of finite cycle-closed projections | (4.29), Sec 3.6, used at (5.38) | prose only; split into H3a, H3b on 2026-11-26 |
| H3a | With no insertion: the partial traces `Tr(P C_b† C_b)` over finite orthonormal families in `H_D` are bounded | implicit around (5.38); not stated in the paper | the abstract form is the hypothesis `hZ` of `finiteDimensional_of_sum_sq_norm_le` in `Diamond/FiniteDim.lean`; tied to `H_D` and `C_b` in prose only |
| H3b | With the insertion `X` of (5.37a): the partial sums `Z_P[X]` over cycle-closed projections converge to `Z[X]` | (5.38), Figure 30, (4.29) | prose only |
| H4  | The boost-sensitive observable has `⟨Δ_η O⟩ > δ_η / 2` in the uncut preparation `C_b` | (5.36b), (5.37b), (D.26) to (D.36) | prose only |
| H5  | Truncation projections on each cut converge strongly to the identity | sentence after (4.31) | prose only |
| H6  | The boost generator is `A / (8 π G)` | (5.22), (3.43) not re-read | prose only |
| H7  | `log Tr(C_b† C_b) = (106 / 45) log s_b + O(1)` from a one-loop curvature integral | (5.67a) to (5.67c), ref [71] | prose only |
| H8  | The limit `q` in (5.54b) exists; its value | (5.54b), (5.61), (5.68), fn 23 | arithmetic in `Elementary/LogCoefficient.lean`; existence of the limit is prose only |
| H9  | Choice of pure extension `ω`; unitary equivalence of other choices | (4.16) not re-read, fn 20 | prose only |
| H10 | `log d(s) ≲ 1 + (s Q_*)^(3/4)` | (D.45a) to (D.46c) | prose only |
| H11 | Each weight `k_a(s)` carries a disk factor `exp(s)` | paragraph above (D.48), ref [51] | prose only |
| H12 | Type I with integer weights; Euclidean to Lorentzian converse | App E.2, ref [36], not re-read | prose only |
| H13 | The clock operator (4.27) is a positive self-adjoint operator on `K_A` that commutes with the area operator, so that `P_D` in (5.2) is defined | (4.27), fn 14, (C.11) to (C.13), (C.17) | prose only; new on 2026-11-26 |
| H14 | Operator inequality `û ≥ (1 - ε) (A / 4π)^(1/2)`, giving `P_D A P_D ≤ 4π ℓ(D)² / (1 - ε)² P_D` | (5.21a) to (5.21d), fn 8 | prose only; new on 2026-11-26 |
| H15 | `C_D† C_D = P_D exp(-A / (4 G ℏ)) P_D`, from continuing the corner boost to `iπ` and gluing to the time reflection | (5.23a), (5.23b), App C | prose only; new on 2026-11-26 |

Entries are never deleted. A discharged entry keeps its row and links to the proof.
-/
