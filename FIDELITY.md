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
- Findings F1, F2 and F4 were re-checked against the TeX on 2026-11-26; each now says what changed.
- `QuantGrav/Diamond/FiniteDim.lean`, `QuantGrav/OperatorAlgebra/CutSums.lean`, `QuantGrav/OperatorAlgebra/BoostBound.lean` and `QuantGrav/Elementary/ClockWeightIntegral.lean` were reviewed by a separate review session on 2026-11-26: statements re-derived by hand, with Sec 5.2 of the TeX read at `main.tex` lines 1728 to 1830. Recorded in `notes/external-audits-2026-11-26.md`, section 5 item 7.
- The proofs in `ClausenAsymptotics.lean`, `BoostBound.lean` and `PairAmplitudeReal.lean` were written by subagents from fixed statements. The statements were written first and, for the Clausen bound and the real part, checked numerically. The proofs are accepted on the strength of the kernel and the axiom audit, not on a reading of the proofs. The model computations in `OrderOfExhaustion.lean`, from `closedAmplitude_one` to `flipCutAmplitude_five_limits`, were also proved by a subagent from fixed statements; there the formula `(w delta/2)(3n - r)` was derived by hand first, and the proofs were read afterwards. The increasing-exhaustion and response lemmas of that file were written directly.
- For Step 3 (2026-11-26) Sec 4.2, Sec 4.3, the start of Sec 5.1, (5.21) and App C.2 from its start were read directly from the TeX.
- Independent review of the definitions in `QuantGrav/Diamond/Setup.lean` (2026-11-26): a fresh reader with no access to this log, `handoff.md` or `Hypotheses.lean` checked every field against the TeX. It read `main.tex` lines 548 to 610, 955 to 1250, 1440 to 1865, 1920 to 2029 and 2940 to 3180 in full and searched the rest. Result: no field wrong. One gap, that positivity of the area operator was not recorded; it is now the lower bound inside H14. Two citations were corrected (`ε`, positivity of the clock), a fourth warning was added for the area operator on `H_omega`, `minReading` was renamed `clockLowerBound`, and the degenerate scalar model was replaced by `ofProjections`. The reviewer could not refute the claim in F6 that the clock is not constructed outside `K_A`. The formal statements of H1, H13 and H14 were written only after this review.
- Second pass by the same reader (2026-11-26) over the revised `Setup.lean`, the formal statements `H1`, `H13`, `AreaBoundAt`, `H14`, and every theorem in `ClockHypotheses.lean`: all four statements classified as faithful in this encoding, every theorem docstring found to match what is proved, all five required changes confirmed done, nothing required before commit. Its optional points were applied: scope notes in the docstrings of `Ω`, `H1`, `AreaBoundAt`, `H14` and `H1_iff_tendsto_norm_sq`; the lemma `fixedAreaDiamondSpace_eq_map`; the model theorem `exists_setup_H1_H13_not_H14`; and a separate fixed-area hypothesis `H14a`. `H14a`, `H14.h14a`, `H14a.fixedAreaDiamondSpace_eq_bot` and `exists_setup_H1_H13_not_H14` were added after that pass, adapted from the reader's own scratch checks; their final text has not been re-read by it.

- Sen's paper, arXiv:1205.0971v2 (JHEP 04 (2013) 156), was read on 2026-11-26 from arxiv.org in a browser: the abstract page, and in the HTML rendering Section 1 in full, Section 3 in full, the paragraph ending at (2.41), and the three numbered points that open Section 4. Equations were taken from the LaTeX carried by the rendering. Not read: the rest of Section 2, Section 5 and the appendices. Every sentence of the paper under study that cites Sen was re-read in the TeX (abstract, lines 111, 1932, 2095, 2097).
- The paper's acknowledgements (`main.tex` line 2400) were read on 2026-11-26. They say that several of the calculations and proofs were developed in collaboration with an AI model over many months, without saying which. This confirms the entry in `handoff.md` Section 2, which came from the earlier extraction.
- For WP1-f, (3.25) to (3.28) and footnote 8 were read in the TeX (lines 556 to 596) on 2026-11-26.
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
| Differs from paper? | Covers the last implication only. The step from `q = x^2 (2 - q)` and the moment identity (5.60) are not formalized |

### `ratio_sq_of_q` (same file)

| Field | Content |
|---|---|
| Paper | Not stated in the paper |
| Formal statement | For real `x`: `2 x^2 / (1 + x^2) = 257/302` if and only if `x^2 = 257/347` |
| Differs from paper? | Addition. Combines footnote 23 with (5.68). See finding F3 |

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
| `clock_mean_eq_of_const` | Last sentence of App D.3 | For constant `rho = r > 0` and `u = (1 - eps) r`, the averaged clock equals `(1 - eps) sqrt(A/(4 pi))` | The paper says the classical clock attains the bound for vanishing shear and uniform density; this is that case |

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


### Closed cuts and H3c (`QuantGrav/Diamond/ClosedCuts.lean`)

`T_P` is the partial trace `sum_i ‖C e_i‖^2` over a cut `P` of orthonormal vectors `e_i`, and `Delta_P` is the response `<Delta_eta O>_P` on the cut, here an abstract real number. The closed amplitude of (5.38) is `Z_P[X] = T_P (Delta_P - delta/2)`.

| Lean | Paper | Formal statement | Differs from paper? |
|---|---|---|---|
| `exists_orthonormal_sum_sq_norm_gt` | Not stated; the contrapositive of F2 | If `H` is infinite-dimensional and `c ‖v‖^2 <= ‖C v‖^2` with `c > 0`, the partial traces over finite orthonormal families exceed every bound | Addition |
| `open_gluing_id_and_unbounded_partial_traces` | (4.29), (4.30) against H3a | On an infinite-dimensional Hilbert space, in every Hilbert basis the identity satisfies the resolution of the identity (4.29) and the absolute bound (4.30), and its partial traces are unbounded | Addition. The open-gluing statements cannot imply H3a |
| `cut_amplitude_le_neg_rank` | (5.38) with the counting step of (D.24) | For a cut of `n` orthonormal vectors, `delta >= 0` and a response `Delta <= delta/4`: `T_P (Delta - delta/2) <= -(c delta/4) n` | The paper has `\|<Delta_eta O>_P\| <= delta/2` on its cuts and concludes `Z_P[X] <= 0`. The bound `delta/4` is a stricter choice in the same construction: the paper makes the bound of (5.32) smaller than `delta/2` by choosing `Delta s` and `r`, and the same choice makes it smaller than any positive number |
| `tendsto_cut_amplitude_atBot`, `not_tendsto_cut_amplitude_nhds` | Not stated | Along any family of such cuts whose ranks tend to infinity, `T_P (Delta_P - delta/2)` tends to minus infinity, so it has no finite limit | Addition |
| `finiteDimensional_of_cut_amplitude_bddBelow` | Not stated | If infinite dimension would give cuts of arbitrarily large rank, with response at most `delta/4`, on which `T_P (Delta_P - delta/2) >= -B`, then `H` is finite-dimensional | Addition. Hypothesis H3c in abstract form. That infinite dimension gives large cuts of small response is the paper's (D.24), (D.25) with (5.32); here it is part of the hypothesis, not proved |


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

What the model shows. All five sequences are increasing exhaustions of one basis. Along each of them the cut projections converge strongly to the identity, and every open sum of (4.29) converges to the same uncut matrix element. The closed amplitudes of one fixed bounded insertion on one fixed bounded preparation still behave in five different ways. By `abs_flipCutResponse_le_iff` the nonempty cuts of the last three sequences satisfy the paper's condition on a cut, the left inequality of (5.37b). There the amplitude is nonpositive, as (5.38) says, and the three limits are `0`, `-w delta` and minus infinity. If the first family is read as the states inside the paper's narrow area interval and the second as the states outside it, the cuts `(3n, n)` and `(7n, n)` are unions of `n` cycles of lengths 4 and 8 in the sense of the paragraph before (5.37). That reading is prose and not part of any formal statement.

What it does not show. The model has no dynamics, no constraints and no area operator, and the insertion is put in by hand. `C† C = w` has infinite trace, so there is no uncut amplitude for the partial sums to converge to. The space is infinite-dimensional, which the paper argues `H_D` is not. So the model does not locate an error in the paper. It shows that H3b does not follow from (4.29) and (4.30), from `P -> 1` strongly, or from the left inequality of (5.37b). H3b has to come from the argument of Sec 3.6.

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
- So the finiteness claim is as strong as the argument of Sec 3.6 that a finite uncut amplitude exists and equals the cut sum, plus the inputs of (5.30c): the area bound (5.21d) (H14), the boost weight (5.23) (H6, H15) and unitarity (H2). Sec 3.6 has not been read for this log.
- For WP4: the target can be stated as `dim H_D < infinity` from H3a and (5.30c). H3b with H4 is then a second, independent route, to be formalized only if H3a is rejected. A third route, weaker than H3b, is H3c (F10).
- Three audits made independently on 2026-11-26 reach this reading of Sec 5.2: this repository, and two external ones collected in `notes/external-audits-2026-11-26.md`. The external ones were not verified here. The separate review session that read `main.tex` lines 1728 to 1830 agrees with the reading.

**F3. Footnote 23 and (5.68) together fix a ratio the paper treats as free.** The text fixes `l(D)/r_h > 1 - eps` as a free ratio. Footnote 23 gives `q = 2x^2/(1+x^2)` with `x = (1 - eps) r_h / l`, which depends on that ratio. (5.68) gives `q = 257/302` with no dependence on it. Both hold only if `x^2 = 257/347`, about `x = 0.8606` (`ratio_sq_of_q`). The paper does not comment on this. Registered under H8.

**F4. Handoff soft spots confirmed.**
- (5.39c) is `Z Tr(rho e^{A/4G hbar}) = Tr(1)`. It is an identity, not an independent count.
- (5.20) says the closure of `{P_D pi(X) psi}` is `P_D H_omega = H_D`. It is a density statement, not a dimension formula. The closure bar is in the TeX (line 1616) and was lost in the PDF text, so the earlier wording "spanning statement" was too strong. It sits in Sec 5.1, not 5.2.
- No area eigenvalues or spacings are given. (5.40) only names them `A_1, ..., A_m`.
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

- (4.29) and (4.30) hold for every bounded operator, the identity included, on any Hilbert space. The identity on an infinite-dimensional space has unbounded partial traces. So nothing in Sec 4.4 can give H3a (`open_gluing_id_and_unbounded_partial_traces`).
- On a cut with response at most `delta/4`, the closed amplitude of (5.38) is at most `-(c delta/4) rank P` (`cut_amplitude_le_neg_rank`). If `H_D` were infinite-dimensional, the paper's own cuts would therefore drive `Z_P[X]` to minus infinity (`tendsto_cut_amplitude_atBot`): the closed sums would have no finite limit at all.
- Hence a lower bound on `Z_P[X]` along those cuts already gives finite dimension (`finiteDimensional_of_cut_amplitude_bddBelow`). Register entry H3c. It is weaker than H3b, which asks for convergence to `Z[X]`, and it does not use H4, the positivity of `Z[X]`.
- The three routes, given (5.30c): H3a is equivalent to finite dimension (F2); H3b with H4 implies it, which is the paper's route; H3c implies it. Each is a statement about closing the cut, and none is derived in the paper from its constructions.
- Closed partial sums depend on the order of exhaustion. In a model with two countable orthonormal families, the flip `F` between them, the preparation `C = sqrt(w) 1` and the insertion `delta F ⊗ F̄ - delta/2`, the closed amplitude on the cut with the first `r` labels of one family and the first `n <= r` of the other is `(w delta/2)(3n - r)` (`flipCutAmplitude_eq`). Five increasing exhaustions of the same basis give plus infinity, `w delta`, `0`, `-w delta` and minus infinity (`flipCutAmplitude_five_limits`, `isIncreasingExhaustion_five_routes`). Along every increasing exhaustion the cut projections converge strongly to the identity and the open sums of (4.29) converge to the same limit (`IsIncreasingExhaustion.tendsto_sum_inner_smul`, `IsIncreasingExhaustion.tendsto_open_cut_sum`). Three of the five satisfy the left inequality of (5.37b) on every nonempty cut (`abs_flipCutResponse_le_iff`); their limits are `0`, `-w delta` and minus infinity. So H3b does not follow from open gluing, from `P -> 1` strongly, or from (5.37b). The model does not realise the paper's dynamics, and in it there is no finite uncut amplitude, so it does not say which step fails in the paper's setting.
- For two or more cuts, the sum of absolute values over all intermediate labels jointly can diverge even for unitary evolutions and normalizable states. Example: a unitary that is block diagonal with normalized Hadamard blocks of size `2^k`, and two states whose components are uniform in block `k` with squared norm `2^{-k/2}/k` there; the absolute sum over block `k` is `1/k`. The observation is from the external audit; this example is ours and is not formalized. So WP2-c is a statement about one cut, and the valid statement for several cuts is the sequential truncation of WP2-d.
- App E does not support Sec 5.2 independently. E.3 verifies the finiteness condition of E.1 for the causal diamond by citing (5.39c), in (E.17). In the other direction, that condition with the identity filter and the ordinary trace of (E.15a) would give finite dimension at once. Read in the TeX; the point was raised in the external audit.


## Hypothesis register

Maintained here and in `QuantGrav/Hypotheses.lean`. Entries are never deleted.

| ID | Statement | Paper location | Paper's support |
|---|---|---|---|
| H1 | `‖Psi_L - Omega_A‖ -> 0` as `L -> infinity`; equivalently `Omega_A` in `M` (F1). Formal: `DiamondSetup.H1`, in the second form | (5.7), (5.16), fn 18, (C.13) to (C.16d) | Called strong evidence; last step heuristic per fn 18 |
| H2 | Amplitude maps `U_M` are unitary | (4.18), not re-read | Assumed |
| H3 | Cut-state sums converge to the uncut amplitude with insertions fixed. Split into H3a and H3b on 2026-11-26 | (4.29), Sec 3.6, used at (5.38) | Diffeomorphism-invariance argument, not re-read |
| H3a | With no insertion: the partial traces `Tr(P C_b† C_b)` over finite orthonormal families in `H_D` are bounded. Given (5.30c) this is equivalent to `dim H_D < infinity` (F2) | Implicit in the sentences around (5.38); not stated | Not stated by the paper |
| H3b | With the insertion `X` of (5.37a): the partial sums `Z_P[X]` over cycle-closed projections converge to `Z[X]` | (5.38), Figure 30, (4.29) | Diffeomorphism-invariance argument of Sec 3.6. Not a consequence of (4.29), (4.30), of `P -> 1` strongly, or of the left inequality of (5.37b): in a model, five increasing exhaustions of one basis give five different closed limits (F10, `QuantGrav/Diamond/OrderOfExhaustion.lean`) |
| H3c | The closed amplitudes `Z_P[X]` are bounded below along the paper's cuts of small response. Weaker than H3b; with it finite dimension follows without H4 (F10) | Not stated in the paper | Not stated. Abstract form: hypothesis `hcuts` of `finiteDimensional_of_cut_amplitude_bddBelow`. Added 2026-11-26 |
| H4 | `<Delta_eta O> > delta_eta / 2` in the uncut preparation | (5.36b), (5.37b), (D.26) to (D.36) | One-loop estimate on a smooth background |
| H5 | Truncation projections converge strongly to the identity | Sentence after (4.31) | Asserted. Explicit hypothesis `hlim` of `tendsto_inner_evolveCut`; proved for orthogonal projections onto increasing sequences of subspaces with dense union in `tendsto_inner_evolveCut_starProjection` (2026-11-26) |
| H6 | Boost generator is `A/(8 pi G)` | (5.22); (3.43) not re-read | Classical corner symplectic structure |
| H7 | `log Tr(C_b† C_b) = (106/45) log s_b + O(1)` | (5.67a) to (5.67c), ref [71] | Imported one-loop coefficient plus Gauss-Bonnet. The prefactor evaluates to `212/45`, Sen's pure-gravity `C_local` (F9) |
| H8 | `q` exists as a limit; its value | (5.54b), (5.61), (5.68), fn 23 | Value derived from H7 (see `log_coefficient_roundtrip`); tension F3. Comparison with Sen: F9 |
| H9 | Choice of pure extension `omega` | (4.16) not re-read, fn 20 | Deferred by author |
| H10 | `log d(s) <~ 1 + (s Q_*)^(3/4)` | (D.45a) to (D.46c) | Unspecified constants |
| H11 | Disk factor `e^s` in each weight | Paragraph above (D.48), ref [51] | Citation |
| H12 | Type I with integer weights; Euclidean to Lorentzian converse | App E.2, ref [36], not re-read | Citation. App E cannot support Sec 5.2 independently: E.3 verifies the finiteness condition for the causal diamond by citing (5.39c) (F10) |
| H13 | The clock (4.27) is densely defined on `K_A`. Formal: `DiamondSetup.H13`. Narrowed on 2026-11-26: existence of the clock and commutation with the area moved to H16 | fn 14, the paragraph after (C.17) | Derived on condition that the H1 estimate holds for displaced Gaussian states (F1). Added 2026-11-26 |
| H14 | `u >= (1 - eps)(A/4pi)^(1/2)` as operators, hence `0 <= P_D A P_D <= 4 pi l(D)^2/(1 - eps)^2 P_D`. Formal: `DiamondSetup.H14`, as spectral support | (5.21a) to (5.21d), fn 8 | Cauchy-Schwarz on `S` plus positivity of focusing, at fixed area. On `H_omega` it rests on H16. Added 2026-11-26 |
| H14a | On `K_A` the clock has no readings below `(1 - eps)(A/4pi)^(1/2)`: the fixed-area half of H14. Formal: `DiamondSetup.H14a`; implied by H14 | (5.21a) to (5.21c) at fixed area, fn 8 | Cauchy-Schwarz on `S` plus positivity of focusing. Does not need H16. Added 2026-11-26. The classical inequality behind it is proved (`clock_mean_ge`); the operator statement is not |
| H15 | `C_D† C_D = P_D e^{-A/(4 G hbar)} P_D`: the future half of the diamond is prepared by continuing the corner boost to `i pi`, and gluing to its time reflection leaves only this weight | (5.23a), (5.23b), App C | Asserted from analytic continuation and unitarity. Added 2026-11-26 |
| H16 | The clock has spectral projections on all of `H_omega`, they map `K_A` to itself, and they commute with those of the area operator. In Lean: fields `clock`, `clock_proj_of_neg`, `clock_proj_mem`, `commute` of `DiamondSetup` | (5.2); the sentences after (5.2), before (5.20) and before (5.21) | Asserted. The clock is constructed on `K_A` only, (4.26), (4.27), (C.11), (C.13) (F6). Added 2026-11-26 |
| H17 | The area operator is a self-adjoint operator on `H_omega`, with `K_A` in its eigenspace for the value `A`. In Lean: fields `area`, `area_exhausts`, `area_tendsto_atBot`, `area_proj_of_lt`, `area_proj_area₀` of `DiamondSetup` | (4.12) to (4.15); `A = A 1` before (4.24) | Presupposed: introduced as the boost generator on prepared states before `H_omega` is built (F6). Added 2026-11-26 |
| H18 (candidate) | The quantization of the reduced phase space is taken to be the quantum theory. The outcome may depend on the reduction and on the operator ordering, here Weyl ordering (4.20), and it is not compared with Dirac quantization | Sec 3, Sec 4.1, (4.20); Sec 3 not re-read | Not addressed in the parts read. Raised in an external review (`notes/external-audits-2026-11-26.md`, section 3). Added 2026-11-26 |

References the register depends on, from the paper's bibliography:
- [34] Sen, arXiv:1205.0971.
- [36] Colafranceschi, Dong, Marolf, Wang, arXiv:2310.02189.
- [51] Carlip, Teitelboim, arXiv:gr-qc/9312002.
- [71] Bastianelli, Bonezzi, Melis, arXiv:2206.13287.
- [82] Behrndt, Hassi, de Snoo, Wietsma, Proc. Roy. Soc. Edinburgh A 140 (2010) 927. Used for (C.13).

## Open items that affect fidelity

- The licence is MIT (2026-11-26). `linter.style.header` is on again with its licence line set to MIT, so every linter in Mathlib's standard set is now active. The file headers name the git author as copyright holder and author; which proofs were written by subagents is recorded under "How the paper was read", and the commit history records the co-authorship.
- The comparison of (5.69) with Sen's ensembles is made in F9. Reference [71] of the paper (Bastianelli, Bonezzi, Melis), the stated source of the coefficient in (5.67c), has not been read.
- Second-reader review is done for the WP1-a to WP1-e files in `QuantGrav/Elementary/`, for the definitions in `QuantGrav/Diamond/Setup.lean`, and for `FiniteDim.lean`, `CutSums.lean`, `BoostBound.lean` and `ClockWeightIntegral.lean`. It is outstanding for `ClockLowerBound.lean`, `PairAmplitudeReal.lean`, `QuantGrav/Entropy/SenComparison.lean`, `QuantGrav/Diamond/ClosedCuts.lean` and `QuantGrav/Diamond/OrderOfExhaustion.lean`, and for the four items added after the second pass over `Setup.lean` and `ClockHypotheses.lean` (`H14a`, `H14.h14a`, `H14a.fixedAreaDiamondSpace_eq_bot`, `exists_setup_H1_H13_not_H14`).
