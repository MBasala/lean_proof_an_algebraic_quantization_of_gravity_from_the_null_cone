# Second-reader review, 2026-11-26

> Status, added by the code session on 2026-11-26. Required change 1 was applied in the commit that added this
> file: the theorems of `ClosedCuts.lean` now take a margin `γ` and assume `Δ ≤ δ / 2 - γ`. Most of the optional
> improvements and the omissions listed in Section 5 were applied with it; Optional improvement 9 was not. See
> `handoff.md` Section 14.6 and finding F10 of `FIDELITY.md`. The report below is as the reviewer wrote it, and
> describes the files as they were at commit `846062e`.

## 1. Who reviewed what, and how

- **Date.** 2026-11-26.
- **Reviewer.** An automated second reader (Claude). It did not write any of the Lean under
  review and took no part in the first fidelity pass.
- **What was checked.** Statements and docstrings only: each public `def`, `structure` and
  `theorem` was restated from the Lean, checked by hand as mathematics, and compared with the
  TeX of arXiv:2611.34924v1 (`paper/arxiv-src/main.tex`). Proofs were not checked; the kernel
  does that.
- **Repository state.** Branch `b2-entropy-accounting` at commit `846062e`. Commit `7bafa6e`
  landed while the review was running. Among the reviewed files it changed only the module
  docstring of `QuantGrav/Hypotheses.lean`; the declarations reviewed there are the same before
  and after. Line numbers below are those at `846062e`.
- **Method.** Phase 1 was blind: only the Lean sources, `main.tex` and
  `paper/equation_index.tsv` were read. `FIDELITY.md`, `handoff.md`, `handoff-spectral.md`,
  `README.md` and `notes/` were not opened. Phase 1 results (Sections 2 to 4) were written to
  this file before Phase 2 began. Phase 2 (Section 5) then compared `FIDELITY.md` with the Lean.
  After Phase 2, Sections 2 to 4 were changed only as follows: two notes marked "Added after
  Phase 2" in Sections 2 and 3; the correction of a count in Required change 1 ("all four
  statements" for "the three conclusions"); the table of counts at the head of Section 4; and
  a few quoted phrases of the paper replaced by paraphrase. No classification was changed.
- **Disclosure.** During Phase 1 a search of `QuantGrav/` for the number `106 / 45` returned one
  line of the module docstring of `Hypotheses.lean` (the entry for H7). It concerns none of the
  four items reviewed in that file.

### Files covered

1. `QuantGrav/Diamond/ClosedCuts.lean` (7 theorems).
2. `QuantGrav/Diamond/OrderOfExhaustion.lean` (6 definitions, 21 theorems).
3. Four items: `H14a` (`QuantGrav/Hypotheses.lean`, lines 190 to 197), and `H14.h14a`,
   `H14a.fixedAreaDiamondSpace_eq_bot`, `exists_setup_H1_H13_not_H14`
   (`QuantGrav/Diamond/ClockHypotheses.lean`, lines 119 to 131 and 229 to 250).
4. `QuantGrav/Elementary/ClockLowerBound.lean` (8 theorems).
5. `QuantGrav/Entropy/ClockMoments.lean` (3 definitions, 21 theorems).
6. `QuantGrav/Elementary/PairAmplitudeReal.lean` (3 theorems).
7. `QuantGrav/Entropy/SenComparison.lean` (6 definitions, 9 theorems).

In total 88 declarations.

### `main.tex` line ranges read in full

- 528 to 602: (3.21) to (3.28), footnote 8.
- 1166 to 2099: Sec 4.3 from (4.20), all of Sec 4.4, and Sec 5.1 to Sec 5.3 complete. This
  contains (4.20) to (4.34), (5.1) to (5.69), footnotes 14 to 24 and the captions of
  Figures 18 to 33.
- 3135 to 3180: App C.3.
- 3285 to 3469: App D.2 complete, (D.13) to (D.36).
- 3560 to 3594: the end of App D.3.

Footnote numbers were established by counting `\footnote` and `\footnotemark` in the TeX:
footnote 8 is at line 596, 14 at 1229, 18 at 1583, 19 at 1613, 22 at 1834, 23 at 2012 (text at
2021), 24 at 2037. Figure numbers were established by counting captions: Figure 28 is at line
1771, 29 at 1805, 30 at 1830.

### Sen's paper

`SenComparison.lean` makes claims about arXiv:1205.0971. These were checked through an
automated fetch of `https://arxiv.org/abs/1205.0971` and of the HTML rendering it links to
(`v2`, the latest version). The fetch tool returns answers extracted from the page by a small
model, not the page text itself. So formulas (1.1) to (1.5) and (3.11) of Sen's paper are known
to this review only as that tool's transcription. Three separately worded queries agreed with
one another. The tool read the first 100,000 of 137,022 characters, which contained Sections
1 to 3 and the opening of Section 4.

### Scratch checks

- Lean: `C:\Users\MBasa\AppData\Local\Temp\claude\642fab9172d2762b\46ee59a5-ccb3-4618-a144-8046389e72da\scratchpad\review2\ScratchClosedCuts.lean`.
  It prints the eleven statements of items 1 and 3 as the kernel sees them, proves the variant
  of `cut_amplitude_le_neg_rank` proposed in Required change 1, and checks the one-vector
  example used there. It compiles against the built project.
- Python: `C:\Users\MBasa\AppData\Local\Temp\claude\642fab9172d2762b\46ee59a5-ccb3-4618-a144-8046389e72da\scratchpad\review2\checks.py`.
  Numerical checks of the cosine series of `PairAmplitudeReal.lean` inside and outside its
  range, of the finite-spectrum identities and power-law ratios of `ClockMoments.lean`, of the
  fractions at `q = 257/302`, and a brute-force evaluation of the model of
  `OrderOfExhaustion.lean`. All agreed with the Lean statements.

### Not reviewed

- Proofs.
- The other declarations of `Hypotheses.lean`, `ClockHypotheses.lean` and `Setup.lean`. They
  were read only as far as needed to unfold the four items of point 3. The module docstring of
  `Hypotheses.lean` was not reviewed.
- `FiniteDim.lean`, `CutSums.lean`, `LogCoefficient.lean`, `PairAmplitudeLog.lean`. The first
  two were read for the lemmas that `ClosedCuts.lean` cites.
- Cross-references from docstrings to `handoff.md` and to
  `notes/external-audits-2026-11-26.md` (see Section 5 for an existence check only).
- Sen's paper beyond what the fetch tool reported, as described above.

## 2. Required changes

One item.

1. **`QuantGrav/Diamond/ClosedCuts.lean`: the threshold `δ / 4` is attributed to the paper's
   cuts.** Declarations: `tendsto_cut_amplitude_atBot` (docstring, lines 100 to 102),
   `finiteDimensional_of_cut_amplitude_bddBelow` (docstring, lines 125 to 131), and the module
   docstring (lines 29 to 36).

   *What is wrong.* All four statements `cut_amplitude_le_neg_rank`,
   `tendsto_cut_amplitude_atBot`, `not_tendsto_cut_amplitude_nhds` and
   `finiteDimensional_of_cut_amplitude_bddBelow` assume `Δ ≤ δ / 4`. The paper's condition on
   its cuts is `δ_η / 2`, not `δ_η / 4`: (5.37b) at lines 1815 to 1819 reads
   abs⟨Δ_η O⟩_P ≤ δ_η/2, and App D.2 at line 3383 chooses Δs and r "so that the upper bound
   in (5.32) is less than" abs(δ_η)/2. No line of the TeX gives `δ_η / 4`. The docstring of
   `tendsto_cut_amplitude_atBot` nevertheless begins "In infinite dimension the paper's own
   cuts force the closed amplitude to `-∞`", and that of
   `finiteDimensional_of_cut_amplitude_bddBelow` says "In the paper the cuts of large rank and
   small response come from (D.24), (D.25) with (5.32)", in both cases without saying that the
   paper's bound is `δ_η / 2`.

   *Why it matters.* With only the displayed bound of (5.37b), `Δ ≤ δ / 2`, the conclusions of
   all four statements fail. The project's own model shows it: in `OrderOfExhaustion.lean` the
   cut `twoFamilyCut (3 * n) n` has response exactly `δ / 2` (`flipCutResponse_eq`), rank
   `4 n`, and closed amplitude `0` (`flipCutAmplitude_five_limits`), on an infinite-dimensional
   space with `C† C = w > 0`. So the closed amplitude is bounded below, and even constant, on
   cuts of unbounded rank that satisfy (5.37b), and the space is not finite-dimensional. "H3c
   suffices" is true only for cuts whose response stays a fixed distance below `δ / 2`. (The
   paper's own route does not need the margin, because it uses H3b and H4.)

   *What the TeX does support.* The bound of (5.32) with (D.25) does not depend on P, and line
   3383 makes it strictly less than `δ_η / 2`. Call it β. Then the paper's own cuts have
   response at most β < `δ_η / 2`, and `Z_P[X] ≤ -c (δ_η/2 - β) rank P`. So the sentence about
   the paper's own cuts is true, but the theorem as stated proves it only if β ≤ `δ_η / 4`,
   which needs Δs and r chosen more tightly than the paper says. The construction allows that
   choice; the paper does not make it.

   *Smallest fix.* Either of:
   - (a) Docstrings only. In `tendsto_cut_amplitude_atBot` replace "the paper's own cuts" by
     "cuts built as in App D.2 with Δs and r chosen so that the bound of (5.32) is at most
     `δ_η / 4`; the paper asks only for less than `δ_η / 2` (line 3383)". Add one sentence to
     the module docstring and to `finiteDimensional_of_cut_amplitude_bddBelow`: "`δ / 4` is
     this file's choice; under (5.37b) as displayed, `Δ_P ≤ δ / 2`, the conclusion fails
     (`twoFamilyCut (3 * n) n` in `OrderOfExhaustion.lean`)."
   - (b) Generalise the hypothesis to `Δ ≤ δ / 2 - γ` with `0 < γ`, and the bound to
     `-(c * γ) * n`. This covers the paper's own choice with `γ = δ_η/2 - β`. The scratch file
     proves this variant of `cut_amplitude_le_neg_rank` with the same four-line argument; the
     other three follow as before.

   *Added after Phase 2.* `FIDELITY.md` already records the difference, correctly, in the row
   for `cut_amplitude_le_neg_rank` (line 432). The Lean docstrings do not, and two other
   places of the log repeat the unqualified wording; see Section 5.1.

No statement was classified MISMATCH or WRONG CITATION, and none is false or vacuous.

## 3. Optional improvements

1. **`ClosedCuts.lean`, `finiteDimensional_of_cut_amplitude_bddBelow`: relation of H3c to
   H3a.** With `Δ ≤ δ / 4` and `δ > 0`, the hypothesis `-B ≤ T * (Δ - δ / 2)` forces
   `T ≤ 4 B / δ`. So on such cuts "closed amplitude bounded below" is the same as "partial
   trace bounded above", and the proof is the counting step of
   `finiteDimensional_of_sum_sq_norm_le` once more. With a two-sided bound on the response the
   two are equivalent. The docstring compares H3c only with H3b and H4. One sentence relating
   it to H3a (it is H3a restricted to cuts of small response) would tell the reader that H3c
   is not a weaker assumption than H3a on those cuts. Also, `Δ` in `hcuts` is an existentially
   quantified real with only an upper bound; it is not tied to the cut. The module docstring
   says so for the file ("just a real number attached to the cut"); it is worth repeating at
   the theorem.
2. **`ClosedCuts.lean`, `open_gluing_id_and_unbounded_partial_traces`.** The second conjunct
   is an inequality for a `tsum` of norms with no `Summable` statement. Taken alone it would
   hold for a non-summable family too, because such a `tsum` is `0`. Summability is true here
   (`summable_norm_inner_cut`, or the first conjunct, since in `ℂ` unconditional convergence is
   absolute), so (4.30) is fully covered only by the conjunction with outside knowledge. Add
   the `Summable` conjunct or a pointer. In the module docstring, "as every bounded operator
   does" is exact for (4.29) and for absolute convergence; the bound of (4.30) as printed
   (line 1375) needs operators of norm at most one (`tsum_norm_inner_cut_le_of_norm_le_one`).
3. **`ClosedCuts.lean`, `mul_card_le_sum_sq_norm`.** "Paper (D.24), the counting step": the
   inequality `Tr(P C_b† C_b) ≥ (k + N) e^{-s_*} m_{b,D}` is in the sentence before (D.24), at
   line 3372. Naming that sentence would make the pointer exact.
4. **`OrderOfExhaustion.lean`, module docstring, "the paragraph before (5.37)"** (twice, lines
   52 to 54 and 77 to 80). The statement that P tends strongly to the identity as the cycles
   are included, and the construction of the cycles, are at line 1800, in the paragraph that
   opens with the supposition that `H_D` is infinite dimensional. Between it and (5.37) come
   Figure 29 and the paragraph at line 1809 that introduces (5.37). The pointer is right if
   read as "the paragraph before the one that contains (5.37)"; giving the line or the opening
   words would remove the doubt.
5. **`OrderOfExhaustion.lean`: say how much margin the three admissible routes have.** The
   docstring says that the cuts of the routes `(3 n, n)`, `(3 n + 2, n)` and `(7 n, n)` satisfy
   (5.37b). That is correct for (5.37b) as displayed, which is non-strict. But `(3 n, n)` has
   response exactly `δ / 2`, and `(3 n + 2, n)` has response `2 n δ / (4 n + 2)`, which tends
   to `δ / 2`. Only `(7 n, n)` stays away from the threshold (response `δ / 4`). App D.2, line
   3383, asks for a bound strictly below `δ_η / 2` that is the same for all P; the first two
   routes do not meet that. On `(7 n, n)` the limit `-∞` is what
   `tendsto_cut_amplitude_atBot` of `ClosedCuts.lean` predicts for any order. Stating this
   would let the two files be read together: for cuts with a uniform margin the closed
   amplitude tends to `-∞` whatever the order, and the order dependence shown by the five
   routes is among cuts with no such margin or violating (5.37b). The informal reading of
   `twoFamilyCut (3 * n) n` as unions of cycles of length 4 "in the sense of the paragraph
   before (5.37)" is then the boundary case, since the paper takes r as large as the bound
   needs (line 1800).
   A further remark, from the scratch script and not from the Lean: with the cycles of length
   4 fixed, two different exhaustions by complete cycles give `0` and `-∞`, so the order
   dependence in the boundary case does not need routes with different cycle lengths.
6. **`ClockMoments.lean`, `moment_ratios_of_q`.** The third conjunct,
   `q / (2 (1 - q)) - 1 = 167 / 90`, is not explained. The paper's (5.69), line 2093, has
   `q / (2 (1 - q)) - 1/2 = 106 / 45`, so a reader may take the `- 1` for a slip. The number
   `167 / 90` is half of `Sen.mcCoeff 4 (212/45) 0`, Sen's microcanonical coefficient in units
   of `log s`. If that is the intent, say so; the module docstring (line 59) does not mention
   the third conjunct at all. *Added after Phase 2.* `FIDELITY.md`, F3 (line 492), gives the
   meaning: it is the exponent of the density of `s / s_*` implied by (5.63). The docstring
   should carry that sentence.
7. **`ClockMoments.lean`, `sq_le_and_le_of_sq_eq_div`.** The docstring opens "Paper (5.54b),
   (5.54c)". The paper derives those bounds from concavity of the square root and from
   focusing (lines 1970 to 1982). The theorem derives them from the relation
   `x² = q / (2 - q)` of footnote 23. It is a consistency check, not the paper's argument;
   "consistent with (5.54b), (5.54c)" would say that.
8. **`ClockMoments.lean`, module docstring.** The step "so it is a relation between `q` and
   `x`" identifies the paper's `x = (1 - ε) r_h / ℓ` with the square root of the second-moment
   ratio. That identification is the first half of (5.60), which rests on (5.53) and (5.21c).
   `sum_sq_reading_bounds` supplies the error term but (5.53) is the paper's premise. One
   sentence saying so would complete the account of what the conclusion "They are not" rests
   on. The list under "What is not here" could also name (5.54a) and (5.57b), which are not
   formalized.
9. **`ClockHypotheses.lean`, `exists_setup_H1_H13_not_H14`.** In the model the clock projection
   at `ℓ = 0` is the identity on `K_𝒜` while `clockLowerBound > 0`, so H14a fails as well
   (checked by hand, not in Lean). The theorem could conclude `¬S.H14a`, which is the stronger
   non-implication, with `¬S.H14` following by `H14.h14a`.

## 4. Per-file tables

Classifications: FAITHFUL; FAITHFUL WITH CAVEAT (FWC); MISMATCH; NOT IN THE PAPER (NIP);
WRONG CITATION. "Lines" are lines of `main.tex`.

Counts.

| item | declarations | FAITHFUL | FWC | NIP | MISMATCH | WRONG CITATION |
| --- | --- | --- | --- | --- | --- | --- |
| `ClosedCuts.lean` | 7 | 1 | 1 | 5 | 0 | 0 |
| `OrderOfExhaustion.lean` | 27 | 1 | 4 | 22 | 0 | 0 |
| The four items | 4 | 0 | 1 | 3 | 0 | 0 |
| `ClockLowerBound.lean` | 8 | 7 | 0 | 1 | 0 | 0 |
| `ClockMoments.lean` | 24 | 6 | 3 | 15 | 0 | 0 |
| `PairAmplitudeReal.lean` | 3 | 0 | 1 | 2 | 0 | 0 |
| `SenComparison.lean` | 15 | 2 | 0 | 13 | 0 | 0 |
| Total | 88 | 17 | 10 | 61 | 0 | 0 |

Every NIP item is either a helper, a model, a consequence, or a transcription of Sen, and in
each case the Lean docstring presents it as such. The one docstring that attributes more to
the paper than the TeX gives is the subject of Required change 1.

### 4.1 `QuantGrav/Diamond/ClosedCuts.lean`

Throughout, `C : H → K` is a bounded operator between complex inner product spaces, `T` is the
partial trace `∑ i, ‖C (e i)‖²` over a finite orthonormal family `e` of `n` vectors, and `hlow`
is `∀ v, c ‖v‖² ≤ ‖C v‖²`.

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `exists_orthonormal_sum_sq_norm_gt` | `c > 0`, `hlow`, `H` not finite-dimensional: for every real `Z` some finite orthonormal family has `T > Z`. | 3372 | NIP | Contrapositive of a project lemma; the docstring says so. True because families of every size exist and `T ≥ c n`. |
| `open_gluing_id_and_unbounded_partial_traces` | `H` complete and not finite-dimensional, `b` any Hilbert basis, `φ ψ` any vectors: (i) `∑ ⟨φ, b i⟩ ⟨b i, ψ⟩` converges unconditionally to `⟨φ, ψ⟩`; (ii) the `tsum` of the norms of the terms is at most `‖φ‖ ‖ψ‖`; (iii) for every `Z` a finite orthonormal family has `∑ ‖1 (e i)‖² > Z`. | 1266 to 1272, 1371 to 1378 | NIP | A countermodel to an inference, worded as one ("does not imply H3a"). (i), (ii) are (4.29), (4.30) with both operators the identity. (iii) is the size of the family. See Optional 2. |
| `mul_card_le_sum_sq_norm` | `hlow` (any real `c`): `c n ≤ T`. | 3372 to 3377 | FAITHFUL | The sentence before (D.24). Optional 3. |
| `cut_amplitude_le_neg_rank` | `hlow`, `δ ≥ 0`, a real `Δ ≤ δ / 4`: `T (Δ - δ/2) ≤ -(c δ / 4) n`. | 1810 to 1826, 3383 | FWC | The product is the form of (5.38). Stronger hypothesis than (5.37b), which has `δ / 2`; the paper's conclusion is `≤ 0`. Required 1. |
| `tendsto_cut_amplitude_atBot` | `c > 0`, `δ > 0`, `hlow`; a family of orthonormal families indexed by `α` with `Δ a ≤ δ / 4` and sizes tending to infinity along a filter: `T (Δ - δ/2)` tends to `-∞`. | 1800, 1822 to 1834, 3372 to 3383 | NIP | A consequence, not a claim of the paper. Docstring "the paper's own cuts": Required 1. Not vacuous in infinite dimension. |
| `not_tendsto_cut_amplitude_nhds` | Same hypotheses, filter not trivial: the same function has no real limit. | 1834 | NIP | Agrees with the paper's reductio: the partial sums cannot approach `Z[X]`. Same threshold. |
| `finiteDimensional_of_cut_amplitude_bddBelow` | `c > 0`, `δ > 0`, `hlow`. If [`H` not finite-dimensional implies: for every `N` there are `n ≥ N`, an orthonormal family of size `n` and a real `Δ ≤ δ / 4` with `-B ≤ T (Δ - δ/2)`], then `H` is finite-dimensional. | 1800, 1822 to 1834, 3372 to 3383 | NIP | An alternative hypothesis (H3c); the docstring says so. Not vacuous: the hypothesis holds in every finite-dimensional space. It forces `T ≤ 4 B / δ`. Required 1, Optional 1. |

Other attributions in the module docstring were checked and are supported: the constant
`c = e^{-s_*} m_{b,D}` is (5.30c), line 1747; the cut and `Tr(P C_b† C_b)` are line 1751 and (5.32);
`δ_η > 0` is line 1809; "H3b asks them to converge to `Z[X]`" is line 1834 and the caption of
Figure 30 (line 1830); positivity of `Z[X]` is line 1822.

### 4.2 `QuantGrav/Diamond/OrderOfExhaustion.lean`

`b` is a Hilbert basis, `F = basisFlip b`, the preparation is `C = √w · 1`, and the cut is
`twoFamilyCut r n`.

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `closedAmplitude` (def) | `∑_{i,j ∈ P} ⟨C b_i, A C b_j⟩ · conj ⟨b_i, B b_j⟩` for bounded `C A B` and a finite label set `P`. | 1751 to 1758, 3359 to 3363 | FWC | Numerator of (5.31) for product observables only; the reflected copy is modelled by complex-conjugate matrix elements. The docstring says both. |
| `closedAmplitude_one` | With `A = B = 1` it is `∑_{i ∈ P} ‖C b_i‖²`. | 1752 to 1757 | FAITHFUL | Denominator of (5.31). |
| `IsIncreasingExhaustion` (def) | A sequence of finite label sets that is monotone and reaches every label. | 1800 | FWC | Covers countable label sets only. The paper orders cycles by inclusion and allows an uncountable basis (lines 1800, 3379). |
| `IsIncreasingExhaustion.tendsto_atTop` | Such a sequence eventually contains every finite set. | none | NIP | Helper. |
| `IsIncreasingExhaustion.tendsto_sum_inner_smul` | Along such a sequence `∑_{i ∈ P n} ⟨b_i, x⟩ b_i → x` for every `x`. | 1800 | FWC | The sequence case of "P → 1 strongly". |
| `IsIncreasingExhaustion.tendsto_open_cut_sum` | For bounded `U₁`, `U₂` the sums `∑_{i ∈ P n} ⟨φ, U₂ b_i⟩ ⟨b_i, U₁ ψ⟩` tend to `⟨φ, U₂ U₁ ψ⟩`. | 1266 to 1272 | FWC | A corollary of (4.29) for sequences of cuts; (4.29) itself is `hasSum_inner_cut`. |
| `twoFamilyCut` (def) | Labels `(k, false)` with `k < r` and `(k, true)` with `k < n`. | none | NIP | Model. |
| `mem_twoFamilyCut` | Membership in that set. | none | NIP | Helper. |
| `twoFamilyCut_subset` | Monotone in `r` and `n`. | none | NIP | Helper. |
| `isIncreasingExhaustion_twoFamilyCut` | `r`, `s` monotone, `s n ≤ r n`, `s` unbounded: `twoFamilyCut (r n) (s n)` is an increasing exhaustion. | none | NIP | Helper. Checked by hand. |
| `sum_twoFamilyCut` | A sum over the cut splits into the two families. | none | NIP | Helper. |
| `card_twoFamilyCut` | The cut has `r + n` labels. | none | NIP | Helper. |
| `filter_partner_mem_twoFamilyCut` | For `n ≤ r` the labels whose partner is in the cut are `twoFamilyCut n n`. | none | NIP | Helper. Fails for `n > r`, as the hypothesis indicates. |
| `card_filter_partner_mem_twoFamilyCut` | For `n ≤ r` there are `2 n` of them. | none | NIP | Helper. |
| `basisFlip` (def) | The unitary built from the relabelling `(k, a) ↦ (k, !a)`. | none | NIP | Model. |
| `basisFlip_apply` | `F (b (k, a)) = b (k, !a)`. | none | NIP | Model. |
| `inner_basisFlip` | `⟨b_i, F b_j⟩` is `1` if `i` is the partner of `j`, else `0`. | none | NIP | Model. |
| `closedAmplitude_basisFlip` | `w ≥ 0`: the closed amplitude with insertions `F`, `F` is `w` times the number of labels of `P` whose partner is in `P`. | none | NIP | Model. Checked by brute force. |
| `sum_sq_norm_sqrt_smul_one` | `w ≥ 0`: the partial trace over `P` is `w` times the number of labels. | none | NIP | Model. Supports "`C† C = w` has infinite trace". |
| `flipCutAmplitude` (def) | `δ · Re(closedAmplitude with F, F) - (δ/2) · (partial trace)` on the cut. | 1810 to 1826 | NIP | Stand-in for `Z_P[X]` of (5.38); the docstring says "standing in". |
| `flipCutAmplitude_eq` | `w ≥ 0`, `n ≤ r`: it equals `(w δ / 2)(3 n - r)`. | none | NIP | Model. Checked by brute force; false for `n > r`. |
| `flipCutResponse` (def) | `δ · Re(closedAmplitude with F, F)` divided by the partial trace; `0` by convention on an empty cut or for `w = 0`. | 1752 to 1757, 1815 to 1819 | NIP | Stand-in for the response of (5.37b). The theorems about it assume `w > 0`, `r > 0`. |
| `flipCutResponse_eq` | `w > 0`, `n ≤ r`, `r > 0`: it equals `2 n δ / (r + n)`. | none | NIP | Model. |
| `flipCutAmplitude_eq_trace_mul` | Same hypotheses: amplitude = partial trace × (response − `δ/2`). | 1823 to 1826 | NIP | The form of (5.38), in the model. |
| `abs_flipCutResponse_le_iff` | `w > 0`, `δ > 0`, `n ≤ r`, `r > 0`: abs(response) ≤ `δ/2` exactly when `3 n ≤ r`. | 1815 to 1819 | NIP | Quotes the first inequality of (5.37b) correctly (non-strict). Optional 5. |
| `flipCutAmplitude_five_limits` | `w > 0`, `δ > 0`: along `(n, n)` the amplitude tends to `+∞`; on `(3n+1, n+1)` it is `w δ`; on `(3n, n)` it is `0`; on `(3n+2, n)` it is `-(w δ)`; along `(7n, n)` it tends to `-∞`. | none | NIP | Model. Recomputed by hand. |
| `isIncreasingExhaustion_five_routes` | Each of the five routes is an increasing exhaustion. | none | NIP | Model. |

Every sentence of the module docstring about what the model shows was traced to a theorem of
the file:

- "closed partial sums ... depend on the order": `flipCutAmplitude_five_limits` with
  `isIncreasingExhaustion_five_routes`.
- "(4.29), (4.30) ... hold in the model" and "do not determine the closed amplitude":
  `IsIncreasingExhaustion.tendsto_open_cut_sum` (limit independent of the route) against the
  five limits. The second is a statement about an inference and is worded as one.
- "the nonempty cuts of the last three routes satisfy it ... those of the first two do not":
  follows from `abs_flipCutResponse_le_iff` by substituting the five routes; no theorem states
  the five instances, but each is immediate. See Optional 5 for the margin.
- "no uncut amplitude ... `C† C = w` has infinite trace": `sum_sq_norm_sqrt_smul_one`.
- "It does not say which hypothesis fails in the paper's own setting" and "does not realise
  the paper's dynamics or constraints": correct, and nothing elsewhere in the file contradicts
  them. No sentence presents the model as a counterexample to the paper's theory.
- The reading of `(3 n, n)` and `(7 n, n)` as unions of cycles of lengths 4 and 8 is marked
  "not part of any formal statement"; it agrees with line 1800 (one vector outside the
  interval per cycle). The route `(3 n + 2, n)` is not a union of complete cycles of one
  length, and the docstring does not say it is.

Attributions to the paper: "(5.37a)" for `X` (line 1812), "(5.37b)" for the condition on a cut
(line 1816), "(5.31)" for the ratio (line 1753), "(5.38)" (line 1824) are all correct. "The
paper's cuts ... are finite unions of cycles" is lines 1800 and 1822.

### 4.3 The four items of `Hypotheses.lean` and `ClockHypotheses.lean`

`S` is a `DiamondSetup`: a closed subspace `fixedArea` (`K_𝒜`), a number `area₀ > 0`,
`0 < ε < 1`, a unit vector `Ω` in `K_𝒜`, and two families of projections `clock.proj`,
`area.proj` read as `1_{(-∞, t]}`. `clockLowerBound = (1 - ε) √(area₀ / 4π)` and
`areaBound ℓ = 4π ℓ² / (1 - ε)²`.

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `H14a` (def) | For every real `ℓ` strictly below `clockLowerBound` and every `x` in `K_𝒜`, `clock.proj ℓ x = 0`. Readings equal to the bound are allowed. | 596, 1638 to 1646, 1203 | FWC | (5.21c) on `K_𝒜`, where the area is the number `𝒜`, stated for spectral projections instead of as an operator inequality. The paper argues it at fixed area (line 1638). Footnote 8 is the classical bound. All docstring attributions are supported. |
| `H14.h14a` | H14 implies H14a. | 1638 to 1646 | NIP | Implication between two register entries. The paper goes the other way, from (5.21c) and commutation to (5.21d). The module docstring's "quantum form of footnote 8" is apt. |
| `H14a.fixedAreaDiamondSpace_eq_bot` | Under H14a, for `ℓ < clockLowerBound`, the intersection of the range of `clock.proj ℓ` with `K_𝒜` is zero. | 1644, 3166 to 3179 | NIP | A consequence of (5.21c), (5.21d) that the paper does not state. Consistent with line 1452 (the classical clock reads `(1 - ε) b`) and with (5.30a). The notation `P_D(𝒜) K_𝒜` is line 3179. |
| `exists_setup_H1_H13_not_H14` | On any Hilbert space with a unit vector `Ω` there is a setup in which H1 and H13 hold and H14 fails. | none | NIP | A model showing the fields do not imply H14; worded as that. In it the clock reads `0` and the area is `1`, as the docstring says. H14a fails in it too (Optional 9). |

### 4.4 `QuantGrav/Elementary/ClockLowerBound.lean`

All statements are about real functions on a measure space, as the module docstring says.

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `focusing_nonneg` | `0 ≤ ε ≤ v`, `g ≥ 0` on `[ε, v]`: `(1/8) ∫_ε^v s g(s) ds ≥ 0`. | 575, 579, 1179 to 1186 | FAITHFUL | (3.26c), with the nonnegativity of `Ξ` that the paper states at line 579. "Sum of squares (4.21)" is supported by (4.21b), (4.21c). No integrability assumed; true either way. |
| `clock_reading_ge` | `ρ₀ ≥ 0`, `ε ≤ 1`, `Ξ ≥ 0` on `[ε, 1]`, `exp ∘ Ξ` integrable: `(1 - ε) ρ₀ ≤ ρ₀ ∫_ε^1 exp(Ξ)`. | 580 to 584 | FAITHFUL | (3.27) with `Ξ ≥ 0`. |
| `sq_integral_le_measure_mul_integral_sq` | Finite measure, `ρ` in `L²`: `(∫ ρ)² ≤ ν(S) ∫ ρ²`. | 596, 1642, 1222 | FAITHFUL | Classical form of (5.21b); `𝖺 = ∫ ϱ_S ε₀` is (4.26). |
| `integral_pos_of_integral_sq_pos` | `ρ ≥ 0` integrable and `∫ ρ² > 0`: `∫ ρ > 0`. | none | NIP | Helper. |
| `clock_mean_ge_area_div` | `ρ ≥ 0`, `u ≥ (1 - ε) ρ` pointwise, integrability, `∫ ρ² > 0`: `(1 - ε)(∫ ρ²)/(∫ ρ) ≤ (∫ ρ u)/(∫ ρ)`. | 593 to 595, 1641, 1568 | FAITHFUL | Classical form of (5.21a) with the average (3.28). |
| `clock_mean_ge` | Total mass `4π`, `ε ≤ 1`, `ρ ≥ 0` in `L²`, `u ≥ (1 - ε) ρ`, `ρ u` integrable, `∫ ρ² > 0`: `(1 - ε) √((∫ ρ²)/4π) ≤ (∫ ρ u)/(∫ ρ)`. | 592 to 596, 1643 | FAITHFUL | Footnote 8 and the classical form of (5.21c). |
| `clock_mean_ge_of_focusing` | The same with `u(y) = ρ(y) ∫_ε^1 exp(Ξ_y)`, `Ξ_y ≥ 0`. | 580 to 596 | FAITHFUL | Footnote 8 in the paper's variables. |
| `clock_mean_eq_of_const` | Total mass `4π`, constant `r > 0`: `(∫ r (1 - ε) r)/(∫ r) = (1 - ε) √((∫ r²)/4π)`. | 3593 | FAITHFUL | The last sentence of App D.3, as cited. |

### 4.5 `QuantGrav/Entropy/ClockMoments.lean`

`u i` are readings, `w i` weights, `M k t = momentSum u w k t`.

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `momentSum` (def) | `∑ i, if u i ≤ t then (u i)^k w i else 0`. | 1989 to 1993 | FAITHFUL | For `k = 0`, `w = e^{-s}` it is `Z` of (5.56), with the same non-strict cutoff. |
| `firstMomentOf` (def) | `ℓ Z(ℓ) - ∫_0^ℓ Z`. | 1989 to 1993 | NIP | A definition for arbitrary `Z`; it is (5.56) rearranged. |
| `secondMomentOf` (def) | `ℓ² Z(ℓ) - 2 ∫_0^ℓ t Z(t) dt`. | none | NIP | Definition. |
| `integral_ite_le` | `u, ℓ ≥ 0`: the integral over `[0, ℓ]` of `g` switched on at `u` is `∫_u^ℓ g` if `u ≤ ℓ`, else `0`. | none | NIP | Helper. |
| `intervalIntegrable_ite_le` | A continuous function switched on at `u` is interval integrable. | none | NIP | Helper. |
| `integral_momentSum_zero` | `u i ≥ 0`, `ℓ ≥ 0`: `∫_0^ℓ M 0 = ∑_{u_i ≤ ℓ} (ℓ - u_i) w_i`. | 1991 to 1993 | FAITHFUL | (5.56), first equality. |
| `firstMomentOf_momentSum` | Same hypotheses: `ℓ M 0 ℓ - ∫_0^ℓ M 0 = M 1 ℓ`. | 1991 to 1993 | FAITHFUL | (5.56), second equality, cleared of the division by `Z(ℓ)`. |
| `secondMomentOf_momentSum` | Same hypotheses: `ℓ² M 0 ℓ - 2 ∫_0^ℓ t M 0 t dt = M 2 ℓ`. | none | NIP | The docstring says "Not in the paper". |
| `integral_div_sq` | `0 < u ≤ ℓ`: `∫_u^ℓ c / t² dt = c/u - c/ℓ`. | none | NIP | Helper. |
| `reading_eq_sq_div_add_integral` | `0 < u ≤ ℓ`: `u = u²/ℓ + ∫_u^ℓ (u/t)² dt`. | 2023 | FAITHFUL | (5.60), second half. |
| `momentSum_one_eq_div_add_integral` | `u i > 0`, `ℓ > 0`: `M 1 ℓ = M 2 ℓ / ℓ + ∫_0^ℓ M 2 t / t² dt`. | 2025 | FWC | The exact sum that the sentence at line 2025 refers to. The step from it to (5.61) uses (5.57b) and the first half of (5.60) and is not formalized, as the module docstring says. |
| `intervalIntegrable_momentSum` | `M k` is interval integrable. | none | NIP | Helper. |
| `measurable_momentSum` | `M k` is measurable. | none | NIP | Helper. |
| `continuousAt_ite_le_const` | A constant switched on at `u` is continuous away from `u`. | none | NIP | Helper. |
| `continuousAt_momentSum` | `M k` is continuous at any `ℓ` that is not a reading. | none | NIP | Helper. |
| `hasDerivAt_log_integral_momentSum_div` | `u i ≥ 0`, `ℓ > 0` not a reading, `ℓ M 0 ℓ - M 1 ℓ > 0`: `r ↦ log((∫_0^r M 0)/r)` has derivative `M 1 ℓ / (ℓ M 0 ℓ - M 1 ℓ) / ℓ` at `ℓ`. | 1995 to 1999 | FAITHFUL | (5.57a), which the paper asserts between eigenvalues of the clock (line 1995). The positivity hypothesis is `∫_0^ℓ Z > 0` by (5.56), as the docstring says. |
| `sum_sq_reading_bounds` | `w ≥ 0`, `0 ≤ a i ≤ u i ≤ ℓ`: `∑ w a² ≤ ∑ w u² ≤ ℓ ∑ w u`, and `∑ w u² ≤ ∑ w a² + 2 ℓ ∑ w (u - a)`. | 1966 to 1968, 1983 to 1986, 2023 | FWC | The first two are (5.55) before division by the total weight. The third is an addition (an explicit error for the first half of (5.60)); the docstring says so. |
| `firstMomentOf_rpow` | `p > 0`, `ℓ > 0`, `Z(t) = K t^p`: `firstMomentOf Z ℓ = p/(p+1) · ℓ Z(ℓ)`. | 2000, 2004 to 2010 | NIP | Exact power law, an idealisation. Consistent with (5.57b), (5.58): `p = q/(1 - q)`. |
| `secondMomentOf_rpow` | Same: `secondMomentOf Z ℓ = p/(p+2) · ℓ² Z(ℓ)`. | none | NIP | As above. |
| `eq_sq_mul_two_sub_iff` | `q = x² (2 - q)` iff `q = 2x²/(1 + x²)`. | 2027 | FAITHFUL | First two forms of (5.61). The third form is not stated in Lean. |
| `sq_eq_div_two_sub_iff` | `q ≠ 2`: `x² = q/(2 - q)` iff `q = 2x²/(1 + x²)`. | 2027 | NIP | A rearrangement of (5.61). |
| `powerLaw_moment_ratios` | `p > 0`: with `q = p/(p+1)` and `X = p/(p+2)`: `q = 2X/(1 + X)`, `X = q/(2 - q)`, `p = q/(1 - q)`. | 2004 to 2010, 2027 | NIP | Pure algebra in `p`. Its link to moments is through the two `rpow` lemmas. |
| `sq_le_and_le_of_sq_eq_div` | `0 < q < 1`, `x ≥ 0`, `x² = q/(2 - q)`: `x² ≤ q`, `q ≤ x`, `x < 1`. | 1970 to 1982 | FWC | Same inequalities as (5.54b), (5.54c), from a different hypothesis. Optional 7. |
| `moment_ratios_of_q` | At `q = 257/302`: `q/(1 - q) = 257/45`, `q/(2 - q) = 257/347`, `q/(2(1 - q)) - 1 = 167/90`. | 2085 to 2088, 2093 | NIP | Arithmetic, correct. Third conjunct: Optional 6. |

Module docstring: "Footnote 23 gives `q = 2x²/(1 + x²)` with `x = (1 - ε) r_h / ℓ`" is lines
2021 to 2028; "(5.68) gives `q = 257/302`" is line 2087. The conclusion that the two do not
conflict is the file's own. It is supported for exact power laws by the theorems, and it agrees
with footnote 24 of the paper: (5.63) gives the distribution of `s / s_*` the exponent
`q / (2(1 - q))`, whose mean is `q / (2 - q)`, the same `x²`. What it rests on beyond the
theorems is stated under "What is not here", with the addition suggested in Optional 8.

### 4.6 `QuantGrav/Elementary/PairAmplitudeReal.lean`

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `hasSum_cos_div_sq` | `0 ≤ θ ≤ 2π`: `∑_{k ≥ 1} cos(kθ)/k² = π²/6 - πθ/2 + θ²/4`. | none | NIP | Standard Fourier series. Checked numerically; false outside the range, as the docstring says. |
| `re_tsum_cexp_div_sq` | Same range: the real part of `∑_{k ≥ 1} exp(-iθk)/k²` is that polynomial. | none | NIP | The series is summable, so the `tsum` carries no junk value. |
| `re_pair_amplitude` | `s ≥ 1/π`: the real part of `(1/(2s²)) ∑_{k ≥ 1} exp(-2ik/s)/k²` is `(1/(2s²))(π²/6 - π/s + 1/s²)`. | 1400 to 1410, 1419 | FWC | The sum is the middle member of (4.33) with (4.32). The closed form of the real part is an addition, and it covers `s ≥ 1/π` only; the paper has every `s > 0`. The docstring states the range and why. |

### 4.7 `QuantGrav/Entropy/SenComparison.lean`

"Sen" columns refer to arXiv:1205.0971v2 as reported by the fetch tool (Section 1 above).

| declaration | what it says | lines | classification | note |
| --- | --- | --- | --- | --- |
| `Sen.cLocal` (def) | `(2 nS - 26 nV + 7 nF - (233/2) n32 + 424)/90`. | none | NIP | Agrees with Sen (1.2) as fetched, including "424 is the graviton loop" and the field content. |
| `Sen.numCartan` (def) | `(D - 1)/2` in natural numbers. | none | NIP | Agrees with Sen's `N_C`, the integer part of `(D - 1)/2`. |
| `Sen.numRotations` (def) | `(D - 1)(D - 2)/2`. | none | NIP | Agrees with Sen's `N_R`. |
| `Sen.mcCoeff` (def) | `C - (D-4)/2 - (D-2)/2 · N_C - (D-4)/2 · nV`. | none | NIP | Agrees with Sen (1.1) and (3.11) as fetched. |
| `Sen.mixedCoeff` (def) | `C - (D-4)/2 - (D-4)/2 · nV`. | none | NIP | Agrees with Sen (1.4) as fetched; (1.3) defines the ensemble as a sum over all angular momenta at fixed mass and charge. |
| `Sen.singletCoeff` (def) | `C - (D-4)/2 - (D-2)/2 · N_R - (D-4)/2 · nV`. | none | NIP | Agrees with Sen (1.5) as fetched. |
| `Sen.cLocal_pure_gravity` | `cLocal 0 0 0 0 = 212/45`. | none | NIP | Arithmetic. Sen states the value. |
| `Sen.mixedCoeff_four` | `mixedCoeff 4 C 0 = C`. | none | NIP | Arithmetic. "Neither fixing the mass nor the zero modes adds a logarithm" agrees with Sen Sec 3 and (2.41) as fetched. True for every `nV`, not only `0`. |
| `Sen.mcCoeff_four` | `mcCoeff 4 C 0 = C - 1`. | none | NIP | Arithmetic. |
| `Sen.singletCoeff_four` | `singletCoeff 4 C 0 = C - 3`. | none | NIP | Arithmetic. Sen's `(212/45 - 3) ln a` for singlet states confirmed as fetched. |
| `fixed_mass_coeff_eq_sen_mixed` | `106/45 = mixedCoeff 4 (212/45) 0 / 2`. | 2091 to 2095 | FAITHFUL | `106/45` is the fixed-mass coefficient of (5.69). The paper says there that the angular momenta are summed (line 2091), which is the ensemble of Sen (1.3), (1.4). |
| `fixed_mass_coeff_sub_sen_mc` | `106/45 - mcCoeff 4 (212/45) 0 / 2 = 1/2`. | 2093 | NIP | Arithmetic. |
| `fixed_mass_coeff_sub_sen_singlet` | `106/45 - singletCoeff 4 (212/45) 0 / 2 = 3/2`. | 2093 | NIP | Arithmetic. |
| `entropy_coeff_eq_sen_local_add_one` | `257/90 = (212/45 + 1)/2`. | 2046 to 2050, 2087 | NIP | `257/90` is `q/(2(1 - q))` of (5.65) at `q = 257/302`; the paper does not print it. "None of Sen's three coefficients" follows from the three `_four` lemmas. |
| `trace_log_prefactor_eq` | `53/(45 (4π)²) · (8π · 8π) = 212/45`. | 2079 to 2085 | FAITHFUL | The prefactor of `log(s_b^{1/2})` in (5.67c) with `∫ R[q] dA = 8π` (line 2085). |

Module docstring: the three ensembles, "all counting states per unit interval of mass", and
`A_H ∼ a^(D-2)` agree with Sen's Section 1 as fetched. The version `v2` is the latest. The
statement that `ln A_H` is `2 ln a` in four dimensions follows.

## 5. Phase 2: log against Lean

Read in `FIDELITY.md` at commit `846062e`: the theorem-entry sections for the seven items
(lines 151 to 159, 171 to 183, 289 to 296, the rows at 306, 307 and 312, 316 to 332, 361 to
383, 424 to 466); findings F2, F3, F8, F9, F10 and F12; register rows H3, H3a, H3b, H3c, H7,
H8, H14 and H14a; line 25 of "How the paper was read" (on Sen) and the last open item. The
log's statements about Sen were compared with the fetched text described in Section 1, with
one further query.

Summary. No row names a theorem that does not exist, or one with a different meaning. No
"Formal statement" cell has a wrong inequality direction, quantifier or constant. What was
found is: public theorems with no row (19, all but one of them helpers), cells that leave out
hypotheses, one stale sentence, and two places that repeat the wording of Required change 1.

### 5.1 `ClosedCuts.lean` (lines 424 to 434; F10, lines 539 to 544; register, lines 608 to 610)

1. **No row for `mul_card_le_sum_sq_norm`.** It is named only in F12 (line 579), and it
   appears without its name in the "Paper" cell of `cut_amplitude_le_neg_rank` ("the counting
   step of (D.24)").
2. **Hypotheses left out of "Formal statement" cells.** The lower bound
   `∀ v, c ‖v‖² ≤ ‖C v‖²`, which is what defines `c`, is stated only in the first row; the
   section's opening sentence does not make it a standing assumption. The cell for
   `tendsto_cut_amplitude_atBot` and `not_tendsto_cut_amplitude_nhds` says "such cuts",
   which inherits `δ ≥ 0` from the row above, but the two theorems need `0 < c` and `0 < δ`;
   with `δ = 0` the conclusion fails. The cell for
   `finiteDimensional_of_cut_amplitude_bddBelow` omits `0 < c`, `0 < δ` and the lower bound,
   and without the lower bound the statement is false.
3. **The row for `cut_amplitude_le_neg_rank` (line 432) is correct, and it is the one place
   that records `δ / 4` against the paper's `δ / 2`.** It says the paper has the bound
   `δ / 2`, concludes `Z_P[X] ≤ 0`, and that `δ / 4` is "a stricter choice in the same
   construction". That is exactly the Phase 1 reading. Incomplete on one point: it does not
   say that the margin is needed, that is, that under (5.37b) as displayed the conclusion
   fails (Required change 1).
4. **F10, second bullet (line 542), repeats the unqualified attribution.** "If `H_D` were
   infinite-dimensional, the paper's own cuts would therefore drive `Z_P[X]` to minus
   infinity (`tendsto_cut_amplitude_atBot`)". As in the Lean docstring, the "therefore" needs
   either the cuts re-chosen with bound `δ_η / 4`, or the variant with a general margin. The
   conclusion is true for the paper's cuts because the bound of (5.32) with (D.25) is the
   same for all P and strictly below `δ_η / 2` (line 3383); the cited theorem does not prove
   it in that form.
5. **Register entry H3c (line 610) gives no threshold.** "Bounded below along the paper's
   cuts of small response": "small" has to mean a fixed margin below `δ_η / 2` (in Lean, at
   most `δ / 4`). With the threshold of (5.37b) as displayed the entry would not give finite
   dimension.
6. **The relation of H3c to H3a is not recorded.** F10 (line 544) and F2 (line 483) list H3a,
   H3b with H4, and H3c as three routes, and call H3c weaker than H3b. In the Lean form, the
   hypothesis `-B ≤ T (Δ - δ/2)` with `Δ ≤ δ / 4` forces `T ≤ 4 B / δ`: on cuts of small
   response a lower bound on the closed amplitude is an upper bound on the partial trace.
   Given (5.30c) and a two-sided bound on the response, H3c on those cuts and H3a are
   equivalent, and both are equivalent to finite dimension. So H3c is weaker than H3b, as the
   log says, but it is not weaker than H3a. Also, under the standing assumptions the
   hypothesis `hcuts` of `finiteDimensional_of_cut_amplitude_bddBelow` is equivalent to its
   conclusion (it is vacuous in finite dimension and contradictory in infinite dimension), as
   is normal for a reductio stated this way.
7. **"(4.29) and (4.30) hold for every bounded operator"** (F10, line 541, and the row for
   `open_gluing_id_and_unbounded_partial_traces`). True of (4.29) and of absolute
   convergence. The bound of (4.30) as printed needs operators of norm at most one. The Lean
   conjunct that the row calls "the absolute bound (4.30)" is the `tsum` inequality without a
   summability statement (Optional improvement 2).

### 5.2 `OrderOfExhaustion.lean` (lines 437 to 466; F10, line 545; register, line 609)

1. **No rows for ten helper theorems:** `IsIncreasingExhaustion.tendsto_atTop`,
   `mem_twoFamilyCut`, `twoFamilyCut_subset`, `isIncreasingExhaustion_twoFamilyCut`,
   `sum_twoFamilyCut`, `card_twoFamilyCut`, `filter_partner_mem_twoFamilyCut`,
   `card_filter_partner_mem_twoFamilyCut`, `inner_basisFlip`, `sum_sq_norm_sqrt_smul_one`.
   Two of them, `card_twoFamilyCut` and `card_filter_partner_mem_twoFamilyCut`, are the counts
   that the Lean module docstring cites for the formula `(w δ / 2)(3 n - r)`, and
   `sum_sq_norm_sqrt_smul_one` is what supports "`C† C = w` has infinite trace". The six
   definitions are all described, and `basisFlip_apply` is named with `basisFlip`.
2. **The rows that exist are accurate.** Hypotheses (`w ≥ 0` or `w > 0`, `n ≤ r`, `r > 0`,
   `δ > 0`), the five routes and the five outcomes all match the Lean. The definition of
   `flipCutResponse` does not mention that it is `0` by convention on an empty cut or for
   `w = 0`; the theorems exclude both cases.
3. **"What the model shows" (line 462) is correct for (5.37b) as displayed, and silent on the
   margin.** Of the three routes said to satisfy the left inequality of (5.37b), `(3 n, n)`
   meets it with equality and `(3 n + 2, n)` has responses tending to `δ / 2`. App D.2, line
   3383, asks for a bound strictly below `δ_η / 2`, the same for every P; only `(7 n, n)`
   meets that, and there the limit `-∞` is the one `tendsto_cut_amplitude_atBot` forces for
   every order. The same applies to F10, line 545, and to the reading of `(3 n, n)` as cycles
   of length 4. The conclusion "H3b does not follow from (5.37b)" is unaffected, since `-∞`
   is not convergence either (Optional improvement 5).
4. **One stale sentence.** "What it does not show" ends: "H3b has to come from the argument
   of Sec 3.6" (line 464). F12 (line 571) and the register row H3b (line 609) now say that
   Sec 3.6 contains no such argument. The sentence predates F12 and should point to it. (This
   review did not read Sec 3.6; it confirms only that line 1800 cites it, by the label at line
   871.)
5. **Register row H3b (line 609) compresses the evidence.** It gives "five different closed
   limits" as the ground for three non-implications. For the third, from the left inequality
   of (5.37b), only three of the five routes count; the theorem-entry section and F10 say
   this correctly.
6. **Checked and confirmed.** The "Paper" cell of `flipCutAmplitude_five_limits`: the last
   sentence of the paragraph at line 1800 and the caption of Figure 30 (line 1830) both say
   that closing the cut has to reproduce the uncut amplitude. The definition bullet for
   `closedAmplitude`: no antiunitary map is named anywhere in the TeX (searched), and (5.31)
   gives no formula for the reflected state. One thing it could add: App D.2, line 3359,
   describes the reflected state as the conjugate of the state, on the oppositely oriented
   copy of S, which is the paper's nearest support for the encoding by complex conjugation.

### 5.3 The four items (lines 289 to 296; rows at lines 306, 307, 312; F8; register, line 622)

No discrepancies found. The section for `H14a`, the three rows and the register entry state
the Lean correctly, including the strict inequality in `ℓ` and the direction of `H14.h14a`.
Not recorded, and optional: the model behind `exists_setup_H1_H13_not_H14` violates H14a as
well (Optional improvement 9).

### 5.4 `ClockLowerBound.lean` (lines 171 to 183)

No discrepancies found in the seven rows. Two small omissions: `integral_pos_of_integral_sq_pos`
has no row, and the cell for `clock_mean_eq_of_const` does not repeat that the total mass is
`4π`, which the statement needs.

### 5.5 `ClockMoments.lean` (lines 361 to 383; F3; register row H8)

1. **No rows for seven helper theorems:** `integral_ite_le`, `intervalIntegrable_ite_le`,
   `integral_div_sq`, `intervalIntegrable_momentSum`, `measurable_momentSum`,
   `continuousAt_ite_le_const`, `continuousAt_momentSum`. The three definitions are described.
2. **Hypotheses left out of two cells.** `secondMomentOf_momentSum`: the cell omits
   `u_i ≥ 0` and `ℓ ≥ 0`, which the row above states for the first moment.
   `hasDerivAt_log_integral_momentSum_div`: the cell omits `u_i ≥ 0`, and writes the
   positivity hypothesis as `∫_0^ℓ Z > 0` where the Lean has
   `0 < ℓ * momentSum u w 0 ℓ - momentSum u w 1 ℓ`. The two are the same number by
   `firstMomentOf_momentSum`.
3. **F3 agrees with the Lean and with Phase 1.** It names the first half of (5.60) as resting
   on (5.21c) and (5.53), it records that the asymptotic step is not formal, and it records
   the question of wording about "fixed `ℓ(D)/r_h`" (lines 1970 and 2012 of the TeX), which
   Phase 1 also noticed. It explains the third conjunct of `moment_ratios_of_q` as the
   exponent of the density implied by (5.63); the Lean docstring does not (Optional
   improvement 6). The arithmetic in its fifth bullet was rechecked: `√(347/257) ≈ 1.162`,
   relative standard deviation `≈ 0.27`, `167/90 + 1/2 = 106/45`.

### 5.6 `PairAmplitudeReal.lean` (lines 151 to 159)

No discrepancies found. All three theorems are in the entry. The statement it quotes from
`abs_im_pair_amplitude_sub_le` matches that theorem, and the value at `s = 10` was reproduced
to eight digits.

### 5.7 `SenComparison.lean` (lines 316 to 332; F9; register row H7; line 25)

No discrepancies found. All 15 declarations have a row. On Sen's side the rows and F9 agree
with the fetched text: (1.1) to (1.5); `N_C` defined after (1.1) and `N_R` after (1.5); the
term `-N_C ln a = -ln a` mentioned after (1.1) for four dimensions; `(212/45 - 3) ln a` for
singlet states after (1.5); the mixed value in four dimensions to be read off (1.4); the three
numbered points that open Sec 4, with `ln a` added on passing from a count per unit area to a
count per unit mass; and the cancellation of the zero-mode count between (2.41) and (3.3). On
the paper's side, the sentences that cite Sen are at lines 72, 111, 1932, 2095 and 2097, as
line 25 of the log says, and the ensemble is named at lines 1932 and 2091.

### 5.8 Cross-references

`notes/external-audits-2026-11-26.md` exists and has sections 1.2 and 5. Its text was not
read, so the pointers "section 1.2 A", "section 1.2 B" and "section 5 item 3" made by the Lean
docstrings and by the log were not verified beyond that. `handoff.md` was not opened, so "break
attempt B3 of `handoff.md`, Section 14" in `ClockMoments.lean` was not verified.
