# Draft note to the author (handoff Step 6)

Status: draft, not sent. Michael decides whether to send it, and in what form.
Drafted: 2026-11-26.

## The note

Subject: Questions from a Lean formalization of arXiv:2611.34924

Dear Venkatesa Chandrasekaran,

I am formalizing the mathematical skeleton of your paper in Lean 4 with Mathlib, with every unproved input as a named hypothesis. So far only elementary statements are machine-checked: (4.29) to (4.34), (5.17), (5.39c), (5.50), (5.56), (5.57a), (C.21), the bound (5.32) in abstract form, and the arithmetic of (5.61), (5.68) and (5.69). None of the headline claims is. The development was written with the help of an AI model and is checked by the Lean kernel.

Making the definitions precise raised nine questions I could not settle from the text. I would be grateful for your view on any of them.

1. The clock on H_ω. The clock is constructed on K_A by the form (4.27) and (C.11) to (C.13); (5.2) then applies its spectral projection on H_ω. How is the clock defined on vectors of H_ω outside K_A, and why does it commute with the area operator there? As I read it, the construction determines P_D(A) K_A but not the rest of H_D.

2. Finite dimension. Before (5.38), Z[X] is the expectation of X in the uncut preparation times that preparation's squared norm. Is this norm, the amplitude with no insertion, taken to be finite and reproduced by closing the cut? If so, (5.30c) alone gives dim H_D ≤ Z[1] e^{s_*} / m_{b,D}, which I have checked formally, and the boost argument is not needed. Or is the boost argument there because the statement with no insertion is not available? More generally, for which family of cuts, and for which insertions, must the closed partial sums reproduce the uncut amplitude? In a toy model with two orthonormal families of states and a flip observable, which I have checked formally, closed sums along different increasing exhaustions of the same basis have different limits, even when every cut satisfies the left inequality of (5.37b) as displayed. When the responses stay a fixed margin below δ_η/2, as the choice of Δs and r after (D.25) provides, the closed sums tend to minus infinity in every order. The text cites Section 3.6 for this step. As I read it, that section matches classical fields and shows that the action is additive, and (4.29) to (4.31) treat fixed external states. Is the closed case derived somewhere, or is it condition 1 of Appendix E.1?

3. Domain of the clock. By the sentence after (C.14), ‖Ψ_L − Ω_A‖ → 0 exactly when Ω_A lies in M, and the paragraph after (C.17) derives density of the form domain from the same estimate. Is there an argument that (4.27) is densely defined, or that Ω_A lies in M, that does not pass through (5.8) to (5.16) and the heuristic step of footnote 18?

4. The ratio ℓ(D)/r_h. As I read (5.53), r_h is defined from the state ρ_D, which depends on ℓ(D) alone, so ℓ(D)/r_h is determined and not chosen. Footnote 23 then relates it to q, and with (5.68) gives x² = 257/347, that is ℓ(D)/r_h → (1 − ε)(347/257)^(1/2) ≈ 1.16 (1 − ε). Is that the intended reading of "at fixed ℓ(D)/r_h", or is the ratio meant to be a free choice?

5. Comparison with Sen. As I read (5.66) to (5.69), q is obtained from the coefficient in (5.67c), and (5.69) returns that coefficient whatever its value. The number 106/45 is Sen's mixed-ensemble coefficient, his (1.4), which in four dimensions is C_local alone; his microcanonical and singlet coefficients are lower by 1 and 3 in units of ln a. Is there an evaluation of q that does not use (5.67c), and is the mixed ensemble the comparison meant in the abstract?

6. Records. The acknowledgements say several calculations and proofs were developed with an AI model. Are records of those derivations, or any formal artifacts, available?

7. The resolution. The steps that control the focusing in the argument for (5.19) are made at fixed angular and radial resolution, and the Wigner function (C.15a) is written for a finite set of canonical pairs. Is the resolution removed, and are the estimates uniform in it? In a model with the variance 1/(2sk) of (4.32) and a cost growing like k² per mode, as (D.41) suggests, the mean of an unsubtracted positive quadratic form over the first N radial modes grows like N²/s, and the probability that it stays below any bound tends to zero. How is the focusing operator (4.22) defined when all modes are included: unsubtracted, as its positivity in (5.21) requires, or counted by occupation numbers, as in Appendix D.3?

8. The states behind the entropy. With the trace of (5.39b) and (E.15), the entropy (5.50) is at most log dim H_D, and footnote 24 gives exp[a s_* + o(s_*)] orthogonal states below area a s_*. (D.46c) bounds the graviton states at fixed area by exp[C(1 + (s Q_*)^{3/4})], with the corner data fixed. If that also bounds the multiplicity of each area eigenvalue in (5.40), there must be exp[a s_* + o(s_*)] distinct area eigenvalues below a s_*, which I have checked formally. Is that the intended picture, or do the states sit at fewer areas, in excitations of the corner variables that d(s) does not count? And in (D.48), is each graviton state at area s meant to stand for e^s orthogonal states of weight e^{-s} k_a(s)? That is what the two formulas give when read with the ordinary trace.

9. The corner variables and the clock. Take X = ∫_S φ K ε_0, with K = ϱ_S²/(8πG) the area density and φ a non-constant function on S with ∫φ ε_0 = 0. From (A.14), (A.16), (A.28) and (A.30) I find that the variation of the relative boost λ − γ enters the symplectic form only in its wedge with δK, so that the Hamiltonian vector field of X is a shift of λ − γ by φ and nothing else: its components along K, the angular pairs (Y^i, p_i) and the conformal metric z^α(v, y) at fixed v vanish. X then Poisson-commutes with f_S(y), with Ξ_y(v), and with the clock (3.27), (3.28), just as the total area does. Is that right, and is λ − γ an independent variable on the capped cone? One point on the way: with the cap condition (3.18) the form (A.14), which is written for a cut of fixed area density, seems to need one more term at v = ε, (ε³/4) δK ∧ g(∂_v z, δz). Then the quantum question. In the canonical pairs (q_j, p_j) of Sec 4.2, are the modes of K(y), or of f_S(y), among the coordinates, up to a linear symplectic map? You name the pairs (K(y), λ − γ) after (A.27) and (K(y), Π_K) before (B.24). If they are, then e^{itX}, or e^{it∫ψ f_S ε_0}, commutes exactly with Q(f_S(y)) and Q(z^α(v, y)), hence with every factor of (4.26), and it is one member of a Weyl pair on K_A. I have checked formally that a subspace invariant under such an operator is zero or infinite-dimensional, so P_D(A) K_A could not be both nonzero, as (5.19) gives, and finite-dimensional. If they are not, the commutator first fails at order ħ³ in the product (C.9): does finite dimension then rest on that term? Either way, what bounds the excitations of the relative boost at fixed area, given that App D.3 holds the corner data fixed?

I would be glad to share the Lean files.

With thanks,
Michael Basala

## Where each question comes from

| Question | Source in this repository |
|---|---|
| 1 | Finding F6; register entries H16, H17; `QuantGrav/Diamond/Setup.lean` |
| 2 | Findings F2, F10, F12; register entries H3a, H3b, H3c; `QuantGrav/Diamond/FiniteDim.lean`, `QuantGrav/Diamond/ClosedCuts.lean`; the toy model is `QuantGrav/Diamond/OrderOfExhaustion.lean`, simplified from the one in `notes/external-audits-2026-11-26.md`, section 1.2 A |
| 3 | Findings F1, F7; register entries H1, H13; `QuantGrav/Diamond/ClockHypotheses.lean` |
| 4 | Finding F3, corrected on 2026-11-26; `QuantGrav/Entropy/ClockMoments.lean`; `ratio_sq_of_q` in `QuantGrav/Elementary/LogCoefficient.lean` |
| 5 | Finding F9; `log_coefficient_roundtrip`; `QuantGrav/Entropy/SenComparison.lean` |
| 6 | The paper's acknowledgements (`main.tex` line 2400); `handoff.md` Section 2 |
| 7 | Finding F11; candidate register entry H19; `QuantGrav/Elementary/FocusingDivergence.lean`, `QuantGrav/Elementary/GaussianModeLimits.lean`, `QuantGrav/Diamond/ClockDivergence.lean` |
| 8 | Finding F13; register entries H10, H11, H12; `QuantGrav/Entropy/GibbsAccounting.lean`, `QuantGrav/Entropy/BandCounting.lean`, `QuantGrav/Entropy/LogLevelsModel.lean` |
| 9 | Findings F14, F15; candidate register entry H21; `QuantGrav/Diamond/ConfigurationOnly.lean`, `QuantGrav/Diamond/FixedResolution.lean`, `QuantGrav/Elementary/OccupationCount.lean`, `QuantGrav/Elementary/ConstantPoissonBracket.lean`; the derivations `notes/b6-derivation-first.md` and `notes/b6-derivation-second.md` |

Questions 1 to 5 of `handoff.md` Section 13, Step 6 are questions 4, 5, 3, 2 and 6 here. Question 1 here is new, from finding F6. The ensemble part of question 5 is new, from finding F9. Question 7 is new, from finding F11 (break attempt B1). Question 8 is new, from finding F13 (break attempt B2). Question 9 is new, from findings F14 and F15 (break attempts B5 and B6); it was rewritten after B6 around the explicit vector field.

## To settle before sending

- The offer to share the Lean files. The repository is private.
- The sentence saying the development was written with the help of an AI model.
- The salutation. The author's title is not known to this repository.
- Question 2 rests on a reading of the two sentences around (5.38) that no second reader has checked (see the open items in `FIDELITY.md`).
- Question 9 rests on two derivations made by an AI model (finding F15 in `FIDELITY.md`, `notes/b6-derivation-first.md`, `notes/b6-derivation-second.md`), which no expert has checked. It asks whether the vector field is right and which canonical coordinates Sec 4.2 uses. It should not be sent in a form that asserts either, and the remark about (A.14) should be checked by someone who knows Reisenberger's papers before it is sent.
