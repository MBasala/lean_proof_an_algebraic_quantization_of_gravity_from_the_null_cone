/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Diamond.ConfigurationOnly
public import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Analysis.Normed.Group.Tannery
import Mathlib.Analysis.Normed.Lp.lpHolder

/-!
# The Weyl-pair hypothesis is satisfiable

`QuantGrav/Diamond/ConfigurationOnly.lean` proves that the first member of a Weyl pair
`IsWeylPairOn K V W c` has no eigenvector in `K`, so that `K` is zero or infinite-dimensional,
and draws consequences for `H_D`. This file shows that the hypotheses of those theorems can hold
on a nonzero space, so the theorems are not vacuous.

* `exists_isWeylPairOn_top`: on `ℓ²(ℤ)` there are `V`, `W` and `c` with `IsWeylPairOn ⊤ V W c`.
* `DiamondSetup.exists_setup_H1_isWeylPairOn`: there is a setup on `ℓ²(ℤ)` that satisfies H1,
  with a Weyl pair on its fixed-area space whose first member commutes with every clock
  projection.

The statements are existential. The witness in the proofs is `(V x)_n = x_{n-1}` together with
the phases `(W_s x)_n = e^{-i s n} x_n`, with `c = 1`. On the Fourier side, with
`f(θ) = ∑ₙ x_n e^{i n θ}`, `V` is multiplication by `e^{i θ}` and `W_s` is the rotation
`f(θ) ↦ f(θ - s)`: an angle and its angular momentum. That reading is commentary and is not
formalized. It is not the pair `(q̂, p̂)` on `L²(ℝ, dq)` of the paper's Sec 4.2, which is not
formalized either. In the witness setup the clock takes the single value `1` on the whole space,
so its projections are `0` or `1` and commute with everything, and the conclusion of the
theorems of `ConfigurationOnly.lean` is visible directly: for every maximum reading `ℓ ≥ 1`,
`H_D` is all of `ℓ²(ℤ)`. So the hypotheses are shown to be jointly consistent only for a clock
that takes one value. It is not a model of the paper's theory.
-/

public section

namespace QuantGrav

open Filter Topology

/-- The shift on `ℓ²(ℤ)`, `(V x)_n = x_{n-1}`, as a linear isometric equivalence. It is the
coordinate map of the standard Hilbert basis of `ℓ²(ℤ)` reindexed along `n ↦ n + 1`. -/
private noncomputable def l2Shift : lp (fun _ : ℤ => ℂ) 2 ≃ₗᵢ[ℂ] lp (fun _ : ℤ => ℂ) 2 :=
  ((HilbertBasis.ofRepr (LinearIsometryEquiv.refl ℂ (lp (fun _ : ℤ => ℂ) 2))).reindex
    (Equiv.addRight (1 : ℤ))).repr

/-- The entries of a shifted vector: `(V x)_n = x_{n-1}`. -/
private theorem l2Shift_apply (x : lp (fun _ : ℤ => ℂ) 2) (n : ℤ) :
    l2Shift x n = x (n - 1) := by
  rw [l2Shift, HilbertBasis.repr_reindex_apply]
  rfl

/-- The numbers `e^{-i s n}` have modulus one. -/
private theorem norm_exp_neg_mul_I (s : ℝ) (n : ℤ) :
    ‖Complex.exp (-(s * n) * Complex.I)‖ = 1 := by
  rw [← Complex.ofReal_intCast, ← Complex.ofReal_mul, ← Complex.ofReal_neg,
    Complex.norm_exp_ofReal_mul_I]

/-- The phases on `ℓ²(ℤ)`, `(W_s x)_n = e^{-i s n} x_n`, as a bounded operator: multiplication
by a sequence of numbers of modulus one. -/
private noncomputable def l2Phase (s : ℝ) :
    lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2 :=
  lp.mapCLM 2 (fun n : ℤ => Complex.exp (-(s * n) * Complex.I) • ContinuousLinearMap.id ℂ ℂ)
    zero_le_one fun n => by
      rw [norm_smul, norm_exp_neg_mul_I, one_mul]
      exact ContinuousLinearMap.norm_id_le

/-- The entries of a vector multiplied by the phases: `(W_s x)_n = e^{-i s n} x_n`. -/
private theorem l2Phase_apply (s : ℝ) (x : lp (fun _ : ℤ => ℂ) 2) (n : ℤ) :
    l2Phase s x n = Complex.exp (-(s * n) * Complex.I) * x n := by
  rw [l2Phase, lp.mapCLM_apply_coe]
  rfl

/-- The Weyl relation between the shift and the phases, `V W_s = e^{i s} W_s V`. Both sides have
`n`-th entry `e^{-i s (n - 1)} x_{n-1}`. The constant `c = 1` is written out so that the
statement has the form of `IsWeylPairOn.weyl`. -/
private theorem l2Shift_l2Phase (s : ℝ) (x : lp (fun _ : ℤ => ℂ) 2) :
    l2Shift (l2Phase s x) = Complex.exp ((1 : ℝ) * s * Complex.I) • l2Phase s (l2Shift x) := by
  ext n
  rw [l2Shift_apply, l2Phase_apply, lp.coeFn_smul, Pi.smul_apply, l2Phase_apply, l2Shift_apply,
    smul_eq_mul, ← mul_assoc, ← Complex.exp_add]
  congr 2
  push_cast
  ring

/-- The square of the norm of a vector of `ℓ²(ℤ)` is the sum of the squares of the moduli of its
entries. -/
private theorem hasSum_norm_sq (x : lp (fun _ : ℤ => ℂ) 2) :
    HasSum (fun n : ℤ => ‖x n‖ ^ 2) (‖x‖ ^ 2) := by
  have h := lp.hasSum_norm (p := 2) (by simp) x
  simpa using h

/-- The phases are strongly continuous at `s = 0`: `W_s x → x` as `s → 0`. The proof is
dominated convergence for the series `‖W_s x - x‖² = ∑ₙ |e^{-i s n} - 1|² |x_n|²`, whose terms
are at most `4 |x_n|²`. -/
private theorem tendsto_l2Phase (x : lp (fun _ : ℤ => ℂ) 2) :
    Tendsto (fun s : ℝ => l2Phase s x) (𝓝 0) (𝓝 x) := by
  -- The entries of `W_s x - x`.
  have hentry : ∀ (s : ℝ) (n : ℤ), ‖(l2Phase s x - x) n‖ ^ 2
      = ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ^ 2 * ‖x n‖ ^ 2 := by
    intro s n
    rw [lp.coeFn_sub, Pi.sub_apply, l2Phase_apply, ← sub_one_mul, norm_mul, mul_pow]
  -- `‖W_s x - x‖² = ∑ₙ |e^{-i s n} - 1|² |x_n|²`.
  have hsq : ∀ s : ℝ, ‖l2Phase s x - x‖ ^ 2
      = ∑' n : ℤ, ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ^ 2 * ‖x n‖ ^ 2 := by
    intro s
    rw [← (hasSum_norm_sq (l2Phase s x - x)).tsum_eq]
    exact tsum_congr (hentry s)
  -- Dominated convergence, with the summable bound `4 |x_n|²`.
  have hlim : Tendsto
      (fun s : ℝ => ∑' n : ℤ, ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ^ 2 * ‖x n‖ ^ 2)
      (𝓝 0) (𝓝 (∑' _ : ℤ, (0 : ℝ))) := by
    refine tendsto_tsum_of_dominated_convergence ((hasSum_norm_sq x).summable.mul_left 4) ?_ ?_
    · intro n
      have hc : Continuous fun s : ℝ =>
          ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ^ 2 * ‖x n‖ ^ 2 := by
        fun_prop
      simpa using hc.tendsto 0
    · refine Eventually.of_forall fun s n => ?_
      rw [Real.norm_of_nonneg (by positivity)]
      have h2 : ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ≤ 2 := by
        refine (norm_sub_le _ _).trans_eq ?_
        rw [norm_exp_neg_mul_I, norm_one]
        norm_num
      have h4 : ‖Complex.exp (-(s * n) * Complex.I) - 1‖ ^ 2 ≤ 4 :=
        (pow_le_pow_left₀ (norm_nonneg _) h2 2).trans_eq (by norm_num)
      exact mul_le_mul_of_nonneg_right h4 (sq_nonneg _)
  -- From the squares of the norms to the norms.
  have h1 : Tendsto (fun s : ℝ => ‖l2Phase s x - x‖ ^ 2) (𝓝 0) (𝓝 0) := by
    simpa only [hsq, tsum_zero] using hlim
  have h2 := h1.sqrt
  simp only [Real.sqrt_sq (norm_nonneg _), Real.sqrt_zero] at h2
  exact tendsto_iff_norm_sub_tendsto_zero.mpr h2

/-- **`IsWeylPairOn` can hold on a nonzero space.** On `ℓ²(ℤ)` there are a bounded operator
`V`, a family `W s` and a constant `c` that form a Weyl pair on the whole space. -/
theorem exists_isWeylPairOn_top :
    ∃ (V : lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2)
      (W : ℝ → lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2) (c : ℝ),
      IsWeylPairOn ⊤ V W c := by
  -- The shift, the phases, and `c = 1`.
  refine ⟨l2Shift.toLinearIsometry.toContinuousLinearMap, l2Phase, 1, ?_⟩
  exact
    { ne_zero := one_ne_zero
      map_mem := fun _ _ => Submodule.mem_top
      shift_mem := fun _ _ _ => Submodule.mem_top
      norm_map := fun x _ => l2Shift.norm_map x
      tendsto_shift := fun x _ => tendsto_l2Phase x
      weyl := fun s x _ => l2Shift_l2Phase s x }

namespace DiamondSetup

/-- **The hypotheses of the theorems of `ConfigurationOnly.lean` are jointly satisfiable.** There
is a setup on `ℓ²(ℤ)` that satisfies H1, together with a Weyl pair on its fixed-area space whose
first member commutes with every clock projection there. In the witness the clock takes one
value, so the commutation holds for a trivial reason. -/
theorem exists_setup_H1_isWeylPairOn :
    ∃ (S : DiamondSetup (lp (fun _ : ℤ => ℂ) 2))
      (V : lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2)
      (W : ℝ → lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2) (c : ℝ),
      S.H1 ∧ IsWeylPairOn S.fixedArea V W c ∧
        ∀ (ℓ : ℝ), ∀ x ∈ S.fixedArea, V (S.clock.proj ℓ x) = S.clock.proj ℓ (V x) := by
  obtain ⟨V, W, c, hVW⟩ := exists_isWeylPairOn_top
  -- A unit vector of `ℓ²(ℤ)`: the sequence that is `1` at `0` and `0` elsewhere.
  have hΩ : ‖(lp.single 2 (0 : ℤ) (1 : ℂ) : lp (fun _ : ℤ => ℂ) 2)‖ = 1 := by
    rw [lp.norm_single (by norm_num), norm_one]
  have hPΩ : (1 : lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2)
      (lp.single 2 (0 : ℤ) (1 : ℂ)) = lp.single 2 (0 : ℤ) (1 : ℂ) := rfl
  have hone : IsStarProjection (1 : lp (fun _ : ℤ => ℂ) 2 →L[ℂ] lp (fun _ : ℤ => ℂ) 2) :=
    IsStarProjection.one _
  -- The setup in which `K_𝒜` is the whole space and the clock reads `1` on all of it.
  have h13 := ofProjections_self_H13 1 hone _ hΩ hPΩ 1 2 1 (1 / 2) one_pos one_lt_two
    zero_le_one (by norm_num) (by norm_num)
  refine ⟨_, V, W, c, h13.h1, ?_, ?_⟩
  · -- `K_𝒜` is the range of the identity.
    have htop : (ofProjections 1 1 hone hone hone.isIdempotentElem.eq _ hΩ hPΩ 1 2 1 (1 / 2)
        one_pos one_lt_two zero_le_one (by norm_num) (by norm_num)).fixedArea = ⊤ := by
      rw [Submodule.eq_top_iff']
      intro x
      exact LinearMap.mem_range.mpr ⟨x, rfl⟩
    rw [htop]
    exact hVW
  · -- Each clock projection is the identity or zero.
    intro ℓ x _
    by_cases hℓ : (1 : ℝ) ≤ ℓ
    · simp only [ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte]
      rfl
    · simp only [ofProjections, SpectralFamily.ofProj, hℓ, ↓reduceIte]
      rw [zero_apply, zero_apply, map_zero]

end DiamondSetup

end QuantGrav
