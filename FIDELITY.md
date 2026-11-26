# Fidelity log

Pairs every formal statement with the paper's equation and records any divergence.
Paper: Chandrasekaran, "An algebraic quantization of gravity from the null cone", arXiv:2611.34924v1.

## How the paper was read

- Source used: the PDF in the repository root (83 pages), text extracted with PyMuPDF on 2026-11-26.
- The TeX source (arXiv v1) was fetched later the same day. `paper/equation_index.tsv` gives the LaTeX label and `main.tex` line of every printed equation number; its numbers agree with all 528 equation tags found in the PDF text. The two it adds, (5.37a) and (D.34b), are in the PDF but share a line with other glyphs there.
- The displayed equations behind the theorem entries below, (5.17), (5.60), (5.61), (5.68), (5.69), (C.14), and the sentences leading into them, were re-checked against the TeX and match. The findings F1 to F5 were written from the PDF text and have not all been re-checked against the TeX.
- Read directly from that text, by the agent that wrote this log: Sec 4.4, Sec 5.1 to 5.3, App C.2 from (C.13), App C.3, App D.2, App D.3, footnote 8.
- Everything else in the paper is indexed by section and equation number only. Claims about its content still come from the earlier extraction passes and are marked "not re-read" where they appear.
- Extracted math is partly garbled (accents, fractions). Each statement below was checked against the surrounding prose as well as the displayed equation.
- Independent review of WP1 (separate session, 2026-11-26, recorded in `handoff.md` Section 13): every statement in `QuantGrav/Elementary/` was re-derived by hand and matches (4.32) to (4.34), (5.17), (5.61), (5.68), (5.69). The reviewer read `main.tex` lines 1996 to 2100 directly, and confirmed the reconstruction behind `q_of_growth_exponent_iff` and `log_coefficient_roundtrip` and findings F3 and F5. The reviewer did not rerun the build.
- Clean-checkout build, 2026-11-26, commit `1651972`: a fresh `git clone` of the repository, with `.lake/packages` linked to the existing Mathlib checkout instead of downloaded again. `lake exe cache get` reported nothing to download, `lake build --wfail` completed (5813 jobs), and `scripts/check_forbidden.sh` was clean. Run on Windows with Lean `v4.37.0-rc1`.
- Clean-checkout build, 2026-11-26, commit `02c615f`: same method. `lake build --wfail` completed (5849 jobs) and `scripts/check_forbidden.sh` was clean. The GitHub workflow cannot finish on this repository because its runner lacks disk space, so from this date the gate for each push is this local run from a fresh clone. Commits that change only Markdown files after a recorded run are not rebuilt.
- Clean-checkout build, 2026-11-26, commit `a4084dc` (MIT licence, header linter on): same method. `lake build --wfail` completed (5849 jobs) and `scripts/check_forbidden.sh` was clean.
- Clean-checkout build, 2026-11-26, commit `1275141` (WP1-f): same method. `lake build --wfail` completed (6265 jobs) and `scripts/check_forbidden.sh` was clean.
- Clean-checkout build, 2026-11-26, commit `8b4c0af` (section 5 of the external-audits note): same method. `lake build --wfail` completed (6457 jobs) and `scripts/check_forbidden.sh` was clean. The run covers the two commits before it on the same branch, `f94506a` and `9d5947a`.
- Clean-checkout build, 2026-11-26, commit `45cc928` (break attempt B3): same method. `lake build --wfail` completed (6459 jobs) and `scripts/check_forbidden.sh` was clean.
- Clean-checkout build, 2026-11-26, commit `741fd47` (break attempt B1): same method. `lake build --wfail` completed (6849 jobs) and `scripts/check_forbidden.sh` was clean.
- Clean-checkout build, 2026-11-26, commit `7bafa6e` (break attempt B2): same method. `lake build --wfail` completed (6859 jobs) and `scripts/check_forbidden.sh` was clean. The commit before it on main, `6526d79`, changed only Markdown files.
- Clean-checkout build, 2026-11-26, commit `4a0ede8` (Track A item 4): same method. `lake build --wfail` completed (6867 jobs) and `scripts/check_forbidden.sh` was clean.
- Findings F1, F2 and F4 were re-checked against the TeX on 2026-11-26; each now says what changed.
- `QuantGrav/Diamond/FiniteDim.lean`, `QuantGrav/OperatorAlgebra/CutSums.lean`, `QuantGrav/OperatorAlgebra/BoostBound.lean` and `QuantGrav/Elementary/ClockWeightIntegral.lean` were reviewed by a separate review session on 2026-11-26: statements re-derived by hand, with Sec 5.2 of the TeX read at `main.tex` lines 1728 to 1830. Recorded in `notes/external-audits-2026-11-26.md`, section 5 item 7.
- The proofs in `ClausenAsymptotics.lean`, `BoostBound.lean` and `PairAmplitudeReal.lean` were written by subagents from fixed statements. The statements were written first and, for the Clausen bound and the real part, checked numerically. The proofs are accepted on the strength of the kernel and the axiom audit, not on a reading of the proofs. The model computations in `OrderOfExhaustion.lean`, from `closedAmplitude_one` to `flipCutAmplitude_five_limits`, were also proved by a subagent from fixed statements; there the formula `(w delta/2)(3n - r)` was derived by hand first, and the proofs were read afterwards. The increasing-exhaustion and response lemmas of that file were written directly. The proofs in `QuantGrav/Entropy/ClockMoments.lean` were written by a subagent from fixed statements; every statement was first checked numerically on a random finite spectrum and on power laws. For B1, five subagents wrote the proofs in `OneAddSumLeProd.lean`, `GaussianExpSq.lean`, `GaussianQuadraticForm.lean`, `FocusingDivergence.lean` and `GaussianModeLimits.lean`, one file each and in parallel, from fixed statements; the bound of G3, the mean of the model focusing and the two limits were checked by Monte Carlo first. `ClockDivergence.lean` was written directly.
- For Step 3 (2026-11-26) Sec 4.2, Sec 4.3, the start of Sec 5.1, (5.21) and App C.2 from its start were read directly from the TeX.
- Independent review of the definitions in `QuantGrav/Diamond/Setup.lean` (2026-11-26): a fresh reader with no access to this log, `handoff.md` or `Hypotheses.lean` checked every field against the TeX. It read `main.tex` lines 548 to 610, 955 to 1250, 1440 to 1865, 1920 to 2029 and 2940 to 3180 in full and searched the rest. Result: no field wrong. One gap, that positivity of the area operator was not recorded; it is now the lower bound inside H14. Two citations were corrected (`ε`, positivity of the clock), a fourth warning was added for the area operator on `H_omega`, `minReading` was renamed `clockLowerBound`, and the degenerate scalar model was replaced by `ofProjections`. The reviewer could not refute the claim in F6 that the clock is not constructed outside `K_A`. The formal statements of H1, H13 and H14 were written only after this review.
- Second pass by the same reader (2026-11-26) over the revised `Setup.lean`, the formal statements `H1`, `H13`, `AreaBoundAt`, `H14`, and every theorem in `ClockHypotheses.lean`: all four statements classified as faithful in this encoding, every theorem docstring found to match what is proved, all five required changes confirmed done, nothing required before commit. Its optional points were applied: scope notes in the docstrings of `Ω`, `H1`, `AreaBoundAt`, `H14` and `H1_iff_tendsto_norm_sq`; the lemma `fixedAreaDiamondSpace_eq_map`; the model theorem `exists_setup_H1_H13_not_H14`; and a separate fixed-area hypothesis `H14a`. `H14a`, `H14.h14a`, `H14a.fixedAreaDiamondSpace_eq_bot` and `exists_setup_H1_H13_not_H14` were added after that pass, adapted from the reader's own scratch checks; their final text has not been re-read by it.

- Sen's paper, arXiv:1205.0971v2 (JHEP 04 (2013) 156), was read on 2026-11-26 from arxiv.org in a browser: the abstract page, and in the HTML rendering Section 1 in full, Section 3 in full, the paragraph ending at (2.41), and the three numbered points that open Section 4. Equations were taken from the LaTeX carried by the rendering. Not read: the rest of Section 2, Section 5 and the appendices. Every sentence of the paper under study that cites Sen was re-read in the TeX (abstract, lines 111, 1932, 2095, 2097).
- The paper's acknowledgements (`main.tex` line 2400) were read on 2026-11-26. They say that several of the calculations and proofs were developed in collaboration with an AI model over many months, without saying which. This confirms the entry in `handoff.md` Section 2, which came from the earlier extraction.
- For WP1-f, (3.25) to (3.28) and footnote 8 were read in the TeX (lines 556 to 596) on 2026-11-26.
- For break attempt B3 (`handoff.md` Section 14), all of Sec 5.3 was read in the TeX by the code session on 2026-11-26: lines 1912 to 2097, from (5.50) to (5.69), with footnotes 23 and 24. The review session had read the same passage and proposed the reading that B3 confirms; see finding F3.
- For break attempt B1 the code session read in the TeX on 2026-11-26: (3.26) to (3.28) (lines 546 to 597); Sec 4.2 from its start to (4.10) (lines 1029 to 1068); Sec 4.3 from (4.20) to (4.27) (lines 1166 to 1238); the pair example of Sec 4.4 (lines 1386 to 1438); all of Sec 5.1 (lines 1449 to 1612); App C.2 (lines 2995 to 3133); and App D.3 to (D.46) (lines 3460 to 3533). The equation numbers used for B1 were taken from `paper/equation_index.tsv`.
- Independent review for B1 (2026-11-26), as `handoff.md` Section 14.1 requires before an outcome 2 is recorded. A fresh reader with no access to this log, `handoff.md`, `notes/` or `Hypotheses.lean` read the same seven ranges and more (lines 60 to 114, 637 to 737, 944 to 953, 1250 to 1386, 1612 to 1700, 1851 to 1859, 3135 to 3180), searched the whole TeX, and checked every attribution in the docstrings of `FocusingDivergence.lean`, `GaussianModeLimits.lean` and `ClockDivergence.lean`. It confirmed the reading of the resolution. It found two equation numbers off by one, one wrong sentence about (3.27), and several attributions stronger than the text. All of its required changes were applied to the docstrings. Its verdict on a summary: accurate that the control of the focusing is at fixed resolution and never made uniform; too strong to call the model the paper's own estimate; wrong to call any of it a disproof. Finding F11 follows its wording. It read the two `Elementary` files while their proofs were still placeholders; the statements have not changed since, only the docstrings.
- For the first item of B4 (`handoff.md` Section 14.2), Sec 3.6 was read in full in the TeX by the code session on 2026-11-26: lines 870 to 942, equations (3.60) to (3.66). Read with it: the first paragraph of Sec 4 (line 947); Sec 4.4 to (4.31) (lines 1250 to 1272 and 1366 to 1384); App E.1 (lines 3596 to 3657); the passage of the JT prologue with (2.17) (lines 302 to 311); and every sentence that cites Sec 3.6 or one of its equations (lines 286, 609, 618, 635, 1076, 1256, 1683, 1800, 2937, 3745). An independent reader, with no access to this log, `handoff.md`, `notes/` or the Lean files, read the same section, Sec 4.4, Sec 5.2, App E and more, and answered eleven neutral questions about what Sec 3.6 argues and how it is used. The two readings agree on every point. Finding F12 records them.
- For break attempt B2 the code session read in the TeX on 2026-11-26: (5.39) to (5.41) (lines 1834 to 1865); the start of Sec 5.3 with (5.50) (lines 1912 to 1931); lines 1962 to 2097, from (5.53) to (5.69) with footnotes 23 and 24; App D.3 in full (lines 3456 to 3555); all of App E (lines 3596 to 3771); and lines 320, 1032 to 1034, 1445 and 2141. The numbers of the two equations in footnote 24 were checked against the PDF, page 48. An independent reader, with no access to this log, `handoff.md`, `notes/` or the Lean files, read the same passages, searched the whole TeX for every statement about the area spectrum, and answered eleven neutral questions. The two readings agree. The reader pointed to four passages the code session had not yet read (lines 320, 1032 to 1034, 1445 and 2141), which it then read, and made one check of (5.63); finding F13 says which.
- The proofs in `QuantGrav/Entropy/GibbsAccounting.lean`, `BandCounting.lean` and `LogLevelsModel.lean` were written by three subagents, one file each, from fixed statements that had been checked numerically. The types of all 48 public declarations were printed from the files as first compiled, with placeholder proofs, and again after the proofs were in; the two printouts are identical. The proofs are accepted on the strength of the kernel and the axiom audit.
- Second-reader review, 2026-11-26, by an automated reader that did not write the Lean: every public declaration of `ClosedCuts.lean`, `OrderOfExhaustion.lean`, `ClockLowerBound.lean`, `ClockMoments.lean`, `PairAmplitudeReal.lean`, `SenComparison.lean`, and the items `H14a`, `H14.h14a`, `H14a.fixedAreaDiamondSpace_eq_bot`, `exists_setup_H1_H13_not_H14`, 88 in all. Its first pass was blind, with the Lean and the TeX only; it read `main.tex` lines 528 to 602, 1166 to 2099, 3135 to 3180, 3285 to 3469 and 3560 to 3594 in full. Its second pass compared this log with the Lean. Result: no statement mismatched, miscited, false or vacuous; one required change, to `ClosedCuts.lean`, applied the same day (F10); nine optional points and some omissions in this log, most of them applied. Sen's paper was read by that reader only through a fetch tool's extraction. The report is `notes/second-reader-review-2026-11-26.md`.
- For Track A item 4 the code session used its reading of Sec 5.3 for B2 and B3 (lines 1962 to 2051) and re-read (5.54b), the sentences around (5.56) to (5.59), (5.62) and (5.65) on 2026-11-26. No new passage was read.
- The proofs in `QuantGrav/Elementary/LogIntegralLimit.lean`, `MonotoneLogGrowth.lean`, `QuantGrav/Entropy/ClockTraceAsymptotics.lean` and `MeanAreaGrowth.lean` were written by four subagents, one file each, from fixed statements. The exact identities and the limits were checked numerically first. The types of all public declarations were printed from the statement files and again after the proofs were in; the printouts are identical.
- External audits of the paper that appeared on 2026-11-26 are collected in `notes/external-audits-2026-11-26.md`, written by a separate review session. That session cloned one repository and read its reports, not its Lean sources line by line, and read two other sources through a summarising fetcher. Nothing external was built or kernel-checked. The code session has not read those sources itself. Statements taken from them are marked as such below, and every Lean proof in this repository is our own.
- App E.1 condition 5 with (E.4) and (E.5), and App E.3 with (E.15) to (E.17), were read in the TeX (lines 3636 to 3650 and 3734 to 3757) on 2026-11-26.
- For `OrderOfExhaustion.lean`, (5.30) to (5.38) and the text between them were re-read in the TeX (lines 1736 to 1831) on 2026-11-26.

## Theorem entries

All theorems are in namespace `QuantGrav`. Axiom sets are pinned in `QuantGrav/Audit.lean`; each depends only on `propext`, `Classical.choice`, `Quot.sound`.

### WP1-c: `clock_weight_le` (`QuantGrav/Elementary/ClockWeight.lean`)

| Field | Content |
|---|---|
| Paper | Sentence above (5.17); sentence above (C.14) |
| Paper's claim, in substance | The weight `u [L/(L+u)]^2` is at most `L/4`. Integrating it over the clock readings bounds the expected reading in `Psi_L`, and with a Markov step gives `‖(1 - P_D) Psi_L‖^2 <= L / (4 l(D))` |
| Formal statement | For real `L > 0` and `u >= 0`: `u * (L / (L + u))^2 <= L / 4` |
| Differs from paper? | Covers the pointwise inequality only. The integration against the spectral measure of the clock and the Markov step are not formalized; they need the clock operator (H13). Domain `L > 0`, `u >= 0` is the paper's |

### `clock_weight_eq_iff` (same file)

| Field | Content |
|---|---|
| Paper | Not in the paper |
| Formal statement | Under the same hypotheses, equality holds exactly when `u = L` |
| Differs from paper? | Addition. Shows the constant `1/4` is sharp. The handoff had checked this by hand |

### WP1-d: `log_coefficient_eq_iff` (`QuantGrav/Elementary/LogCoefficient.lean`)

| Field | Content |
|---|---|
| Paper | (5.68), (5.69) |
| Paper's claim, in substance | `q = 257/302`, and at fixed mass with angular momenta summed the coefficient of `log s_b` is `q/(2(1-q)) - 1/2 = 106/45` |
| Formal statement | For real `q != 1`: `q / (2 (1 - q)) - 1/2 = 106/45` if and only if `q = 257/302` |
| Differs from paper? | The paper asserts the two equalities; the theorem states their equivalence, which is stronger than the forward check. Stated over the reals because `q` is a real limit; the handoff sketch used rationals. The hypothesis `q != 1` is formally redundant in Lean, where division by zero is zero and both sides are false at `q = 1`; it is kept so the statement does not rest on that convention |

### `q_of_growth_exponent_iff` (same file)

| Field | Content |
|---|---|
| Paper | The two sentences between (5.67c) and (5.68), with (5.58) and (5.66) |
| Paper's claim, in substance | The measure in (5.66) adds `1/2` to the power `106/45`; with `s_*` proportional to `l^2`, (5.58) then gives `q = 257/302` |
| Formal statement | For real `q != 1`: `q / (1 - q) = 2 (106/45 + 1/2)` if and only if `q = 257/302` |
| Differs from paper? | The paper does not display the intermediate equation `q/(1-q) = 2(c + 1/2)`. It is this log's reconstruction of those two sentences. It reproduces the paper's value, which is evidence the reconstruction is right, not proof |

### `log_coefficient_roundtrip` (same file)

| Field | Content |
|---|---|
| Paper | Not stated in the paper |
| Formal statement | For real `q != 1` and any real `c`: if `q / (1 - q) = 2 (c + 1/2)` then `q / (2 (1 - q)) - 1/2 = c` |
| Differs from paper? | Addition. It answers the WP5 question in `handoff.md`: under the reconstruction above, (5.69) returns whatever coefficient (5.67c) put in. The number `106/45` in (5.69) is the input H7, not an output of an independently computed `q` |

### WP1-e: `log_coefficient_of_ratio` (same file)

| Field | Content |
|---|---|
| Paper | (5.61), footnote 23 |
| Paper's claim, in substance | With `x = (1 - eps) r_h / l`: `q = x^2 (2 - q)`, so `q = 2x^2/(1 + x^2)` and `q/(2(1-q)) = x^2/(1 - x^2)` |
| Formal statement | For real `x` with `x^2 != 1`: if `q = 2 x^2 / (1 + x^2)` then `q / (2 (1 - q)) = x^2 / (1 - x^2)` |
| Differs from paper? | Covers the last implication only. The first equivalence, the moment identity (5.60) and its sum over readings are in `QuantGrav/Entropy/ClockMoments.lean` |

### `ratio_sq_of_q` (same file)

| Field | Content |
|---|---|
| Paper | Not stated in the paper |
| Formal statement | For real `x`: `2 x^2 / (1 + x^2) = 257/302` if and only if `x^2 = 257/347` |
| Differs from paper? | Addition. Footnote 23 is a relation between `q` and `x`, and `x` is determined by the state, so this is the value of `x` that (5.68) implies. It is not a constraint on a free ratio, as this entry said before 2026-11-26. See finding F3 |

### WP1-a: `hasSum_pair_amplitude`, `summable_norm_pair_phase` (`QuantGrav/Elementary/PairAmplitude.lean`)

| Field | Content |
|---|---|
| Paper | (4.32), second equality of (4.33), and the sentence after (4.33) |
| Paper's claim, in substance | With `(Delta q_k)^2 = 1/(2sk)`, `lim_N 2 sum_{k=1}^N (Delta q_k)^4 e^{-2ik/s} = Li_2(e^{-2i/s}) / (2 s^2)`, and the sum converges absolutely for every `s > 0` |
| Formal statement | For real `s > 0`, the series with terms `2 (1/(2 s (k+1)))^2 e^{-2i(k+1)/s}`, `k = 0, 1, ...`, has sum `(1/(2 s^2)) sum_k e^{-2i(k+1)/s} / (k+1)^2`. The norms of `e^{-2i(k+1)/s} / (k+1)^2` are summable for every real `s` |
| Differs from paper? | The dilogarithm is not defined; the right-hand side stays a series, as the handoff planned. `HasSum` is unconditional convergence, which implies the paper's `N -> infinity` limit of partial sums. The first equality of (4.33), from the operator expression to `2 (Delta q_k)^4 e^{-2ik/s}` by Wick contraction, is not formalized. Mode numbers are written `k + 1` so nothing depends on division by zero. Absolute summability holds for all real `s`, including `s <= 0`, which is more than the paper claims and only because the phase has norm one |

### WP1-b: `cubic_term_partial_pair_sum` (same file)

| Field | Content |
|---|---|
| Paper | First equality of (4.34) |
| Paper's claim, in substance | At fixed area, `(G_N^3 / 3!) d^3/dG_N^3 [ (1/(2s^2)) sum_{k=1}^N e^{-2ik/s} / k^2 ]` at `G_N = 0` equals `-(i/s^3) sum_{k=1}^N 1/k` |
| Formal statement | For real `kappa`, `G` and natural `N`: `G^3/6` times the third derivative at `0` of `g -> ((kappa g)^2 / 2) sum_{k<N} e^{-2i(k+1) kappa g} / (k+1)^2` equals `-i (kappa G)^3 sum_{k<N} 1/(k+1)` |
| Differs from paper? | The paper's `1/s` is written `kappa G` with `kappa = 4 hbar / A` held fixed; that `s = A/(4 G_N hbar)` is the paper's definition and is used as given. `kappa` is any real, not only positive. No other change |

### WP1-b: `abs_harmonic_sub_log_le`, `tendsto_harmonic_atTop` (same file)

| Field | Content |
|---|---|
| Paper | Second equality of (4.34) |
| Paper's claim, in substance | `sum_{k=1}^N 1/k = log N + O(1)`, so the cubic term diverges logarithmically as the cutoff is removed |
| Formal statement | For `N >= 1`: `\|sum_{k<N} 1/(k+1) - log N\| <= 1`. The partial sums tend to infinity |
| Differs from paper? | The `O(1)` is made explicit as the constant `1`. Both facts are Mathlib's (`harmonic_le_one_add_log`, `log_add_one_le_harmonic`, divergence of the harmonic series), restated in the paper's form |

### WP1-b: `abs_im_tsum_cexp_div_sq_sub_le` (`QuantGrav/Elementary/ClausenAsymptotics.lean`)

| Field | Content |
|---|---|
| Paper | Not displayed. Underlies the sentence after (4.34) |
| Formal statement | For real `0 < theta <= 1`: the imaginary part of `sum_k e^{-i theta (k+1)} / (k+1)^2` differs from `theta log theta - theta` by at most `theta^3 / 24` |
| Differs from paper? | Addition, from the handoff's WP1-b. The handoff asked for `O(theta^3)` as `theta -> 0+`; this is an explicit bound on `(0, 1]`, which implies it. Checked numerically before proving: the true error is about `-theta^3 / 72`. The file also proves the identity behind it, `hasSum_sin_div_sq`: for `0 < theta <= 1`, `sum_k sin((k+1) theta)/(k+1)^2 = -(1/2) int_0^theta log(2 - 2 cos t) dt`. The proof goes through `r^k`-damped sums and Abel's limit theorem; the dilogarithm and Clausen function are never defined |

### WP1-b: `abs_im_pair_amplitude_sub_le` (`QuantGrav/Elementary/PairAmplitudeLog.lean`)

| Field | Content |
|---|---|
| Paper | Last two sentences of the paragraph after (4.34) |
| Paper's claim, in substance | Summing before expanding converts the `log N` divergence into the finite term `-i log s / s^3` in (4.33) |
| Formal statement | For real `s >= 2`: the imaginary part of `(1/(2 s^2)) sum_k e^{-2i(k+1)/s} / (k+1)^2` differs from `(log 2 - 1 - log s) / s^3` by at most `1/(6 s^5)` |
| Differs from paper? | The paper names only the `log s` term. The theorem also fixes the non-logarithmic `1/s^3` piece, `(log 2 - 1)/s^3`, and bounds the remainder. Restricted to `s >= 2`. The real part is given exactly by `re_pair_amplitude`, in the next entry. The paper's further claim that the third derivative of the full sum diverges as `G_N -> 0+` is not formalized; `cubic_term_partial_pair_sum` with `tendsto_harmonic_atTop` covers the truncated sums only |

### WP1-b: `re_pair_amplitude`, `re_tsum_cexp_div_sq`, `hasSum_cos_div_sq` (`QuantGrav/Elementary/PairAmplitudeReal.lean`)

| Field | Content |
|---|---|
| Paper | (4.33) gives the amplitude as `Li_2(e^{-2i/s}) / (2 s^2)`. Its real part is not displayed |
| Formal statement | For real `0 <= theta <= 2 pi`: `sum_k cos((k+1) theta)/(k+1)^2 = pi^2/6 - pi theta/2 + theta^2/4`, and this is the real part of `sum_k e^{-i theta (k+1)}/(k+1)^2`. For real `s >= 1/pi`: the real part of `(1/(2 s^2)) sum_k e^{-2i(k+1)/s}/(k+1)^2` is `(1/(2 s^2)) (pi^2/6 - pi/s + 1/s^2)` |
| Differs from paper? | Addition, suggested by the external audit note (`notes/external-audits-2026-11-26.md`, section 5 item 3); the proof is ours, from Mathlib's Fourier series of the Bernoulli polynomial `B_2`. Exact, with no remainder. The range `s >= 1/pi` is `theta = 2/s <= 2 pi`; the series is periodic in `theta` and the polynomial is not, so nothing is stated outside it. With `abs_im_pair_amplitude_sub_le`, for `s >= 2` the amplitude is `(1/(2 s^2))(pi^2/6 - pi/s + 1/s^2) + i (log 2 - 1 - log s)/s^3` up to an imaginary error of at most `1/(6 s^5)` |

Numbers. At `s = 10` the formula gives `0.006703874007446236`, the value reported in the external audit to every digit. The same audit's imaginary part at `s = 10` differs from `(log 2 - 1 - log 10)/10^3` by `5.56e-7`, inside the bound `1/(6 s^5) = 1.67e-6` of `abs_im_pair_amplitude_sub_le`; that comparison was made by hand in the review session.


### WP1-g: `integral_clock_weight_le`, `setIntegral_clock_tail_le_integral_div`, `setIntegral_clock_tail_le` (`QuantGrav/Elementary/ClockWeightIntegral.lean`)

| Field | Content |
|---|---|
| Paper | (5.17), the sentence above it, and the sentence above (C.14) |
| Paper's claim, in substance | `‖(1 - P_D) Psi_L‖^2 <= <Psi_L\| u \|Psi_L> / l(D) <= L / (4 l(D))`, obtained by integrating the weight `u [L/(L+u)]^2 <= L/4` over the clock readings |
| Formal statement | Let `mu` be a probability measure on the reals with `u >= 0` almost everywhere, and `L, l > 0`. Then `int u (L/(L+u))^2 dmu <= L/4`; `int_{u > l} (L/(L+u))^2 dmu <= (int u (L/(L+u))^2 dmu) / l`; and so `int_{u > l} (L/(L+u))^2 dmu <= L/(4 l)`. The middle statement needs only a finite measure |
| Differs from paper? | The spectral measure of the clock in the incoming state is replaced by an arbitrary probability measure, so nothing depends on H13. The identification of `‖(1 - P_D) Psi_L‖^2` with `int_{u > l} (L/(L+u))^2 dmu` is prose only. In (C.14) the readings are those of `P_M psi`, whose total weight can be less than one; the bounds then hold a fortiori but are stated here for total weight one |

### WP1-f: `clock_mean_ge` and its steps (`QuantGrav/Elementary/ClockLowerBound.lean`)

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `focusing_nonneg` | (3.26c), and "Since `Xi_y(v) >= 0`" after (3.26d) | For `0 <= eps <= v` and `g >= 0` on `[eps, v]`: `(1/8) int_eps^v s g(s) ds >= 0` | `g` stands for `(d_s qbar)^{AB} d_s qbar_{AB}`. Its nonnegativity is a hypothesis here; in the paper it is a sum of squares by (4.21) |
| `clock_reading_ge` | (3.27) | For `rho_0 >= 0`, `eps <= 1` and `Xi >= 0` on `[eps, 1]` with `exp(Xi)` integrable there: `(1 - eps) rho_0 <= rho_0 int_eps^1 exp(Xi(v)) dv` | Integrability of `exp(Xi)` is assumed. The paper has it for smooth data, (5.8) |
| `sq_integral_le_measure_mul_integral_sq` | Classical form of (5.21b) | For `rho` in `L^2` of a finite measure `nu`: `(int rho)^2 <= nu(S) int rho^2` | Any finite measure space. With `nu(S) = 4 pi` it reads `a^2 <= 4 pi A` |
| `clock_mean_ge_area_div` | Classical form of (5.21a) | If `rho >= 0`, `u >= (1 - eps) rho` pointwise and `int rho^2 > 0`: `(1 - eps)(int rho^2)/(int rho) <= (int rho u)/(int rho)` | Integrability of `rho`, `rho^2` and `rho u` is assumed |
| `clock_mean_ge` | Footnote 8; classical form of (5.21c); the average is (3.28) | On a measure space of total mass `4 pi`, for `rho >= 0` in `L^2` with `A = int rho^2 > 0`, `eps <= 1`, and `u >= (1 - eps) rho` with `rho u` integrable: `(1 - eps) sqrt(A/(4 pi)) <= (int rho u)/(int rho)` | The corner sphere is an abstract measure space of total mass `4 pi`. `rho` is nonnegative and square integrable where the paper has a smooth positive density. Integrability of `rho u` is assumed: where a reading is infinite the paper's inequality holds trivially, and this real-valued statement does not cover that case |
| `clock_mean_ge_of_focusing` | Footnote 8 with (3.27) | The same with `u(y) = rho(y) int_eps^1 exp(Xi_y(v)) dv` and `Xi_y >= 0` | As above |
| `clock_mean_eq_of_const` | Last sentence of App D.3 | For a measure of total mass `4 pi`, constant `rho = r > 0` and `u = (1 - eps) r`, the averaged clock equals `(1 - eps) sqrt(A/(4 pi))` | The paper says the classical clock attains the bound for vanishing shear and uniform density; this is that case |
| `integral_pos_of_integral_sq_pos` | Not in the paper | For `rho >= 0` integrable with `int rho^2 > 0`: `int rho > 0` | Helper for the rows above |

Checked numerically before proving: over 20,000 random discrete cases the averaged clock minus the bound was never below zero beyond rounding. These are statements about functions on the sphere. The operator inequalities (5.21a) to (5.21c) for the quantum clock remain hypotheses H14 and H14a.


### WP2-c: `hasSum_inner_cut`, `summable_norm_inner_cut`, `tsum_norm_inner_cut_le`, `tsum_norm_inner_cut_le_of_norm_le_one` (`QuantGrav/OperatorAlgebra/CutSums.lean`)

| Field | Content |
|---|---|
| Paper | (4.29), (4.30) |
| Paper's claim, in substance | `<phi\| U_2 U_1 \|psi> = sum_alpha <phi\| U_2 \|e_alpha><e_alpha\| U_1 \|psi>` in an orthonormal basis on the cut, and `sum_alpha \|<phi\| U_2 \|e_alpha><e_alpha\| U_1 \|psi>\| <= sqrt(<phi\|phi><psi\|psi>)` because time evolution preserves norms |
| Formal statement | For bounded `U_1 : H_1 -> H`, `U_2 : H -> H_2` between complex Hilbert spaces and a Hilbert basis `b` of `H`: the terms `<phi, U_2 b_i><b_i, U_1 psi>` sum to `<phi, U_2 U_1 psi>`; their norms are summable; the sum of norms is at most `‖U_2† phi‖ ‖U_1 psi‖`; and at most `‖phi‖ ‖psi‖` when `‖U_1‖, ‖U_2‖ <= 1` |
| Differs from paper? | More general: any bounded operators, any Hilbert basis of any cardinality. As `handoff.md` expected, absolute convergence of the sum over intermediate states holds for every bounded evolution and is not a feature of this theory. Unitarity (H2) enters only through `‖U‖ <= 1` in the last statement. The physical claim behind (4.29), that the amplitude of the glued spacetime is `<phi\| U_2 U_1 \|psi>` (causal factorization and H3), is not addressed. The statements are about a single cut. Joint absolute convergence over two or more cuts fails in general (F10), so none is stated. Along any increasing sequence of finite cuts that exhausts the basis, the partial sums of the single-cut statement converge to the same limit (`IsIncreasingExhaustion.tendsto_open_cut_sum`, in `QuantGrav/Diamond/OrderOfExhaustion.lean`) |

### WP2-d: `norm_inner_truncation_error_le`, `tendsto_inner_evolveCut`, `tendsto_inner_evolveCut_starProjection` (same file)

| Field | Content |
|---|---|
| Paper | (4.31) and the two sentences after it |
| Paper's claim, in substance | `\|<phi\| (U_m ... U_1 - U_m P_{m-1} U_{m-1} ... P_1 U_1) \|psi>\| <= sqrt(<phi\|phi>) sum_{j=1}^{m-1} ‖(1 - P_j) U_j ... U_1 psi‖`, each term tends to zero as the remaining states are included, so restoring all intermediate states recovers the amplitude |
| Formal statement | For sequences `U`, `P` of bounded operators on one inner product space, all of norm at most one, the full and truncated amplitudes after `m + 1` steps with `m` cuts differ by at most `‖phi‖` times the sum over cuts of `‖x_j - P_j x_j‖`, where `x_j` is the full state at that cut. If the `P` depend on a parameter and converge strongly to the identity on each cut, the truncated amplitude converges to the full one. That holds in particular for orthogonal projections onto increasing sequences of subspaces with dense union |
| Differs from paper? | Definitions `evolve` and `evolveCut` are new and should be read against (4.31): indices start at `0`, so the paper's `U_j` is `U (j-1)` and its `P_j` is `P (j-1)`. All operators act on one space, whereas the paper's caps may carry different spaces. `U` and `P` need only have norm at most one; they need not be unitary or projections. Strong convergence of the truncations is H5, here the explicit hypothesis `hlim`. The last theorem discharges H5 when the kept states on each cut are an increasing sequence of subspaces with dense union, for instance initial segments of a countable orthonormal basis. Nets over an uncountable basis are covered by `tendsto_inner_evolveCut` with `hlim` supplied, not by the last theorem |

### WP2-e: `compression_mul` (same file)

| Field | Content |
|---|---|
| Paper | (C.21) |
| Paper's claim, in substance | `P_D X Y P_D = (P_D X P_D)(P_D Y P_D) + P_D X (1 - P_D) Y P_D` |
| Formal statement | In any ring, for `P` with `P P = P`: `P X Y P = (P X P)(P Y P) + P X (1 - P) Y P` |
| Differs from paper? | More general: a ring identity for any idempotent. It depends on the axiom `propext` only |


### WP2-g: `norm_exp_smul_apply_sub_le`, `norm_inner_apply_sub_inner_apply_le`, `norm_inner_exp_apply_sub_inner_le` (`QuantGrav/OperatorAlgebra/BoostBound.lean`)

| Field | Content |
|---|---|
| Paper | (5.32), proved in the paper by (D.22), (D.23) |
| Paper's claim, in substance | With `Psi_P` the normalized state on the doubled cut and the boost acting on the conjugate copy by `e^{i eta s/(2 pi)}`: the boosted state is within `(\|eta\|/2 pi) sqrt(Tr[rho_P (s - s_0)^2])` of `Psi_P` up to a phase, by `\|e^{ix} - 1\| <= \|x\|`; so the expectation value of a bounded `O` changes by at most `(\|eta\|/pi) ‖O‖ sqrt(Tr[rho_P (s - s_0)^2])` |
| Formal statement | On a complex Hilbert space, for a bounded self-adjoint `A`, real `theta`, any vector `Psi`: `‖exp(i theta A) Psi - Psi‖ <= \|theta\| ‖A Psi‖`. For bounded `O` and vectors `xi`, `psi`: `\|<xi, O xi> - <psi, O psi>\| <= ‖O‖ (‖xi‖ + ‖psi‖) ‖xi - psi‖`. Hence for a unit vector `Psi`: the expectation value of `O` changes by at most `2 ‖O‖ \|theta\| ‖A Psi‖` under `Psi -> exp(i theta A) Psi` |
| Differs from paper? | Stated for one abstract Hilbert space and one bounded self-adjoint generator. The paper's case is `A = (1 tensor (s* - s_0))/(2 pi)` on the doubled space, `theta = eta`, `Psi = Psi_P`, for which `‖A Psi_P‖^2 = Tr[rho_P (s - s_0)^2]/(4 pi^2)` and the last bound is exactly (5.32). That mapping is prose: the doubled space, `Psi_P` and the identity for `‖A Psi_P‖` are not formalized. Boundedness of `A` is the paper's `0 <= s <= s_*` (5.30a), which rests on H14. The scalar inequality `\|e^{ix} - 1\| <= \|x\|` is not used; the operator version is proved by the mean value inequality, which covers continuous spectrum without a spectral theorem. Proof written by a subagent from fixed statements; see the note under "How the paper was read" |


### Finding F2: `finiteDimensional_of_sum_sq_norm_le`, `finrank_le_of_sum_sq_norm_le` (`QuantGrav/Diamond/FiniteDim.lean`)

| Field | Content |
|---|---|
| Paper | Not stated in the paper. Uses (5.30c) and the counting step of (D.24); same shape as the paper's AdS argument (5.44) to (5.46) |
| Formal statement | Let `H`, `K` be complex inner product spaces and `C : H -> K` a bounded linear map. Suppose `c > 0` with `c ‖v‖^2 <= ‖C v‖^2` for all `v`, and a real `Z` with `sum_i ‖C (e i)‖^2 <= Z` for every finite orthonormal family `e` in `H`. Then `H` is finite-dimensional and `dim H <= Z / c` |
| Differs from paper? | Addition. No physics enters. Completeness of `H` and `K` is not assumed, which is weaker than the Hilbert spaces `handoff.md` asked for. Finite orthonormal families are indexed by `Fin n`. The two conclusions are separate theorems. The mapping to the paper, `H = H_D`, `C = C_b` on `H_D`, `c = e^{-s_*} m_{b,D}`, `sum_i ‖C (e i)‖^2 = Tr(P C_b† C_b)`, is prose and has no formal counterpart until `H_D` and `C_b` are defined |

### Finding F2, converse: `sum_sq_norm_le_finrank`, `finiteDimensional_iff_exists_sum_sq_norm_le` (same file)

| Field | Content |
|---|---|
| Paper | Not stated in the paper. Uses the upper bound `C_b† C_b <= 1` of (5.30c) |
| Formal statement | If `H` is finite-dimensional and `‖C v‖ <= ‖v‖` for all `v`, then `sum_i ‖C (e i)‖^2 <= dim H` for every finite orthonormal family. Hence, for `c ‖v‖^2 <= ‖C v‖^2 <= ‖v‖^2` with `c > 0`: `H` is finite-dimensional if and only if the sums `sum_i ‖C (e i)‖^2` over finite orthonormal families are bounded |
| Differs from paper? | Addition. Same remarks as above |


### Definitions: `SpectralFamily`, `DiamondSetup` (`QuantGrav/Diamond/Setup.lean`)

| Lean | Paper | Differs from paper? |
|---|---|---|
| `SpectralFamily`: `proj`, `isStarProjection`, `proj_mul_proj_of_le`, `tendsto_proj_nhdsGT` | The spectral projections `1_{(-inf, t]}` of a self-adjoint operator, with closed right end as in (5.2) | Modelling choice. Mathlib has no spectral theorem for unbounded operators, so the family replaces the operator. The dictionary between the two is not formalized. The family need not reach the identity or zero |
| `fixedArea`, `isClosed_fixedArea` | `K_A`: (4.8) to (4.10), a completion, embedded isometrically in `H_omega` after (4.16) | Only "closed subspace" is recorded. The Fock structure (4.10) is not |
| `area₀`, `area₀_pos` | `A = 4 pi b^2`, Sec 5.1; positive area, App C.2 | None |
| `ε`, `ε_pos`, `ε_lt_one` | `0 < eps < 1`, the sentence after (3.18) | None. `eps << 1` of Sec 5.3 is not encoded |
| `Ω`, `Ω_mem`, `norm_Ω` | `Omega_A`, (4.7), (4.8) | Only a unit vector of `K_A`. Its Gaussian form is not recorded |
| `clock`, `clock_proj_of_neg`, `clock_proj_mem` | `1_{[0, l]}(u)` in (5.2); positivity from (4.22) and (4.27); "acts within `K_A`" after (4.26) | The family lives on `H_omega`. The paper constructs the clock on `K_A` only (F6). Register entry H16 |
| `area`, `area_exhausts`, `area_tendsto_atBot` | `A` as boost generator, with the spectral theorem applied to it, (4.12) to (4.15) | Presupposes a self-adjoint `A` on `H_omega` (F6). Positivity of `A` is not a field; it is the lower bound in H14. Register entry H17 |
| `commute` | Asserted after (5.2), before (5.20) and before (5.21) | Assumed. On `K_A` it follows from the other fields (`clock_proj_area_proj_comm_of_mem_fixedArea`), so it has content only off `K_A` |
| `area_proj_of_lt`, `area_proj_area₀` | Every occupation number state has corner area `A`, after (4.11); `A = A 1` before (4.24) | None |
| `diamondProj`, `diamondSpace` | `P_D` and `H_D = P_D H_omega`, (5.1), (5.2) | Outside `K_A` they depend on the unspecified extension of the clock |
| `fixedAreaDiamondSpace` | `P_D(A) K_A`, App C.3 | The part of `H_D` that the paper's construction determines |
| `areaBound` | `4 pi l^2/(1 - eps)^2`, (5.21d) | None |
| `clockLowerBound` | `(1 - eps)(A/4pi)^(1/2)`, fn 8, (5.21c) | A lower bound. The paper claims it is attained only classically |
| `ofProjections` | Not in the paper | A model showing the fields are consistent. Not a model of the paper's theory |

Not represented: the algebra of observables, its representation, cyclicity of `Omega_A`, irreducibility (4.17), so (5.20) cannot be stated; the regularized clocks; `Psi_L`; the operators of (4.26), (5.21a), (5.21b); the conditional probability (5.3).

### H1: `DiamondSetup.H1` (`QuantGrav/Hypotheses.lean`)

| Field | Content |
|---|---|
| Paper | (5.7), (5.16) with fn 18; (C.14) and the sentence after it; (5.19) |
| Paper's claim, in substance | `‖Psi_L - Omega_A‖ -> 0` as `L -> infinity`. The paper calls the outcome strong evidence and says the last step is a heuristic |
| Formal statement | `S.H1`: `P_l Omega -> Omega` as `l -> infinity`, where `P_l` is the clock's spectral projection |
| Differs from paper? | Stated in the form `Omega_A in M`. The paper says this is equivalent, in the sentence after (C.14). `Psi_L` is not defined in Lean, so that equivalence is the paper's and is not a theorem here. `H1` is a proposition that theorems take as an argument; nothing asserts it |

### H13: `DiamondSetup.H13` (same file)

| Field | Content |
|---|---|
| Paper | fn 14; the paragraph after (C.17) |
| Paper's claim, in substance | The clock (4.27) is finite on a dense set of `K_A`. The paper derives this on the condition that the estimate behind H1 also holds for displaced Gaussian states |
| Formal statement | `S.H13`: `P_l x -> x` as `l -> infinity` for every `x` in `K_A` |
| Differs from paper? | Unconditional, where the paper's statement is conditional; displaced Gaussian states are not in the structure, so the condition cannot be stated. About `K_A` only. Narrower than the register entry H13 was before 2026-11-26: existence of the clock and commutation with the area moved to H16 |

### H14: `DiamondSetup.AreaBoundAt`, `DiamondSetup.H14` (same file)

| Field | Content |
|---|---|
| Paper | (5.21a) to (5.21d), fn 8 |
| Paper's claim, in substance | `u >= (1 - eps)(A/4pi)^(1/2)` as operators, hence `0 <= P_D A P_D <= 4 pi l(D)^2/(1 - eps)^2 P_D` |
| Formal statement | `S.AreaBoundAt l`: every vector of `H_D` for maximum reading `l` is fixed by `1_{(-inf, 4 pi l^2/(1 - eps)^2]}(A)` and annihilated by `1_{(-inf, a]}(A)` for every `a < 0`. `S.H14`: this for every `l` |
| Differs from paper? | The spectral-support form of the operator inequalities. For commuting self-adjoint operators the two forms agree by the spectral theorem, which is not formalized. In this form (5.21c) and "(5.21d) for every `l`" are the same statement. (5.21a), (5.21b) cannot be stated. The paper argues at fixed area; on `H_omega` the statement rests on H16 |

### H14a: `DiamondSetup.H14a` (same file)

| Field | Content |
|---|---|
| Paper | (5.21a) to (5.21c) at fixed area; fn 8 for the classical bound |
| Paper's claim, in substance | At fixed area `A`, positivity of the focusing term and Cauchy-Schwarz on `S` give `u >= (1 - eps)(A/4pi)^(1/2)` |
| Formal statement | `S.H14a`: `P_l x = 0` for every `x` in `K_A` and every `l < (1 - eps)(A/4pi)^(1/2)` |
| Differs from paper? | The spectral-support form of the fixed-area inequality. It does not involve the extension of the clock to `H_omega`, so it is the part of H14 that the paper's argument supports directly. The paper goes from this to (5.21d) by commutation; in Lean the implication proved is the other one, `H14.h14a` |


### First consequences (`QuantGrav/Diamond/ClockHypotheses.lean`, and two lemmas in `Setup.lean`)

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `H13.h1` | Not stated | H13 implies H1 | Addition |
| `H1_iff_tendsto_norm_sq` | (5.19): `‖P_D Omega_A‖^2 -> 1` as `l(D) -> infinity`, deduced from H1 through (5.17), (5.18) | `S.H1` holds if and only if `‖P_l Omega‖^2 -> 1` | An equivalence, where the paper has an implication. See F7 |
| `H1.exists_diamondProj_ne_zero` | The sentence after (5.19): the incoming wavefunction has nonzero projection for some finite maximum reading | Under H1 there is `l` with `P_l Omega != 0` | None |
| `H14.clock_proj_eq_zero_of_lt_clockLowerBound`, `H14.h14a` | (5.21c) at fixed area; fn 8 | H14 implies H14a: under H14, `P_l x = 0` for `x` in `K_A` and `l < (1 - eps)(A/4pi)^(1/2)` | The paper argues the fixed-area bound first and extends it; the Lean implication runs from the `H_omega` statement to the fixed-area one |
| `H14a.fixedAreaDiamondSpace_eq_bot` | Not stated | Under H14a, `P_D(A) K_A` is trivial when `l < (1 - eps)(A/4pi)^(1/2)` | Addition |
| `fixedAreaDiamondSpace_eq_map` | App C.3 writes `P_D(A) K_A` | `fixedAreaDiamondSpace l` is the image of `K_A` under `P_l` | Addition; justifies the definition. Uses `clock_proj_mem` |
| `clock_proj_area_proj_comm_of_mem_fixedArea` | Not stated | On `K_A` the clock and area projections commute, without using the field `commute` | Addition |
| `areaBound_clockLowerBound` | Not stated | `areaBound (clockLowerBound) = A` | Addition; a consistency check on the two constants |
| `exists_setup_not_H1` | Not stated | On any Hilbert space with a unit vector there is a `DiamondSetup` in which H1 fails | Addition. See F8 |
| `exists_setup_H1_H13_not_H14` | Not stated | On any Hilbert space with a unit vector there is a `DiamondSetup` satisfying H1 and H13 in which H14 fails | Addition. See F8 |
| `exists_setup_H1_H13_H14_diamondSpace_eq_top` | Not stated | On any Hilbert space with a unit vector there is a `DiamondSetup` satisfying H1, H13 and H14 in which `K_A` and every `H_D` with `l >= 1` are the whole space | Addition. See F8 |


### Step 5: comparison with Sen (`QuantGrav/Entropy/SenComparison.lean`)

Sen's formulas are transcribed as definitions and paired with his equation numbers. `a` is the size of the black hole, `A_H ~ a^(D-2)`; in four dimensions a coefficient of `log s` is half the coefficient of `ln a`.

| Lean | Source | Formal statement | Differs from source? |
|---|---|---|---|
| `Sen.cLocal` | Sen (1.2) | `C_local = (2 n_S - 26 n_V + 7 n_F - (233/2) n_{3/2} + 424)/90` | Transcription. Sen states it for uncharged black holes in `D = 4` with minimally coupled fields |
| `Sen.numCartan`, `Sen.numRotations` | Sen, after (1.1) and after (1.5) | `N_C = [(D-1)/2]`, `N_R = (D-1)(D-2)/2` | Transcription, with natural-number division |
| `Sen.mcCoeff` | Sen (1.1) | `C_local - (D-4)/2 - (D-2) N_C/2 - (D-4) n_V/2` | Transcription. The coefficient of `ln a` in `S_mc - S_BH` |
| `Sen.mixedCoeff` | Sen (1.4) | `C_local - (D-4)/2 - (D-4) n_V/2` | Transcription |
| `Sen.singletCoeff` | Sen (1.5) | `C_local - (D-4)/2 - (D-2) N_R/2 - (D-4) n_V/2` | Transcription |
| `Sen.cLocal_pure_gravity` | Sen, after (1.5) | `C_local = 212/45` with no matter fields | None |
| `Sen.mixedCoeff_four`, `Sen.mcCoeff_four`, `Sen.singletCoeff_four` | Sen (1.1), (1.4), (1.5) at `D = 4`, `n_V = 0` | The three coefficients are `C`, `C - 1`, `C - 3` for any local coefficient `C` | Sen states `C - 3` for pure gravity and the `-ln a` of the microcanonical case; the mixed case is read off (1.4) |
| `fixed_mass_coeff_eq_sen_mixed` | Paper (5.69) against Sen (1.4) | `106/45` is half of Sen's mixed coefficient for pure gravity in `D = 4` | Addition. The comparison the paper asserts in words |
| `fixed_mass_coeff_sub_sen_mc`, `fixed_mass_coeff_sub_sen_singlet` | Paper (5.69) against Sen (1.1), (1.5) | `106/45` exceeds half of Sen's microcanonical and singlet coefficients by `1/2` and `3/2` | Addition |
| `entropy_coeff_eq_sen_local_add_one` | Paper (5.65), (5.68) | `257/90 = (212/45 + 1)/2` | Addition |
| `trace_log_prefactor_eq` | Paper (5.67c) | `53/(45 (4 pi)^2) * 8 pi * 8 pi = 212/45` | Checks the paper's own evaluation of the prefactor, with the Gauss-Bonnet value `8 pi` of the curvature integral put in |


### Break attempt B1: a positive quadratic form of Gaussian modes, and the clock (`QuantGrav/Elementary/`, `QuantGrav/Diamond/ClockDivergence.lean`)

Outcome 2 of `handoff.md` Section 14.1 for the passage from fixed resolution to (5.19), and outcome 4, undecided, for (5.19) itself. The finding is F11. Everything below about Gaussian modes is a model. It is a countermodel to an inference, not a counterexample to the theory.

Files: `OneAddSumLeProd.lean` (G1), `GaussianExpSq.lean` (G2), `GaussianQuadraticForm.lean` (G3), `FocusingDivergence.lean`, `GaussianModeLimits.lean`, all in `QuantGrav/Elementary/`, and `QuantGrav/Diamond/ClockDivergence.lean`.

Definitions.

- `radialVariance s k = 1/(2 s (k + 1))`, as a nonnegative real. Paper: the variance `(Delta q_k)^2 = 1/(2 s k)` of the pair example (4.32), with modes counted from zero here. The general state (4.7) has free widths, and Sec 5.1 does not give them.
- The model focusing of the first `N` modes is `sum_{k<N} a_k q_k^2` for weights `a_k >= c (k+1)^2`, or `a_k >= c`. Paper: no such object. The growth `k^2` is read off from (D.41), `k^2 abs(h_I)^2` proportional to `abs(k)/s` for one graviton at large angular momentum, where it refers to the shear term of the cost (D.40). (D.40) is not the focusing of (4.22) and (C.16b).

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `one_add_sum_le_prod_one_add`, `one_add_trace_le_det_one_add` | Not in the paper | For `x_i >= 0`: `1 + sum x_i <= prod (1 + x_i)`. For a positive semidefinite real matrix `A`: `1 + tr A <= det(1 + A)` | Mathematics only (G1). The matrix form is not used further here |
| `integral_exp_neg_mul_sq_gaussianReal`, `integral_exp_neg_sum_mul_sq_pi` | Not in the paper | For a centred Gaussian variable of variance `v` and `b >= 0`: the mean of `exp(-b q^2)` is `(1 + 2 b v)^(-1/2)`. For finitely many independent ones the mean of `exp(-sum b_k q_k^2)` is the product | Mathematics only (G2) |
| `measureReal_sum_mul_sq_le_le`, `measureReal_infinitePi_sum_range_mul_sq_le_le` | Not in the paper | For independent centred Gaussian variables `q_k` of variances `v_k`, weights `a_k >= 0` and `c > 0`: `P(sum_{k<N} a_k q_k^2 <= c) <= e (1 + (2/c) sum_{k<N} a_k v_k)^(-1/2)` | Mathematics only (G3). Stated on a finite product, and for the first `N` coordinates of the infinite product measure |
| `measure_forall_sum_range_mul_sq_le_eq_zero`, `ae_tendsto_sum_mul_sq_atTop` | Not in the paper | If `sum a_k v_k` diverges: for each `c > 0` the event that every partial sum is at most `c` has probability zero, and almost surely the partial sums tend to infinity | Mathematics only |
| `le_sum_mul_radialVariance`, `tendsto_sum_mul_radialVariance_atTop`, `tendsto_sum_mul_radialVariance_atTop_of_le` | (4.32), (D.41) | With variances `1/(2 s (k+1))`, `s > 0`, and weights `a_k >= c (k+1)^2`: `sum_{k<N} a_k v_k >= c N (N+1)/(4 s)`, which diverges for `c > 0`. It diverges already for weights `a_k >= c > 0` | The paper gives the two scalings and does not form this sum. See the definitions above for how far each scaling is the paper's |
| `measureReal_focusing_le_le`, `ae_tendsto_focusing_atTop`, `ae_tendsto_focusing_atTop_of_le` | (4.22), (4.32), (C.16b), (D.41) | For those Gaussian modes and `x > 0`: `P(sum_{k<N} a_k q_k^2 <= x) <= e (1 + c N (N+1)/(2 s x))^(-1/2)`. With all modes the form is infinite almost surely | Model. One harmonic of one polarization, one Gaussian variable per mode, a diagonal form |
| `tendsto_integral_div_add_fixed_modes` | (C.15b), with (5.9) | For a fixed number of modes `N` and a nondecreasing `g >= 0`: the mean of `g(Q_N)/(L + g(Q_N))` tends to `0` as `L` tends to infinity | The model's analogue of (C.15b). The paper's statement is about the full nonlinear clock on `(q, p)`, for a finite set of canonical pairs |
| `mul_one_sub_le_integral_div_add`, `tendsto_integral_div_add_all_modes` | Not stated | For fixed `L > 0`, weights `a_k >= 0` with `sum a_k v_k` divergent, and `g` nondecreasing, nonnegative and unbounded: the same mean tends to `1` as `N` tends to infinity, with an explicit lower bound at each `N` | Addition. In the model the two limits do not commute |
| `proj_apply_eq_zero_of_forall_exists`, `DiamondSetup.diamondProj_Ω_eq_zero_of_forall_exists`, `DiamondSetup.diamondProj_Ω_eq_zero_of_modes` | (5.2), (5.19) | For an orthogonal projection `E` and a vector `Omega`: if for every `eps > 0` some orthogonal projection `F` has `‖F Omega‖ <= eps` and `‖psi - F psi‖ <= eps ‖psi‖` on the range of `E`, then `E Omega = 0`. The same for `E = P_D` | Addition. An abstract Hilbert-space statement |
| `DiamondSetup.diamondProj_Ω_eq_zero_of_gaussian_modes`, `DiamondSetup.diamondProj_Ω_eq_zero_of_radial_modes` | (4.7), (4.32), (5.19), (5.21) | Suppose `‖F N c Omega_A‖^2` is the Gaussian probability that the model focusing of the first `N` modes is at most `c`; the series of means diverges; and for every `eps > 0` some `c > 0` gives `‖psi - F N c psi‖ <= eps ‖psi‖` on `H_D` for all `N`. Then `P_D Omega_A = 0` | Conditional. Neither input is established for the paper's theory; see F11 |
| `DiamondSetup.not_H1_of_forall_diamondProj_Ω_eq_zero` | (5.19) | If `P_D Omega_A = 0` for every maximum reading, H1 fails | The limit in (5.19) would then be `0` |


### Break attempt B3: clock moments and footnote 23 (`QuantGrav/Entropy/ClockMoments.lean`)

Outcome 3 of `handoff.md` Section 14.1: consistent. The finding is F3.

A finite spectrum is a finite family of states with clock readings `u_i` and weights `w_i`. In the paper `w_i = e^{-s_i}`.

Definitions.

- `momentSum u w k t`: the sum of `u_i^k w_i` over the states with `u_i <= t`. Paper: for `k = 0` it is `Z(t)` of (5.56), and `<u>_l` is `momentSum u w 1 l / momentSum u w 0 l`.
- `firstMomentOf Z l = l Z(l) - int_0^l Z` and `secondMomentOf Z l = l^2 Z(l) - 2 int_0^l t Z(t) dt`, for any function `Z`. The paper has no such definitions. For the counting function of a finite spectrum they are the weighted sums of `u_i` and `u_i^2`, the first by (5.56); see the first two rows.

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `integral_momentSum_zero`, `firstMomentOf_momentSum` | (5.56) | For readings `u_i >= 0` and `l >= 0`: `int_0^l Z` is the sum of `(l - u_i) w_i` over `u_i <= l`, and `l Z(l) - int_0^l Z` is the sum of `u_i w_i` over `u_i <= l` | The paper writes the second as `Z(l)(l - <u>_l)`. No sign condition on the weights is needed |
| `secondMomentOf_momentSum` | Not in the paper | For readings `u_i >= 0` and `l >= 0`: `l^2 Z(l) - 2 int_0^l t Z(t) dt` is the sum of `u_i^2 w_i` over `u_i <= l` | Addition: the second-moment analogue of (5.56) |
| `hasDerivAt_log_integral_momentSum_div` | (5.57a) | For readings `u_i >= 0` and `l > 0` that is not a reading, with `l Z(l)` greater than the sum of `u_i w_i` over `u_i <= l`, which by (5.56) says `int_0^l Z > 0`: `log((1/l) int_0^l Z)` has a derivative `D` at `l`, and `l D` is the sum of `u_i w_i` divided by the sum of `(l - u_i) w_i`, both over `u_i <= l` | The paper says "between eigenvalues". Its right side `<u>_l/(l - <u>_l)` is the same number; the form here is the integrand of (5.58) |
| `reading_eq_sq_div_add_integral` | (5.60), second half | For `0 < u <= l`: `u = u^2/l + int_u^l (u/t)^2 dt` | None |
| `momentSum_one_eq_div_add_integral` | Footnote 23: "summing this identity over clock readings" | For readings `u_i > 0` and `l > 0`: the sum of `u_i w_i` over `u_i <= l` equals `1/l` times the sum of `u_i^2 w_i` over `u_i <= l`, plus `int_0^l (1/t^2) M_2(t) dt`, where `M_2(t)` is the sum of `u_i^2 w_i` over `u_i <= t` | The paper goes on to `q = x^2 (2 - q)` by replacing the normalised second moment by `x^2` at every `t` and using (5.57b). That asymptotic step is not formalized |
| `sum_sq_reading_bounds` | (5.55); (5.60), first half | For weights `w_i >= 0` and `0 <= a_i <= u_i <= l`: `sum w a^2 <= sum w u^2 <= l sum w u`, and `sum w u^2 <= sum w a^2 + 2 l sum w (u - a)` | In the paper `a = (1 - eps)(A/4 pi)^(1/2)` by (5.21c). After division by the total weight, `sum w a^2` is `(1 - eps)^2 r_h^2` and `sum w (u - a)` is the mean time delay of (5.53). So `x^2 <= <(u/l)^2> <= x^2 + 2 <delay>/l` exactly, where the paper states `<(u/l)^2> = x^2 + o(1)` |
| `firstMomentOf_rpow`, `secondMomentOf_rpow` | Not stated; behind (5.58) and (5.61) | For `p > 0`, `l > 0` and `Z(t) = K t^p`: the first moment is `p/(p+1)` times `l Z(l)`, and the second is `p/(p+2)` times `l^2 Z(l)` | An exact power law is an idealisation. The paper has `log Z = (q/(1-q) + o(1)) log l` in (5.58) |
| `powerLaw_moment_ratios`, `eq_sq_mul_two_sub_iff`, `sq_eq_div_two_sub_iff` | (5.61) | For `p > 0`, the ratios `q = p/(p+1)` and `X = p/(p+2)` satisfy `q = 2X/(1+X)`, `X = q/(2-q)` and `p = q/(1-q)`. For real `q` and `x`: `q = x^2 (2-q)` exactly when `q = 2x^2/(1+x^2)`; and for `q != 2`, `x^2 = q/(2-q)` exactly when `q = 2x^2/(1+x^2)` | The paper derives (5.61) by summing (5.60). Here it is shown to hold for every power law |
| `sq_le_and_le_of_sq_eq_div` | (5.54b), (5.54c) | For `0 < q < 1` and `x >= 0` with `x^2 = q/(2-q)`: `x^2 <= q <= x < 1` | The paper obtains the bounds from concavity and from focusing. Here they follow from the relation |
| `moment_ratios_of_q` | (5.68) with (5.58) and (5.61) | For `q = 257/302`: `q/(1-q) = 257/45`, `q/(2-q) = 257/347`, `q/(2(1-q)) - 1 = 167/90` | The last two numbers are not in the paper |
| `integral_ite_le`, `intervalIntegrable_ite_le`, `integral_div_sq`, `intervalIntegrable_momentSum`, `measurable_momentSum`, `continuousAt_ite_le_const`, `continuousAt_momentSum` | Not in the paper | Integrals, integrability, measurability and continuity of step functions and of the moment sums | Helpers for the rows above |


### Break attempt B2: entropy accounting, footnote 24, and a model (`QuantGrav/Entropy/GibbsAccounting.lean`, `BandCounting.lean`, `LogLevelsModel.lean`)

Outcome 3 of `handoff.md` Section 14.1: consistent. The finding is F13.

A finite spectrum is a finite family of states with levels `s_i`. Equal levels are allowed and each state counts once, as in the sentence after (5.56). In the paper `s_i` is the area of state `i` in units of `4 G hbar`, and the number of states is `d_D = dim H_D`. Statements with no nonemptiness hypothesis also hold for the empty family, where every sum is zero and Lean's `log 0` is `0`.

Definitions.

- `gibbsZ s`: the sum of `e^{-s_i}`. Paper: `Z_{D,1}` of (5.39b).
- `gibbsWeight s i = e^{-s_i}/Z`. Paper: the diagonal of `rho_D` of (5.39a) in an eigenbasis of the area.
- `gibbsMean s f`: the sum of `p_i f_i`. Paper: the expectation of `f` of the area in `rho_D`.
- `gibbsEntropy s`: the sum of `-p_i log p_i`. Paper: `S(rho_D)` of (5.50).
- `levelValues s`: the set of distinct levels, and `levelFiber s x`: the set of states at level `x`. Paper: the eigenvalues `A_1, ..., A_m` of (5.40) and the eigenspaces `H_{D,A_j}`. The cardinality of a fibre is the multiplicity `d_j`.
- `levelsBelow s c`: the states with `s_i <= c`. `levelBand s b c`: the states with `b < s_i <= c`. `gibbsProb s t`: the sum of `p_i` over a set of states `t`. Paper: the cardinality of `levelsBelow s (a s_*)` is the dimension in (5.64), and its `gibbsProb` is the probability in (5.63).
- `logLevels N`: the `N + 1` levels `log 1, ..., log (N + 1)`. Not in the paper. It is a model.

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `gibbsZ_nonneg`, `gibbsZ_pos`, `gibbsWeight_pos`, `gibbsWeight_mul_gibbsZ`, `sum_gibbsWeight` | (5.39a), (5.39b) | `Z >= 0`, and `Z > 0` for a nonempty family; `p_i > 0`; `p_i Z = e^{-s_i}`; and `sum p_i = 1` for a nonempty family | None. The last is `Tr rho_D = 1` |
| `gibbsEntropy_eq_mean_add_log` | (5.50) | `-sum p_i log p_i = sum p_i s_i + log Z` | None. The paper writes it with the trace on `H_D`; this is the same identity in an eigenbasis of the area |
| `card_eq_gibbsZ_mul_mean_exp` | (5.39c) | The number of states equals `Z` times the sum of `p_i e^{s_i}` | None. It is an identity, as F4 says |
| `gibbsZ_mul_exp_mean_le_card`, `gibbsEntropy_le_log_card` | Not stated | `Z e^{<s>} <= d` and `S <= log d`, with `d` the number of states | Addition. Jensen's inequality applied to (5.39c) |
| `sum_card_levelFiber`, `card_levelValues_le_card` | (5.40) and the sentence before it | The multiplicities of the distinct levels add up to the number of states, and there are at most that many distinct levels | None |
| `card_le_card_levelValues_mul`, `gibbsEntropy_le_log_card_levelValues_add_log`, `gibbsZ_mul_exp_mean_le_card_levelValues_mul` | Not in the paper | If every level has multiplicity at most `D`, and `m` is the number of distinct levels: `d <= m D`, `S <= log m + log D` and `Z e^{<s>} <= m D` | Addition: the accounting lemma of B2 |
| `inv_card_le_sum_sq_gibbsWeight` | The sentence after (D.47): finite dimension implies `R(2) > 0` | For a nonempty family: `sum p_i^2 >= 1/d` | The paper states positivity only. The nonemptiness hypothesis is not needed |
| `sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq` | (D.49) | For a finite set of labels `a` with real numbers `sigma_a` and `k_a`: `(sum k_a)^2 <= (sum e^{sigma_a}) (sum e^{-sigma_a} k_a^2)` | The paper has an integral over `s` and a sum over `a = 1, ..., d(s)`, so its denominator is `int ds e^s d(s)`. Here there is one finite sum over labels. No sign condition on `k_a` is needed |
| `levelBand_subset_levelsBelow`, `gibbsProb_nonneg`, `gibbsProb_mul_gibbsZ` | Not in the paper | The band `(b, c]` lies in the set of states with `s_i <= c`; `gibbsProb s t >= 0`; and `gibbsProb s t` times `Z` is the sum of `e^{-s_i}` over `t` | Bookkeeping |
| `card_levelsBelow_le` | Footnote 24, upper half of (5.64) | At most `Z e^c` states have `s_i <= c` | The paper states the asymptotic form only |
| `gibbsProb_levelBand_mul_le_card`, `card_levelBand_le` | Footnote 24, lower half of (5.64) | The number `N` of states with `b < s_i <= c` satisfies `P Z e^b <= N <= P Z e^c`, where `P` is the probability of the band | As above |
| `card_le_card_image_mul_of_card_levelFiber_le`, `gibbsProb_levelBand_mul_le_card_image_mul` | Not in the paper | If every level in the band `(b, c]` has multiplicity at most `D`, the band contains at least `P Z e^b / D` distinct levels | Addition |
| `tendsto_log_card_levelsBelow_div` | Footnote 24: (5.64) from (5.63) | For a family of finite spectra and scales `sigma -> infinity`: if `log Z / sigma -> 0` and, for every `0 < delta < a`, the band `((a - delta) sigma, a sigma]` eventually has probability at least some `p > 0`, then `log N(a sigma) / sigma -> a`, where `N(c)` is the number of states with `s_i <= c` | The paper's `sigma` is `s_*`. The hypothesis on the bands is the sentence after (5.63), that every band has positive limiting probability; it is taken as given, and (5.63) itself is not formalized. The paper has `a <= 1`, which is not needed |
| `tendsto_log_card_image_levelsBelow_div` | Not in the paper | Under the same hypotheses, if every level at most `a sigma` has multiplicity at most `D` with `log D / sigma -> 0`, then the number `m(a sigma)` of distinct levels at most `a sigma` satisfies `log m(a sigma) / sigma -> a` | Addition: the consequence recorded in F13. The multiplicity bound is a hypothesis. In the paper it would be (D.46c) with `Q_*` bounded |
| `logLevels_nonneg`, `logLevels_le`, `logLevels_injective`, `card_levelFiber_logLevels_le_one` | Not in the paper | The levels `log (k + 1)`, `k = 0, ..., N`, lie in `[0, log (N + 1)]` and are distinct, so every multiplicity is at most one | A model |
| `gibbsZ_logLevels`, `gibbsZ_logLevels_le`, `log_le_gibbsZ_logLevels`, `tendsto_log_gibbsZ_logLevels_div` | Not in the paper; compare (5.62) | In the model `Z` is the harmonic number `H_{N+1}`, so `log (N + 2) <= Z <= 1 + log (N + 1)`, and `log Z / log (N + 1) -> 0` | A model |
| `card_levelsBelow_logLevels` | Not in the paper; compare (5.64) | In the model exactly `min (N + 1, floor(e^c))` states have level at most `c` | A model |
| `exists_le_gibbsProb_levelBand_logLevels` | Not in the paper; compare (5.63) | In the model, for `0 < delta < a <= 1` and `sigma = log (N + 1)`, the band `((a - delta) sigma, a sigma]` has probability at least some `p > 0` for all large `N` | A model. Only this lower bound is proved. Numerically the probability of `s_i <= a sigma` tends to `a`, which is (5.63) with exponent one; the paper's exponent is `q/(2(1 - q))` |
| `tendsto_log_card_levelsBelow_logLevels`, `tendsto_log_card_image_levelsBelow_logLevels` | Not in the paper; compare (5.64) | In the model, for `0 < a <= 1`: `log N(a sigma) / sigma -> a`, and the same for the number of distinct levels | A model |

### Track A item 4: the trace as the maximum reading grows (`QuantGrav/Elementary/LogIntegralLimit.lean`, `MonotoneLogGrowth.lean`, `QuantGrav/Entropy/ClockTraceAsymptotics.lean`, `MeanAreaGrowth.lean`)

These files state (5.57b), (5.58), (5.62) and (5.65) as theorems conditional on named limits, as `handoff.md` Section 14.3 item 4 asks. There is no finding here: each step holds as the paper gives it, once its inputs are assumed.

A spectrum is a family of states with clock readings `u_i` and areas `s_i`, in units of `4 G hbar`. It may be infinite, but only finitely many states have `u_i <= l`, for every `l`; in the paper that is the finite dimension of the diamond with maximum reading `l`. The paper varies "only the upper limit" in the clock projector (line 1988), so one spectrum serves for every `l`.

Definitions.

- `belowReading u l f`: the restriction of a function `f` on the states to the states with `u_i <= l`. Not in the paper.
- `cutoffZ u s l`: the sum of `e^{-s_i}` over `u_i <= l`. Paper: `Z(l)` of (5.56).
- `cutoffMeanReading u s l`, `cutoffMeanArea u s l`, `cutoffEntropy u s l`: the mean of `u`, the mean of `s` and the entropy in the thermal state `e^{-s}/Z` on the states with `u_i <= l`, in the sense of `GibbsAccounting.lean`. Paper: `<u>_l`, `<s>` and `S(rho_D)` for the diamond with maximum reading `l`.
- `cutoffMeanSqrtArea u s c l`: the mean of `(s_i/c)^(1/2)` in the same state. Paper: with `c = pi/((1 - eps)^2 G hbar)` it is the mean of `(1 - eps)(A/4 pi)^(1/2)`, the lower bound on the reading in (5.21c).

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `tendsto_integral_div_div_log_div`, `tendsto_integral_div_div_log` | (5.58), second equality | For `a > 0`, if `phi(t) -> kappa` as `t -> infinity` and `phi(t)/t` is integrable on every `[a, l]`: `(int_a^l phi(t) dt/t)/log(l/a) -> kappa`, and the same with `log l` in the denominator | The paper has `phi = <u>/(l' - <u>)` and `kappa = q/(1 - q)`. Stated for any `phi` |
| `integral_pos_of_integral_pos_of_le`, `intervalIntegrable_sub_integral_div_integral_div` | The condition on `l_0` in the sentence before (5.58) | For nondecreasing `Z`, `0 < a <= l` and `int_0^a Z > 0`: `int_0^l Z > 0`, and the integrand of (5.58) is integrable on `[a, l]` | Bookkeeping |
| `log_integral_div_sub_log_integral_div` | (5.57a), integrated from `a` to `l` | For nondecreasing `Z`, with `I(l) = int_0^l Z`, `0 < a <= l` and `I(a) > 0`: `log(I(l)/l) - log(I(a)/a) = int_a^l ((t Z(t) - I(t))/I(t)) dt/t` | Exact. The paper states (5.57a) between eigenvalues and notes that the integral is continuous across them; here the jumps of `Z` are handled by the fundamental theorem of calculus with a countable exceptional set. By (5.56) the bracket is `<u>_t/(t - <u>_t)` |
| `log_eq_integral_add_log_sub_log` | (5.58), first equality | Same hypotheses: `log Z(l)` is that integral plus `log(I(a)/a)` minus `log(I(l)/(l Z(l)))` | Exact, where the paper writes `O(1)`. The first extra term is a constant. The second is `-log(1 - <u>_l/l)` by (5.56); it is bounded when `<u>_l/l` stays away from one, as under (5.57b) with `q < 1`, and in general it is only nonnegative |
| `tendsto_log_div_log_of_tendsto_integral_div`, `tendsto_log_div_log_div_of_tendsto_integral_div` | (5.58) from (5.57b) | For nondecreasing `Z` that is positive somewhere: if `I(l)/(l Z(l)) -> 1 - q` with `q < 1`, then `log Z(l)/log l -> q/(1 - q)`, and the same with `log(l/l_0)` for any `l_0 > 0` | The limit is a hypothesis. The paper's `o(1)` is this limit. The hypotheses force `q >= 0`. In the second form `l_0` is any positive number; the paper's condition `int_0^{l_0} Z > 0` is not needed for the limit |
| `cutoffZ_eq_momentSum`, `cutoffZ_mul_cutoffMeanReading_eq_momentSum`, `cutoffZ_nonneg`, `cutoffZ_pos`, `monotone_cutoffZ` | (5.56), the definition of `Z(l)` | For `t <= l`, `Z(t)` and `Z(t) <u>_t` are the moment sums of order 0 and 1 of the finite spectrum of states with `u_i <= l`; `Z >= 0`; `Z(l) > 0` once some state has `u_i <= l`; and `Z` is nondecreasing | Bookkeeping that ties this file to `ClockMoments.lean` |
| `integral_cutoffZ`, `firstMomentOf_cutoffZ` | (5.56) | For readings `u_i >= 0` and `l >= 0`: `int_0^l Z = Z(l)(l - <u>_l)`, and `l Z(l) - int_0^l Z = Z(l) <u>_l` | None. `ClockMoments.lean` has this for a finite spectrum; here the spectrum may be infinite, with finitely many states below each `l` |
| `cutoffEntropy_eq` | (5.50) | `S = <s>_l + log Z(l)` for the thermal state on the states with `u_i <= l` | None |
| `tendsto_integral_cutoffZ_div` | (5.57b) | For a nonempty spectrum with `u_i >= 0`: if `<u>_l/l -> q`, then `((1/l) int_0^l Z)/Z(l) -> 1 - q` | The paper writes `[1 - q + o(1)] Z(l)`. No condition on `q` is needed for this step |
| `tendsto_log_cutoffZ_div_log` | (5.58) | The same with `q < 1`: `log Z(l)/log l -> q/(1 - q)` | Conditional on the limit `q`, register entry H8. The paper has `log(l(D)/l_0)` in place of `log l`; the two forms are equivalent, see the fifth row |
| `tendsto_sub_div_log_of_tendsto_log_div_log`, `tendsto_log_div_of_tendsto_log_div_log` | The step from (5.58) to (5.62) and (5.65) | For functions `S`, `m`, `Z` of `l` with `S = m + log Z`: if `log Z/log l -> kappa` and `log m/log l -> 2`, then `(S - m)/log m -> kappa/2`; and under the two limits alone, `log Z/m -> 0` | (5.59) enters only as `log m = (2 + o(1)) log l`. No sign condition on `m`: Lean's `log` is the logarithm of the absolute value |
| `tendsto_cutoffEntropy_sub_div_log`, `tendsto_log_cutoffZ_div_log_cutoffMeanArea` | (5.65), (5.62) | For a nonempty spectrum with `u_i >= 0`: if `<u>_l/l -> q < 1` and `log <s>_l/log l -> 2`, then `(S - <s>_l)/log <s>_l -> q/(2(1 - q))`, and `log Z(l)/log <s>_l -> q/(2(1 - q))` | Conditional on two limits: H8 and (5.59). The first is the paper's `S = <s> + (q/(2(1 - q))) log <s> + o(log <s>)`. The second gives (5.62), which the paper states as `log Z/<s> = O(log <s>/<s>)`; by (5.50) the two are one statement. The paper's `q` is a limit as the black hole grows; here it is a limit in the maximum reading of one spectrum, which is how the paper uses it under the integral of (5.58) |
| `tendsto_log_cutoffZ_div_cutoffMeanArea` | Weaker than (5.62) | Under the same hypotheses, `log Z(l)/<s>_l -> 0` | The trace is subleading to the area term |
| `sq_gibbsMean_sqrt_le`, `sq_cutoffMeanSqrtArea_le` | (5.54a) | For `f >= 0`, `<f^(1/2)>^2 <= <f>` in the thermal state of a finite spectrum; hence `c <(s/c)^(1/2)>_l^2 <= <s>_l` for `c > 0` and `s_i >= 0` | None |
| `cutoffMeanSqrtArea_le_cutoffMeanReading`, `cutoffMeanArea_le` | (5.21c) and (5.30a), in mean | If `s_i <= c u_i^2` and `u_i >= 0` for every state: `<(s/c)^(1/2)>_l <= <u>_l` for `c > 0`, and `<s>_l <= c l^2` for `c >= 0` and `l >= 0` | The paper states (5.21c) as an operator inequality, register entry H14. Here it is assumed state by state. The hypothesis `l >= 0` of the second is not needed |
| `tendsto_log_cutoffMeanArea_div_log` | (5.59) | If `0 <= s_i <= c u_i^2` and `u_i >= 0` for every state, `<u>_l/l -> q > 0`, and `(<u>_l - <(s/c)^(1/2)>_l)/l -> 0`, then `log <s>_l/log l -> 2` | The paper obtains (5.59) by holding `l(D)/r_h` fixed. Here the same relation follows from the area bound, `q > 0` and the mean time delay (5.53). The delay is assumed in the form `o(l)`, which the paper's `o(r_h)` implies because `r_h <= l/(1 - eps)`. The condition `q > 0` cannot be dropped: a finite spectrum has `q = 0` and `log <s>_l/log l -> 0` |
| `tendsto_cutoffEntropy_sub_div_log_of_delay` | (5.65) | Under those hypotheses and `q < 1`: `(S - <s>_l)/log <s>_l -> q/(2(1 - q))` | (5.65) conditional on three named inputs: the area bound state by state (H14), the limit `q` with `0 < q < 1` (H8), and the mean time delay (5.53), register entry H20 |

### Closed cuts and H3c (`QuantGrav/Diamond/ClosedCuts.lean`)

`T_P` is the partial trace `sum_i ‖C e_i‖^2` over a cut `P` of orthonormal vectors `e_i`, and `Delta_P` is the response `<Delta_eta O>_P` on the cut, here an abstract real number. The closed amplitude of (5.38) is `Z_P[X] = T_P (Delta_P - delta/2)`. Where a row uses `c`, the operator satisfies `c ‖v‖^2 <= ‖C v‖^2` for every `v`. Changed on 2026-11-26 after the second-reader review: the bound on the response was `delta/4`, a stricter choice than the paper makes; it is now `delta/2 - gamma` with a margin `gamma`, which covers the paper's cuts as the paper builds them.

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `exists_orthonormal_sum_sq_norm_gt` | Not stated; the contrapositive of F2 | If `H` is infinite-dimensional and `c ‖v‖^2 <= ‖C v‖^2` with `c > 0`, the partial traces over finite orthonormal families exceed every bound | Addition |
| `open_gluing_id_and_unbounded_partial_traces` | (4.29), (4.30) against H3a | On an infinite-dimensional Hilbert space, in every Hilbert basis the identity satisfies the resolution of the identity (4.29) and the absolute bound (4.30), and its partial traces are unbounded | Addition. The open-gluing statements cannot imply H3a. The bound of (4.30) as printed needs operators of norm at most one, which the identity is; (4.29) and absolute convergence hold for every bounded operator. That the series of norms is summable is `summable_norm_inner_cut` |
| `mul_card_le_sum_sq_norm` | The sentence before (D.24) | The partial trace over `n` orthonormal vectors is at least `c n` | None. The paper has `Tr(P C_b† C_b) >= (k + N) e^{-s_*} m_{b,D}` |
| `cut_amplitude_le_neg_rank` | (5.38) with that counting step | For a cut of `n` orthonormal vectors, a margin `gamma >= 0` and a response `Delta <= delta/2 - gamma`: `T_P (Delta - delta/2) <= -(c gamma) n` | For `gamma = 0` this is the paper's `Z_P[X] <= 0`, from `\|<Delta_eta O>_P\| <= delta/2` in (5.37b). The paper's cuts have a margin `gamma > 0` that it does not name: the sentence after (D.25) makes the bound of (5.32) less than `\|delta_eta\|/2`, the same for every finite union of cycles |
| `tendsto_cut_amplitude_atBot`, `not_tendsto_cut_amplitude_nhds` | Not stated | For `c > 0` and a fixed margin `gamma > 0`: along any family of cuts with `Delta_P <= delta/2 - gamma` whose ranks tend to infinity, `T_P (Delta_P - delta/2)` tends to minus infinity, so it has no finite limit | Addition. The margin is needed: with `Delta_P = delta/2` the closed amplitude can stay at zero in infinite dimension, as the cuts `(3n, n)` of `OrderOfExhaustion.lean` show |
| `sum_sq_norm_le_div_of_neg_le_cut_amplitude` | Not stated | For `gamma > 0`, on a cut with `Delta <= delta/2 - gamma` and `T_P (Delta - delta/2) >= -B`: `T_P <= B/gamma` | Addition. On cuts with a margin, a lower bound on the closed amplitude is an upper bound on the partial trace. So H3c is H3a restricted to those cuts. No orthonormality and no lower bound on `C` is used |
| `finiteDimensional_of_cut_amplitude_bddBelow` | Not stated | For `c > 0` and a fixed margin `gamma > 0`: if infinite dimension would give cuts of arbitrarily large rank, with response at most `delta/2 - gamma`, on which `T_P (Delta_P - delta/2) >= -B`, then `H` is finite-dimensional | Addition. Hypothesis H3c in abstract form. That infinite dimension gives large cuts with a margin is the paper's (D.24), (D.25) with (5.32); here it is part of the hypothesis, not proved. `Delta` is a real number with an upper bound; nothing ties it to the cut |


### Order of exhaustion: a model (`QuantGrav/Diamond/OrderOfExhaustion.lean`)

A model, not the paper's theory. `b` is a Hilbert basis of `H` with labels `(k, a)`, where `k` is a natural number and `a` takes two values: two countable orthonormal families. A cut `P` is a finite set of labels.

Definitions.

- `closedAmplitude b C A B P = sum_{i,j in P} <C b_i, A C b_j> conj<b_i, B b_j>`. Paper: the numerator of (5.31) for a product observable `A ⊗ B̄`, with `A` on the copy prepared by `C` and `B̄` on its time reflection. Encoding choice: the time-reflected copy carries the complex-conjugate matrix elements in the basis `b`. The paper introduces `|i*>` at (5.31) as the time reflection of `|i>` across `S` and gives no formula for it; no antiunitary map is named anywhere in the TeX. If the reflection is an antiunitary `J` with `|i*> = J|i>`, then `<i*| J B J^{-1} |j*> = conj<i|B|j>`, and every bounded operator on the reflected copy is `J B J^{-1}` for some `B`, so under that reading the definition covers every product observable (checked by hand, not formal). With `A = B = 1` the definition gives the denominator of (5.31) (`closedAmplitude_one`). In the model every matrix element of `B` is 0 or 1, so the choice does not affect it.
- `IsIncreasingExhaustion P`, for a sequence of cuts: `P m` is contained in `P n` when `m <= n`, and every label lies in some `P n`. Paper: the cuts of Sec 5.2 are finite unions of cycles of basis labels, and the paragraph before (5.37) says `P -> 1` strongly as the cycles are included. Sequences only, so a countable basis.
- `twoFamilyCut r n`: the first `r` labels of the first family and the first `n` of the second.
- `basisFlip b`: the unitary `F` that sends each basis vector to its partner in the other family (`basisFlip_apply`).
- `flipCutAmplitude b w delta r n = delta Re closedAmplitude b C F F P - (delta/2) sum_{i in P} ‖C b_i‖^2`, with `C = sqrt(w) 1` and `P = twoFamilyCut r n`. Paper: `Z_P[X]` of (5.38), with `delta F ⊗ F̄` standing in for `Delta_eta O` and `delta` for `delta_eta`, so that `X = delta F ⊗ F̄ - delta/2` has the shape of (5.37a).
- `flipCutResponse b w delta r n = delta Re closedAmplitude b C F F P / sum_{i in P} ‖C b_i‖^2`. Paper: `<Delta_eta O>_P` of (5.31) and (5.37b).

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `closedAmplitude_one` | (5.31), denominator | `closedAmplitude b C 1 1 P = sum_{i in P} ‖C b_i‖^2`, for any Hilbert basis, bounded `C` and cut `P` | A check on the definition |
| `IsIncreasingExhaustion.tendsto_sum_inner_smul` | `P -> 1` strongly, paragraph before (5.37) | Along an increasing exhaustion, `sum_{i in P_n} <b_i, x> b_i -> x` for every `x` | Any Hilbert basis; sequences of cuts only |
| `IsIncreasingExhaustion.tendsto_open_cut_sum` | (4.29) | Along an increasing exhaustion, `sum_{i in P_n} <phi, U_2 b_i><b_i, U_1 psi> -> <phi, U_2 U_1 psi>` for bounded `U_1`, `U_2` | `hasSum_inner_cut` restated along sequences of cuts. The limit is the same for every increasing exhaustion |
| `closedAmplitude_basisFlip` | Not in the paper | With `C = sqrt(w) 1` and `w >= 0`: `closedAmplitude b C F F P` is `w` times the number of labels of `P` whose partner is in `P` | Model |
| `flipCutAmplitude_eq` | (5.38) in the model | For `w >= 0` and `n <= r`: `flipCutAmplitude b w delta r n = (w delta/2)(3n - r)` | Model |
| `flipCutResponse_eq`, `flipCutAmplitude_eq_trace_mul` | (5.31), (5.38) in the model | For `w > 0`, `n <= r`, `r > 0`: the response is `2 n delta/(r + n)`, and `flipCutAmplitude` is the partial trace times the response minus `delta/2` | Model. `flipCutAmplitude` has the form `T_P (Delta_P - delta/2)` of (5.38), with `T_P = w (r + n)` |
| `abs_flipCutResponse_le_iff` | (5.37b), left inequality | For `w, delta > 0`, `n <= r`, `r > 0`: `\|response\| <= delta/2` exactly when `3n <= r` | Model |
| `flipCutAmplitude_five_limits` | Last sentence of the paragraph before (5.37), and the caption of Figure 30: the partial sums must reproduce the uncut amplitude | For `w, delta > 0`, with cut sizes `(r, n)`: along `(n, n)` the amplitude tends to plus infinity; on `(3n+1, n+1)` it is `w delta` for every `n`; on `(3n, n)` it is `0`; on `(3n+2, n)` it is `-w delta`; along `(7n, n)` it tends to minus infinity | Model. See below |
| `isIncreasingExhaustion_five_routes` | Paragraph before (5.37) | Each of those five sequences of cuts is an increasing exhaustion | Model |
| `IsIncreasingExhaustion.tendsto_atTop`, `mem_twoFamilyCut`, `twoFamilyCut_subset`, `isIncreasingExhaustion_twoFamilyCut`, `sum_twoFamilyCut`, `card_twoFamilyCut`, `filter_partner_mem_twoFamilyCut`, `card_filter_partner_mem_twoFamilyCut`, `inner_basisFlip`, `sum_sq_norm_sqrt_smul_one` | Not in the paper | Membership, monotonicity, sums and cardinalities for the cuts of the model, the matrix elements of the flip, and the partial trace of `sqrt(w) 1` | Helpers for the rows above. The two cardinalities give the formula `(w delta/2)(3n - r)`, and the last gives the infinite trace of `C† C` |

What the model shows. All five sequences are increasing exhaustions of one basis. Along each of them the cut projections converge strongly to the identity, and every open sum of (4.29) converges to the same uncut matrix element. The closed amplitudes of one fixed bounded insertion on one fixed bounded preparation still behave in five different ways. By `abs_flipCutResponse_le_iff` the nonempty cuts of the last three sequences satisfy the paper's condition on a cut, the left inequality of (5.37b). There the amplitude is nonpositive, as (5.38) says, and the three limits are `0`, `-w delta` and minus infinity. (5.37b) as displayed is not strict, and only the last of the three keeps a fixed margin below `delta/2`: the responses are `delta/2` exactly, `2n delta/(4n + 2)`, and `delta/4`. With a uniform margin, which the paper's cuts have by the sentence after (D.25), `tendsto_cut_amplitude_atBot` gives minus infinity in every order. So the dependence on the order is among cuts with no uniform margin. If the first family is read as the states inside the paper's narrow area interval and the second as the states outside it, the cuts `(3n, n)` and `(7n, n)` are unions of `n` cycles of lengths 4 and 8 in the sense of the paragraph at line 1800, two before (5.37); length 4 is the boundary case. That reading is prose and not part of any formal statement.

What it does not show. The model has no dynamics, no constraints and no area operator, and the insertion is put in by hand. `C† C = w` has infinite trace, so there is no uncut amplitude for the partial sums to converge to. The space is infinite-dimensional, which the paper argues `H_D` is not. So the model does not locate an error in the paper. It shows that H3b does not follow from (4.29) and (4.30), from `P -> 1` strongly, or from the left inequality of (5.37b). The paper cites Sec 3.6 for H3b, and Sec 3.6 contains no such argument (F12).

Source. The model is a simplification of one described in an external audit (`notes/external-audits-2026-11-26.md`, section 1.2 A). There the same closed amplitudes arise from a boost acting on two families of different area. Their Lean was not read. The definitions, statements and proofs here are ours. The formula `(w delta/2)(3n - r)` was derived by hand before it was stated; it agrees with theirs, and the five routes are theirs with the second one reindexed.


## Findings from the direct reading

Each is this log's reading of the PDF text. None has been checked with the author.

**F1. H1 is a statement about the form domain of the clock.** (C.14) says that as `L` grows, `Psi_L` tends to `P_M psi`, where `M` is the closure of the domain of the clock's quadratic form, and that `1 - <psi|Psi_L>` tends to `‖(1 - P_M) psi‖^2`. So `‖Psi_L - Omega_A‖ -> 0` holds exactly when `Omega_A` lies in `M`. The estimates (5.8) to (5.16) are evidence for that membership. The paper calls the outcome strong evidence, and footnote 18 says the last step is a heuristic for noncommuting operators. The paragraph after (C.17) derives density of the clock's domain from the same estimate, so footnote 14's claim that the clock is densely defined is not independent of H1. Registered as H13. Re-checked against the TeX (lines 3035 to 3046 and 3131): the text is as described, no change.

**F2. Given (5.30c), finite dimension is equivalent to bounded partial traces.** This replaces the earlier, tentative F2. Proved in `QuantGrav/Diamond/FiniteDim.lean`; what follows is the reading of the paper that connects it.

- (5.30c) states `e^{-s_*} m_{b,D} 1 <= C_b† C_b <= 1` on `H_D`. For a finite orthonormal family with projection `P`, `Tr(P C_b† C_b) = sum_i ‖C_b e_i‖^2`. (D.24) uses `Tr(P C_b† C_b) >= rank(P) e^{-s_*} m_{b,D}`, which is the first step of the proof here.
- Split H3 accordingly. H3a: the partial traces `Tr(P C_b† C_b)` are bounded, which is what closing the cut with no insertion gives if the uncut amplitude is a finite number. H3b: the partial sums `Z_P[X]` with the insertion `X` of (5.37a) converge to `Z[X]`.
- Consequence, machine-checked up to the mapping: given (5.30c), `dim H_D < infinity` holds exactly when H3a holds, and then `dim H_D <= Z e^{s_*} / m_{b,D}`. The boost argument, (5.32), the cycle construction of (D.24), (D.25), H3b and H4 are not needed for that implication.
- What the paper's own argument uses: H3b and H4, with (5.30c) and (5.32). It does not state H3a. It does use the quantity H3a is about: the sentence before (5.38) obtains `Z[X]` by multiplying the expectation value of `X` in the uncut preparation by that preparation's squared norm, and the sentence after it requires the partial sums to approach `Z[X]`. Both treat the squared norm, which is the uncut amplitude with no insertion, as a positive real number. Read that way, the paper assumes it finite without saying so. If the cut sum with no insertion is also required to reproduce it, as (4.29) is used for `X`, that is H3a and the conclusion follows at once.
- The paper nowhere says for which insertions closing the cut reproduces the uncut amplitude. Whether it holds for the identity is the open point, and it is question 4 for the author in `handoff.md` Section 13.
- So the finiteness claim is as strong as the argument of Sec 3.6 that a finite uncut amplitude exists and equals the cut sum, plus the inputs of (5.30c): the area bound (5.21d) (H14), the boost weight (5.23) (H6, H15) and unitarity (H2). Sec 3.6 was read on 2026-11-26 and contains no such argument: it is classical (F12).
- For WP4: the target can be stated as `dim H_D < infinity` from H3a and (5.30c). H3b with H4 is then a second, independent route, to be formalized only if H3a is rejected. A third route, weaker than H3b, is H3c (F10).
- Three audits made independently on 2026-11-26 reach this reading of Sec 5.2: this repository, and two external ones collected in `notes/external-audits-2026-11-26.md`. The external ones were not verified here. The separate review session that read `main.tex` lines 1728 to 1830 agrees with the reading.

**F3. Footnote 23 relates `q` to `l(D)/r_h`, and with (5.68) it fixes that ratio. This is not a tension.** Corrected on 2026-11-26 by break attempt B3 of `handoff.md` Section 14, outcome 3. The earlier version read footnote 23 and (5.68) as two evaluations of `q` that agree only for one value of a ratio the paper leaves free. The ratio is not free. Proved in `QuantGrav/Entropy/ClockMoments.lean`; the reading was proposed by the review session and confirmed here against the TeX.

- `r_h` is defined from the state: `4 pi r_h^2 = <A>` in (5.53), repeated in footnote 23 as `r_h^2 = <A>_l/(4 pi)`. Once the representation is fixed, the state `rho_D` of (5.39a) depends on the maximum reading `l` alone. So `x = (1 - eps) r_h/l` is determined by `l`. It is an output of the theory, as `q` is.
- Footnote 23 is the relation between these two outputs. By (5.21c), (5.53) and `u <= l`, the normalised second moment of the clock is `x^2` up to the mean time delay: `x^2 <= <(u/l)^2> <= x^2 + 2 <delay>/l` (`sum_sq_reading_bounds`). If `Z(l)` grows as `l^p`, the first and second moments are `p/(p+1)` and `p/(p+2)` times `l` and `l^2` (`firstMomentOf_rpow`, `secondMomentOf_rpow`). With `q = p/(p+1)`, which is `p = q/(1-q)` as in (5.58), this gives `x^2 = q/(2-q)`, the same statement as `q = 2x^2/(1+x^2)` (`powerLaw_moment_ratios`, `sq_eq_div_two_sub_iff`). It holds for every `p > 0`.
- The footnote's own route checks out. The identity for one reading and its sum over a finite spectrum are exact (`reading_eq_sq_div_add_integral`, `momentSum_one_eq_div_add_integral`), and so are (5.56) and (5.57a) (`firstMomentOf_momentSum`, `hasDerivAt_log_integral_momentSum_div`).
- The bounds (5.54b) and (5.54c), `x^2 <= q <= x`, and `x < 1`, hold for every `0 < q < 1` once `x^2 = q/(2-q)` (`sq_le_and_le_of_sq_eq_div`). So (5.54), (5.55), (5.58) and (5.61) are consistent with each other for every such `q`.
- Consequences of `q = 257/302` that the paper does not state. `p = 257/45` and `x^2 = 257/347` (`moment_ratios_of_q`, `ratio_sq_of_q`), so `l(D)/r_h` tends to `(1 - eps) sqrt(347/257)`, about `1.162 (1 - eps)`. By (5.63) in footnote 24 the area in `rho_D` is spread over `[0, s_*]` as a power law: density exponent `q/(2(1-q)) - 1 = 167/90`, mean `<s>/s_* = 257/347`, relative standard deviation about `0.27`. The density of states is then `e^s s^(167/90)` per unit area and `e^s s^(106/45)` per unit mass, and the second is (5.69). Apart from the three numbers in `moment_ratios_of_q`, this bullet is arithmetic by hand, checked numerically.
- What remains is a question of wording. The paper says "we must specify how the maximum clock reading scales with horizon area" and works "at fixed `l(D)/r_h`": the paragraph before (5.54), and the sentence before (5.59). If a free choice of the ratio is meant, it conflicts with the relation above, which leaves none. If it means that the ratio tends to a constant, there is no conflict. Question 4 of `notes/note-to-author-draft.md` asks which.
- Not formalized: that `Z` grows as a power of `l`, which is (5.58) and rests on H8, and the step from exact power laws to asymptotic ones. For a nondecreasing `Z`, Karamata's theorem and its converse say that (5.57b) makes `Z` regularly varying with index `q/(1-q)`, and then the second-moment ratio tends to `q/(2-q)` with no further assumption. That is quoted from the standard theorem, not checked against a source and not formal.

**F4. Handoff soft spots confirmed.**
- (5.39c) is `Z Tr(rho e^{A/4G hbar}) = Tr(1)`. It is an identity, not an independent count.
- (5.20) says the closure of `{P_D pi(X) psi}` is `P_D H_omega = H_D`. It is a density statement, not a dimension formula. The closure bar is in the TeX (line 1616) and was lost in the PDF text, so the earlier wording "spanning statement" was too strong. It sits in Sec 5.1, not 5.2.
- No area eigenvalues or spacings are given. (5.40) only names them `A_1, ..., A_m`. What the entropy requires of them is in F13.
- (5.32) is proved in (D.22), (D.23) by `|e^{ix} - 1| <= |x|`. That step is elementary and could be a WP2 theorem. The physics input H4 is (5.36b) and (5.37b), supported by (D.26) to (D.36) at one loop on a smooth background. Done as WP2-g in `BoostBound.lean`.
- The pigeonhole step is in the paragraph after (D.24): finitely many intervals cover `[0, s_*]`, so one has a spectral subspace of full dimension. It is stated for any cardinality.
- The entropy formula is (5.50); the handoff's map started Sec 5.3 at (5.51).
- Re-checked against the TeX on 2026-11-26: (5.39c), (5.40), (5.50), (D.22), (D.23) and the pigeonhole paragraph are as described. Only the (5.20) item changed.

**F5. WP1-a, WP1-b checked against (4.32) to (4.34).** The variance `1/(2sk)`, the pair phase `e^{-2ik/s}`, the closed form `Li_2(e^{-2i/s}) / (2 s^2)`, the divergent first-order term `-(i/s^3) sum 1/k`, and the claimed finite term `-i log s / s^3` are as the handoff states. The paper states the finite term without the subleading pieces. The real part of the closed form is now exact as well (`re_pair_amplitude`).

**F6. The clock and the area operator on `H_omega` are assumed, not constructed.** Read from the TeX of Sec 4.2, Sec 4.3, Sec 5.1 and App C; an independent reader tried to refute it and could not.

- The clock is defined on the fixed-area space `K_A` by the form (4.27), and the sentence after (4.26) says each factor acts within `K_A`. (C.11) to (C.13) work on `K_A`. Then (5.2) applies its spectral projection on `H_omega`, with `H_D = P_D H_omega` (5.1). `H_omega` is larger than `K_A`: it is the closed span of the images of `K_A` under insertions that can change the area. The paper does not say how the clock acts there, and does not decompose `H_omega` into fixed-area spaces.
- That the clock commutes with the area operator is asserted after (5.2), before (5.20) and before (5.21), with no argument, and again in Sec 5.3 with a reference to (5.21), which does not prove it. On `K_A` it is automatic, because the area is the number `A` there.
- The area operator enters as the generator of the corner boost acting on prepared states, (4.12) to (4.15), before `H_omega` is built, and the spectral theorem is applied to it. That the boost is implemented on `H_omega` by a self-adjoint generator, for a pure extension `omega` chosen by an existence argument, is presupposed. Footnote 20 leaves the dependence on `omega` open.
- So the paper's construction determines `P_D(A) K_A`, the part of `H_D` inside `K_A`, and no more. Sec 5.2 is about all of `H_D`, including several area eigenvalues. Registered as H16 and H17; in Lean they are fields of `DiamondSetup`.

**F7. In the spectral encoding H1 is (5.19).** By the sentence after (C.14), `‖Psi_L - Omega_A‖ -> 0` holds exactly when `Omega_A` lies in `M`. `P_D` increases strongly to the projection onto `M` as `l(D)` grows, so `Omega_A in M` is the same as (5.19). `H1_iff_tendsto_norm_sq` proves that equivalence for the formal H1.

- The route (5.4) to (5.18) through `Psi_L`, the weight bound (5.17) and the Markov step is therefore not needed to pass from H1 to (5.19). WP1-c and WP1-g formalize steps of that route; they remain correct and are not used.
- The step from (5.19) to the state `psi` of (5.20) uses only that `P_D Omega_A` is nonzero for some finite `l(D)` (`H1.exists_diamondProj_ne_zero`). That is weaker than H1: it says `Omega_A` is not orthogonal to `M`.
- H13 implies H1 (`H13.h1`). The paper argues in the other direction, from the H1 estimate for displaced states to H13.

**F8. H1, H13 and H14 are consistent, are not implied by the setup, and do not bound `dim H_D`.** Machine-checked on the model `ofProjections`.

- `exists_setup_H1_H13_H14_diamondSpace_eq_top`: the three hold together in a setup where `H_D` is the whole Hilbert space, of any dimension. So they cannot yield finite dimension. That has to come from the inputs of Sec 5.2; see F2.
- `exists_setup_not_H1`: the fields of `DiamondSetup` do not imply H1. A clock that is defined nowhere satisfies every field.
- `exists_setup_H1_H13_not_H14`: nor do the fields with H1 and H13 imply H14. A clock that reads `0` at area `1` satisfies H1 and H13.
- The models are not models of the paper's theory. They show what the formal hypotheses do and do not say.


**F9. (5.69) is Sen's mixed-ensemble coefficient, which in four dimensions is the local coefficient alone.** This answers the third WP5 question in `handoff.md`. Sen's paper was read directly; see "How the paper was read".

- Sen gives the coefficient of `ln a` in three ensembles, each counting states per unit interval of mass. For pure gravity in `D = 4`: microcanonical, with the angular momentum component `J_3` fixed, (1.1): `212/45 - 1`. Mixed, with all angular momenta summed, (1.4): `212/45`. Singlet, rotationally invariant states only, (1.5): `212/45 - 3`. Here `212/45 = 424/90` is his local coefficient `C_local` (1.2), the graviton contribution to the trace anomaly.
- The paper's (5.69) is `106/45` of `log s_b` at fixed mass with angular momenta summed, where `s_b` is proportional to `M^2`, so `log s_b = 2 ln a` up to a constant. That is Sen's mixed ensemble, in the number and in the description: his `e^{S_mixed} dM` counts the states of all angular momentum in a mass interval (`fixed_mass_coeff_eq_sen_mixed`).
- It is not his microcanonical or his singlet coefficient. It exceeds them by `1/2` and `3/2` in units of `log s_b`. The singlet value, `(212/45 - 3) ln a`, is the only number Sen's summary states for the four-dimensional Schwarzschild black hole, and the one he compares with loop quantum gravity. The paper names the ensemble where it states the result (the opening of Sec 5.3, and before (5.69)). Its abstract and introduction say only "the coefficient Sen obtained" and "at fixed mass".
- In `D = 4` without gauge fields Sen's mixed coefficient is `C_local` with nothing added, for any value of `C_local` (`Sen.mixedCoeff_four`): the integration that fixes the mass contributes `a^{-(D-4)/2} = 1`, and the zero-mode terms cancel between his (2.41) and (3.3). The paper's (5.67c) imports the same local coefficient; its prefactor evaluates to `212/45` (`trace_log_prefactor_eq`). With `log_coefficient_roundtrip`, the agreement with Sen is therefore the agreement of that imported number, together with the absence of any further logarithm between (5.67c) and the density of states per unit mass.
- The change of variables from area to mass is the same in both papers. Sen's Sec 4 adds `ln a` on passing from states per unit area to states per unit mass; the paper's `ds_b / s_b^{1/2} ~ dM` in (5.69) does the same.
- What is independent on the paper's side is H7 alone: that the Lorentzian trace `Tr(C_b† C_b)` carries the logarithmic term of the Euclidean one-loop determinant. Sen's corresponding statement, (2.41), is about the Euclidean grand canonical partition function.
- The coefficient in the paper's entropy formula (5.65), `q/(2(1-q)) = 257/90`, is `C_local + 1` in units of `ln a` (`entropy_coeff_eq_sen_local_add_one`). It belongs to the state `rho_D` at fixed maximum clock reading and is none of Sen's three.


**F10. Open gluing does not control closed cuts, and boundedness below would be enough (H3c).** Proved in `QuantGrav/Diamond/ClosedCuts.lean` and `QuantGrav/Diamond/OrderOfExhaustion.lean`. That boundedness below suffices was observed in an external audit (`notes/external-audits-2026-11-26.md`, section 1.2 B); the order-of-exhaustion model is simplified from the same audit (section 1.2 A); the statements and proofs here are ours.

- (4.29) and the absolute convergence in (4.30) hold for every bounded operator on any Hilbert space; the bound of (4.30) as printed holds for operators of norm at most one, the identity included. The identity on an infinite-dimensional space has unbounded partial traces. So nothing in Sec 4.4 can give H3a (`open_gluing_id_and_unbounded_partial_traces`).
- On a cut whose response stays a margin `gamma >= 0` below `delta/2`, the closed amplitude of (5.38) is at most `-(c gamma) rank P` (`cut_amplitude_le_neg_rank`). The paper's cuts have such a margin with `gamma > 0`: the sentence after (D.25) makes the bound of (5.32) less than `|delta_eta|/2`, the same for every finite union of cycles. So if `H_D` were infinite-dimensional, the paper's own cuts would drive `Z_P[X]` to minus infinity (`tendsto_cut_amplitude_atBot`): the closed sums would have no finite limit at all. Until 2026-11-26 this was proved here only for responses at most `delta/4`, which is stricter than what the paper states; the second-reader review found that, and the theorems now take the margin as a parameter.
- Hence a lower bound on `Z_P[X]` along those cuts already gives finite dimension (`finiteDimensional_of_cut_amplitude_bddBelow`). Register entry H3c. It is weaker than H3b, which asks for convergence to `Z[X]`, and it does not use H4, the positivity of `Z[X]`. It is not weaker than H3a: on cuts with a margin, a lower bound `-B` on `Z_P[X]` bounds the partial trace by `B/gamma` (`sum_sq_norm_le_div_of_neg_le_cut_amplitude`), so H3c is H3a restricted to those cuts.
- The three routes, given (5.30c): H3a is equivalent to finite dimension (F2); H3b with H4 implies it, which is the paper's route; H3c implies it. Each is a statement about closing the cut, and none is derived in the paper from its constructions.
- Closed partial sums depend on the order of exhaustion. In a model with two countable orthonormal families, the flip `F` between them, the preparation `C = sqrt(w) 1` and the insertion `delta F ⊗ F̄ - delta/2`, the closed amplitude on the cut with the first `r` labels of one family and the first `n <= r` of the other is `(w delta/2)(3n - r)` (`flipCutAmplitude_eq`). Five increasing exhaustions of the same basis give plus infinity, `w delta`, `0`, `-w delta` and minus infinity (`flipCutAmplitude_five_limits`, `isIncreasingExhaustion_five_routes`). Along every increasing exhaustion the cut projections converge strongly to the identity and the open sums of (4.29) converge to the same limit (`IsIncreasingExhaustion.tendsto_sum_inner_smul`, `IsIncreasingExhaustion.tendsto_open_cut_sum`). Three of the five satisfy the left inequality of (5.37b) on every nonempty cut (`abs_flipCutResponse_le_iff`); their limits are `0`, `-w delta` and minus infinity. Of those three only `(7n, n)` keeps a fixed margin below `delta/2`, with response `delta/4`; `(3n, n)` has response exactly `delta/2` and `(3n + 2, n)` has responses tending to it. With a uniform margin, as the paper's cuts have, the limit is minus infinity in every order (second bullet), so the dependence on the order is among cuts with no uniform margin. Either way there is no convergence to a finite `Z[X]`. So H3b does not follow from open gluing, from `P -> 1` strongly, or from (5.37b). The model does not realise the paper's dynamics, and in it there is no finite uncut amplitude, so it does not say which step fails in the paper's setting.
- For two or more cuts, the sum of absolute values over all intermediate labels jointly can diverge even for unitary evolutions and normalizable states. Example: a unitary that is block diagonal with normalized Hadamard blocks of size `2^k`, and two states whose components are uniform in block `k` with squared norm `2^{-k/2}/k` there; the absolute sum over block `k` is `1/k`. The observation is from the external audit; this example is ours and is not formalized. So WP2-c is a statement about one cut, and the valid statement for several cuts is the sequential truncation of WP2-d.
- App E does not support Sec 5.2 independently. E.3 verifies the finiteness condition of E.1 for the causal diamond by citing (5.39c), in (E.17). In the other direction, that condition with the identity filter and the ordinary trace of (E.15a) would give finite dimension at once. Read in the TeX; the point was raised in the external audit.


**F11. The paper controls the focusing behind (5.19) only at fixed resolution, and never uniformly in it. In a model with the scalings of the paper's pair example, an estimate of the same kind gives the opposite answer once all radial modes are included.** Break attempt B1 of `handoff.md` Section 14: outcome 2 for the passage from fixed resolution to (5.19); outcome 4, undecided, for (5.19) itself. This is a countermodel to an inference. It is not a counterexample to the theory and not a disproof. The Lean is listed in the entry "Break attempt B1". The reading was made by the code session and checked by an independent reader; see "How the paper was read".

- What the paper states.
  - The Gaussian state (4.7) is a product over countably many canonical pairs, with free widths. Sec 5.1 fixes its centre and holds `(Delta q_j)^2/hbar` fixed, without giving the widths. Only the pair example gives them: `(Delta q_k)^2 = 1/(2 s k)` for the radial modes of one harmonic of one polarization, (4.32).
  - The focusing operator (4.22) is an unsubtracted sum of squares of Weyl-quantised fields. Its positivity is what the area bound (5.21) uses, and also (C.11) and (5.15).
  - (5.19) is stated for the full state and the full clock. The paper says it argues for it, that the estimates give strong evidence, and in footnote 18 that one step is a heuristic. (5.20) then uses it without qualification.
  - Every step that controls the radiative focusing is restricted: "at fixed angular and radial resolution" before (5.8) (line 1500); the Wigner function (C.15a) "for the finite set" of canonical pairs (line 3048), with the almost-everywhere smoothness stated for that density (line 3058); "at fixed resolution" at lines 3067 and 3116. The resolution is not defined, and is not said to be the finite set of (C.15a). It is never removed. The only uniformity claimed is in the cap `Xi_*` (line 3124).
  - The paper says elsewhere that its sums include gravitons of arbitrarily short wavelength (lines 1254, 1386, 1438).
- The model. Take independent centred Gaussian modes with the variances of (4.32) and a positive quadratic form with weights growing like `k^2`, the growth read off from (D.41). Its mean over the first `N` modes is at least `c N (N+1)/(4 s)` (`le_sum_mul_radialVariance`), the probability that it is at most `x` is at most `e (1 + c N (N+1)/(2 s x))^(-1/2)` (`measureReal_focusing_le_le`), and with all modes it is infinite almost surely (`ae_tendsto_focusing_atTop`). The same holds with weights only bounded below, by the harmonic series.
- The two limits. For a reading that is a nondecreasing unbounded function `g` of that form: at a fixed number of modes the mean of `g/(L + g)` tends to `0` as `L` grows, which is the model's analogue of (C.15b) (`tendsto_integral_div_add_fixed_modes`); at fixed `L` it tends to `1` as the number of modes grows (`tendsto_integral_div_add_all_modes`). So an estimate at each fixed number of modes does not give the estimate with all modes unless it is uniform in that number, and the paper claims no such uniformity.
- The conditional statement on the Hilbert space. If in `Omega_A` the modes are Gaussian in this sense with divergent mean focusing, and a clock reading of at most `l` bounds the model focusing, then `P_D Omega_A = 0` (`diamondProj_Ω_eq_zero_of_gaussian_modes`). If that holds for every `l`, H1 fails (`not_H1_of_forall_diamondProj_Ω_eq_zero`). In the paper's own terms, by the sentence after (C.14), `Omega_A` would be orthogonal to the form domain of the clock.
- Three links are not established, and the paper's text does not settle them. They are the missing input for (5.19) itself.
  1. That `Omega_A` of Sec 5.1 has the variances of (4.32). By hand, not formal: if the profile of a mode along a generator depends on both members of its canonical pair, the uncertainty relation gives a mean cost of order `k/s` per mode for any widths, so no choice of widths would remove the divergence.
  2. That the focusing in the clock, with all modes included and no subtraction, has weights growing like `k^2` in such coordinates. The paper treats the cost in two ways. (4.22) and (5.21) use the unsubtracted positive expression. App D.3 counts the cost of a state by occupation numbers, in the sentence before (D.45), and under that count a Gaussian state costs nothing. The pair example subtracts the Gaussian expectation value of its quadratic insertion, in the sentence before (4.32). The paper does not reconcile these.
  3. That a bounded clock reading bounds the model focusing. By (3.27) the reading at a generator is at least `rho_S(y) (1 - v_0) e^{Xi_y(v_0)}` for an interior `v_0`, since `Xi_y` is nondecreasing; the total focusing `Xi_y(1)` bounds it from above, which is (5.8). The paper states no operator inequality of this kind.
- How the model differs from the paper's integrand. The paper integrates over both members of each canonical pair, and the clock depends on both; the model has one Gaussian variable per mode. The paper's focusing is not stated to be diagonal in any mode basis, is quadratic only within the first polarization, and is defined per generator, so that several harmonics give cross terms at a fixed point of `S`. The reading is a functional of the whole profile of the focusing along the generator, weighted by a fluctuating corner area density and averaged over `S`. The model covers the zeroth-order quantity only, not the operator expectation (5.7) with its corrections.
- By hand, not formal: the bound of G3 holds for any positive semidefinite quadratic form of centred Gaussian variables, with the mean of the form in place of `sum a_k v_k`. The matrix inequality `one_add_trace_le_det_one_add` is the step that would be needed. So the restriction to a diagonal form in one variable per mode could be dropped.
- An external audit reports the same divergence for the uncentred quadratic source of (4.33) (`notes/external-audits-2026-11-26.md`, section 1.2 G item 2).
- Register: candidate entry H19, a fixed resolution. Question 7 of `notes/note-to-author-draft.md` asks the author.


**F12. Sec 3.6 is classical. That closing a cut reproduces the uncut amplitude is asserted by appeal to diffeomorphism invariance; the paper derives only the open case.** First item of B4 in `handoff.md` Section 14.2. The question was whether Sec 3.6 argues H3a, or H3c, or neither. It argues neither, and not H3b. Read by the code session and, blind, by an independent reader; they agree.

- What Sec 3.6 contains (lines 870 to 942). Matching of local Lorentz frames and fields on the overlap of two causal diamonds, (3.60), with a Schwarzschild example. Matching across the corner `S` up to a relative boost, (3.61), (3.62). The boost charges on the two sides, which are the area per unit solid angle over `8 pi G`, and the relative boost as the variable conjugate to their mean, (3.63), (3.64). The variation of the angular embedding, (3.65), and the glued symplectic potential, (3.66). Cancellation of the internal boundary terms, and additivity of the action, `I_M = I_{M_i} + I_{M_j}`.
- What it does not contain. No amplitude, state, Hilbert space, trace or sum over intermediate states, and no finiteness, boundedness or convergence statement. The word diffeomorphism does not occur in it. The nearest statements are classical. When `S` only subdivides a region, its frame is no longer boundary data after gluing (line 924). Once the outward charges cancel, changes of the angular embedding `g_S` of the cut are gauge transformations (line 938). The charge on the union has support only at its outer boundary (line 941). The section glues two adjacent regions and leaves an outer boundary; it never glues a region to itself or to its time reflection.
- How it is cited. The section is cited by label twice. At line 1076, for the relative boost being conjugate to the area element: classical, and supported. At line 1800, for the statement that closing the internal cut with `C_b` and both insertions fixed "must reproduce" the uncut amplitude. The section supplies the classical side of that statement, for two adjacent regions with an outer boundary: the action is additive and the data at the internal cut are gauge. It does not supply the step from there to a sum over a basis of states on a closed cut, and it says nothing about whether that sum converges or to what.
- Where the quantum step is made. The first paragraph of Sec 4 (line 947) asserts that pairing wavefunctions on a shared spacelike cut gives the amplitude of the uncut region. Sec 4.4 then derives the composition law (4.29) between fixed incoming and outgoing states, from causal factorization (4.2e), which is a defining relation of the algebra, and unitarity (4.18); (4.30) and (4.31) give absolute convergence and the truncation error. All of this is the open case. It is WP2-c and WP2-d here.
- The closed case. Sec 5 states it five times. The introduction to Sec 5 (line 1447) gives it as a consequence of (4.29): closing the cut "inserts the identity". The caption of Figure 28 (line 1771) says that diffeomorphism invariance of (4.5) requires the amplitude to be the same wherever the cut is made, "at fixed external states", and then that closing the cut inserts the identity. The last sentence of the paragraph before (5.37) (line 1800) says that by diffeomorphism invariance closing the cut "must reproduce" the uncut amplitude, and points to Sec 3.6. The caption of Figure 30 (line 1830) says the partial sums "must reproduce" it because all the cycles together insert the identity. The sentence after (5.38) (line 1834) says gluing "requires" the partial sums to approach it, by (4.29). (4.5) is a kernel between fixed endpoint configurations, and (4.29) is the open law, derived between fixed external states. No estimate like (4.31) is given for the closed sum.
- Appendix E. Invariance under changes of intermediate cuts, including in a closed configuration, is condition 1 of App E.1. Finiteness of every closed amplitude of the filtered preparations is part of condition 5. Both are requirements, not results. E.3 verifies condition 5 for the causal diamond by citing the result of Sec 5.2, in (E.17) (F10).
- The paper's own example of an infinite closed trace. In the JT prologue, (2.17a) gives every state of an infinite orthonormal family the same weight, and (2.17b) concludes `Tr W >= N e^{-2 pi (K_L + K_R)/hbar}` for every `N`, so `Tr W` is infinite. That is the counting step of F2, `mul_card_le_sum_sq_norm`, used by the paper itself. There the paper takes the Hilbert space of the diamond to be infinite dimensional, so nothing is contradicted. What it shows is that in the paper's framework the gluing rules alone do not make the closed amplitude with no insertion finite.
- What this settles. H3 is a principle the paper assumes for closed configurations, not something it derives. H3a is argued nowhere in the paper, and H3c is stated nowhere. The conclusions of F2 and F10 are unchanged; the open question in F2 about Sec 3.6 is closed.
- What was not read. Sec 3.1 and 3.3 to 3.5, Sec 6, and App A, B and D.1 were not read in full for this item. The independent reader searched the whole TeX for the closing of a cut, for diffeomorphism invariance and for changes of cut, and read every hit. The papers the section cites were not read.


**F13. With the ordinary trace, footnote 24 needs `exp[a s_* + o(s_*)]` orthogonal states below area `a s_*`. The paper does not say whether they come from many area eigenvalues or from large multiplicities, and its only bound on multiplicities, (D.46c), is on graviton states. This is not a contradiction.** Break attempt B2 of `handoff.md` Section 14.2, outcome 3. Read by the code session and, blind, by an independent reader; they agree.

- The trace is the ordinary trace on `H_D`. (5.39b) writes `Tr_{H_D}`. Line 1915 calls `rho_D` a density operator on the finite dimensional Hilbert space, and (5.50) is its von Neumann entropy. The sentence after (5.56) counts states with the same `(s_i, u_i)` separately (line 1995). Footnote 24 speaks of the number of orthogonal states and writes a dimension. Sec 5.4 says the physical trace gives unit weight to each rank one projection (line 2141). (E.15) evaluates closing as `Tr_{H_Sigma}`, and (E.17) bounds a trace on `H_D` by `d_D` times the operator norm. This answers the question B2 put about register entry H12: the positive integer weights of App E.2 are those of the Euclidean theorem of ref [36], in (E.12), and in the paper's own realization in E.3 no sector of `H_D` has a weight other than one.
- So (5.50) and (5.39c) are identities of finite sums, and `S(rho_D) <= log d_D` (`gibbsEntropy_eq_mean_add_log`, `card_eq_gibbsZ_mul_mean_exp`, `gibbsEntropy_le_log_card`). With `m` distinct area eigenvalues of multiplicity at most `D`, `S <= log m + log D` (`gibbsEntropy_le_log_card_levelValues_add_log`). This is the accounting lemma.
- Footnote 24. (5.63) is the cumulative probability, `Pr(s_i <= a s_*) -> a^{q/(2(1-q))}`. (5.64) is the count, `dim(1_{[0, a s_*]}(s) H_D) = exp[a s_* + o(s_*)]`. `handoff.md` 14.2 cites the count as (5.63). The inference to (5.64) from weights `e^{-s_i}`, `log Z = o(s_*)` and bands of positive limiting probability is correct (`tendsto_log_card_levelsBelow_div`; finite forms `card_levelsBelow_le`, `gibbsProb_levelBand_mul_le_card`). (5.63) itself is stated without its steps and is not formalized. One check on it, due to the independent reader: a cumulative probability `a^k` on `[0, 1]` has mean `k/(k+1)`, and for `k = q/(2(1-q))` that is `q/(2-q)`, which is `x^2 = <s>/s_*` by F3. So (5.63) agrees with footnote 23. This is arithmetic and is not formalized.
- App D.3. Line 3516 defines `d(s)` as including only the states whose graviton occupation numbers satisfy `sum n_i nu_i <= Q_*`; lines 3463 and 3542 call it the number of graviton states allowed by focusing at fixed corner area. (D.46c) is `log d(s) <~ 1 + (s Q_*)^{3/4}`. The setting is one loop about a spherical corner in flat spacetime (line 3463), with the data on `Sigma_i` and at `S` held fixed (lines 3487, 3496). From the bound on `Q_*` at line 3533 one gets `s Q_* <~ s_*` for `0 <= s <= s_*` (our arithmetic), so `log d(s)` is `O(s_*^{3/4})` there. D.3 never relates `d(s)` to the eigenspaces `H_{D,A_j}` of (5.40).
- What the accounting forces. The count (5.64) is the sum of the multiplicities of the area eigenvalues below `a s_*`. If every multiplicity is at most `D` with `log D = o(s_*)`, there are `exp[a s_* + o(s_*)]` distinct eigenvalues below `a s_*` (`tendsto_log_card_image_levelsBelow_div`; finite form `gibbsProb_levelBand_mul_le_card_image_mul`), so their mean spacing there is at most `a s_* e^{-a s_* + o(s_*)}`. If instead there are only polynomially many eigenvalues, some multiplicity is `exp[a s_* + o(s_*)]`, far above (D.46c). The paper states neither. It gives no eigenvalue, no spacing and no multiplicity (F4); the number `m` is only said to be at most `d_D`, and it is at least two by (5.41).
- Why (D.46c) does not decide between them. `d(s)` counts graviton states with the corner data fixed. The Fock space at fixed area of Sec 4.2 also contains excitations of the corner variables, a state "can fluctuate ... in the distribution of area over S" (lines 1032, 1034). Sec 5.4 names `d_A = dim H_{Sigma,A}` and a fixed-area entropy `log d_A` (line 2141) without giving its size or relating it to `d(s)`. Line 1445 says only that the covariant entropy bound suggests the corner area limits the number of orthogonal states. So the states could sit at one area and be states that `d(s)` does not count.
- The factor `e^s` of App D.3. Line 3542 puts a factor `e^s` in each one-copy weight `k_a(s)`, from the Euclidean action of a disk normal to `S` (cite key `CarlipTeitelboim1995`), and a factor `e^{-s}` in the cyclic gluing of two copies, because there is then one disk. In an ordinary trace over orthonormal states with weights `w_i`, one copy gives `sum w_i` and two copies glued cyclically give `sum w_i^2`, as (D.47) says. Term by term, (D.48) has those two forms exactly when each label `(s, a)` stands for `e^s ds` orthonormal states of weight `e^{-s} k_a(s)`. The number of states is then `int ds e^s d(s)`, which is the denominator of (D.49), and (D.49) is the bound `sum w^2/(sum w)^2 >= 1/N` (`sq_sum_le_sum_exp_mul_sum_exp_neg_mul_sq`, `inv_card_le_sum_sq_gibbsWeight`). The paper does not state this assignment, does not relate `k_a(s)` to the weights `e^{-s_i}` of (5.56), and does not say how `int ds` in (D.48) relates to the eigenvalues of (5.40). Line 2091 restores "the factor exp(s) at each area" to obtain a density of states, without saying where it was removed.
- Consistency, in Lean. `QuantGrav/Entropy/LogLevelsModel.lean` is the spectrum `log 1, ..., log (N + 1)`, one state per level. Its trace is the harmonic number `H_{N+1}`, so `log Z = o(sigma)` with `sigma = log (N + 1)`; every band `((a - delta) sigma, a sigma]` has probability bounded below for large `N`; exactly `min(N + 1, floor(e^c))` states lie at or below `c`; and (5.64) holds with every multiplicity equal to one. So footnote 24 does not contradict a bound on the multiplicities. The opposite arrangement, levels `1, ..., n` with multiplicity about `e^j` at level `j`, also has `Z` of order `n` and satisfies the footnote. That one is not formalized.
- What this says about the criticism that the entropy is not a count of microstates. As the paper is written, the entropy is a von Neumann entropy for the ordinary trace, so it is at most `log dim H_D`, and footnote 24 asserts the count. What the paper does not do is exhibit the states. The count is inferred from the trace. In the one-loop evaluation the factor `e^s` is the action of a disk. The places where the states would have to be, the area spectrum or the corner excitations at fixed area, are not computed.
- Why outcome 3 and not 1. The rule in `handoff.md` 14.2 asks for three statements in the paper: an ordinary trace, a multiplicity bound per area value, and a spectrum too sparse. The first is stated. The second is stated for graviton states at one loop, not for the eigenspaces of `H_D`. The third is stated nowhere.
- Not read for this item: Sec 5.4 apart from line 2141, Sec 6, and App A, B, C, D.1 and D.2. The cited papers of Carlip and Teitelboim and of Colafranceschi, Dong, Marolf and Wang were not read.


## Hypothesis register

Maintained here and in `QuantGrav/Hypotheses.lean`. Entries are never deleted.

| ID | Statement | Paper location | Paper's support |
|---|---|---|---|
| H1 | `‖Psi_L - Omega_A‖ -> 0` as `L -> infinity`; equivalently `Omega_A` in `M` (F1). Formal: `DiamondSetup.H1`, in the second form | (5.7), (5.16), fn 18, (C.13) to (C.16d) | Called strong evidence; last step heuristic per fn 18. The steps that control the focusing are made at fixed resolution and are not uniform in it (F11, H19) |
| H2 | Amplitude maps `U_M` are unitary | (4.18), not re-read | Assumed |
| H3 | Cut-state sums converge to the uncut amplitude with insertions fixed. Split into H3a and H3b on 2026-11-26 | (4.29), Sec 3.6, used at (5.38) | Asserted by appeal to diffeomorphism invariance. Sec 3.6, which the paper cites for it, is classical: it shows that the action is additive and that the data at an internal cut are gauge, and it says nothing about amplitudes. (4.29) to (4.31) derive the open case, between fixed external states. In App E.1 invariance under changes of cut is condition 1, a requirement (F12) |
| H3a | With no insertion: the partial traces `Tr(P C_b† C_b)` over finite orthonormal families in `H_D` are bounded. Given (5.30c) this is equivalent to `dim H_D < infinity` (F2) | Implicit in the sentences around (5.38); not stated | Not stated by the paper, and not argued in Sec 3.6. Finiteness of closed amplitudes appears only as condition 5 of App E.1, a requirement. In the paper's JT prologue the analogous trace is infinite, (2.17b) (F12) |
| H3b | With the insertion `X` of (5.37a): the partial sums `Z_P[X]` over cycle-closed projections converge to `Z[X]` | (5.38), Figure 30, (4.29) | Stated five times in Sec 5, by appeal to diffeomorphism invariance and to (4.29), with one pointer to Sec 3.6. Neither contains an argument for the closed case (F12). Not a consequence of (4.29), (4.30), of `P -> 1` strongly, or of the left inequality of (5.37b): in a model, five increasing exhaustions of one basis give five different closed limits, three of them on cuts that satisfy that inequality as displayed (F10, `QuantGrav/Diamond/OrderOfExhaustion.lean`) |
| H3c | The closed amplitudes `Z_P[X]` are bounded below along the paper's cuts, whose responses stay a fixed margin below `delta_eta/2`. Weaker than H3b; with it finite dimension follows without H4. On those cuts it is H3a restricted to them (F10) | Not stated in the paper | Not stated, and not argued in Sec 3.6 (F12). Abstract form: hypothesis `hcuts` of `finiteDimensional_of_cut_amplitude_bddBelow`, with the margin as `gamma`; the relation to H3a is `sum_sq_norm_le_div_of_neg_le_cut_amplitude`. Added 2026-11-26 |
| H4 | `<Delta_eta O> > delta_eta / 2` in the uncut preparation | (5.36b), (5.37b), (D.26) to (D.36) | One-loop estimate on a smooth background |
| H5 | Truncation projections converge strongly to the identity | Sentence after (4.31) | Asserted. Explicit hypothesis `hlim` of `tendsto_inner_evolveCut`; proved for orthogonal projections onto increasing sequences of subspaces with dense union in `tendsto_inner_evolveCut_starProjection` (2026-11-26) |
| H6 | Boost generator is `A/(8 pi G)` | (5.22); (3.43) not re-read | Classical corner symplectic structure |
| H7 | `log Tr(C_b† C_b) = (106/45) log s_b + O(1)` | (5.67a) to (5.67c), ref [71] | Imported one-loop coefficient plus Gauss-Bonnet. The prefactor evaluates to `212/45`, Sen's pure-gravity `C_local` (F9) |
| H8 | `q` exists as a limit; its value | (5.54b), (5.61), (5.68), fn 23 | Value derived from H7 (see `log_coefficient_roundtrip`); footnote 23 relates `q` to `l(D)/r_h` and is not a second evaluation of `q` (F3, corrected 2026-11-26). Comparison with Sen: F9. The existence of the limit is the hypothesis `hq` of `tendsto_log_cutoffZ_div_log` and `tendsto_cutoffEntropy_sub_div_log`; (5.58) and (5.65) are proved from it |
| H9 | Choice of pure extension `omega` | (4.16) not re-read, fn 20 | Deferred by author |
| H10 | `log d(s) <~ 1 + (s Q_*)^(3/4)` | (D.45a) to (D.46c) | Unspecified constants. One loop, about a spherical corner in flat spacetime, with the data at `S` held fixed (lines 3463, 3487, 3496). `d(s)` counts graviton states at fixed area (line 3516). The paper does not relate it to the multiplicities of the area eigenvalues of (5.40) (F13) |
| H11 | Disk factor `e^s` in each weight | Paragraph above (D.48), ref [51] | Citation. Read with an ordinary trace, the two formulas of (D.48) say that each graviton state at area `s` stands for `e^s` orthonormal states of weight `e^{-s} k_a(s)`. The paper does not say this, and does not relate `k_a(s)` to the weights `e^{-s_i}` of (5.56) (F13) |
| H12 | Type I with integer weights; Euclidean to Lorentzian converse | App E.2, ref [36]. App E.2 and E.3 read on 2026-11-26; ref [36] not read | Citation. The integer weights are those of the Euclidean theorem, (E.12). In E.3 the paper's own trace is `Tr_{H_Sigma}` with no sector weights, (E.15), so the trace of Sec 5 is the ordinary one (F13). App E cannot support Sec 5.2 independently: E.3 verifies the finiteness condition for the causal diamond by citing (5.39c) (F10) |
| H13 | The clock (4.27) is densely defined on `K_A`. Formal: `DiamondSetup.H13`. Narrowed on 2026-11-26: existence of the clock and commutation with the area moved to H16 | fn 14, the paragraph after (C.17) | Derived on condition that the H1 estimate holds for displaced Gaussian states (F1). Added 2026-11-26. The estimate it rests on is made at fixed resolution (F11, H19) |
| H14 | `u >= (1 - eps)(A/4pi)^(1/2)` as operators, hence `0 <= P_D A P_D <= 4 pi l(D)^2/(1 - eps)^2 P_D`. Formal: `DiamondSetup.H14`, as spectral support | (5.21a) to (5.21d), fn 8 | Cauchy-Schwarz on `S` plus positivity of focusing, at fixed area. On `H_omega` it rests on H16. Added 2026-11-26 |
| H14a | On `K_A` the clock has no readings below `(1 - eps)(A/4pi)^(1/2)`: the fixed-area half of H14. Formal: `DiamondSetup.H14a`; implied by H14 | (5.21a) to (5.21c) at fixed area, fn 8 | Cauchy-Schwarz on `S` plus positivity of focusing. Does not need H16. Added 2026-11-26. The classical inequality behind it is proved (`clock_mean_ge`); the operator statement is not |
| H15 | `C_D† C_D = P_D e^{-A/(4 G hbar)} P_D`: the future half of the diamond is prepared by continuing the corner boost to `i pi`, and gluing to its time reflection leaves only this weight | (5.23a), (5.23b), App C | Asserted from analytic continuation and unitarity. Added 2026-11-26 |
| H16 | The clock has spectral projections on all of `H_omega`, they map `K_A` to itself, and they commute with those of the area operator. In Lean: fields `clock`, `clock_proj_of_neg`, `clock_proj_mem`, `commute` of `DiamondSetup` | (5.2); the sentences after (5.2), before (5.20) and before (5.21) | Asserted. The clock is constructed on `K_A` only, (4.26), (4.27), (C.11), (C.13) (F6). Added 2026-11-26 |
| H17 | The area operator is a self-adjoint operator on `H_omega`, with `K_A` in its eigenspace for the value `A`. In Lean: fields `area`, `area_exhausts`, `area_tendsto_atBot`, `area_proj_of_lt`, `area_proj_area₀` of `DiamondSetup` | (4.12) to (4.15); `A = A 1` before (4.24) | Presupposed: introduced as the boost generator on prepared states before `H_omega` is built (F6). Added 2026-11-26 |
| H18 (candidate) | The quantization of the reduced phase space is taken to be the quantum theory. The outcome may depend on the reduction and on the operator ordering, here Weyl ordering (4.20), and it is not compared with Dirac quantization | Sec 3, Sec 4.1, (4.20); Sec 3 not re-read | Not addressed in the parts read. Raised in an external review (`notes/external-audits-2026-11-26.md`, section 3). Added 2026-11-26 |
| H19 (candidate) | The focusing in the clock is taken at a fixed angular and radial resolution, that is, with finitely many modes | The sentence before (5.8); (C.15a); the sentences before (C.15c) and (C.16d) | Used in the argument for (5.19), not stated as a hypothesis. The resolution is not defined and is never removed. In a model with all radial modes and the scalings of (4.32) and (D.41), the focusing is infinite almost surely (F11). Rests on it: (5.8), (C.15b), (C.16d), and through them the support for H1 and H13. Added 2026-11-26 |
| H20 (candidate) | The mean time delay is small: `<u - (1 - eps)(A/4 pi)^(1/2)> = o(r_h)`. Formal: the hypothesis `hdelay` of `tendsto_log_cutoffMeanArea_div_log`, in the weaker form `o(l)` | (5.53) and the sentence before it (line 1965) | Asserted: the classical contribution to the average time delay vanishes at each horizon area in the expansion about Schwarzschild. Used for (5.59), and through it for (5.62) and (5.65). Added 2026-11-26 |

References the register depends on, from the paper's bibliography:
- [34] Sen, arXiv:1205.0971.
- [36] Colafranceschi, Dong, Marolf, Wang, arXiv:2310.02189.
- [51] Carlip, Teitelboim, arXiv:gr-qc/9312002.
- [71] Bastianelli, Bonezzi, Melis, arXiv:2206.13287.
- [82] Behrndt, Hassi, de Snoo, Wietsma, Proc. Roy. Soc. Edinburgh A 140 (2010) 927. Used for (C.13).

## Open items that affect fidelity

- The licence is MIT (2026-11-26). `linter.style.header` is on again with its licence line set to MIT, so every linter in Mathlib's standard set is now active. The file headers name the git author as copyright holder and author; which proofs were written by subagents is recorded under "How the paper was read", and the commit history records the co-authorship.
- The comparison of (5.69) with Sen's ensembles is made in F9. Reference [71] of the paper (Bastianelli, Bonezzi, Melis), the stated source of the coefficient in (5.67c), has not been read.
- Second-reader review is done for the WP1-a to WP1-e files in `QuantGrav/Elementary/`, for the definitions in `QuantGrav/Diamond/Setup.lean`, for `FiniteDim.lean`, `CutSums.lean`, `BoostBound.lean` and `ClockWeightIntegral.lean`, and, since 2026-11-26, for `ClockLowerBound.lean`, `PairAmplitudeReal.lean`, `QuantGrav/Entropy/SenComparison.lean`, `QuantGrav/Entropy/ClockMoments.lean`, `QuantGrav/Diamond/ClosedCuts.lean`, `QuantGrav/Diamond/OrderOfExhaustion.lean` and the four items added after the second pass over `Setup.lean` and `ClockHypotheses.lean` (`notes/second-reader-review-2026-11-26.md`). It is outstanding for the files added on 2026-11-26 after those: the B1 files in `QuantGrav/Elementary/` and `QuantGrav/Diamond/ClockDivergence.lean`, whose attributions to the paper were reviewed but whose statements were not re-derived by a second reader, and the seven files of B2 and Track A item 4 in `QuantGrav/Entropy/` and `QuantGrav/Elementary/`. One point of that review is left open: `exists_setup_H1_H13_not_H14` could conclude the stronger `not H14a`, which the reviewer checked by hand and not in Lean.
