module

public import Mathlib.Analysis.InnerProductSpace.Orthonormal
public import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Analysis.InnerProductSpace.GramSchmidtOrtho
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Dimension.Free
import Mathlib.Tactic.Linarith

/-!
# Finite dimension from bounded partial traces (finding F2)

Paper: arXiv:2611.34924v1, (5.30c), (5.38), (D.24), and the AdS argument (5.44) to (5.46).

This file is pure linear algebra. It uses no physics, no trace class and no completeness.

Let `C : H → K` be a bounded operator between complex inner product spaces. For a finite
orthonormal family `e` in `H`, the number `∑ i, ‖C (e i)‖²` is the partial trace
`Tr(P C† C)` over the projection `P` onto the span of `e`.

* `finiteDimensional_of_sum_sq_norm_le`, `finrank_le_of_sum_sq_norm_le`: if `C† C ≥ c > 0` and
  every partial trace is at most `Z`, then `H` is finite-dimensional with `dim H ≤ Z / c`.
* `sum_sq_norm_le_finrank`: conversely, if `H` is finite-dimensional and `C† C ≤ 1`, every
  partial trace is at most `dim H`.
* `finiteDimensional_iff_exists_sum_sq_norm_le`: so for `c ≤ C† C ≤ 1` with `c > 0`, `H` is
  finite-dimensional exactly when the partial traces are bounded.

Mapping to the paper: `H = H_D`, `C = C_b` restricted to `H_D`, and `c = e^{-s_*} m_{b,D}`, with
both operator bounds given by (5.30c). The bound `Z` on partial traces is hypothesis H3a: the sum
over cut states with no insertion converges to a finite uncut amplitude. See `FIDELITY.md`,
finding F2.
-/

public section

namespace QuantGrav

open Module

variable {H K : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K]

/-- If `c ‖v‖² ≤ ‖C v‖²` for all `v` with `c > 0`, and the partial traces `∑ i, ‖C (e i)‖²` over
finite orthonormal families are at most `Z`, then every finite orthonormal family has at most
`Z / c` members. This is the counting step of (D.24), `Tr(P C_b† C_b) ≥ rank(P) e^{-s_*} m`. -/
theorem card_orthonormal_le_of_sum_sq_norm_le (C : H →L[ℂ] K) {c Z : ℝ} (hc : 0 < c)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2)
    (hZ : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → ∑ i, ‖C (e i)‖ ^ 2 ≤ Z)
    (n : ℕ) (e : Fin n → H) (he : Orthonormal ℂ e) : (n : ℝ) ≤ Z / c := by
  rw [le_div_iff₀ hc]
  calc (n : ℝ) * c = ∑ i : Fin n, c * ‖e i‖ ^ 2 := by simp [he.1]
    _ ≤ ∑ i, ‖C (e i)‖ ^ 2 := Finset.sum_le_sum fun i _ => hlow (e i)
    _ ≤ Z := hZ n e he

/-- **Finding F2.** A bounded operator that is bounded below by `c > 0` and whose partial traces
over finite orthonormal families are bounded by `Z` acts on a finite-dimensional space. -/
theorem finiteDimensional_of_sum_sq_norm_le (C : H →L[ℂ] K) {c Z : ℝ} (hc : 0 < c)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2)
    (hZ : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → ∑ i, ‖C (e i)‖ ^ 2 ≤ Z) :
    FiniteDimensional ℂ H := by
  by_contra hfin
  have hrank : Cardinal.aleph0 ≤ Module.rank ℂ H := by
    rw [← not_lt, Module.rank_lt_aleph0_iff]
    exact hfin
  obtain ⟨f, hf⟩ := exists_linearIndependent_of_le_rank (R := ℂ) (M := H) (n := ⌊Z / c⌋₊ + 1)
    (Cardinal.natCast_lt_aleph0.le.trans hrank)
  have h := card_orthonormal_le_of_sum_sq_norm_le C hc hlow hZ _ _
    (InnerProductSpace.gramSchmidtNormed_orthonormal hf)
  have hlt : Z / c < (⌊Z / c⌋₊ + 1 : ℕ) := by exact_mod_cast Nat.lt_floor_add_one (Z / c)
  linarith

/-- **Finding F2**, the dimension bound: under the hypotheses of
`finiteDimensional_of_sum_sq_norm_le`, `dim H ≤ Z / c`. Compare (5.46),
`dim ≤ e^{βΛ} Z_β`. -/
theorem finrank_le_of_sum_sq_norm_le (C : H →L[ℂ] K) {c Z : ℝ} (hc : 0 < c)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2)
    (hZ : ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → ∑ i, ‖C (e i)‖ ^ 2 ≤ Z) :
    (finrank ℂ H : ℝ) ≤ Z / c := by
  have := finiteDimensional_of_sum_sq_norm_le C hc hlow hZ
  exact card_orthonormal_le_of_sum_sq_norm_le C hc hlow hZ _ _
    (stdOrthonormalBasis ℂ H).orthonormal

/-- Converse of finding F2: on a finite-dimensional space, a contraction has partial traces
bounded by the dimension. -/
theorem sum_sq_norm_le_finrank [FiniteDimensional ℂ H] (C : H →L[ℂ] K)
    (hup : ∀ v : H, ‖C v‖ ≤ ‖v‖) (n : ℕ) (e : Fin n → H) (he : Orthonormal ℂ e) :
    ∑ i, ‖C (e i)‖ ^ 2 ≤ finrank ℂ H := by
  have hn : n ≤ finrank ℂ H := by simpa using he.linearIndependent.fintype_card_le_finrank
  calc ∑ i, ‖C (e i)‖ ^ 2 ≤ ∑ _i : Fin n, (1 : ℝ) := by
        refine Finset.sum_le_sum fun i _ => ?_
        have h := hup (e i)
        rw [he.1 i] at h
        nlinarith [norm_nonneg (C (e i))]
    _ = n := by simp
    _ ≤ finrank ℂ H := by exact_mod_cast hn

/-- **Finding F2**, both directions. For an operator with `c ‖v‖² ≤ ‖C v‖² ≤ ‖v‖²`, `c > 0`,
the space is finite-dimensional exactly when the partial traces over finite orthonormal families
are bounded. In the paper's terms: given (5.30c), `dim H_D < ∞` is equivalent to H3a. -/
theorem finiteDimensional_iff_exists_sum_sq_norm_le (C : H →L[ℂ] K) {c : ℝ} (hc : 0 < c)
    (hlow : ∀ v : H, c * ‖v‖ ^ 2 ≤ ‖C v‖ ^ 2) (hup : ∀ v : H, ‖C v‖ ≤ ‖v‖) :
    FiniteDimensional ℂ H ↔
      ∃ Z : ℝ, ∀ (n : ℕ) (e : Fin n → H), Orthonormal ℂ e → ∑ i, ‖C (e i)‖ ^ 2 ≤ Z := by
  constructor
  · intro hfin
    exact ⟨finrank ℂ H, fun n e he => sum_sq_norm_le_finrank C hup n e he⟩
  · rintro ⟨Z, hZ⟩
    exact finiteDimensional_of_sum_sq_norm_le C hc hlow hZ

end QuantGrav
