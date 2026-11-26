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
- Findings F1, F2 and F4 were re-checked against the TeX on 2026-11-26; each now says what changed.
- `QuantGrav/Diamond/FiniteDim.lean` was written after that review and has had no second reader.
- The proof of `abs_im_tsum_cexp_div_sq_sub_le` was written by a subagent from a fixed statement. Its statement was written and checked numerically first; the proof is accepted on the strength of the kernel and the axiom audit, not on a reading of the proof.

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
| Formal statement | For `N >= 1`: `|sum_{k<N} 1/(k+1) - log N| <= 1`. The partial sums tend to infinity |
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
| Differs from paper? | The paper names only the `log s` term. The theorem also fixes the non-logarithmic `1/s^3` piece, `(log 2 - 1)/s^3`, and bounds the remainder. Restricted to `s >= 2`. It says nothing about the real part. The paper's further claim that the third derivative of the full sum diverges as `G_N -> 0+` is not formalized; `cubic_term_partial_pair_sum` with `tendsto_harmonic_atTop` covers the truncated sums only |

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
- For WP4: the target can be stated as `dim H_D < infinity` from H3a and (5.30c). H3b with H4 is then a second, independent route, to be formalized only if H3a is rejected.

**F3. Footnote 23 and (5.68) together fix a ratio the paper treats as free.** The text fixes `l(D)/r_h > 1 - eps` as a free ratio. Footnote 23 gives `q = 2x^2/(1+x^2)` with `x = (1 - eps) r_h / l`, which depends on that ratio. (5.68) gives `q = 257/302` with no dependence on it. Both hold only if `x^2 = 257/347`, about `x = 0.8606` (`ratio_sq_of_q`). The paper does not comment on this. Registered under H8.

**F4. Handoff soft spots confirmed.**
- (5.39c) is `Z Tr(rho e^{A/4G hbar}) = Tr(1)`. It is an identity, not an independent count.
- (5.20) says the closure of `{P_D pi(X) psi}` is `P_D H_omega = H_D`. It is a density statement, not a dimension formula. The closure bar is in the TeX (line 1616) and was lost in the PDF text, so the earlier wording "spanning statement" was too strong. It sits in Sec 5.1, not 5.2.
- No area eigenvalues or spacings are given. (5.40) only names them `A_1, ..., A_m`.
- (5.32) is proved in (D.22), (D.23) by `|e^{ix} - 1| <= |x|`. That step is elementary and could be a WP2 theorem. The physics input H4 is (5.36b) and (5.37b), supported by (D.26) to (D.36) at one loop on a smooth background.
- The pigeonhole step is in the paragraph after (D.24): finitely many intervals cover `[0, s_*]`, so one has a spectral subspace of full dimension. It is stated for any cardinality.
- The entropy formula is (5.50); the handoff's map started Sec 5.3 at (5.51).
- Re-checked against the TeX on 2026-11-26: (5.39c), (5.40), (5.50), (D.22), (D.23) and the pigeonhole paragraph are as described. Only the (5.20) item changed.

**F5. WP1-a, WP1-b checked against (4.32) to (4.34).** The variance `1/(2sk)`, the pair phase `e^{-2ik/s}`, the closed form `Li_2(e^{-2i/s}) / (2 s^2)`, the divergent first-order term `-(i/s^3) sum 1/k`, and the claimed finite term `-i log s / s^3` are as the handoff states. The paper states the finite term without the subleading pieces.

## Hypothesis register

Maintained here and in `QuantGrav/Hypotheses.lean`. Entries are never deleted.

| ID | Statement | Paper location | Paper's support |
|---|---|---|---|
| H1 | `‖Psi_L - Omega_A‖ -> 0` as `L -> infinity`; equivalently `Omega_A` in `M` (F1) | (5.7), (5.16), fn 18, (C.13) to (C.16d) | Called strong evidence; last step heuristic per fn 18 |
| H2 | Amplitude maps `U_M` are unitary | (4.18), not re-read | Assumed |
| H3 | Cut-state sums converge to the uncut amplitude with insertions fixed. Split into H3a and H3b on 2026-11-26 | (4.29), Sec 3.6, used at (5.38) | Diffeomorphism-invariance argument, not re-read |
| H3a | With no insertion: the partial traces `Tr(P C_b† C_b)` over finite orthonormal families in `H_D` are bounded. Given (5.30c) this is equivalent to `dim H_D < infinity` (F2) | Implicit in the sentences around (5.38); not stated | Not stated by the paper |
| H3b | With the insertion `X` of (5.37a): the partial sums `Z_P[X]` over cycle-closed projections converge to `Z[X]` | (5.38), Figure 30, (4.29) | Diffeomorphism-invariance argument of Sec 3.6 |
| H4 | `<Delta_eta O> > delta_eta / 2` in the uncut preparation | (5.36b), (5.37b), (D.26) to (D.36) | One-loop estimate on a smooth background |
| H5 | Truncation projections converge strongly to the identity | Sentence after (4.31) | Asserted |
| H6 | Boost generator is `A/(8 pi G)` | (5.22); (3.43) not re-read | Classical corner symplectic structure |
| H7 | `log Tr(C_b† C_b) = (106/45) log s_b + O(1)` | (5.67a) to (5.67c), ref [71] | Imported one-loop coefficient plus Gauss-Bonnet |
| H8 | `q` exists as a limit; its value | (5.54b), (5.61), (5.68), fn 23 | Value derived from H7 (see `log_coefficient_roundtrip`); tension F3 |
| H9 | Choice of pure extension `omega` | (4.16) not re-read, fn 20 | Deferred by author |
| H10 | `log d(s) <~ 1 + (s Q_*)^(3/4)` | (D.45a) to (D.46c) | Unspecified constants |
| H11 | Disk factor `e^s` in each weight | Paragraph above (D.48), ref [51] | Citation |
| H12 | Type I with integer weights; Euclidean to Lorentzian converse | App E.2, ref [36], not re-read | Citation |
| H13 | Clock operator (4.27) is positive, self-adjoint, densely defined, commutes with area | (4.27), fn 14, (C.11) to (C.13), (C.17) | Argued; depends on the H1 estimate (F1). Added 2026-11-26 |
| H14 | `u >= (1 - eps)(A/4pi)^(1/2)` as operators, hence (5.21d) | (5.21a) to (5.21d), fn 8 | Cauchy-Schwarz on `S` plus positivity of focusing. Added 2026-11-26 |
| H15 | `C_D† C_D = P_D e^{-A/(4 G hbar)} P_D`: the future half of the diamond is prepared by continuing the corner boost to `i pi`, and gluing to its time reflection leaves only this weight | (5.23a), (5.23b), App C | Asserted from analytic continuation and unitarity. Added 2026-11-26 |

References the register depends on, from the paper's bibliography:
- [34] Sen, arXiv:1205.0971.
- [36] Colafranceschi, Dong, Marolf, Wang, arXiv:2310.02189.
- [51] Carlip, Teitelboim, arXiv:gr-qc/9312002.
- [71] Bastianelli, Bonezzi, Melis, arXiv:2206.13287.
- [82] Behrndt, Hassi, de Snoo, Wietsma, Proc. Roy. Soc. Edinburgh A 140 (2010) 927. Used for (C.13).

## Open items that affect fidelity

- No licence or copyright header has been chosen, so `linter.style.header` is switched off in `lakefile.toml`. Every other linter in Mathlib's standard set is on.
- The comparison of (5.69) with Sen's ensemble (WP5 question 3) has not been made. Sen's paper has not been read for this log.
- Second-reader review is done for `QuantGrav/Elementary/` and outstanding for `QuantGrav/Diamond/FiniteDim.lean` and for the reading of the paper in F2.
