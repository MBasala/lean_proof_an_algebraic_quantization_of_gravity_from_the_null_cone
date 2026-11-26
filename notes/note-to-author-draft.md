# Draft note to the author (handoff Step 6)

Status: draft, not sent. Michael decides whether to send it, and in what form.
Drafted: 2026-11-26.

## The note

Subject: Questions from a Lean formalization of arXiv:2611.34924

Dear Venkatesa Chandrasekaran,

I am formalizing the mathematical skeleton of your paper in Lean 4 with Mathlib, with every unproved input as a named hypothesis. So far only elementary statements are machine-checked: (4.29) to (4.34), (5.17), (5.56), (5.57a), (C.21), the bound (5.32) in abstract form, and the arithmetic of (5.61), (5.68) and (5.69). None of the headline claims is. The development was written with the help of an AI model and is checked by the Lean kernel.

Making the definitions precise raised seven questions I could not settle from the text. I would be grateful for your view on any of them.

1. The clock on H_ω. The clock is constructed on K_A by the form (4.27) and (C.11) to (C.13); (5.2) then applies its spectral projection on H_ω. How is the clock defined on vectors of H_ω outside K_A, and why does it commute with the area operator there? As I read it, the construction determines P_D(A) K_A but not the rest of H_D.

2. Finite dimension. Before (5.38), Z[X] is the expectation of X in the uncut preparation times that preparation's squared norm. Is this norm, the amplitude with no insertion, taken to be finite and reproduced by closing the cut? If so, (5.30c) alone gives dim H_D ≤ Z[1] e^{s_*} / m_{b,D}, which I have checked formally, and the boost argument is not needed. Or is the boost argument there because the statement with no insertion is not available? More generally, for which family of cuts, and for which insertions, must the closed partial sums reproduce the uncut amplitude? In a toy model with two orthonormal families of states and a flip observable, which I have checked formally, closed sums along different increasing exhaustions of the same basis have different limits, even when every cut satisfies the left inequality of (5.37b).

3. Domain of the clock. By the sentence after (C.14), ‖Ψ_L − Ω_A‖ → 0 exactly when Ω_A lies in M, and the paragraph after (C.17) derives density of the form domain from the same estimate. Is there an argument that (4.27) is densely defined, or that Ω_A lies in M, that does not pass through (5.8) to (5.16) and the heuristic step of footnote 18?

4. The ratio ℓ(D)/r_h. As I read (5.53), r_h is defined from the state ρ_D, which depends on ℓ(D) alone, so ℓ(D)/r_h is determined and not chosen. Footnote 23 then relates it to q, and with (5.68) gives x² = 257/347, that is ℓ(D)/r_h → (1 − ε)(347/257)^(1/2) ≈ 1.16 (1 − ε). Is that the intended reading of "at fixed ℓ(D)/r_h", or is the ratio meant to be a free choice?

5. Comparison with Sen. As I read (5.66) to (5.69), q is obtained from the coefficient in (5.67c), and (5.69) returns that coefficient whatever its value. The number 106/45 is Sen's mixed-ensemble coefficient, his (1.4), which in four dimensions is C_local alone; his microcanonical and singlet coefficients are lower by 1 and 3 in units of ln a. Is there an evaluation of q that does not use (5.67c), and is the mixed ensemble the comparison meant in the abstract?

6. Records. The acknowledgements say several calculations and proofs were developed with an AI model. Are records of those derivations, or any formal artifacts, available?

7. The resolution. The steps that control the focusing in the argument for (5.19) are made at fixed angular and radial resolution, and the Wigner function (C.15a) is written for a finite set of canonical pairs. Is the resolution removed, and are the estimates uniform in it? In a model with the variance 1/(2sk) of (4.32) and a cost growing like k² per mode, as (D.41) suggests, the mean of an unsubtracted positive quadratic form over the first N radial modes grows like N²/s, and the probability that it stays below any bound tends to zero. How is the focusing operator (4.22) defined when all modes are included: unsubtracted, as its positivity in (5.21) requires, or counted by occupation numbers, as in Appendix D.3?

I would be glad to share the Lean files.

With thanks,
Michael Basala

## Where each question comes from

| Question | Source in this repository |
|---|---|
| 1 | Finding F6; register entries H16, H17; `QuantGrav/Diamond/Setup.lean` |
| 2 | Findings F2, F10; register entries H3a, H3b, H3c; `QuantGrav/Diamond/FiniteDim.lean`, `QuantGrav/Diamond/ClosedCuts.lean`; the toy model is `QuantGrav/Diamond/OrderOfExhaustion.lean`, simplified from the one in `notes/external-audits-2026-11-26.md`, section 1.2 A |
| 3 | Findings F1, F7; register entries H1, H13; `QuantGrav/Diamond/ClockHypotheses.lean` |
| 4 | Finding F3, corrected on 2026-11-26; `QuantGrav/Entropy/ClockMoments.lean`; `ratio_sq_of_q` in `QuantGrav/Elementary/LogCoefficient.lean` |
| 5 | Finding F9; `log_coefficient_roundtrip`; `QuantGrav/Entropy/SenComparison.lean` |
| 6 | The paper's acknowledgements (`main.tex` line 2400); `handoff.md` Section 2 |
| 7 | Finding F11; candidate register entry H19; `QuantGrav/Elementary/FocusingDivergence.lean`, `QuantGrav/Elementary/GaussianModeLimits.lean`, `QuantGrav/Diamond/ClockDivergence.lean` |

Questions 1 to 5 of `handoff.md` Section 13, Step 6 are questions 4, 5, 3, 2 and 6 here. Question 1 here is new, from finding F6. The ensemble part of question 5 is new, from finding F9. Question 7 is new, from finding F11 (break attempt B1).

## To settle before sending

- The offer to share the Lean files. The repository is private.
- The sentence saying the development was written with the help of an AI model.
- The salutation. The author's title is not known to this repository.
- Question 2 rests on a reading of the two sentences around (5.38) that no second reader has checked (see the open items in `FIDELITY.md`).
