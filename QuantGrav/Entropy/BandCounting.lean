/-
Copyright (c) 2026 Michael Basala. All rights reserved.
Released under MIT license as described in the file LICENSE.
Authors: Michael Basala
-/
module

public import QuantGrav.Entropy.GibbsAccounting
public import Mathlib.Order.Filter.AtTopBot.Basic
public import Mathlib.Topology.Order.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Topology.Algebra.Order.Field

/-!
# Counting states in a band of area: footnote 24

Paper: arXiv:2611.34924v1, Sec 5.3, footnote 24: (5.63), (5.64); App D.3: (D.46c).

This file is part of break attempt B2 of `handoff.md`, Section 14. Footnote 24 of the paper
infers the number of orthogonal states below a given area from their weight in the trace. With
`s_*` the largest area allowed by focusing, it states

* (5.63): `Pr(sᵢ ≤ a s_*) → a^{q / (2 (1 - q))}` for fixed `0 < a ≤ 1`, so every band
  `((a - δ) s_*, a s_*]` has positive limiting probability;
* each state has weight `e^{-sᵢ}` in the trace, and `log Z = o(s_*)`;
* (5.64): hence `dim (1_{[0, a s_*]}(ŝ) H_D) = exp[a s_* + o(s_*)]`.

The inference from the first two items to the third is correct, and is proved here for finite
spectra, in the notation of `QuantGrav/Entropy/GibbsAccounting.lean`.

## Results

* `card_levelsBelow_le`: at most `Z e^{c}` states have level at most `c`.
* `gibbsProb_levelBand_mul_le_card`, `card_levelBand_le`: the number `N` of states in the band
  `(b, c]` satisfies `P Z e^{b} ≤ N ≤ P Z e^{c}`, with `P` the probability of the band.
* `gibbsProb_levelBand_mul_le_card_image_mul`: if every level in the band has multiplicity at
  most `D`, the band contains at least `P Z e^{b} / D` distinct levels.
* `tendsto_log_card_levelsBelow_div`: (5.64) from (5.63), as a limit: `log N(a s_*) / s_* → a`.
* `tendsto_log_card_image_levelsBelow_div`: if the multiplicities are at most `D` with
  `log D = o(s_*)`, the number `m(a s_*)` of distinct levels below `a s_*` satisfies
  `log m(a s_*) / s_* → a` as well.

## What this does and does not say

The hypotheses of the two limit theorems are the paper's statements, taken as given:
`log Z = o(s_*)`, and the sentence after (5.63) that every band has positive limiting
probability. Neither is derived here, and (5.63) itself is not formalized.

The last item is the consequence recorded for B2. If the multiplicity of every area eigenvalue
is at most `D` with `log D = o(s_*)`, those two statements force `exp[a s_* + o(s_*)]` distinct
area eigenvalues below `a s_*`. The paper does not state this, and it does not say that the
multiplicities are small. Its bound (D.46c), `log d(s) ≲ 1 + (s Q_*)^{3/4}`, is on the graviton
states at fixed area, at one loop in flat spacetime and with the corner data held fixed, while
its Fock space at fixed area also contains excitations of the corner variables (Sec 4.2). So the
other possibility, few area eigenvalues with multiplicities of order `e^{s}` carried by states
that `d(s)` does not count, is not excluded by anything proved here.
-/

@[expose] public section

namespace QuantGrav

open Filter Topology

variable {ι : Type*} [Fintype ι]

/-- The states with level at most `c`. Its cardinality is the paper's
`dim (1_{[0, c]}(ŝ) H_D)` of (5.64), since the levels are nonnegative there. -/
noncomputable def levelsBelow (s : ι → ℝ) (c : ℝ) : Finset ι :=
  Finset.univ.filter fun i => s i ≤ c

/-- The states with level in the band `(b, c]`. -/
noncomputable def levelBand (s : ι → ℝ) (b c : ℝ) : Finset ι :=
  Finset.univ.filter fun i => b < s i ∧ s i ≤ c

/-- The probability `∑_{i ∈ t} pᵢ` of a set of states in the thermal state. -/
noncomputable def gibbsProb (s : ι → ℝ) (t : Finset ι) : ℝ :=
  ∑ i ∈ t, gibbsWeight s i

/-! ### Finite counts -/

private theorem mem_levelsBelow {s : ι → ℝ} {c : ℝ} {i : ι} :
    i ∈ levelsBelow s c ↔ s i ≤ c := by
  simp only [levelsBelow, Finset.mem_filter, Finset.mem_univ, true_and]

private theorem mem_levelBand {s : ι → ℝ} {b c : ℝ} {i : ι} :
    i ∈ levelBand s b c ↔ b < s i ∧ s i ≤ c := by
  simp only [levelBand, Finset.mem_filter, Finset.mem_univ, true_and]

/-- If every level in `t` is at most `c`, the states of `t` have weight at least `|t| e^{-c}`
in the trace. -/
private theorem card_mul_exp_neg_le_sum {κ : Type*} {s : κ → ℝ} {t : Finset κ} {c : ℝ}
    (h : ∀ i ∈ t, s i ≤ c) : (t.card : ℝ) * Real.exp (-c) ≤ ∑ i ∈ t, Real.exp (-s i) :=
  calc (t.card : ℝ) * Real.exp (-c)
      = ∑ _i ∈ t, Real.exp (-c) := by rw [Finset.sum_const, nsmul_eq_mul]
    _ ≤ ∑ i ∈ t, Real.exp (-s i) :=
        Finset.sum_le_sum fun i hi => Real.exp_le_exp.2 (neg_le_neg (h i hi))

/-- If every level in `t` is at least `b`, the states of `t` have weight at most `|t| e^{-b}`
in the trace. -/
private theorem sum_le_card_mul_exp_neg {κ : Type*} {s : κ → ℝ} {t : Finset κ} {b : ℝ}
    (h : ∀ i ∈ t, b ≤ s i) : ∑ i ∈ t, Real.exp (-s i) ≤ (t.card : ℝ) * Real.exp (-b) :=
  calc ∑ i ∈ t, Real.exp (-s i)
      ≤ ∑ _i ∈ t, Real.exp (-b) :=
        Finset.sum_le_sum fun i hi => Real.exp_le_exp.2 (neg_le_neg (h i hi))
    _ = (t.card : ℝ) * Real.exp (-b) := by rw [Finset.sum_const, nsmul_eq_mul]

private theorem le_mul_exp_of_mul_exp_neg_le {x y c : ℝ} (h : x * Real.exp (-c) ≤ y) :
    x ≤ y * Real.exp c :=
  calc x = x * Real.exp (-c) * Real.exp c := by
        rw [mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, mul_one]
    _ ≤ y * Real.exp c := mul_le_mul_of_nonneg_right h (Real.exp_pos c).le

private theorem mul_exp_le_of_le_mul_exp_neg {x y b : ℝ} (h : y ≤ x * Real.exp (-b)) :
    y * Real.exp b ≤ x :=
  calc y * Real.exp b
      ≤ x * Real.exp (-b) * Real.exp b := mul_le_mul_of_nonneg_right h (Real.exp_pos b).le
    _ = x := by rw [mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, mul_one]

theorem levelBand_subset_levelsBelow (s : ι → ℝ) (b c : ℝ) :
    levelBand s b c ⊆ levelsBelow s c := by
  intro i hi
  exact mem_levelsBelow.2 (mem_levelBand.1 hi).2

theorem gibbsProb_nonneg (s : ι → ℝ) (t : Finset ι) : 0 ≤ gibbsProb s t := by
  exact Finset.sum_nonneg fun i _ => (gibbsWeight_pos s i).le

theorem gibbsProb_mul_gibbsZ (s : ι → ℝ) (t : Finset ι) :
    gibbsProb s t * gibbsZ s = ∑ i ∈ t, Real.exp (-s i) := by
  rw [gibbsProb, Finset.sum_mul]
  exact Finset.sum_congr rfl fun i _ => gibbsWeight_mul_gibbsZ s i

/-- At most `Z e^{c}` states have level at most `c`, because each has weight at least `e^{-c}`
in the trace. This is the upper half of (5.64). -/
theorem card_levelsBelow_le (s : ι → ℝ) (c : ℝ) :
    ((levelsBelow s c).card : ℝ) ≤ gibbsZ s * Real.exp c := by
  have h : ((levelsBelow s c).card : ℝ) * Real.exp (-c) ≤ ∑ i ∈ levelsBelow s c, Real.exp (-s i) :=
    card_mul_exp_neg_le_sum fun i hi => mem_levelsBelow.1 hi
  exact le_mul_exp_of_mul_exp_neg_le
    (h.trans (Finset.sum_le_univ_sum_of_nonneg fun i => (Real.exp_pos (-s i)).le))

/-- A band `(b, c]` of probability `P` contains at least `P Z e^{b}` states, because each has
weight less than `e^{-b}` in the trace. This is the lower half of (5.64). -/
theorem gibbsProb_levelBand_mul_le_card (s : ι → ℝ) (b c : ℝ) :
    gibbsProb s (levelBand s b c) * gibbsZ s * Real.exp b ≤ (levelBand s b c).card := by
  rw [gibbsProb_mul_gibbsZ]
  exact mul_exp_le_of_le_mul_exp_neg
    (sum_le_card_mul_exp_neg fun i hi => (mem_levelBand.1 hi).1.le)

/-- A band `(b, c]` of probability `P` contains at most `P Z e^{c}` states. -/
theorem card_levelBand_le (s : ι → ℝ) (b c : ℝ) :
    ((levelBand s b c).card : ℝ) ≤ gibbsProb s (levelBand s b c) * gibbsZ s * Real.exp c := by
  rw [gibbsProb_mul_gibbsZ]
  exact le_mul_exp_of_mul_exp_neg_le
    (card_mul_exp_neg_le_sum fun i hi => (mem_levelBand.1 hi).2)

/-- A set of states whose levels have multiplicity at most `D` has at least `|t| / D` distinct
levels. -/
theorem card_le_card_image_mul_of_card_levelFiber_le (s : ι → ℝ) (t : Finset ι) {D : ℕ}
    (hD : ∀ i ∈ t, (levelFiber s (s i)).card ≤ D) :
    t.card ≤ (t.image s).card * D := by
  rw [mul_comm]
  refine Finset.card_le_mul_card_image t D fun x hx => ?_
  obtain ⟨i, hi, rfl⟩ := Finset.mem_image.1 hx
  refine (Finset.card_le_card fun j hj => ?_).trans (hD i hi)
  rw [levelFiber, Finset.mem_filter]
  exact ⟨Finset.mem_univ j, (Finset.mem_filter.1 hj).2⟩

/-- **Distinct levels in a band.** If every level in the band `(b, c]` has multiplicity at most
`D`, the band contains at least `P Z e^{b} / D` distinct levels. -/
theorem gibbsProb_levelBand_mul_le_card_image_mul (s : ι → ℝ) (b c : ℝ) {D : ℕ}
    (hD : ∀ x, b < x → x ≤ c → (levelFiber s x).card ≤ D) :
    gibbsProb s (levelBand s b c) * gibbsZ s * Real.exp b
      ≤ ((levelBand s b c).image s).card * D := by
  have h : (levelBand s b c).card ≤ ((levelBand s b c).image s).card * D :=
    card_le_card_image_mul_of_card_levelFiber_le s (levelBand s b c) fun i hi =>
      hD (s i) (mem_levelBand.1 hi).1 (mem_levelBand.1 hi).2
  refine (gibbsProb_levelBand_mul_le_card s b c).trans ?_
  exact_mod_cast h

/-! ### The limit of footnote 24 -/

/-- A set of states of positive probability is nonempty. -/
private theorem nonempty_of_gibbsProb_pos {s : ι → ℝ} {t : Finset ι} (h : 0 < gibbsProb s t) :
    t.Nonempty := by
  refine Finset.ne_empty_iff_nonempty.1 ?_
  rintro rfl
  rw [gibbsProb, Finset.sum_empty] at h
  exact lt_irrefl 0 h

/-- The trace of a spectrum with at least one state is positive. -/
private theorem gibbsZ_pos_of_nonempty {s : ι → ℝ} {t : Finset ι} (h : t.Nonempty) :
    0 < gibbsZ s := by
  obtain ⟨i, -⟩ := h
  have : Nonempty ι := ⟨i⟩
  exact gibbsZ_pos s

/-- If the band `(b, c]` has positive probability, some state has level at most `c`. -/
private theorem card_levelsBelow_pos {s : ι → ℝ} {b c p : ℝ} (hp : 0 < p)
    (h : p ≤ gibbsProb s (levelBand s b c)) : 0 < (levelsBelow s c).card :=
  (Finset.card_pos.2 (nonempty_of_gibbsProb_pos (hp.trans_le h))).trans_le
    (Finset.card_le_card (levelBand_subset_levelsBelow s b c))

/-- The lower half of (5.64) for one spectrum, in logarithms: if the band `(b, c]` has
probability at least `p > 0`, then `log p + log Z + b ≤ log N(c)`. -/
private theorem log_add_log_add_le_log_card_levelsBelow {s : ι → ℝ} {b c p : ℝ} (hp : 0 < p)
    (h : p ≤ gibbsProb s (levelBand s b c)) :
    Real.log p + Real.log (gibbsZ s) + b ≤ Real.log (levelsBelow s c).card := by
  have hZ : 0 < gibbsZ s := gibbsZ_pos_of_nonempty (nonempty_of_gibbsProb_pos (hp.trans_le h))
  have h1 : p * gibbsZ s * Real.exp b ≤ (levelsBelow s c).card :=
    calc p * gibbsZ s * Real.exp b
        ≤ gibbsProb s (levelBand s b c) * gibbsZ s * Real.exp b :=
          mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right h hZ.le) (Real.exp_pos b).le
      _ ≤ (levelBand s b c).card := gibbsProb_levelBand_mul_le_card s b c
      _ ≤ (levelsBelow s c).card :=
          Nat.cast_le.2 (Finset.card_le_card (levelBand_subset_levelsBelow s b c))
  calc Real.log p + Real.log (gibbsZ s) + b
      = Real.log (p * gibbsZ s * Real.exp b) := by
        rw [Real.log_mul (mul_pos hp hZ).ne' (Real.exp_pos b).ne', Real.log_mul hp.ne' hZ.ne',
          Real.log_exp]
    _ ≤ Real.log (levelsBelow s c).card :=
        Real.log_le_log (mul_pos (mul_pos hp hZ) (Real.exp_pos b)) h1

/-- The upper half of (5.64) for one spectrum, in logarithms: `log N(c) ≤ log Z + c`, if some
state has level at most `c`. -/
private theorem log_card_levelsBelow_le {s : ι → ℝ} {c : ℝ} (h : 0 < (levelsBelow s c).card) :
    Real.log (levelsBelow s c).card ≤ Real.log (gibbsZ s) + c := by
  have hZ : 0 < gibbsZ s := gibbsZ_pos_of_nonempty (Finset.card_pos.1 h)
  calc Real.log (levelsBelow s c).card
      ≤ Real.log (gibbsZ s * Real.exp c) :=
        Real.log_le_log (Nat.cast_pos.2 h) (card_levelsBelow_le s c)
    _ = Real.log (gibbsZ s) + c := by
        rw [Real.log_mul hZ.ne' (Real.exp_pos c).ne', Real.log_exp]

/-- For one spectrum, the number `m` of distinct levels at most `c` and the number `N` of
states with level at most `c` satisfy `log N - log D ≤ log m ≤ log N`, if every level at most
`c` has multiplicity at most `D` and `N` is positive. -/
private theorem log_card_image_levelsBelow_bounds {s : ι → ℝ} {c : ℝ} {D : ℕ}
    (hD : ∀ x, x ≤ c → (levelFiber s x).card ≤ D) (h : 0 < (levelsBelow s c).card) :
    Real.log (levelsBelow s c).card - Real.log D
        ≤ Real.log ((levelsBelow s c).image s).card ∧
      Real.log ((levelsBelow s c).image s).card ≤ Real.log (levelsBelow s c).card := by
  have hm : 0 < ((levelsBelow s c).image s).card :=
    Finset.card_pos.2 ((Finset.card_pos.1 h).image s)
  have hle : (levelsBelow s c).card ≤ ((levelsBelow s c).image s).card * D :=
    card_le_card_image_mul_of_card_levelFiber_le s (levelsBelow s c) fun i hi =>
      hD (s i) (mem_levelsBelow.1 hi)
  have hD0 : 0 < D := Nat.pos_of_ne_zero fun h0 => by
    rw [h0, mul_zero] at hle
    exact absurd h (Nat.not_lt.2 hle)
  constructor
  · rw [sub_le_iff_le_add, ← Real.log_mul (Nat.cast_pos.2 hm).ne' (Nat.cast_pos.2 hD0).ne']
    refine Real.log_le_log (Nat.cast_pos.2 h) ?_
    exact_mod_cast hle
  · exact Real.log_le_log (Nat.cast_pos.2 hm) (Nat.cast_le.2 Finset.card_image_le)

/-- Under the band hypothesis of `tendsto_log_card_levelsBelow_div`, eventually some state has
level at most `a σ`. -/
private theorem eventually_card_levelsBelow_pos {α : Type*} {l : Filter α} {ι : α → Type*}
    [∀ n, Fintype (ι n)] (s : ∀ n, ι n → ℝ) (σ : α → ℝ) {a : ℝ} (ha : 0 < a)
    (hband : ∀ δ, 0 < δ → δ < a → ∃ p, 0 < p ∧
      ∀ᶠ n in l, p ≤ gibbsProb (s n) (levelBand (s n) ((a - δ) * σ n) (a * σ n))) :
    ∀ᶠ n in l, 0 < (levelsBelow (s n) (a * σ n)).card := by
  obtain ⟨p, hp, hev⟩ := hband (a / 2) (half_pos ha) (half_lt_self ha)
  filter_upwards [hev] with n hn using card_levelsBelow_pos hp hn

/-- **(5.64) from (5.63).** For a family of finite spectra `s n` and scales `σ n → ∞` (the
paper's `s_*`), suppose `log Z = o(σ)` and, for every `0 < δ < a`, the band
`((a - δ) σ, a σ]` has probability bounded below by a positive constant eventually. Then the
number `N` of states with level at most `a σ` satisfies `log N / σ → a`. This is the paper's
`dim (1_{[0, a s_*]}(ŝ) H_D) = exp[a s_* + o(s_*)]`. -/
theorem tendsto_log_card_levelsBelow_div {α : Type*} {l : Filter α} {ι : α → Type*}
    [∀ n, Fintype (ι n)] (s : ∀ n, ι n → ℝ) (σ : α → ℝ) {a : ℝ} (ha : 0 < a)
    (hσ : Tendsto σ l atTop)
    (hZ : Tendsto (fun n => Real.log (gibbsZ (s n)) / σ n) l (𝓝 0))
    (hband : ∀ δ, 0 < δ → δ < a → ∃ p, 0 < p ∧
      ∀ᶠ n in l, p ≤ gibbsProb (s n) (levelBand (s n) ((a - δ) * σ n) (a * σ n))) :
    Tendsto (fun n => Real.log ((levelsBelow (s n) (a * σ n)).card) / σ n) l (𝓝 a) := by
  have hσpos : ∀ᶠ n in l, 0 < σ n := hσ.eventually_gt_atTop 0
  refine tendsto_order.2 ⟨fun a' ha' => ?_, fun a' ha' => ?_⟩
  · -- The lower bound: `log p / σ + log Z / σ + (a - δ) ≤ log N / σ`, with `a' < a - δ`.
    obtain ⟨δ, hδ, hδa, hδa'⟩ : ∃ δ, 0 < δ ∧ δ < a ∧ a' < a - δ := by
      refine ⟨min ((a - a') / 2) (a / 2), lt_min (by linarith) (by linarith),
        (min_le_right _ _).trans_lt (by linarith), ?_⟩
      have := min_le_left ((a - a') / 2) (a / 2)
      linarith
    obtain ⟨p, hp, hev⟩ := hband δ hδ hδa
    have hlim : Tendsto (fun n => Real.log p / σ n + Real.log (gibbsZ (s n)) / σ n + (a - δ)) l
        (𝓝 (a - δ)) := by
      have h := ((hσ.const_div_atTop (Real.log p)).add hZ).add_const (a - δ)
      rwa [add_zero, zero_add] at h
    filter_upwards [hev, hσpos, hlim.eventually_const_lt hδa'] with n hn hσn hlt
    refine hlt.trans_le ?_
    have h := log_add_log_add_le_log_card_levelsBelow hp hn
    calc Real.log p / σ n + Real.log (gibbsZ (s n)) / σ n + (a - δ)
        = (Real.log p + Real.log (gibbsZ (s n)) + (a - δ) * σ n) / σ n := by
          rw [add_div, add_div, mul_div_cancel_right₀ _ hσn.ne']
      _ ≤ Real.log (levelsBelow (s n) (a * σ n)).card / σ n :=
          div_le_div_of_nonneg_right h hσn.le
  · -- The upper bound: `log N / σ ≤ log Z / σ + a`.
    have hlim : Tendsto (fun n => Real.log (gibbsZ (s n)) / σ n + a) l (𝓝 a) := by
      have h := hZ.add_const a
      rwa [zero_add] at h
    filter_upwards [eventually_card_levelsBelow_pos s σ ha hband, hσpos,
      hlim.eventually_lt_const ha'] with n hn hσn hlt
    refine lt_of_le_of_lt ?_ hlt
    calc Real.log (levelsBelow (s n) (a * σ n)).card / σ n
        ≤ (Real.log (gibbsZ (s n)) + a * σ n) / σ n :=
          div_le_div_of_nonneg_right (log_card_levelsBelow_le hn) hσn.le
      _ = Real.log (gibbsZ (s n)) / σ n + a := by
          rw [add_div, mul_div_cancel_right₀ _ hσn.ne']

/-- **The forced number of distinct levels.** Under the hypotheses of
`tendsto_log_card_levelsBelow_div`, suppose also that every level at most `a σ` has multiplicity
at most `D n`, with `log D = o(σ)`. Then the number `m` of distinct levels at most `a σ`
satisfies `log m / σ → a`: there are `exp[a σ + o(σ)]` distinct levels below `a σ`. -/
theorem tendsto_log_card_image_levelsBelow_div {α : Type*} {l : Filter α} {ι : α → Type*}
    [∀ n, Fintype (ι n)] (s : ∀ n, ι n → ℝ) (σ : α → ℝ) {a : ℝ} (ha : 0 < a)
    (hσ : Tendsto σ l atTop)
    (hZ : Tendsto (fun n => Real.log (gibbsZ (s n)) / σ n) l (𝓝 0))
    (hband : ∀ δ, 0 < δ → δ < a → ∃ p, 0 < p ∧
      ∀ᶠ n in l, p ≤ gibbsProb (s n) (levelBand (s n) ((a - δ) * σ n) (a * σ n)))
    (D : α → ℕ) (hD : ∀ n x, x ≤ a * σ n → (levelFiber (s n) x).card ≤ D n)
    (hDσ : Tendsto (fun n => Real.log (D n) / σ n) l (𝓝 0)) :
    Tendsto (fun n => Real.log (((levelsBelow (s n) (a * σ n)).image (s n)).card) / σ n) l
      (𝓝 a) := by
  have hσpos : ∀ᶠ n in l, 0 < σ n := hσ.eventually_gt_atTop 0
  have hpos := eventually_card_levelsBelow_pos s σ ha hband
  have hN := tendsto_log_card_levelsBelow_div s σ ha hσ hZ hband
  have hlow : Tendsto (fun n => Real.log (levelsBelow (s n) (a * σ n)).card / σ n
      - Real.log (D n) / σ n) l (𝓝 a) := by
    have h := hN.sub hDσ
    rwa [sub_zero] at h
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' hlow hN ?_ ?_
  · filter_upwards [hpos, hσpos] with n hn hσn
    rw [← sub_div]
    exact div_le_div_of_nonneg_right (log_card_image_levelsBelow_bounds (hD n) hn).1 hσn.le
  · filter_upwards [hpos, hσpos] with n hn hσn
    exact div_le_div_of_nonneg_right (log_card_image_levelsBelow_bounds (hD n) hn).2 hσn.le

end QuantGrav
