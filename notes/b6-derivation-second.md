> Copied into the repository on 2026-11-26 from the scratch folder of the second derivation agent of break
> attempt B6 (`handoff.md` Section 14.8), unchanged below this note. This derivation had only the TeX, the
> bibliography and the cited references. It was made by an AI model and has not been checked by an expert.
> Its scripts are `scripts/b6_second_truncation.py` and `scripts/b6_second_identities.py` (called
> `q5_truncation.py` and `check_A_identities.py` below), with outputs
> `notes/b6-second-truncation-output.txt` and `notes/b6-second-identities-output.txt`.

# The flow of the smeared corner area density on the capped null cone

Independent derivation ("b6_second"). Sources read: `paper/arxiv-src/main.tex`, the two `.bib` files,
`paper/equation_index.tsv`, and HTML pages of cited references on arxiv.org / ar5iv. Nothing else in the
repository was opened and no git command was run.

Tags used on every statement:

- **[a: Lnnn]** displayed in the paper, with the line in `main.tex`.
- **[b: ref, eq.]** taken from a cited reference.
- **[c]** my own derivation; the steps are given, and where a script checks it the check is named.
- **[d]** an assumption I had to make. All of them are collected in Section 6.

How the references were read. Two were read as page text in a browser pane (exact formulas):
Reisenberger arXiv:0712.2541 in full (ar5iv), and Chandrasekaran and Flanagan arXiv:2309.03871v2, Sections 3.1,
4.5, 7.1 to 7.3 and Appendix B (arxiv.org/html). The others were read through a fetch tool that returns a
summary written by a small model and refuses long quotations; items that come from it are marked
"(summary)". That tool returns about 100,000 characters per call; arXiv:1211.3880 and arXiv:2309.03932 were
read in two calls each, while for arXiv:1609.00207, arXiv:1412.6057, arXiv:1802.06135 and gr-qc/0703134
only the first part was seen. Nothing was downloaded.

Notation. `K(y) = ρ_S(y)²/(8πG)`. `g(a,b) = g_αβ(z) a^α b^β` with `g = diag(1, e^{2z¹})` [a: L1184].
`z' = ∂_v z`, `∇_v` is (A.15) [a: L2513]. `ε₀` is the fixed area form on `S`, `∫_S ε₀ = 4π` [a: L592].
A wedge of two variations means `(A∧B)(δ₁,δ₂) = A(δ₁)B(δ₂) − A(δ₂)B(δ₁)`; this is the reading under which
(A.14) is literally Reisenberger's eq. (6), which is written as "δ₁…δ₂… − (1↔2)" [b: 0712.2541, (6)].

Functionals of one generator that recur (all at fixed label `y`, integrals over `v` from `ε` to `1`):

```
α_ε[δz] = ½ ∫ v² g(z', δz) dv                (one-form; (3.42c) with lower limit ε)
M_ε     = ¼ ∫ v³ g(z', z') dv
Ξ_y(v)  = ¼ ∫_ε^v s g(z', z') ds             ((3.26c) with (∂q̄)^{AB}∂q̄_AB = 2 g(z',z'), [a: L575, L2595])
J_ε     = ⅛ ∫ v (1 − v²) g(z', z') dv         ((3.42d) with lower limit ε)
identity: 2 J_ε = Ξ_y(1) − M_ε                [c; script check A4]
```

---

## Q1. Conventions

### Q1.1 The paper

| Item | Convention | Where |
|---|---|---|
| Null normals | `ℓ_s` future null generators of `H_p`, `H_q`; on a null boundary `ℓ` is future directed and affinely parametrized, `n` is the transverse null normal with `ℓ·n = −1`. At `S`: `n_p = ℓ_q/(−ℓ_p·ℓ_q)`. | [a: L437, L498, L447] |
| Normalization of `ℓ` | "by choosing a parameter on each null cone". Smooth vertex: `u = 0` there and unit `t·ℓ`, so `ρ(0) = 0`, `∂_uρ(0) = 1`. Capped cone: `p_ε = ∂_uρ` at `v = ε` is left free, and `u_*` of (3.27) is built to be independent of it. | [a: L445, L567, L569, L579 to L583] |
| Inaffinity, connection | `κ = −n_μ ℓ^a∇_a ℓ^μ`, `β_a = −n_μ∇_a ℓ^μ`, `ϖ_a = q_a^b β_b`. `ℓ_a = −e^ψ ∇_a t`. | [a: L460, L667, L834, L2449] |
| Area parameter | `v = ρ/ρ_S`, cap edge at `v = ε`, corner at `v = 1`. On `H_j`: `q_AB = ρ_S² v_j² q̄_AB`. | [a: L569, L2479] |
| Boost `Γ` | Boost of the boundary frame. Corner potential `Θ_S = (1/8πG)∫_S μ (δΓ + Υ)`: sign `+K δΓ`, "conjugate momentum `μ/(8πG)`". `Υ = (ℓ_aδn^a − n_aδℓ^a)/(2(−ℓ·n))`, and after subtracting `B_S`, `Υ = ½ δ log(c_L/d)`. The boost angle of the displaced boundary is `log(c_L d N/2)`. | [a: L702 to L707, L727, L2939, L2811] |
| Boost `γ` | `γ = Γ_R − Γ_L`, `ℓ_R = e^γ Y*ℓ_L`, `n_R = e^{−γ} Y*n_L`, `ϖ_+ = Y*ϖ_− + dγ`, `K_+δΓ_R − K_−δΓ_L = K δγ`. | [a: L895 to L907, L922] |
| Boost `λ` | `λ = −log` of the absolute value of `∂_{v_L}·∂_{v_R}` at `S`: relative normalization of the area-parametrized tangents. `Ω ⊃ ∫ε₀[δλ∧δK + δp_i∧δY^i]`. | [a: L2482, L2520] |
| `λ` against `γ` | `k_q = e^{Γ_q}ℓ_q`, `Γ_q = log(−ℓ_p·k_q) − η`, `η = log(−ℓ_p·ℓ_q)`. The two corner terms are said to combine into one canonical pair `(K, λ − γ)`: `−Kδλ + Kδγ = −Kδ(λ − γ)`. | [a: L2597 to L2599] |
| Unit boost | `∇_aξ^b = ε^b_a = n^bℓ_a − ℓ^bn_a` at `S`, charge `μ/(8πG)`. A uniform boost of the right frame sends `σ_AB(u)` to `e^η σ_AB(e^η u)`, `u` affine from `S`. `α_η(O) = e^{iηK̂/ħ} O e^{−iηK̂/ħ}`. | [a: L783 to L785, L1085, L1652] |
| Cap and joint terms in the action | `(1/8πG)[∫_{Σ₀} K₀ − ∫_{Σ₁} K₁ + ∫_{∂Σ₀} μ log(−n₀·ℓ_p) + ∫_{∂Σ₁} μ log(−n₁·ℓ_q) − ∫_S μ log(−ℓ_p·ℓ_q/2)]`. Cap normal at the joint: `n_i = ℓ_s/(2(−n_i·ℓ_s)) − (n_i·ℓ_s) n_s`. They "vanish as the caps shrink to smooth vertices". | [a: L474 to L481, L452, L491] |
| Cap condition | `dA` at `∂Σ_i` equals `ε² dA` at `S`. | [a: L511] |
| Outer cut | `b_j² = ρ_C(s_j)² det(∇s_j)/ρ_S²` (absolute value of the determinant); `δμ_C = [b²δ(ρ_S²) + 2ρ_S² b δb] ε₀`; the cap potential contains `−(ε_C/8πG)∫_C log(−n_C·ℓ) δμ_C`, `n_C` the future unit normal, `ε_C` "its oriented sign". | [a: L2528 to L2537] |
| Form and bracket | `δH_ξ = Ω(δ, δ_ξ)`, `{O, H_ξ} = δ_ξ O`. | [a: L642, L649] |

No reference is cited in the paragraph of (A.28) [a: L2597 to L2601], and none in the display (3.42); the
sentence before (3.42) cites Reisenberger 0712.2541 and Chandrasekaran and Flanagan for (3.39) [a: L685].

### Q1.2 The references

| Reference (cited at) | Null normals and normalization | Boost parameter and sign | Cap and joint terms | Form and bracket |
|---|---|---|---|---|
| Reisenberger 0712.2541 ((3.39), (A.14), (A.34)); read in full | `n_A = ∂_{v_A}`, tangent in the area parameter `v_A` (proportional to the square root of the area density, equal to 1 on `S₀`); not affine; the affine parameter follows from his eq. (2), which is (3.26a). Both branches are future directed from `S₀`. | `λ = −ln` of the absolute value of `n_L·n_R` on `S₀`. Twist `τ_a` from his (3); `τ̃_R = ρ₀(dλ − τ)`, `τ̃_L = ρ₀(dλ + τ)`. `{ρ₀(θ₁), λ(θ₂)} = 8πG δ²(θ₂ − θ₁)` (9). `ρ₀` and `s_A` commute with all other data. `{μ, λ} = (4πG/ρ₀) δ² v∂_vμ` off `S₀` (17), zero on `S₀` (20). | None: Hilbert action, no boundary terms added. Branches are truncated at `S_A`; admissible variations leave the area density `ρ_A` (in the fixed chart `y_A`) and `μ_A` unchanged on `S_A`; `ρ_A` commutes with everything and is treated as fixed. | `δφ = ω[{φ,·}, δ]` (5), (7) |
| Reisenberger 1211.3880 ((A.14), L496, L567) (summary) | Same data; signature `−+++`; `n_A = ∂_{v^A}`. Relation to affinely normalized tangents on `S₀` through `B_A = ∂_{v^A}η^A`: `τ_η = τ + d ln B_L − d ln B_R`. | `λ = −ln` of the absolute value of `n_L·n_R`. His (117) is the same 2-form as (6) of 0712.2541, with a comoving variation `δ^a` (fixed chart `r = v/v̄`, `y`) in place of `δ°`. | Einstein-Hilbert potential, no boundary term. Admissible variations keep the area density on `S_A` and the chart near `S_A` fixed. | `δA = ω[{A,·}, δ]` (1) |
| Reisenberger gr-qc/0703134 (L627) (summary, first part only) | Signature `−+++`. Sections defining the data were beyond what the tool returned. | not seen | not seen | `δA = Ω̄[Δ_A, δ]`, `{B, A} = Δ_B A` (33), (35) |
| Carlip and Teitelboim gr-qc/9312002 ((3.41), (A.16)) (summary) | No null normals. Units `G = 1/(8π)`. | Opening angle `Θ_E` at the horizon (a proper angle; `2π` for a smooth Euclidean horizon), Lorentzian `Θ_E = iΘ`. Conjugate to the horizon area: `δI = (2π − Θ_E)δA − …` (19); `(ħ/i)∂ψ/∂Θ − Aψ = 0` (5), and locally with the area element in place of `A` (21). So the phase is `AΘ/ħ`: area is the momentum, angle the coordinate, sign `+A δΘ`. | Horizon term `2πA` in the action (18); `I' = Θ_E A + I_can − T_E M` when `Θ_E` is fixed instead (20). | none stated |
| Chandrasekaran and Flanagan 2309.03871 ((3.39), (3.64), (A.10)); Sections 3.1, 4.5, 7.1 to 7.3, App. B read | `ℓ_±` on `S_±`, defined up to `ℓ → e^σ ℓ` (3.3); `ℓ^a∇_aℓ^b = κ ℓ^b` (B.1); auxiliary `n` with `n·n = 0`, `n·ℓ = −1` (B.8); `ω_i = −n_j K_i^j`, `ϖ_i = q_i^j ω_j` (B.14), (B.15). Rescaling-invariant normals `L_±` with `L_+·L_− = −exp(α_+ + α_−)` on `S₀` (4.50), (4.51). | Half-sided boost `χ = f H(f) ∂_u`, `f = b(u − u₀)` (4.43); it changes the data by a delta function in `κ` and by `δq̄ = f H(f) £_ℓ q̄` (4.45). `b_r = b_+ − b_−` (7.32), (7.33). `{ln √q(θ), 2b_r(θ')} = −16π δ²(θ,θ')` (7.44), (7.45d), `G = 1`. The weighted area `∫√q w` generates `b_r → b_r − 8πw` (7.46). All of Section 7 is at linear order about a stationary background; their footnote 19 says the general case of the area generating half-sided boosts is open. | A family of corner terms with free coefficients `c_i` (their Section 6, summary); no logarithm of an inner product of normals in the parts read. | not stated in the parts read; (7.46) is `δF = {X, F}` |
| Hopfmüller and Freidel 1802.06135 ((3.57), (A.30)) (summary) | `L` null and future pointing, dual one-form `L̄` with `L̄(L) = +1`, `g = q + L⊗L̄ + L̄⊗L` (opposite sign to `ℓ·n = −1`). `∇_L L = κ L`. | No boost angle. Spin-0 pair: area form against `μ = κ + (D−3)/(D−2) θ` (`κ + θ/2` in `D = 4`); potential `(½σ^{ab}δγ_ab − ω_aδL^a + δμ) ε_B` (4.11). Reparametrization charge `(L + μ − θ)[f] ε_S` (3.19). | Corner term `α_S` (4.12), removed from the intrinsic potential (4.14). | `δH_ξ = −I_ξΩ`, `{H_ξ, F} = 𝔏_ξ F` (5.1), (5.2) |
| Ciambelli, Freidel, Leigh 2309.03932 ((A.31)) (summary) | Carrollian vector `ℓ`, Ehresmann form `k` with `k(ℓ) = 1`. Area element `Ω = √det q` (the paper's `ρ²ε₀`), `q_ab = Ω q̄_ab`. | Boost `ℓ → ℓ + λℓ` with corner charge `(1/8πG)∫_C ε_C λ`, `I_λ Ω^can = −δG_λ` (37), (38). `{Ω₁, μ₂} = 8πG δ³` (106); `Ω` commutes with the spin-2 data. Dressing time `μ = ∂_v ln ∂_vV` (146); in four dimensions `dV/d(affine)` is proportional to `√Ω` (148). | Corner form (164) in dressing time. | `I_ξΩ = −δQ_ξ` (21) |
| Alexandrov and Speziale 1412.6057 ((A.34)) (summary, first part only) | `8πG = 1`, signature `−+++`; internal null vectors `x_± = (±1, χ^i)`, `χ² = 1`, `x_+·x_− = 2`. | none | none | Second-class constraints whose bracket has principal part `∂_−` (4.31); no explicit kernel with a sign function in the part seen. |
| Lehner, Myers, Poisson, Sorkin 1609.00207 ((3.16), (A.2)) (summary, first part only) | `k^α` future directed, `k^β∇_βk^α = κ k^α`. | none | Joint integrand `a = ln` of the absolute value of `n·k` (null with spacelike) and of `k·k̄/2` (null with null); null term proportional to `∫κ`; the action depends on the parametrization of the generators (2.70). The appendix with the sign rule was not in the part returned. | none |

Donnelly and Freidel 1601.04744 and Speranza 1706.05061 are cited after (3.41) for the angular displacement
of `X`, not for the boost pair [a: L707]; I did not read them.

### Q1.3 Two sign checks across sources [c]

1. From (A.16) and (3.32), (3.33): `Ω(δ, δ_X) = δX` with `Ω ⊃ δλ∧δK` gives `δ_X λ = −φ`, hence
   `{λ(y), X} = −φ(y)` and `{K(y), λ(y')} = +δ²(y, y')` (delta with respect to `ε₀`). Reisenberger's (9),
   `{ρ₀, λ} = 8πG δ²`, is the same statement with `ρ₀ = 8πG K`. His convention `δφ = ω[{φ,·}, δ]` and the
   paper's `δH = Ω(δ, δ_H)`, `{O, H} = δ_H O` give the same bracket for the same 2-form: his Hamiltonian
   vector field is `{H,·}`, the paper's `δ_H` is `{·, H}`, and they differ by a sign in both places.
2. `γ` enters (A.28) with the sign opposite to `λ`, so at fixed `λ` the bracket is `{K, γ} = −δ²`.
   Chandrasekaran and Flanagan's (7.45d) is `{√q, b_r} = −8π δ²` in coordinates, the same sign if `b_r` is
   identified with `γ`. I did not verify that identification independently.

---

## Q2. The symplectic form on the capped null cone

### Q2.1 What the paper displays

(A.14) [a: L2500 to L2511], in units `K = ρ_S²/(8πG)`, for two null boundaries `H_L`, `H_R` through `S`:

```
Ω = Σ_j ∫_S ε₀ { ½ δλ∧δK + (1/16πG) δt̃_ji∧δs_j^i − ¼ δ^yK ∧ g(∂_v z_j, δ^y z_j)|_S
                 + (K/2) ∫_1^{b_j} v² g(∇_v δ°z_j ∧ δ°z_j) dv }
δ^y z = δz − L_ξ z,  ξ_j = δs_j∘s_j^{-1},  δ°z = δ^y z − (v/2) δ^y log(ρ_S²) ∂_v z        [a: L2496]
```

This is Reisenberger's (6) summed over the two branches, with `ρ₀ → ρ_S²`, `e_ab → z`, `v̄_A → b_j`
[b: 0712.2541 (6); `∂_v e_ab δe^{ab} = −2 g(z', δz)` by (4.21b)] [c]. With `s_L = id`, `Y = s_R`,
`p_i = t̃_Ri/(16πG)` the corner terms are (A.16) [a: L2484, L2490, L2520].

Reisenberger derived (6) for variations that keep the area density at the outer cut fixed
[b: 0712.2541, condition (B) on the set `C`]; that is the paper's first specification of the cut, (A.17a)
[a: L2525, L2528]. The capped cone of (3.18) uses a different one: `b = ε` fixed, so the area density at
the cut is `ε²ρ_S²` and varies with `ρ_S²`. The cone block therefore has to be rederived for `b = ε`. I do
that from (A.30a).

### Q2.2 The cone block from (A.30a) [c]

Step 1. (A.30a) [a: L2612 to L2613], per generator, for a parameter `v` and variations at fixed `v`:

```
Θ = (1/8πG) ∫ [ −μ δ(ρ²) + (ρ²/2) g(∂_v z, δz) ] dv + Θ_∂ ,     μ = κ + ∂_vρ²/(2ρ²)
```

Step 2. Take `v = ρ/ρ_S` [a: L569], so `ρ² = ρ_S² v²` and `δ(ρ²) = v² δ(ρ_S²)` at fixed `v`.

Step 3. (A.30b) [a: L2614] with `ρ² = ρ_S² v²` reads `2ρ_S² − 2vρ_S² μ + (ρ_S² v²/2) g(z',z') = 0`, so
`μ = 1/v + (v/4) g(z',z')`. This agrees with (A.23d), `κ_v = (v/4) g(z',z')` [a: L2570], and with (3.26a).

Step 4. Integrating from `ε` to `1` and over `S`:

```
Θ_cone = ∫_S ε₀ [ K α_ε − N_ε δK ] ,     N_ε = ∫_ε^1 v² μ dv = (1 − ε²)/2 + M_ε
```

Step 5. Exterior derivative. Two identities are needed:
`δ( g_αβ z'^α δz^β ) = g(∇_v δz ∧ δz)` (the Christoffel terms of (A.15) are exactly the terms from
`δg_αβ`, because the part of `Γ_{βμν}` symmetric in the two wedge indices drops) and
`δ g(z',z') = 2 g(z', ∇_v δz)`. Then, since `δ(−N δK) = δK∧δN`,

```
δΘ_cone = ∫_S ε₀ { K δα_ε + δK∧α_ε + δK∧δM_ε }
δα_ε = ½ ∫ v² g(∇_v δz ∧ δz) dv ,     δM_ε = ½ ∫ v³ g(z', ∇_v δz) dv
```

Both identities are checked numerically for two polarizations with the curved `g` in script check A3.

### Q2.3 Agreement with (A.14) [c]

Claim. With the cut at fixed area density, `δ(b²K) = 0`, the one-sheet third and fourth terms of (A.14)
equal `−δΘ_b`, where `Θ_b = Kα_b − N_b δK` is the potential of Q2.2 with lower limit `b`.

Proof. Write `ζ = δ^y z`, `a = δ^yK/K`, so `δ°z = ζ − (v/2) a z'`. Then
`g(∇_vδ°z ∧ δ°z) = g(∇_vζ∧ζ) + a ∧ [ (v/2) g(z',∇_vζ) − ½ g(z',ζ) − (v/2) g(∇_v z', ζ) ]`
(the `a∧a` term vanishes). Multiply by `(K/2) v²`, integrate from `1` to `b`, and integrate the first
bracket term by parts. With the third term of (A.14) this gives

```
(A.14), one sheet, terms 3 + 4
  = −(K/2) ∫_b^1 v² g(∇_vζ∧ζ) dv − δ^yK ∧ (α_b + δM_b)[ζ] − (b³/4) δ^yK ∧ g(z', ζ)|_{v=b}
```

On the other side, with a variable limit `b`,
`δΘ_b = K δα_b + δK∧(α_b + δM_b) − (K/2) b² δb ∧ g(z',δz)|_b − (b + (b³/4) g(z',z')|_b) δK∧δb`,
and `δb = −(b/2K) δK` turns the last two terms into `+(b³/4) δK∧g(z',δz)|_b`. The sum of the two displays
is zero. ∎ (Script checks A1 symbolically, A3 numerically with both polarizations.)

Consequences.

- The paper's two presentations, (A.14) [Reisenberger] and (A.30) [Hopfmüller and Freidel], agree term by
  term, including the coefficient of the term at `S`. The overall sign is the orientation of `∫_1^b` for
  `b < 1`.
- For `b = ε` fixed (cap condition (3.18)) the term `−(b³/4) δK∧g(z',δz)|_b` is absent: it came from the
  motion of the cut. A literal substitution `b_j = ε` in (A.14) would keep it. The difference is one mixed
  term located at the cap edge (script check A2). It has the form `δK∧(…δz)` and plays no role in Q3.

### Q2.4 Agreement with (3.42) [c]

(3.42b) [a: L718 to L719] is `Ω = ∫ε₀[K δα + K δΥ + δK∧(α − 2δJ + δΓ + Υ)]`. With `2J = Ξ(1) − M`:

```
(3.42b) = δ[ K α − M δK ] + δK ∧ δ( Γ − Ξ_y(1) ) + (terms with Υ)
```

so (3.42b) is the cone block of Q2.2 with the opposite overall sign to (A.14), and the variable that stands
where `λ` stands in (A.16) is `Γ − Ξ_y(1)`. This matches the geometry: `∂_v = (∂_v u) ℓ` and, from (3.26b),
(3.26d), `∂_v u = (ρ_S/p_ε) e^{Ξ_y(v)}`, so for affinely normalized `ℓ_L`, `ℓ_R`

```
λ = −log|ℓ_L·ℓ_R| − Σ_{j=L,R} [ log(ρ_S/p_{ε,j}) + Ξ_j(1) ]
```

The area-frame angle `λ` differs from an affine-frame angle by the focusing integrals `Ξ(1)`. In the
truncated model of Q5 the statement "`Ω_(3.42b)` equals minus the Q2 form under `λ = Γ − Ξ_y(1)`" is
verified exactly (script output Q5.6, last line).

I also rederived (3.42a) from (3.39) at fixed affine parameter, to see what is new for `ε > 0`. With `κ = 0`
and `Θ_(ℓ) = 2∂_uρ/ρ`, (3.39) gives `(1/16πG)∫du[ρ² g(∂_u z, δ_u z) − 4 ∂_uρ δ_uρ]`. Writing
`δ_u z = δ_v z + z' δ_u v`, `δ_u v = −(∂_u v) δ_v u`, using `(vΞ' − 1)e^{−Ξ} = −∂_v(v e^{−Ξ})` and
`∫_ε^1 v δΞ(v) dv = δJ_ε`:

```
Θ_H − Θ_∂ = ∫ε₀ { K(α_ε − 2δJ_ε) + (1 − ε²) K δ log p_ε − (1 − ε²) δK } + (1/8πG) ∫ε₀ [ ∂_uρ² δu ]_{v=ε}^{v=1}
```

The first term is (3.42a). The last term is the one the paper says cancels at `v = 1` [a: L710]. For
`ε > 0` there is in addition `(1 − ε²) K δ log p_ε` and the endpoint term at `v = ε`. The fixed-`v`
potential of Q2.2 minus this one is `(1/8πG)[ρ² δ log(∂_v u) − ∂_uρ² δu]` taken between the two ends, plus
the exact term `−δ(K M_ε)`: the same structure as the end terms of (A.32) [a: L2632 to L2634].

### Q2.5 The joint term [c from a]

With (A.17c), `μ_C = b² ρ_S² ε₀`, the potential (A.18) is `−ε_C ∫ε₀ β_C δ(b²K)`, `β_C = log(−n_C·ℓ)`. Its
exterior derivative is `−ε_C ∫ε₀ δβ_C ∧ δ(b²K)`. For the cap condition `b = ε`:

```
Ω_joint = −ε_C ε² ∫_S ε₀ δβ_C ∧ δK
```

Since `ℓ = p_ε ∂_ρ` at the cap edge, `β_C = log(−n_C·∂_ρ) + log p_ε`: the normalization `p_ε` enters the
joint term and the term `(1 − ε²)Kδlog p_ε` of Q2.4 only through the variable conjugate to `K` [c].

### Q2.6 The assembled form

Cap condition (3.18), one capped cone, sign conventions of (A.14) and (A.16), `ζ = δ^y z = δz − L_ξ z`,
`κ = δ^yK = δK − ∂_A(K ξ^A)` (area density; compare (B.24) [a: L2943]), `ξ = 0` on the cone whose generators
are used as labels and `ξ^A = δY^i ∂y^A/∂Y^i` on the other:

```
Ω_𝒜 = ∫_S ε₀ {  [T1]  δ(λ − γ) ∧ δK
               [T2] + δp_i ∧ δY^i
               [T3] − (K/2) ∫_ε^1 v² g(∇_v ζ ∧ ζ) dv
               [T4] − ½ κ ∧ ∫_ε^1 v² g(z', ζ) dv
               [T5] − ½ κ ∧ ∫_ε^1 v³ g(z', ∇_v ζ) dv
               [T6] − ε_C ε² δβ_C ∧ δK  }
restricted to ∫_S ε₀ δK = 0, and with (λ − γ) defined modulo a constant on S.
```

Where each term comes from:

- **T1** (A.14) first term summed over `j`, which is (A.16) [a: L2503, L2520]; the frame boost `γ` enters
  through (A.28), `−Kδ(λ − γ)` [a: L2599]. Reisenberger (6), (9) [b].
- **T2** (A.14) second term with `s_L = id`, (A.12d), (A.16) [a: L2484, L2490, L2504, L2520].
- **T3** radiative term: (A.14) fourth term with `δ°` replaced by its `δ^y` part, equal to `−Kδα_ε` of
  (A.30a) and (3.42b) [a], [c: Q2.2, Q2.3].
- **T4, T5** the `δK`-`δz` terms: the `δ°` expansion of the fourth term of (A.14) together with its third
  term, equal to `−δK∧(α_ε + δM_ε)`, which is `δ` of `−N_ε δK` in (A.30a) [c: Q2.2, Q2.3], at fixed
  `b = ε`.
- **T6** (A.17c) and (A.18) at `b = ε` [a: L2530, L2535], [c: Q2.5].

Remarks on what is and is not in this formula.

1. (A.14) sums over both null boundaries through `S`. Each carries its own block T3 to T5 with its own
   `z_j`. Only one block is written because the question is about one capped cone; T1 has the coefficient
   of the two-sided sum, as in (A.16) [d1]. With this normalization the form reproduces two statements I
   did not use to build it [c]: the bulk part of Reisenberger's (17), `{z, λ} = (v/2K) z'` (the field
   `V^K = −1`, `V^z = −(v/2K) z'` contracts T3 to T5 to end terms only, script check A5); and the
   coefficient `1/(2K v w)` of the kernel stated after (A.36) [a: L2668] (for one polarization T3 is
   `K ∫ δ₁z · v∂_v(v δ₂z) dv` up to end terms, and the inverse of `−K v∂_v v` is
   `−sgn(v − w)/(2K v w)`; I fix only the magnitude, not the sign convention of the kernel).
2. Not included, because the paper does not display them: the symplectic form of the data in the interior
   of the cap, and the pieces of `Θ_∂` that depend on the normalization of `ℓ` (Q2.4, Q2.5). [d3]
3. If the cut is instead at fixed area density (A.17a), `b` varies, T6 is absent (`δμ_C = 0`) and the mixed
   term of Q2.3 at `v = b` is present. If the cut is at fixed affine coordinate (A.17b), `b` is a further
   variable and T6 becomes `−ε_C δβ_C∧δ(b²K)`.

### Q2.7 Every mixed term

T4 and T5 can be written as `−κ∧(α_ε + δM_ε)[ζ]`. Integrating T5 by parts gives the equivalent form with
explicit end terms,

```
T4 + T5 = −½ κ∧g(z', ζ)|_{v=1} + (ε³/2) κ∧g(z', ζ)|_{v=ε} + κ ∧ ∫_ε^1 [ v² g(z', ζ) + ½ v³ g(∇_v z', ζ) ] dv
```

Expanding `ζ` and `κ` in the independent variations, by type:

| Pair | Terms |
|---|---|
| `(λ − γ, K)` | T1 |
| `(β_C, K)` | T6 |
| `(p, Y)` | T2 |
| `(z, z)` | `−(K/2)∫v² g(∇_vδz∧δz)` |
| `(K, z)` | `−δK∧(α_ε + δM_ε)[δz]`. In (3.42b) these are the terms `δK∧α` and `−2δK∧δJ` [a: L725], up to the shift of `Γ` by `Ξ(1)`. |
| `(K, Y)` | `+δK∧(α_ε + δM_ε)[L_ξ z]` |
| `(Y, z)` | `+∂_A(Kξ^A)∧(α_ε + δM_ε)[δz] + (K/2)∫v²[ g(∇_vδz∧L_ξz) + g(∇_vL_ξz∧δz) ]` |
| `(Y, Y)` | `−∂_A(Kξ^A)∧(α_ε + δM_ε)[L_ξz] − (K/2)∫v² g(∇_vL_ξz∧L_ξz)` |

The `(K,z)`, `(K,Y)`, `(Y,z)` rows are the mixed terms of [a: L2523]. There is no term in which the
variation of `λ`, `γ` or `β_C` is wedged with anything other than `δK`. In the paper this is visible in
(A.14) (only the first term contains `δλ`), in (3.42b) (`δΓ` only in `δK∧δΓ`) and in (A.18) [a].

### Q2.8 Fixed total area [c]

Fixing `𝒜 = 8πG ∫Kε₀` restricts to `∫δKε₀ = 0`. The restricted form is then degenerate along a constant
shift of `λ − γ`; the reduced phase space is the quotient. This matches the statement that a uniform boost
acts by a phase on the fixed-area space [a: L1034]. Functions of `K`, `Y`, `p`, `z` descend to the quotient;
of `λ − γ` only the non-constant part does.

---

## Q3. The Hamiltonian vector field of `X = ∫_S φ K ε₀`

`φ` real, `∫φε₀ = 0`, not constant. `δX = ∫φ δK ε₀`.

Conventions. The paper's (3.32), (3.33) define `δ_X` by `Ω(δ, δ_X) = δX` and `{O, X} = δ_X O`. The equation
as posed, `Ω(V_X, ·) = δX`, is solved by `V_X = −δ_X = {X, ·}`. I give `V_X`; then `{X, F} = V_X(F)` and
`δ_X F = {F, X} = −V_X(F)`.

Solving [c]. Let `V` have components `(V^λ, V^γ, V^K, V^Y, V^p, V^z, V^β)`, and write `ξ_V = ξ(V^Y)`,
`ζ_V = V^z − L_{ξ_V} z`, `κ_V = V^K − ∂_A(Kξ_V^A)`. Contracting Q2.6:

```
Ω_𝒜(V, ·) = ∫ε₀ { (V^λ − V^γ) δK − V^K δ(λ − γ)                                  [T1]
               + V^{p_i} δY^i − V^{Y^i} δp_i                                     [T2]
               − (K/2) ∫ v² [ g(∇_vζ_V, ζ) − g(∇_vζ, ζ_V) ] dv                   [T3]
               − κ_V (α_ε + δM_ε)[ζ] + κ (α_ε + δM_ε)[ζ_V]                        [T4+T5]
               − ε_C ε² ( V^β δK − V^K δβ_C ) }                                  [T6]
```

This must equal `∫φ δK ε₀` for all variations tangent to the fixed-area surface. Comparing coefficients:

1. of `δ(λ − γ)` and `δβ_C`: `V^K = 0` (a constant is excluded by `∫V^K ε₀ = 0`);
2. of `δp_i`: `V^{Y^i} = 0`, hence `ξ_V = 0`, `κ_V = 0`, `ζ_V = V^z`;
3. of `δz`: `−(K/2)∫v²[g(∇_vV^z, δz) − g(∇_vδz, V^z)]dv = 0` for all `δz`. Integrating by parts this is
   `−K∫ g(δz, v∇_v(vV^z)) dv + (K/2)[v² g(δz, V^z)]_ε^1 = 0`, so `∇_v(vV^z) = 0` and `V^z = 0` at the ends,
   hence `V^z = 0`;
4. of `δY^i`: with 1 to 3 the only remaining term is `V^{p_i} δY^i`, so `V^{p_i} = 0`;
5. of `δK`: `V^λ − V^γ − ε_C ε² V^β = φ + const`.

Result.

| Coordinate | Component of `V_X = {X, ·}` |
|---|---|
| `λ − γ` (the corner variable of (A.16), (A.28)) | `φ(y)` modulo a constant, when `β_C` is held fixed |
| `ρ_S²`, `K` | `0` |
| `f_S` of (4.23) | `0` (it is a function of `K`) |
| `Y^i` | `0` |
| `p_i` | `0` |
| `z^α(v, y)` at fixed `v` | `0` |
| joint variable `β_C` | not fixed by T1 to T6: only `V^λ − V^γ − ε_Cε² V^β = φ` is. The assembled form is degenerate along `(δλ, δβ_C) = (ε_Cε², 1) c(y)`. `V^β = 0` is a solution, and it is the solution if the cap terms the paper does not display remove that degeneracy without involving `δλ`. |

So `V_X = ∫_S ε₀ φ(y) δ/δ(λ − γ)(y)`, a pure shift of the boost variable. In the paper's convention
`δ_X(λ − γ) = −φ`, that is `δ_X γ = +φ` at fixed `λ`: `X` boosts the boundary frame by the rapidity `φ(y)`,
consistent with (3.51). It has the same sign as Chandrasekaran and Flanagan's (7.46) if their `b_r` is
identified with `γ`. In the chart of (3.42b) the same field is `V_X = −φ δ/δΓ` at fixed `(K, z)`.

A consequence in a different chart [c]: `p_i` fixed means `t_R = ρ_S²(dλ − ϖ_L + ϖ_R)` fixed (A.12b), so the
twist changes by a gradient, `V_X(ϖ_L − ϖ_R) = dφ`, as in (3.62d).

Brackets.

| Bracket | Value | Basis |
|---|---|---|
| `{X, K(y')}` | `0` | [c]; [b: Reisenberger, `ρ₀` commutes with all data but `λ`] |
| `{X, f_S(y')}` | `0` | [c] |
| `{X, z^α(v, y')}`, fixed `v` | `0` | [c]; [b: same statement of Reisenberger] |
| `{X, Ξ_{y'}(v)}` (3.26c) | `0` | [c]: functional of `z(·, y')` only |
| `{X, u_*(y')}` (3.27) | `0` | [c]: function of `ρ_S(y')` and `Ξ_{y'}` only |
| `{X, ū_*}` (3.28) | `0` | [c] |
| `{X, (λ − γ)(y')}` | `φ(y')` modulo a constant | [c]; [b: Reisenberger (9)] |

All of the zeros are exact statements about functionals on the phase space, not leading orders.

For contrast, the conjugate variable does not commute with the clock ingredients: from Q2.6,
`{z(v,y), λ(y')} = δ²(y,y') (v/2K) ∂_v z` in the bulk (script check A5; Reisenberger (17)), so
`{Ξ, λ} ≠ 0` and `{u_*, λ} ≠ 0`. Also, observables placed at a fixed affine distance from `S` in the
boosted frame do change under `V_X` [a: L1085]; `z` at fixed `v`, `Ξ` and `u_*` are not of that kind.

What the result rests on. Only one property of the form is used: the variation of the boost variable
appears in no term other than its wedge with `δK`. Every mixed term of Q2.7 is irrelevant to `V_X`, and so
are the orientation sign of the cone block, `ε_C`, and the coefficient of the term at the cap edge.

---

## Q4. The quantum side

### Q4.1 What the text gives

- Both radiative polarizations and the independent corner variables on `S` are expanded "in a countable
  basis of canonical pairs" `(q_j, p_j)` [a: L1034]; the Hilbert space is a product of `L²(ℝ, dq_j)` with
  Gaussian factors (4.7).
- The area element over `8πG` is conjugate to the local relative boost angle `γ = Γ_R − Γ_L`, and one
  excitation can change fluctuations both in a graviton polarization and in differences of `γ` across `S`
  [a: L1076].
- `Ξ` is quantized after the derivatives of `q̄` are expressed in canonical variables `φ^I`; the Weyl
  relations (4.20) use the inverse reduced symplectic form `J^{IJ}`; a function `f` of the boundary fields
  is written as `f∘ι_t` in canonical variables and Weyl ordered [a: L1171 to L1177].
  `J^{IJ} = {φ^I, φ^J}` [a: L1530].
- `ẑ^α = Q(z^α)` [a: L1187], `f̂_S(y) = Q(f_S(y))` [a: L1203], `ρ̂_S² = 𝒜 ŵ_y` with `ŵ_y` built from
  `e^{f̂_S}` (4.24).
- The full symplectic form (A.14) is said to determine the brackets of bulk and edge variables and hence
  the normalization of the canonical variables of Section 4 [a: L2707].
- In the perturbative example the radial modes of `x = v h` are canonical with weight `ρ_S²/G`
  [a: L1397, L3489, L3499, L3505 to L3507].

The paper never writes `f_S(y)` or `z^α(v, y)` as explicit functions of `(q_j, p_j)`. It states only that
they are functions on the reduced phase space and are Weyl ordered.

### Q4.2 What Q2 gives [c]

At fixed angular identification and with `𝔏 = λ − γ − ε_Cε²β_C`, Q2.6 is

```
Ω_𝒜 = ∫ε₀ { δ(𝔏 + M_ε) ∧ δK − δ( K α_ε ) }
```

(`−δK∧δM_ε = δM_ε∧δK`, and `−Kδα_ε − δK∧α_ε = −δ(Kα_ε)`). On each generator choose Darboux coordinates
`(Q_n, P_n)` for the `K`-independent one-form `α_ε`, `α_ε = Σ P_n δQ_n + δG`. Then
`−δ(Kα_ε) = Σ δQ_n∧δ(K P_n) + δG∧δK`, and

```
Ω_𝒜 = ∫ε₀ { δ(𝔏 + M_ε + G) ∧ δK + Σ_n δQ_n ∧ δ𝒫_n } ,     𝒫_n = K(y) P_n
```

After smearing in `y` with an orthonormal basis this is a Darboux chart ("chart I"):

- `K(y)` is itself a canonical coordinate, with conjugate `𝔏 + M_ε + G`. Hence `f_S(y)`, which at fixed
  `𝒜` is `log K(y)` plus a constant, is a function of the `K` coordinates only.
- `z^α(v, y) = z^α[Q(y), 𝒫(y)/K(y)]`: a function of the radiative pairs on the generator and of `K(y)`, and
  independent of the momentum conjugate to `K`. For one polarization `g` is flat and `(Q_n, P_n)` are linear
  in `x = v z`, as in (D.43); for both polarizations the target is curved and `(Q_n, P_n)` are nonlinear in
  `z`. Rescaling both `Q` and `P` by `√K` instead (the paper's perturbative normalization) is an
  equivalent chart.
- In the truncated model the chart is explicit: `(q₁, p₁) = (k, Λ)`, `(q₂, p₂) = (ã₁, w ã₂)` with
  `ã_i = √(K₀c₀ + c₁k) a_i` (script output "Q4").

The cotangent lift of `K = (𝒜/8πG) e^{f}/∫e^{f}ε₀` gives "chart II", in which the non-constant modes of
`f_S` are the coordinates and range over `ℝ`.

### Q4.3 Linear or nonlinear

`X = ∫φKε₀` is a **linear** function of the canonical coordinates in chart I. In chart II it is the
**nonlinear** function `X = (𝒜/8πG) ∫φ e^{f_S}ε₀ / ∫e^{f_S}ε₀` of the `f_S` modes, and of nothing else. The
text does not say which chart is used: (4.23), (4.24) treat `f̂_S(y)` as the elementary operator, which
suggests chart II, but that is not stated. In both, `X` depends only on one set of mutually commuting
coordinates.

### Q4.4 Commutators with the product (C.9)

From (C.9), with `P_n(f,g)` the `n`-th power of the bidifferential operator `←∂_I J^{IJ} →∂_J`
(`P_1 = { , }`):

```
Q(X) Q(F) − Q(F) Q(X) = Q( X⋆F − F⋆X ) ,
X⋆F − F⋆X = iħ {X, F} − (iħ³/24) P_3(X, F) + O(ħ⁵)
```

- Chart I: `X` is linear, so `P_n(X, F) = 0` for `n ≥ 2` and the commutator is exactly `iħ Q({X, F})`,
  which is zero for `F = f_S(y)` and `F = z^α(v, y)` by Q3. `e^{itQ(X)}` is then a Weyl operator
  `D(·)` of (4.20) and commutes exactly with `Q(f_S(y))` and `Q(z^α(v, y))`.
- Chart II: `X` depends only on the coordinates `q_a` (the `f_S` modes), and `F` does not depend on the
  conjugate momenta `p_a` (for `F = z` this is `{q_a, z} = ∂z/∂p_a = 0`). Every term of the series
  contains derivatives of `X` contracted through `J` with `p_a` derivatives of `F`, so
  `X⋆F = XF = F⋆X` to all orders. Directly: `Q(X) = X(q̂)` is a multiplication operator and `Q(F)` acts at
  fixed `q_a`. Again `e^{itQ(X)} = Q(e^{itX})` commutes exactly with `Q(f_S(y))` and `Q(z^α(v, y))`.
- The same holds in any chart related to I or II by a linear symplectic map, since Weyl ordering is
  covariant under those.
- In a Darboux chart related to these by a nonlinear canonical map the classical bracket still vanishes but
  the commutator need not: the first term that can survive is `−(iħ³/24) Q(P_3(X, F))`, order `ħ³`. The
  script shows an example ("chart III") with `P_1 = 0` and `P_3 ≠ 0`.

Answer. `e^{itX}` commutes exactly with `Q(f_S(y))` and with `Q(z^α(v, y))` provided the canonical pairs
of Section 4.2 are related linearly to a chart in which the modes of `K` or of `f_S` are coordinates [d6].
The paper does not state this. If it fails, the commutator first fails to vanish at order `ħ³`.

In the exact case `ρ̂_S(y)` and `Ξ̂_y(v)` commute, so the symmetric placement of `ρ̂_S` around `e^{Ξ̂}` in
(4.26) would not be needed for those two factors. The paper speaks of "the noncommuting operators" in
(4.26) [a: L1583, footnote] without saying which pairs it means, so this does not settle [d6] either way.

---

## Q5. Finite check

Script `q5_truncation.py`, output `q5_truncation_output.txt`.

### Q5.1 Truncation

```
K(y) = K₀ + k 𝒴(y),   λ(y) = l 𝒴(y) (mod const),   z¹(v,y) = W(y) [a₁ R₁(v) + a₂ R₂(v)],   z² = 0
𝒴 = Y₂₀ (j = 2, ∫𝒴² ε₀ = 1),  W = 𝒴,  R₁ = v,  R₂ = v²,  K₀ = 𝒜/(32π²G) fixed,  φ = 𝒴,  X = k
```

Coordinates `(l, k, a₁, a₂)`. `W` must satisfy `c₁ = ∫𝒴W²ε₀ ≠ 0`, otherwise the mixed term is projected
out; here `c₁ = √5/(7√π)`. The matrix is computed by evaluating T1, T3, T4, T5 of Q2.6 on the coordinate
vector fields (angular and radial integrals done by sympy), not from a pre-simplified formula.

### Q5.2 Symplectic matrix at a general point `(l, k, a₁, a₂)`

`Ω_IJ = Ω(∂_I, ∂_J)`, order `(l, k, a₁, a₂)`:

```
        (  0     1     0     0  )
Ω  =    ( −1     0   −m₁   −m₂  )
        (  0    m₁     0     r  )
        (  0    m₂    −r     0  )

m₁ = (c₁/20) [ 5 a₁ (1 − ε⁴) + 8 a₂ (1 − ε⁵) ]
m₂ = (c₁/10) [ 3 a₁ (1 − ε⁵) + 5 a₂ (1 − ε⁶) ]
r  = (K₀ + c₁ k)(1 − ε⁵)/10 ,      c₁ = √5/(7√π)
```

It is antisymmetric and closed (checked), `det Ω = r²`. `m₁`, `m₂` are the `(K, z)` mixed terms T4 + T5;
`r` is the radiative term T3 and depends on `k`.

Poisson matrix `P = Ω⁻¹`, `{φ^I, φ^J} = P^{IJ}`:

```
{k, l} = 1,   {k, a₁} = 0,   {k, a₂} = 0,
{l, a₁} = −m₂/r,   {l, a₂} = m₁/r,   {a₁, a₂} = −1/r
```

The row of `k` is `(1, 0, 0, 0)`: `{k, ·} = ∂/∂l`.

### Q5.3 Brackets of `X` with the clock ingredients (sympy, exact)

```
{X, l} = 1                    {X, k} = 0         {X, a₁} = 0        {X, a₂} = 0
{X, K(y')} = 0                {X, f_S(y')} = 0   {X, f_S(y₁) − f_S(y₂)} = 0
{X, z(v', y')} = 0            {X, Ξ_{y'}(v')} = 0
{X, u_*(y')} = 0              {X, ū_*} = 0
```

`f_S(y') = log K(y') + c(k)` with an arbitrary function `c`, since (4.23) fixes `f_S` only up to a constant.
`u_*` and `ū_*` are kept as unevaluated integrals of `exp Ξ`.

For contrast the boost mode does not commute with them:
`{l, K(y')} = −𝒴(y')`, `{l, a₁} = −m₂/r`, `{l, a₂} = m₁/r`, and `{l, z}`, `{l, Ξ}` are the nonzero
expressions printed in the output. Numerically at `ε = 0.2`, `K₀ = 1`, `8πG = 1`, `k = 0.3`, `a₁ = 0.7`,
`a₂ = −0.4`, with quadrature and finite differences:

```
u_*(cos θ' = 0.3) = 0.7720585 :   {X, u_*} = 0.0,   {l, u_*} = 0.0954768
ū_*               = 0.8009981 :   {X, ū_*} = 0.0,   {l, ū_*} = −0.0046759
```

### Q5.4 Variants (all give `{k, a_i} = 0`, `{k, k} = 0`, `{k, l} = 1` up to the sign convention)

- opposite orientation sign of the cone block;
- the literal `b = ε` substitution in (A.14), with the extra term at the cap edge;
- other radial modes, `R₁ = 1/v`, `R₂ = v³ − v`;
- the chart of (3.42b), coordinates `(Γ₁, k, a₁, a₂)`: `{k, Γ₁} = −1`, `{k, a_i} = 0`, and
  `Ω_(3.42b) = −Ω_Q2` under `l = Γ₁ − ∫𝒴 Ξ_y(1) ε₀` (exact);
- adding the joint mode `β_C = b_C 𝒴`: the 5 by 5 matrix has rank 4 with kernel `(ε_Cε², 1, 0, 0, 0)` in
  the order `(l, b_C, k, a₁, a₂)`, and the general solution of `Ω(V_X, ·) = δX` is
  `V^k = V^{a₁} = V^{a₂} = 0`, `V^l = 1 + ε_Cε² V^{b_C}`.

### Q5.5 Moyal terms in the truncated model

Chart I (`X = q₁`): `P₁ = P₃ = P₅ = 0` against `a₁`, `a₂`, `f_S`, and a quadratic in `a` of the type of `Ξ`.
Chart II (`k = κ tanh q₁`): `P₁ = P₃ = P₅ = 0` against `a₁`, `f_S`.
Chart III (`Q = k + ηΛ³`, `P = Λ`, a nonlinear canonical map): `P₁ = 0` and

```
X⋆a₁ − a₁⋆X = (15 i c₁³ η ħ³ q₂) / (32 (K₀c₀ + c₁(q₁ − η p₁³))^{7/2}) + O(ħ⁵)
```

### Q5.6 What the truncation drops

- all other angular harmonics of `K` and of `λ − γ`, and with them the coupling between harmonics that
  `K(y)` times the radiative density produces (it is projected on `𝒴`);
- the second polarization, hence the curvature of `g` and the parallel transport in (A.15), (A.36);
- the angular pairs `(Y^i, p_i)` and every Lie derivative term;
- all radial modes but two, so the bracket of `λ` with `z` is only the projection of `(v/2K)∂_v z`;
- the interior of the cap; the joint variable is kept only in the last variant;
- the other null boundary through `S`;
- the positivity `K(y) > 0`, which restricts `k` to an interval.

None of these touches the property used in Q3, which the truncation inherits term by term.

---

## 6. Assumptions of type (d), and the weakest step

- **[d1]** The corner terms are taken as in (A.16), with the coefficient of the two-sided sum of (A.14),
  while one cone's block T3 to T5 is displayed. The other null boundary adds its own block and nothing
  containing `δλ`.
- **[d2]** For the cap condition `b = ε` the cone block is `−δ(Kα_ε − N_εδK)` from (A.30a). The terms of
  `Θ_∂` proportional to the displacement `δu` of a cut are assumed to cancel at `v = ε` as the paper says
  they do at `v = 1` [a: L710]. This affects only `(K, z)` terms located at the cap edge. The terms with
  an angular displacement (`ξ ≠ 0`) are taken over from (A.14) by its replacement of `δ` by `δ^y`; I did
  not rederive them.
- **[d3]** `β_C = log(−n_C·ℓ)` is treated as an independent coordinate, and the cap terms the paper does not
  display (interior of the cap, normalization of `ℓ`) are assumed to contain no `δλ` or `δγ`.
- **[d4]** The boost variable conjugate to `K(y)` is an independent coordinate of the fixed-area phase space
  of the capped cone, so that a shift of `λ − γ` at fixed `(K, Y, p, z(v,·), β_C)` is tangent to it.
- **[d5]** Fixed total area is imposed by restricting to `∫δKε₀ = 0` and quotienting by constant shifts of
  `λ − γ`.
- **[d6]** (Q4 only) The canonical pairs of Section 4.2 are linearly related to a chart in which the modes
  of `K` or of `f_S` are coordinates.
- **[d7]** Signs I could not fix from the paper: the orientation of the cone block relative to T1, and
  `ε_C`. Nothing in Q3 to Q5 depends on them (Q5.4).

**Weakest step: [d4].** The whole of Q3 follows from the boost variable being an independent coordinate.
Two remarks on what happens without it [c].

- If the boost variable is simply removed from (3.42b), the remaining form `Kδα + δK∧(α − 2δJ)` on
  `(K, z)` is degenerate on every generator: `W^K = K`, `W^z = −(δα)^{-1}(α − 2δJ)` is in its kernel, and
  `X` has no Hamiltonian vector field. (In the truncation: three variables, an antisymmetric 3 by 3
  matrix.) So the pair `(K, λ − γ)` is needed for `K(y)` to be a coordinate at all.
- If instead the frame at `S` were fixed relative to the geometry, `λ − γ` would become a functional of
  `(K, z, cap data)`: for one diamond the data on `H_p` and `Σ₀` determine the solution [a: L521], hence
  `λ`. Then `δ(λ − γ)∧δK` would contain `δz∧δK` and cap terms, `V_X` would acquire components along them,
  and the brackets with `z`, `Ξ`, `u_*` would not vanish in general.

The paper keeps the frame as an edge mode [a: L640 to L645, L707, L924, L1076], and with that [d4] holds.
What I could not verify from the paper is that no relation ties `λ − γ` to the other data on the capped
cone: (A.14) is imported from a setting with two free null sheets and fixed area density at the cuts, the
symplectic form of the cap is not displayed, and the reference cited for (3.64) derives the area and
boost-angle pair only at linear order about stationary backgrounds and leaves the general case open.

## 7. What is not decided

1. The component of `V_X` along the joint variable `β_C` (Q3): only the combination
   `V^λ − V^γ − ε_Cε²V^β = φ` is fixed by the displayed terms.
2. Which Darboux chart the quantization of Section 4 uses (Q4). The classical brackets are chart
   independent; exact commutation in the Weyl-ordered theory is not.
3. The overall orientation sign between the corner term and the cone block, and `ε_C`.
4. Whether anything in the unread parts of the references changes a convention in Q1: the later parts of
   Reisenberger gr-qc/0703134, Alexandrov and Speziale, Hopfmüller and Freidel, and Lehner et al. were not
   returned by the fetch tool. None of them is used in Q2 to Q5.

## Files

- `derivation.md` (this file)
- `check_A_identities.py`, `check_A_identities_output.txt`: checks A1 to A5 used in Q2 and Q3
- `q5_truncation.py`, `q5_truncation_output.txt`: Q5 and the Moyal checks of Q4
