> Copied into the repository on 2026-11-26 from the scratch folder of the first derivation agent of break
> attempt B6 (`handoff.md` Section 14.8), unchanged below this note. This derivation had the brief and
> finding F14. It was made by an AI model and has not been checked by an expert. Its script is
> `scripts/b6_first_check.py` (called `b6_check.py` below) and its output is
> `notes/b6-first-check-output.txt` (called `b6_check_output.txt` below).

# B6, first derivation: the Hamiltonian flow of a non-constant smearing of the area density on the capped null cone

Written 2026-11-26. One derivation, made alone from `paper/arxiv-src/main.tex`, the brief (`handoff.md` 14.8), the F14 block of `FIDELITY.md`, and the cited references read as HTML. It has not been checked by anyone else. The sympy script is `b6_check.py`, its output `b6_check_output.txt`, both in this folder.

Every statement carries one of four tags.

- **(a)** displayed in the paper; the line in `main.tex` is given.
- **(b)** taken from a cited reference; the reference and equation are given.
- **(c)** derived here; the steps are written out, and where a script part checks it the part is named.
- **(d)** an assumption I had to make.

Notation in this file. `d` is the exterior derivative on phase space (the paper's `δ`). `(da ^ db)(d1, d2) = d1 a d2 b - d2 a d1 b`. `zdot = d_v z`. `g(a, b) = g_{alpha beta} a^alpha b^beta` with `g = diag(1, exp(2 z^1))`, (4.21c). `D_v` is the covariant derivative along the curve `z(v)`, (A.15). `K(y) = rho_S(y)^2/(8 pi G)`, (3.43). `eps` is the cap parameter of (3.18); `eps_0` is the fixed area two-form on `S`.

## 0. Results in brief

1. **Q3, classical.** In the coordinates of (A.16), with `Lambda = lambda - gamma` the variable of (A.28), the Hamiltonian vector field of `X = int_S phi K eps_0` is `V_X = -phi(y) d/dLambda(y)` in the paper's convention (3.32), and every other component is zero: `K`, `f_S`, `Y^i`, `p_i`, `z^alpha(v, y)` on the cone, the joint variable and the cap data. All brackets of `X` with `K(y')`, `f_S(y')`, `z^alpha(v, y')`, `Xi_{y'}(v)`, `u_*(y')` and the average (3.28) are zero. This holds for the assembled form of Section 2.7, which contains one mixed term that (A.14) does not display. It rests on assumption (d1) of Section 6.
2. **Q4, quantum.** The paper does not display how `f_S(y)` and `z^alpha(v, y)` are written in the pairs `(q_j, p_j)`. From the Q2 form I construct a Darboux chart in which `K(y)` is itself a canonical coordinate, so `X` is linear, and there `e^{itX}` commutes exactly with `Q(f_S(y))` and `Q(z^alpha(v, y))`. The same exact statement holds in any chart in which the area distribution is a function of mutually commuting canonical coordinates only. In every chart the terms of order `hbar` and `hbar^2` of `[Q(X), Q(F)]` vanish; in a chart that is not of the kind just described the term of order `hbar^3` does not vanish in general. Which kind of chart Sec 4.2 uses is not decided by the text. The only place where the paper names a canonical pair containing the area density is line 2941, `(K(y), Pi_K)`.
3. **Q5.** The truncated symplectic matrix, its inverse and all brackets are in Section 5 and in the script output. All brackets of `X` with the clock ingredients vanish identically there.
4. **Side finding.** With the cap condition (3.18), the form (A.14) as displayed (integral to `b_j = eps` held fixed, no term at `v = eps`) is not closed. The missing term is T5' of Section 2.7, `+(eps^3/4) dK ^ g(zdot, dz)` at `v = eps` in the orientation of (A.16). It does not affect result 1.

## 1. Q1: conventions

What was read: the paper, Sec 3.1 to 3.6, Sec 4.2, 4.3, App A, App B, App C.2; Reisenberger arXiv:0712.2541 (all) and arXiv:1211.3880 (Sec 1, 2, 4.1, 4.2, 4.4, 4.5) via ar5iv; Carlip and Teitelboim gr-qc/9312002 (all) via ar5iv; Chandrasekaran and Flanagan arXiv:2309.03871 (abstract, Sec 1.4, 4.5, 7.2.1 to 7.3) via ar5iv; Speranza arXiv:1706.05061 (Sec 4 opening, Sec 6 opening) via ar5iv; Hopfmüller and Freidel arXiv:1802.06135 (Sec IV.B) via ar5iv. Not read: Reisenberger gr-qc/0703134, Donnelly and Freidel arXiv:1601.04744, Lehner et al. arXiv:1609.00207, Ciambelli, Freidel and Leigh, Alexandrov and Speziale. Statements below about the unread ones are only what the paper says of them.

| Source | Null normals and their normalization | Boost parameter and its sign | Cap and joint terms |
|---|---|---|---|
| Paper, Sec 3.1, 3.2 | `l_s^mu`: future directed generator of `H_p`, `H_q`, affinely parametrized (lines 437, 498); its normalization is fixed by the choice of a parameter on each cone (line 445). Transverse normal `n_s`, `n_s . l_s = -1` (line 445). At `S`: `n_p = l_q/(-l_p . l_q)`, (3.11). At a joint: (3.12). `kappa_s = -n_{s mu} l^a nabla_a l^mu`, (3.13a). Area coordinate `v = rho/rho_S`, `S` at `v = 1`, `dSigma_i` at `v = eps` (line 569) | none in these sections | Action (3.15a), lines 471 to 486: `(1/8 pi G)[ int_{Sigma_0} eps_Sigma K_0 - int_{Sigma_1} eps_Sigma K_1 + int_{dSigma_0} mu log(-n_0 . l_p) + int_{dSigma_1} mu log(-n_1 . l_q) - int_S mu log(-l_p . l_q/2) ]`; `I_H = (eps_s/8 pi G) int eta_s kappa_s`, `eps_p = 1`, `eps_q = -1`, (3.15b), (3.16). Cap condition `dA at dSigma_i = eps^2 dA at S`, (3.18) |
| Paper, Sec 3.3 | `l`, `n` with `l . n = -1`; `beta_a = -n_mu nabla_a l^mu`, (3.36a); null normals and angular coordinates first held fixed in (3.39) (line 685) | `Gamma` is the parameter of boosts of the boundary frame, and its conjugate momentum is `mu/(8 pi G)` (line 707). `Theta_S = (1/8 pi G) int_S mu (dGamma + Upsilon)`, (3.41); `Upsilon = (l_a dn^a - n_a dl^a)/(2(-l . n))`, (3.44). Under `l -> e^a l`, `n -> e^{-a} n`: `Upsilon = da` (c, Section 2.5 step 3). In `Omega`: `dK ^ dGamma`, (3.42b) | Smooth cone only (`eps = 0`, `p_{0,y} = 1`); no cap term in (3.42) |
| Paper, Sec 3.6 | `l_R = exp(gamma) Y^* l_L`, `n_R = exp(-gamma) Y^* n_L`, (3.61) | `gamma = Gamma_R - Gamma_L` (line 895); `K_+ dGamma_R - K_- dGamma_L = K dgamma`, (3.64); line 924 states that the relative boost `gamma` is conjugate to `K(y)` | none |
| Paper, App A.2 | Generators parametrized by `v_j`, `v_j = 1` at `S`; `lambda = -log abs(d_{v_L} . d_{v_R})` (line 2482). Null covector `l_a = -exp(psi) nabla_a t`, (A.7). `u = u(1, y) + exp(Gamma) s`, (A.23) | `(K(y), lambda)` a corner pair (line 2493); `Omega` contains `dlambda ^ dK`, (A.16). With `k_q = exp(Gamma_q) l_q`: `-K dlambda + K dgamma = -K d(lambda - gamma)`, (A.28). So `lambda` and `gamma` enter with opposite signs | Outer cut `C_j = {v_j = b_j}`; `b_j^2 = rho_{C_j}^2 abs(det grad s_j)/rho_S^2`, (A.17a); `dmu_C = [b^2 d(rho_S^2) + 2 rho_S^2 b db] eps_0`, (A.17c); cap potential contains `-(eps_C/8 pi G) int_C log(-n_C . l) dmu_C`, (A.18) |
| Paper, App B | `l = d_v` has inaffinity `d_v N/N` (line 2742), `N = -g_{tv}` of (B.1); `d_v log N = d_v Xi_y`, (3.55) | the boost angle is given as `log(c_L d N/2)` (line 2811); `Upsilon = (1/2) d log abs(c_L/d)`, where `c_L`, `d` are said to depend on the metric and on where the boundary lies (line 2939) | Cap and joint terms enter through (B.14a); not assembled |
| Reisenberger 0712.2541, 1211.3880 | Two branches `N_L`, `N_R` swept by the future null normal geodesics from a disk `S_0`, truncated at `S_L`, `S_R` (1211.3880 abstract and Sec 1). `n_A = d_{v^A}`, `v` the area parameter, `rho = rho_0 v^2`, `v = 1` on `S_0` (Sec 2.1). No other normalization. Sachs' affine parameters have `d_{eta^L} . d_{eta^R} = -1` | `lambda = -ln abs(n_L . n_R)` (Sec 2.2); by 1211.3880 (18), `lambda = ln abs(d_{eta^R} rho) + ln abs(d_{eta^L} rho) - 2 ln(2 rho_0)`, so `exp(lambda)` is one quarter of the product of the two expansions of `S_0`. `{rho_0(1), lambda(2)} = 8 pi G delta^2`, 0712.2541 (9), with `d phi = omega[{phi, .}, d]`, (5) | None. The Hilbert action is used without added boundary terms (0712.2541 after (6)). Admissible variations leave the area density `rhobar_A(y)` on the truncation surface `S_A` invariant and preserve a chart near `S_A` (1211.3880 Sec 4.1); test variations vanish near the boundary of `N` |
| Carlip and Teitelboim gr-qc/9312002 | No null normals. Slices `tau = const` meeting at `r = r_+` | Opening angle `Theta_E` defined by `(tau_2 - tau_1) N^2 = 2 Theta_E (r - r_+)`, (11); Lorentzian `Theta_E = i Theta`, (14). `dI = (2 pi - Theta_E) dA + ...`, (19); `Theta_E(x)` conjugate to `gamma^{1/2}(x)`, (21). Units `8 pi G = 1` | Surface term `2 pi A` at the horizon, (17), (18); no joints |
| Chandrasekaran and Flanagan 2309.03871 | Two null surfaces `S_+`, `S_-` meeting at `S_0`; normals defined up to rescaling; `alpha_+-` with `Lie_l alpha = kappa`, (4.46); fixed normals `L_+-` with `L_+ . L_- = -exp[alpha_+ + alpha_-]` at `S_0`, (4.51) | `b_+ = alpha_+` at `S_0`, `b_- = -alpha_-` at `S_0`, `b_r = b_+ - b_-`; so `b_r = ln(-L_+ . L_-)`, opposite in sign to Reisenberger's `lambda`. `omega` contains `(1/8 pi) int d sqrt(q) ^ d b_r`, (7.33); `{ln sqrt(q)(theta), 2 b_r(theta')} = -16 pi delta^2`, (7.45d). `int sqrt(q) w` generates `b_r -> b_r - 8 pi w`, Sec 7.3. `G = 1`. Derived for perturbations of stationary backgrounds; the general case is called open in their footnote 19 | No caps. The pair is described as the counterpart, for null boundaries, of the Hayward corner term (Sec 1.4) |
| Speranza 1706.05061 | not used | Vector fields that vanish on the boundary of `Sigma` act on its normal bundle with the points of the boundary held fixed (surface boosts); their Hamiltonian is `int_{dSigma} Q_W`, (6.7) | Extended potential `Theta = int_Sigma (theta + i_chi L) + int_{dSigma} Q_chi`, (4.8); this is the paper's (B.21) |
| Hopfmüller and Freidel 1802.06135 | Normal `L^a`, twist `omega_a` | `mu = kappa + theta (D-3)/(D-2)` conjugate to the conformal factor, (4.18); for `D = 4` this is the paper's `mu = kappa + d_v rho^2/(2 rho^2)` of line 2608 | Corner term `alpha_S` removed from the potential, (4.12) to (4.14) |

Dictionary between the paper and Reisenberger (c, by comparing (A.11) to (A.14) with 1211.3880 Sec 2 and (117)): `rho_S^2 = rho_0`, `K = rho_0/(8 pi G)`, `qbar_AB = e_pq`, `lambda = lambda`, `varpi_L - varpi_R = tau`, `t~_j = tau~_j`, `delta^o = delta^a` (called `delta^circ` in 0712.2541), `b_j = vbar_A`.

## 2. Q2: the symplectic form

### 2.1 Data

On the incoming cone `H_p` I use the coordinates `(v, y)`, `eps <= v <= 1`, of line 569. The induced metric is `q_AB = rho_S(y)^2 v^2 qbar_AB(v, y)` (a: (A.11), line 2479), and `qbar` is written with `z^1, z^2` as in (4.21a). Variations `d` are taken at fixed `(v, y)`. When the angular identification `s` varies, `d^y z = dz - Lie_xi z` with `xi = ds o s^{-1}`, and `d^o z = d^y z - (v/2) d^y log(rho_S^2) zdot` (a: (A.13), line 2497).

### 2.2 The null block, derived from (A.30)

Step 1 (c, from a). The constraint (A.30b), line 2614, with `rho^2 = rho_S^2 v^2` reads `2 rho_S^2 - mu 2 v rho_S^2 + (rho_S^2 v^2/2) g(zdot, zdot) = 0`, so

```
mu = 1/v + (v/4) g(zdot, zdot) = 1/v + kappa_v ,      kappa_v = (v/4) g(zdot, zdot) = d_v Xi_y(v).
```

The last two equalities are (A.23d), line 2570, and (3.26c) with (4.21b). Script A5 checks that the integrand of (3.26c) equals `(1/4) v g(zdot, zdot)`.

Step 2 (c, from a). In (A.30a), line 2612, `d(rho^2)` at fixed `v` is `v^2 d(rho_S^2)`. Dividing by `8 pi G`:

```
Theta_H = int_S eps_0 [ K alpha_eps - ( W_eps + (1 - eps^2)/2 ) dK ] ,
alpha_eps = (1/2) int_eps^1 v^2 g(zdot, dz) dv ,          W_eps = (1/4) int_eps^1 v^3 g(zdot, zdot) dv .
```

`alpha_eps` is the `alpha` of (3.42c) with lower limit `eps`. The term `(1 - eps^2)/2 dK` is exact.

Step 3 (c). Two identities, both checked symbolically for the target metric of (4.21c) (script A3, A4):

```
d[ g(zdot, dz) ] = g(D_v dz ^ dz) ,             d kappa_v = (v/2) g(zdot, D_v dz).
```

Step 4 (c). Taking `d` of `Theta_H`:

```
Omega_H = int_S eps_0 { (K/2) int_eps^1 v^2 g(D_v dz ^ dz) dv
                        + (1/2) dK ^ int_eps^1 [ v^2 g(zdot, dz) + v^3 g(zdot, D_v dz) ] dv }.          (N2')
```

Written on two variations: `Omega_H(d1, d2) = int eps_0 { (K/2) int v^2 [ g(D_v d1 z, d2 z) - g(D_v d2 z, d1 z) ] dv + (1/2)[ d1 K m(d2 z) - d2 K m(d1 z) ] }` with `m(dz) = int_eps^1 [ v^2 g(zdot, dz) + v^3 g(zdot, D_v dz) ] dv`. The contraction used: `d1(Theta_H(d2)) - d2(Theta_H(d1)) = d1 K alpha(d2 z) - d2 K alpha(d1 z) + K [d1(alpha(d2)) - d2(alpha(d1))] - d1 W d2 K + d2 W d1 K`, and `alpha(dz) + dW = (1/2) m(dz)` by step 3.

Step 5 (c). The same form in the variables of (A.13). Substituting `dz = d^o z + (v/2)(dK/K) zdot` and integrating `int v^3 g(D_v zdot, dz) dv` by parts:

```
Omega_H = int_S eps_0 { (K/2) int_eps^1 v^2 g(D_v d^o z ^ d^o z) dv
                        + (1/4) dK ^ g(zdot, dz) at v = 1
                        - (eps^3/4) dK ^ g(zdot, dz) at v = eps }.                                       (N2'')
```

Script C1 checks `(N2') = (N2'')` on generic quartic data for one polarization; script D checks it again after integration over the sphere in the truncation.

An equivalent reading of step 5 (c): `d^o z` is the variation of the conformal metric at fixed area radius `rho = v rho_S`, the bulk term is `int rho^2 g(D_rho dZ ^ dZ) drho` between `rho = eps rho_S` and `rho = rho_S`, and the two endpoint terms come from the variation of the two limits.

### 2.3 Checks of the null block against the paper and the references

- (c) against (3.42a). Since `W_0 - Xi(1) = -2J` (script B2) with `J` of (3.42d), `K alpha_eps - W_eps dK = K(alpha - 2 dJ + dXi(1))` up to an exact term at `eps = 0`. The extra `K dXi_y(1)` is the change of normal from `d_v` to the affine `l = (d_u v) d_v`, `log(d_u v)` at `v = 1` being `log(p_eps/rho_S) - Xi_y(1)` by (3.26b). With the affine normal (Section 2.5 step 7) the null integrand is `K(alpha_eps - 2 dJ_eps + (1 - eps^2) d log p_{eps,y})` up to an exact term, where `J_eps` is (3.42d) with lower limit `eps`. At `eps = 0`, `p_{0,y} = 1` this is the `alpha - 2 dJ` of (3.42a). So (3.42a) is reproduced, and its capped form contains the additional variable `log p_{eps,y}`.
- (b) against Reisenberger. 1211.3880 (117) reads `omega_R = (1/16 pi G) int_{S_0} d^2 theta { d1 lambda d2 rho_0 + d1 tau~_{R i} d2 s_R^i + (1/4) d1^y rho_0 d_v e_pq d2^y e^pq + (1/2) rho_0 int_1^{vbar} v^2 d1^a e^pq d_v d2^a e_pq dv } - (1 <-> 2)`. With `d_v e_pq de^pq = -2 g(zdot, dz)` (c, from (4.21b)) the third and fourth terms are the third and fourth terms of (A.14). So (A.14), per branch, is Reisenberger's (117). For a branch on which `v` runs from 1 at the corner to `b = eps < 1`, the null part of (A.14) is minus the first two terms of (N2''); the third term of (N2'') has no counterpart in (A.14).
- (c) against (A.36). Inverting the first term of (N2') at fixed `K` gives `{z^alpha(v), z^beta(w)}` with coefficient `1/(2 K v w)` times parallel transport. This is the coefficient stated at line 2668.
- (c) against Reisenberger's bracket (17). Script C5: with `V_K = psi`, `V_z = (psi/2K)(v zdot + zdot(1)/v)`, `Omega_H(dz, V)` reduces to a term at `v = eps` only. So in the bulk and at `v = 1` the form gives `{z(v, y), Lambda(y')} = (1/2K)[v d_v z + (1/v) d_v z at v = 1] delta(y, y')` for one branch and one polarization. The first term is 0712.2541 (17), `{mu, lambda} = 4 pi G rho_0^{-1} v d_v mu delta^2`, since `4 pi G/rho_0 = 1/(2K)`.

### 2.4 The cap condition and the term at `v = eps`

(b) In Reisenberger's derivation the truncation surface has fixed area density, so the outer limit of the bulk integral does not vary and `vbar` is the dependent quantity, 1211.3880 (52), which is the paper's (A.17a). (a) The paper's phase space instead fixes `b = eps`, (3.18), line 511. (c) Then `d b = 0`, `dmu_C = eps^2 d(rho_S^2) eps_0` by (A.17c), and the inner limit `rho = eps rho_S` of the bulk integral varies with `rho_S`. This produces the last term of (N2''). Script C2 shows that (N2') minus [(N2'') without that term] equals `-(eps^3/4) dK ^ g(zdot, dz)` at `v = eps`. Script C3, C4 and D show that the form is closed with the term and is not closed without it (in the truncation the nonzero component of `d Omega` is `2 pi Kbar eps^5 s_H/15` on `(kappa, a_1, a_2)`).

So with (3.18), (A.14) as displayed is incomplete by this term. The paper says only that at an outer cut the variation depends on how the location of the cut is specified (line 2525).

### 2.5 The corner at `S` and the joint, from the action (3.15)

This subsection derives which variable multiplies `dK` at the corner. It uses (A.8), (A.9) and (3.15) only.

Step 1 (a). `theta` pulled back to a null boundary is `(1/8 pi G) d(kappa eta) + d_ext b + E`, with `16 pi G b = (h - 2 dpsi) mu + i_upsilon eta` and `upsilon^a = dl^a - l^a dpsi = -h^{ab} l_b` ((A.8), (A.9), lines 2447 to 2467; `d_ext` is the exterior derivative on the boundary).

Step 2 (c). `b` on a cut, for variations that keep the cut and `l . n = -1`. The contractions:

```
h = q^{ab} h_ab - 2 h_ab l^a n^b                     (g^{ab} = q^{ab} - l^a n^b - n^a l^b, footnote at line 533)
q^{ab} h_ab mu = 2 dmu
i_upsilon eta pulled back to the cut = -(n_a upsilon^a) mu     (eta = du ^ mu, (3.14); upsilon is tangent to H)
n_a upsilon^a = -h_ab n^a l^b
h_ab l^a n^b = -n_a dl^a - l_a dn^a ,   l_a dn^a = dpsi         (from d(l . n) = 0 and d l_a = dpsi l_a)
=> 16 pi G b = 2 dmu - (l_a dn^a - n_a dl^a) mu ,       b = (1/8 pi G)(dmu - Upsilon mu),   Upsilon as in (3.44).
```

Step 3 (c). If `l = e^a L`, `n = e^{-a} N`, then `Upsilon[l, n] = da + Upsilon[L, N]`. Proof: `l . dn = da + L . dN`, `n . dl = -da + N . dL`. (Script G2.)

Step 4 (c). At `S` take the two dyads `(l_p, n_p = l_q/E)` and `(l_q, n_q = l_p/E)`, `E = -l_p . l_q`, (3.11). Then `Upsilon_p = [l_p . dl_q - l_q . dl_p]/(2E) + dE/(2E)` and `Upsilon_q` is the same with `p`, `q` exchanged, so `Upsilon_p + Upsilon_q = d log E`. (Script G1, with an arbitrary varying metric on the normal plane.)

Step 5 (c). With the orientation signs of (A.2), line 2422, the null boundaries contribute `-int_{H_p}(E + d_ext b) + int_{H_q}(E + d_ext b)` to `dI`, the `d(kappa eta)` terms being cancelled by (3.15b). `S` is the upper end of `H_p` and the lower end of `H_q`. Adding the variation of the corner term of (3.15a):

```
dI at S = -(1/8 pi G) int_S [ 2 dmu - mu d log E ] - (1/8 pi G) int_S [ log(E/2) dmu + mu d log E ]
        = -(1/8 pi G) int_S [ log(-l_p . l_q/2) + 2 ] dmu_S .
```

Only `dmu_S` appears. No variation of a normal survives.

Step 6 (c). At the joint `dSigma_0`, (3.12) gives `l_p = E_0 (n_0 + r_0)`, `n_p = (n_0 - r_0)/(2 E_0)`, `E_0 = -n_0 . l_p`, `r_0` the unit normal of the joint within the cap. By step 3, `Upsilon_p = d log E_0 + Upsilon_cap` with `Upsilon_cap = (r_0 . dn_0 - n_0 . dr_0)/2`. The joint is the lower end of `H_p`:

```
dI at dSigma_0 = (1/8 pi G) int [ dmu - Upsilon_p mu ] + (1/8 pi G) int [ log E_0 dmu + mu d log E_0 ]
               = (1/8 pi G) int_{dSigma_0} [ (1 + log(-n_0 . l_p)) dmu_C - mu Upsilon_cap ].
```

The first term is (A.18) (a), with `eps_C = +1` when `dI` is read as `Theta_out - Theta_in`. The second contains only the frame of the cap and belongs with the cap terms.

Step 7 (c). The null integrand for the affine normal in terms of the one for `d_v`. Write `l_p = exp(beta) d_v`, `beta(v, y) = P(y) - Xi_y(v)`, `P = log(p_{eps,y}/rho_S)`, from (3.26b). `theta` pulled back does not depend on the choice of normal, so (A.8) for both normals gives `E_aff + d_ext b_aff = (1/8 pi G) d(kappa_v eta') + d_ext b' + E'`, with `kappa_aff = 0`. By step 3, `b_aff - b' = -(1/8 pi G) dbeta mu` on a cut. For `l' = d_v` held fixed on the reference cone, `psi' = log N` with `N = -g_{tv}` of (B.1), `upsilon' = -dlog N d_v`, and the last two terms of (A.9) cancel: `-2 Theta n'_a upsilon'^a + 2 Theta dpsi' = -2 Theta dlog N + 2 Theta dlog N`. So `E'` is the integrand of (A.30a), and

```
int_{H_p} E_aff = Theta_H + int_S eps_0 K [ (1 - eps^2) dP - dXi_y(1) ] + exact.
```

Step 8 (c). Collecting the incoming side. Write `-n_0 . l_p = exp(P + a_C)` with `a_C = log(-n_0 . d_v)` at `v = eps`, and `-l_p . l_q = exp(P - Xi_y(1) + gamma - lambda)`, where `lambda` is as at line 2482 and `gamma` is the logarithm of the normalization of `l_q` relative to `d_{v_q}` at `S`. Per unit `eps_0`:

```
-K[alpha_eps + dW_eps + (1 - eps^2) dP - dXi(1)] + eps^2 (P + a_C) dK - (P - Xi(1) + gamma - lambda - log 2) dK
   = -K(alpha_eps + dW_eps) + eps^2 a_C dK + (lambda - gamma) dK   - (1 - eps^2) d(K P) + d(K Xi(1)) + log 2 dK .
```

The last three terms are exact (script G3). Hence, up to exact terms,

```
Theta_in = Theta_cap + int_S eps_0 [ K (alpha_eps + dW_eps) - eps^2 a_C dK - (lambda - gamma) dK ] ,
Omega_in = d Theta_in = Omega_cap + Omega_H - int_S eps_0 [ d(lambda - gamma) ^ dK + eps^2 da_C ^ dK ].
```

Three consequences (c).

1. The affine normalization `P` of `l_p` drops out. A rescaling of the affine parameter of the incoming generators is a degenerate direction of the assembled form. It is not the variable conjugate to `K`.
2. The variable multiplying `dK` at the corner is `lambda - gamma`, with `gamma` the normalization of the transverse normal `l_q`. This is (A.28), line 2599, where `gamma` is introduced through `k_q = exp(Gamma_q) l_q`.
3. `lambda`, `a_C`, `alpha_eps`, `W_eps` are built from the metric on the cone and the cap. `gamma` is not: nothing on the incoming surface fixes the normalization of `l_q`.

Two remarks on signs (c). First, `Omega_in` has the radiative term positive and `-dLambda ^ dK`; (A.14) and (A.16) are written for branches leaving the corner and have `+dlambda ^ dK` and, for `b < 1`, the radiative term negative. The relative sign is the same. I use the orientation of (A.16) below, `Omega = -Omega_in`. Second, I put the whole corner term of (3.15a) on the incoming side. A different split multiplies the coefficient of `dLambda ^ dK` by a constant and leaves a term `d P ^ dK`; neither changes which components of `V_X` vanish.

### 2.6 The cap

(a) The paper displays only `Theta_Sigma = (1/16 pi G) int_Sigma B_{Sigma mu nu} ^ d omega_Sigma^{mu nu}`, (3.46), and says that the extrinsic curvature terms of (3.15a) cancel the terms in `dK_i` (line 2435). (c) `a_C = log(-n_0 . d_v)` at `v = eps` equals `log(2/eps) - log theta_+`, where `theta_+` is the expansion of `n_0 + r_0`, because the expansion of `d_v` is `2/v`. So `a_C` is a function of the cap data at its edge. (d) I write `Omega_cap[c]` for the form of the cap data `c`, including the `Upsilon_cap` term of step 6, and assume that it couples to the cone only through `K` (by `dmu_C = eps^2 dK eps_0`), through `a_C`, and through the matching of `z`, `zdot` at `v = eps`.

### 2.7 The assembled form

In the orientation of (A.16), with `Lambda = lambda - gamma`, `d^y` of (A.13), and `s_H = -1`:

```
Omega =   int_S eps_0  dLambda ^ dK                                                         (T1)
        + int_S eps_0  dp_i ^ dY^i                                                          (T2)
        + s_H int_S eps_0 (K/2) int_eps^1 v^2 g( D_v d^y z ^ d^y z ) dv                      (T3)
        + s_H int_S eps_0 (1/2) d^y K ^ int_eps^1 v^2 g( zdot, d^y z ) dv                    (T4)
        + s_H int_S eps_0 (1/2) d^y K ^ int_eps^1 v^3 g( zdot, D_v d^y z ) dv                (T5)
        + eps^2 int_S eps_0  da_C ^ d^y K                                                    (T6)
        + s_H Omega_cap[c]                                                                   (T7)
```

Equivalently `T3 + T4 + T5 = T3' + T4' + T5'` with

```
T3' = s_H int eps_0 (K/2) int_eps^1 v^2 g( D_v d^o z ^ d^o z ) dv
T4' = s_H int eps_0 (1/4) d^y K ^ g( zdot, d^y z ) at v = 1
T5' = -s_H int eps_0 (eps^3/4) d^y K ^ g( zdot, d^y z ) at v = eps .
```

Where each term comes from.

| Term | Content | Source | Status |
|---|---|---|---|
| T1 | corner pair `(K, Lambda)`, `Lambda = lambda - gamma` | (A.16) line 2520, (A.28) line 2599; rederived in Section 2.5 step 8 | (a), (c) |
| T2 | angular pair | (A.12d), (A.16); Reisenberger 1211.3880 (99), (100), (105) | (a), (b); not rederived |
| T3 | radiative | (A.30a); equals the fourth term of (A.14) once `d^o` is expanded | (c) from (a) |
| T4, T5 | mixed `K` with `z` along the whole generator | (A.30a), (A.30b); this is the `dK ^ alpha` of line 725 together with the `z` dependence of `mu` | (c) from (a) |
| T4' | mixed `K` with `z` at `S` | third term of (A.14); Reisenberger (116) | (a), (b), (c) |
| T5' | mixed `K` with `z` at the joint | not in (A.14); Section 2.4 | (c) |
| T6 | joint | (A.17c) with `db = 0`, (A.18), with `a_C` the angle to `d_v` after the cancellation of Section 2.5 step 8 | (a), (c) |
| T7 | cap | (3.46); not assembled by the paper | (a), (d) |
| in `d^y` | mixed `s` with `z` and `s` with `K` | `d^y z = dz - Lie_xi z`, `d^y K = dK - div(K xi)`, (A.13), (B.24) | (a) |

Written out, the mixed angular terms are those obtained by inserting `d^y z = dz - Lie_xi z` and `d^y K = dK - div(K xi)` in T3 to T6, for example from T3: `-s_H int eps_0 (K/2) int v^2 [ g(D_v Lie_xi z ^ dz) + g(D_v dz ^ Lie_xi z) - g(D_v Lie_xi z ^ Lie_xi z) ] dv`. On the branch whose generators are used as labels (`s = id`, line 2484) `xi = 0` and these terms are absent.

The terms `K dUpsilon + dK ^ Upsilon` of (3.42b) do not appear separately. (c) By Section 2.5 steps 4 and 5 the `Upsilon` terms of the two null boundaries and the variation of the corner term of (3.15a) combine into `log(-l_p . l_q/2) dmu_S`. What is left of the variations of the normals is their normalization: `P`, which cancels, and `gamma`, which is in `Lambda`. (a) The paper also states `Upsilon = (1/2) d log abs(c_L/d)`, line 2939, an exact form.

`Lambda` occurs in T1 only. `gamma` occurs only inside `Lambda`. `P` does not occur.

### 2.8 Fixed total area

(c) On the surface `int_S K eps_0 = A/(8 pi G)` tangent vectors have `int dK eps_0 = 0`, so a shift of `Lambda` by a constant is in the kernel of the pulled back form. The reduced phase space is that surface with `Lambda` taken modulo constants. `X = int phi K eps_0` changes by a constant when a constant is added to `phi`, so `int phi eps_0 = 0` is a normalization.

## 3. Q3: the Hamiltonian vector field

### 3.1 The equation and its solution

Convention (a): `dH = Omega(d, V_H)` and `{O, H} = V_H(O)`, (3.32), (3.33), lines 641 to 651. (The brief writes `Omega(V_X, .) = dX`; that convention gives the opposite sign of `V_X(Lambda)` and the same vanishing components.)

Let `V = (V_Lambda, V_K, V_Y, V_p, V_z, V_c)`, with `xi_V = V_Y o Y^{-1}`, `V_z^y = V_z - Lie_{xi_V} z`, `V_K^y = V_K - div(K xi_V)`. The contractions of the terms of Section 2.7 with `(d, V)`:

```
T1:  int eps_0 ( dLambda V_K - V_Lambda dK )
T2:  int eps_0 ( dp_i V_Y^i - V_{p_i} dY^i )
T3:  s_H int eps_0 (K/2) int v^2 [ g(D_v d^y z, V_z^y) - g(D_v V_z^y, d^y z) ] dv
T4:  s_H int eps_0 (1/2) [ d^y K int v^2 g(zdot, V_z^y) dv - V_K^y int v^2 g(zdot, d^y z) dv ]
T5:  s_H int eps_0 (1/2) [ d^y K int v^3 g(zdot, D_v V_z^y) dv - V_K^y int v^3 g(zdot, D_v d^y z) dv ]
T6:  eps^2 int eps_0 ( da_C V_K^y - V(a_C) d^y K )
T7:  s_H Omega_cap(dc, V_c)
```

`dX = int phi dK eps_0`. Take `V_K = 0`, `V_Y = 0`, `V_p = 0`, `V_z = 0`, `V_c = 0`. Then `xi_V = 0`, `V_z^y = 0`, `V_K^y = 0`, `V(a_C) = 0`, every contraction except the second half of T1 vanishes, and `Omega(d, V) = -int eps_0 V_Lambda dK`. So (c)

```
V_X = -phi(y) d/dLambda(y) ,    all other components zero.
```

Uniqueness (c): two solutions differ by a vector in the kernel of `Omega`; on the reduced phase space the kernel is quotiented and brackets of functions on it are unambiguous. In the truncation of Section 5 the matrix is invertible and the solution is unique.

### 3.2 Components

| Coordinate | Component of `V_X` | Status |
|---|---|---|
| `Lambda(y) = lambda - gamma` | `-phi(y)`, modulo a constant at fixed area | (c) |
| `rho_S(y)^2`, `K(y)` | 0 | (c) |
| `f_S(y)` of (4.23) | 0, given (d5) | (c) |
| `Y^i(y)` | 0 | (c) |
| `p_i(y)` | 0 | (c) |
| `z^alpha(v, y)`, each `v` in `[eps, 1]` | 0 | (c) |
| joint variable `a_C(y)` | 0 | (c), given (d3) |
| cap data `c` | 0 | (c), given (d3) |
| affine normalization `P = log(p_{eps,y}/rho_S)` | not a coordinate of the form; undetermined | (c) |

How the shift of `Lambda` is shared between `lambda` and `gamma` is not fixed by the form, which contains only `Lambda`. If it is carried by `gamma`, the metric is unchanged and `V_X` is a rescaling of the transverse normal at `S` by `exp(phi)`, a local boost of the frame. If `lambda` is treated as free data, as in Reisenberger's phase space for two branches, `V_X` shifts `lambda` at fixed `e_pq(v, theta)` on both branches, and by (A.12b) with `p_i` fixed the difference of normal connections `varpi_L - varpi_R` changes by `-dphi`. In both readings the entries of the table are the same.

### 3.3 Brackets

With `{O, X} = V_X(O)`:

| Quantity `O` | `{O, X}` | Why |
|---|---|---|
| `K(y')` | 0 | `V_X(K) = 0` |
| `f_S(y')` | 0 | function of `K` only, (4.23), (d5) |
| `z^alpha(v, y')` at fixed `v` | 0 | `V_X(z) = 0` |
| `Xi_{y'}(v)`, (3.26c) | 0 | functional of `z(., y')` |
| `u_*(y') = rho_S int_eps^1 exp(Xi) dv`, (3.27) | 0 | function of `rho_S(y')` and `z(., y')` |
| `ubar_*`, (3.28) | 0 | function of `rho_S`, `u_*` |
| `Lambda(y')` | `-phi(y')` | T1; so `{K(y), Lambda(y')} = delta(y, y')` with respect to `eps_0` |

Not zero, for comparison (c): `{z(v, y), Lambda(y')}` (Section 2.3, last item), and the bracket of `X` with any quantity defined with the frame at `S`. Example: let `s` be the affine parameter along a generator measured from `S` and normalized by the frame whose transverse normal is rescaled by `V_X`. Then `ds/dv` is proportional to `exp(Lambda) exp(Xi_y(v) - Xi_y(1))` by (3.26b), and `{z(s_0, y), X} = phi(y) s d_s z` at fixed `s_0` (script E; the sign follows the sign convention for `Lambda`, (d8)). This is the classical form of the statement at line 1085, that a uniform boost of the frame takes `sigma_AB(u)` to `e^eta sigma_AB(e^eta u)`. The same applies to the two factors in the first form of (3.27): `p_{eps,y}` and `u(1, y) - u(eps, y)` each change under a rescaling of `u`, their product does not (line 579).

### 3.4 Independent support for the vanishing brackets

- (b) Reisenberger 0712.2541, in the sentence after (10): `s_A` and `rho_0` have vanishing brackets with all the remaining data, the one nonzero bracket of `rho_0` being (9) with `lambda`. The remaining data include `mu`, `mubar` (the conformal metric at fixed `(v, theta)`) on both branches. This is the statement for two branches leaving a corner, with truncation surfaces of fixed area density.
- (b) Chandrasekaran and Flanagan, Sec 7.3: the weighted area `int sqrt(q) w` with an arbitrary weight generates `b_r -> b_r - 8 pi w`; the area and boost variables are in a sector symplectically orthogonal to the spin two sector (Sec 7.2). This is for perturbations of stationary backgrounds. Their footnote 19 leaves open whether half-sided boosts are generated by the area operator in general.
- (a) The paper's own (3.42b): `dGamma` occurs only in `dK ^ dGamma`; and line 579: the clock is constructed so as not to depend on the normalization of `u`.
- (a) In the two-dimensional prologue the reduced potential (2.7), line 197, pairs each corner charge with the rapidity `Gamma_i` of the local Lorentz frame at that corner, in a term separate from the clock pair and from the matter profiles at fixed `v`.

None of these items is a derivation for the capped cone in four dimensions. They agree with Section 3.1.

### 3.5 What would change the answer

(c) The components along `K`, `f_S`, `z(v, y)` vanish exactly when the variable conjugate to `K` enters the form only through T1. They would not vanish if the radiative coordinates of the reduced phase space were the conformal metric at fixed frame-normalized affine parameter instead of at fixed `v`; then the same vector field has nonzero components along those coordinates (Section 3.3). The clock (3.27), (4.22) to (4.26) is written with `v`.

## 4. Q4: the quantum side

### 4.1 What the text gives

(a) There are canonical coordinates `phi = (q, p)` on the reduced phase space with `h = iota(phi)` and `Omega = iota^* d Theta`, (3.45), line 734. The Weyl relations use the constant inverse form `J^{IJ}`, (4.20), line 1173, and `J^{IJ} = {phi^I, phi^J}`, line 1530. At fixed area both radiative polarizations on the incoming cone and the independent corner variables on `S` are expanded in a countable basis of canonical pairs (line 1034). A function `f` of the boundary fields is quantized by writing `f o iota_t` in canonical variables and Weyl ordering it (line 1177). `zhat^alpha = Q(z^alpha)`, line 1187; `fhat_S(y) = Q(f_S(y))`, line 1203. Weyl ordering assigns the displacement operator `D(lambda)` to each Fourier mode of `f(q, p)` (line 1509). The product is (C.9), line 3012. Line 2707 says that the full form (A.14) fixes the brackets of bulk and edge variables and with them the normalization of the canonical variables of Section 4. The pairs `(q^i, Pi_i)` and `(K(y), Pi_K)` are named at line 2941, (B.24).

Not displayed anywhere: the map `iota`, that is, `f_S(y)` and `z^alpha(v, y)` as functions of `(q_j, p_j)`.

### 4.2 `f_S` and `z^alpha` in canonical pairs, from the Q2 form

(c) With labels fixed and the cap sector set aside, a potential for the form of Section 2.7 is, up to exact terms,

```
Theta = int_S eps_0 [ ( Lambda + eps^2 a_C - s_H W_eps[z] ) dK + s_H K theta_rad[z] ] ,
```

with `theta_rad = alpha_eps = (1/2) int_eps^1 v^2 g(zdot, dz) dv` a one-form on the space of curves `z(v)` that does not contain `K`. Let `(Q_k, P_k)` be Darboux coordinates of `d theta_rad` for each generator, `theta_rad = sum_k P_k dQ_k + dG[z]`. Then `s_H K theta_rad = s_H K sum_k P_k dQ_k - s_H G dK + d(s_H K G)`, and the canonical pairs are

```
( K(y), Pi_K(y) )    and    ( Q_k(y), p_k(y) = s_H K(y) P_k(y) ) ,       Pi_K := Lambda + eps^2 a_C - s_H ( W_eps[z] + G[z] ) .
```

So in this chart (c):

- `K(y)` is a canonical coordinate and `f_S(y) = log K(y) + const(A)` is a nonlinear function of that one coordinate.
- `z^alpha(v, y) = Z^alpha(v; Q(y), s_H p(y)/K(y))`: it depends on the radiative pairs and on `K(y)`, and not on `Pi_K(y)`.
- For one polarization (`z^2 = 0`, flat target) `Z` is linear in `(Q, P)`, so `z` is linear in the radiative pairs with coefficients that depend on `K(y)`. For two polarizations `d theta_rad` is a form on curves in the hyperbolic plane and the Darboux map is nonlinear; I did not construct it.

In the truncation of Section 5 this chart is explicit (script D): `Pi_kappa = Kbar [c_Lambda Lambda_1 - s_H N_1 (W~ + (1/4) a^T A_sym a)]`, `qtil = R a_2`, `ptil = R a_1`, `R^2 = s_H Kbar (N_0 + kappa N_1)(A_12 - A_21)/2`, with `{kappa, Pi_kappa} = {qtil, ptil} = 1` and all other brackets zero.

(c) `z^alpha(v, y)` cannot be linear in any Darboux chart: the bracket `{z^alpha(v, y), z^beta(w, y)}` has the coefficient `1/(2 K(y) v w)` (line 2668), which is not constant on phase space, while linear functions of Darboux coordinates have constant brackets. In the truncation `{a_1, a_2} = -2/(Kbar s_H (A_12 - A_21)(N_0 + N_1 kappa))`.

### 4.3 Is `X` linear

(c) In the chart of 4.2, `X = int phi K eps_0` is a linear function of the canonical coordinates `K(y)`. Under a linear symplectic change of chart it stays linear. Under a nonlinear canonical change it does not in general. (a) The paper names `(K(y), Pi_K)` as a canonical pair at line 2941. (d7) Whether that pair is among the `(q_j, p_j)` of (4.7) to (4.10) is not stated, so whether `X` is linear in the pairs of Sec 4.2 is not decided by the text. A second natural chart takes modes of `f_S` as coordinates (the parametrization (4.23) by an unconstrained real function); there `X` is a nonlinear function of mutually commuting coordinates.

### 4.4 Commutation with the product (C.9)

(c) From (C.9), `f * g - g * f = 2 sum over odd n of (1/n!) (i hbar/2)^n P^n(f, g)`, where `P^n` applies `J^{IJ} d_I (x) d_J` `n` times; even orders cancel because `P^n(g, f) = (-1)^n P^n(f, g)`. So

```
[Q(X), Q(F)] = Q( i hbar {X, F} - (i hbar^3/24) P^3(X, F) + O(hbar^5) ).
```

By Section 3.3, `{X, F} = 0` for `F` any of `f_S(y)`, `z^alpha(v, y)`. Three cases.

1. `X` linear in the chart, `X = lambda_I phi^I`. Then `e^{itX}` is the Weyl operator `D(t lambda)` of (4.20). From (4.20), `D(lambda) D(mu) D(lambda)^{-1} = exp(-i hbar lambda_I J^{IJ} mu_J) D(mu)`, so conjugation by `D(t lambda)` translates the symbol of `Q(F)` along `J^{IJ} lambda_J`, which is the direction of `V_X`. `F` is constant along `V_X`. So `e^{itX}` commutes with `Q(f_S(y))` and `Q(z^alpha(v, y))` exactly, to all orders in `hbar`. In the expansion, every `P^n(X, F)` with `n >= 2` vanishes because `X` has no second derivative.
2. `X` a nonlinear function of mutually commuting canonical coordinates `q_1..q_m` only, and `F` independent of their conjugates `p_1..p_m` (which is what `{K(y), F} = 0` for all `y` gives when the `K(y)` are functions of `q_1..q_m`). Then every term of `P^n(X, F)` contains a derivative of `F` with respect to some `p_i`, `i <= m`, and vanishes. Again exact commutation.
3. Otherwise `P^3(X, F)` does not vanish in general, and the commutator first fails to vanish at order `hbar^3`. For the boost written as `exp(i eta K/hbar)` (line 1034) this is order `hbar^2` in the conjugated operator.

Script F: in the chart of 4.2 (chart A) the coefficients of `hbar`, `hbar^3`, `hbar^5` in `X * F - F * X` are zero for `F = log(1 + kappa y_0)`, the two `z` modes, and functions of them; in chart B, obtained by the canonical map `kappa = Q - (b/3) P^3`, `Pi_kappa = P`, the coefficient of `hbar` is zero and the coefficient of `hbar^3` is `-i b c y_0^3/(6 (1 + kappa y_0)^3) = -(i/12) b c f_S'''`. Chart B is artificial; it shows the order and nothing else.

In cases 1 and 2 the same holds for every operator built from `Q(f_S)` and `Q(z^alpha)` by products, because the product of two symbols independent of `Pi_K` is independent of `Pi_K`. So `e^{itX}` then commutes with each factor of (4.26) and preserves the form (4.27).

### 4.5 Answer to Q4

- How `f_S(y)` and `z^alpha(v, y)` are written in the pairs: not displayed by the paper. From the Q2 form, in the chart that has `K(y)` as a coordinate: `f_S = log K + const`, and `z^alpha` a function of the radiative pairs and of `K`, not of `Pi_K`. `z^alpha` is nonlinear in any chart.
- `X` linear or nonlinear: linear in that chart; not decided for the chart of Sec 4.2.
- Exact commutation: yes in cases 1 and 2. If the chart of Sec 4.2 is of neither kind, the first failure is at order `hbar^3`.

Remarks (c). In case 2 with `f_S` modes as coordinates, `e^{itX}` is a multiplication operator and is not a Weyl operator; a Weyl operator of the area distribution is then `exp(it int psi f_S eps_0)`. The symmetric orderings in (4.24a) and (4.26) are not needed in cases 1 and 2 as far as the factors `rhohat_S(y)` are concerned, since those commute with each other and with `exp(Xihat)`; they are needed in case 3. The footnote at line 1583 calls the operators in (4.26) noncommuting without saying which.

## 5. Q5: finite check

### 5.1 The truncation

(d) Angular data: a real function `Y(y)` with `int Y eps_0 = 0` (the harmonic of the area density), a real profile `chi(y)`, and `c_Lambda = int Y^2 eps_0`, `N_0 = int chi^2 eps_0`, `N_1 = int Y chi^2 eps_0`. Radial modes `psi_1(v)`, `psi_2(v)`. The truncated configurations are

```
K(y) = Kbar (1 + kappa Y(y)),     Lambda(y) = Lambda_0 + Lambda_1 Y(y),     z^1(v, y) = chi(y) (a_1 psi_1(v) + a_2 psi_2(v)),     z^2 = 0,
```

with total area `32 pi^2 G Kbar` fixed. Coordinates `(Lambda_1, kappa, a_1, a_2)`. `X = int phi K eps_0` with `phi = phi_1 Y` is `X = Kbar c_Lambda phi_1 kappa`. The form is the pullback of `T1 + T3 + T4 + T5` with labels fixed; `A_ij = int_eps^1 v^2 psi_i' psi_j dv`, `B_ij = int_eps^1 v^3 psi_i' psi_j' dv`.

### 5.2 The symplectic matrix at a general point

From the script, part D (i), for generic `psi_1, psi_2`; `Omega = (1/2) Omega_IJ dphi^I ^ dphi^J`, antisymmetric, upper triangle:

```
Omega[Lambda_1, kappa] = Kbar c_Lambda
Omega[Lambda_1, a_1]   = 0
Omega[Lambda_1, a_2]   = 0
Omega[kappa, a_1]      = s_H Kbar (N_1/2) [ (A_11 + B_11) a_1 + (A_21 + B_12) a_2 ]
Omega[kappa, a_2]      = s_H Kbar (N_1/2) [ (A_12 + B_12) a_1 + (A_22 + B_22) a_2 ]
Omega[a_1, a_2]        = s_H Kbar (N_0 + N_1 kappa) (A_12 - A_21)/2
det Omega = Kbar^4 c_Lambda^2 (A_12 - A_21)^2 (N_0 + N_1 kappa)^2 / 4
```

The inverse, with `{F, G} = d_I F J^{IJ} d_J G`:

```
J[Lambda_1, kappa] = -1/(Kbar c_Lambda)
J[Lambda_1, a_1]   =  N_1 [ (A_12 + B_12) a_1 + (A_22 + B_22) a_2 ] / ( Kbar c_Lambda (A_12 - A_21)(N_0 + N_1 kappa) )
J[Lambda_1, a_2]   = -N_1 [ (A_11 + B_11) a_1 + (A_21 + B_12) a_2 ] / ( Kbar c_Lambda (A_12 - A_21)(N_0 + N_1 kappa) )
J[kappa, a_1]      = 0
J[kappa, a_2]      = 0
J[a_1, a_2]        = -2/( s_H Kbar (A_12 - A_21)(N_0 + N_1 kappa) )
```

The mixed entries `Omega[kappa, a_j]` are not zero, and the inverse has `J[kappa, a_j] = 0`. For `psi_1 = v`, `psi_2 = v^2`: `A = [[(1 - eps^4)/4, (1 - eps^5)/5], [2(1 - eps^5)/5, (1 - eps^6)/3]]`, `B = [[(1 - eps^4)/4, 2(1 - eps^5)/5], [2(1 - eps^5)/5, 2(1 - eps^6)/3]]`, `A_12 - A_21 = -(1 - eps^5)/5`; the explicit entries are in the output, part D (ii). For `Y = P_2(cos theta)`, `chi = cos theta`: `c_Lambda = 4 pi/5`, `N_0 = 4 pi/3`, `N_1 = 8 pi/15`.

The script also builds the matrix a second way, from (N2'') with `d^o` integrated over the sphere, and finds the same matrix.

### 5.3 Brackets

`V_X = J grad X = (-phi_1, 0, 0, 0)` in the order `(Lambda_1, kappa, a_1, a_2)`, and `Omega V_X = grad X`.

| Bracket | Value |
|---|---|
| `{Lambda_1, X}` | `-phi_1` |
| `{kappa, X}`, `{a_1, X}`, `{a_2, X}` | 0, 0, 0 |
| `{K(y), X}`, `{rho_S(y)^2, X}`, `{f_S(y), X}` | 0, 0, 0 |
| `{z^1(v_0, y), X}`, `{d_v z^1(v_0, y), X}` | 0, 0 |
| `{Xi_y(v_0), X}`, `{exp(Xi_y(v_0)), X}` | 0, 0 |
| `{u_*(y), X}` with `u_* = rho_S(y) int_eps^1 exp(Xi_y(v)) dv` | 0 |
| `{ubar_*, X}` with (3.28) | 0 |
| `{kappa, Lambda_1}` | `1/(Kbar c_Lambda)` |
| `{a_1, kappa}`, `{a_2, kappa}` | 0, 0 |
| `{a_1, a_2}` | `-2/(s_H Kbar (A_12 - A_21)(N_0 + N_1 kappa))` |
| `{K(y), Lambda_1}`, `{f_S(y), Lambda_1}`, `{z^1(v_0, y), Lambda_1}`, `{Xi_y(v_0), Lambda_1}`, `{u_*(y), Lambda_1}` | all nonzero; expressions in the output |

Here `f_S(y) = log(1 + kappa Y(y))`, for which (4.23) holds with `int exp(f_S) eps_0 = 4 pi` (checked in the script). The zeros are exact symbolic zeros. They follow from `J[kappa, a_j] = J[kappa, kappa] = 0` and from the absence of `Lambda_1` in the clock.

### 5.4 What the truncation drops

- All harmonics of `K` and of `Lambda` but one; the constant mode of `Lambda` is removed by the reduction.
- The second polarization `z^2`, hence the curvature of the target and the factor `exp(2 z^1)` in (4.22).
- All radial modes but two, and the angular dependence of `z` beyond one fixed profile `chi`.
- The angular pairs `(Y^i, p_i)` and every term with `Lie_xi`.
- The joint variable `a_C` (absorbed in `Lambda_1`), the cap data, the matching of `z` and `zdot` to the cap at `v = eps`, and the other cone `H_q`.
- Positivity `1 + kappa Y > 0`, and all questions of invertibility in infinitely many dimensions.

(c) For this `X` the truncated calculation is the restriction of the full one: the full `V_X = -phi d/dLambda` with `phi = phi_1 Y` is tangent to the truncated configurations. For other functions, for example `Lambda_1`, the truncated brackets are projections and are not the restrictions of the full brackets.

## 6. Assumptions of type (d), the weakest step, and what is not decided

(d1) The variable conjugate to `K(y)` is a coordinate of the reduced phase space, independent of `K`, `Y`, `p`, `z`, and the cap data. The paper asserts this (line 337: the variables acted on by the boundary charges are edge modes; (3.41); (A.16); (A.28); line 1034: the corner variables on `S` are called independent). Section 2.5 derives that this variable is `lambda - gamma` with `gamma` the normalization of the transverse normal, which no incoming datum fixes. If the phase space contained no such variable, `K(y)` would have no Hamiltonian vector field of this form and Q3 would have to be redone in the cap sector.

(d2) The orientation sign `s_H = -1` and the coefficient 1 of `dLambda ^ dK` (the whole corner term of (3.15a) put on the incoming side). Neither affects which components vanish.

(d3) The cap: `Omega_cap` is not assembled; I assume it couples to the cone only through `K`, `a_C` and the matching at `v = eps`, and that it does not contain `Lambda`.

(d4) `X = int phi(y) K(y) eps_0` is taken with `phi` a fixed function of the generator labels `y`.

(d5) The additive constant in `f_S`, which (4.23) leaves free, is fixed by a rule that involves `K` only.

(d6) Existence and uniqueness of Hamiltonian vector fields in infinitely many dimensions are not addressed. Reisenberger states that the symplectic form on null data has no inverse on all modes (1211.3880 Sec 1), defines his bracket through test variations vanishing near the boundary, and finds that it does not preserve the reality of `e_ab` although it is real on observables (0712.2541, last page). His truncation surfaces have fixed area density, which (3.18) does not have; Section 2.4 is my treatment of that difference and has no counterpart in the references.

(d7) Q4: the chart of Sec 4.2.

(d8) Script E: the identification of the `K`-conjugate with the logarithm of the normalization of a frame at `S`, with a chosen sign.

Weakest step. For Q3 it is (d1) together with (d3): the paper never assembles the capped cone, and the cap sector is treated here only through its couplings. The conclusion did not change in any of the three readings I could construct (frame variable `gamma`; free `lambda` as in Reisenberger; (3.42b) with `Gamma`). For the outcome of B6 as a whole it is (d7), which the text does not decide.

Not decided by this derivation: whether the pairs `(q_j, p_j)` of (4.7) to (4.10) are of the kind of case 1 or 2 of Section 4.4; the form of the cap sector; and how (3.41) and (3.42a) split the corner contributions. (3.41) keeps `Upsilon` as a separate term next to `dGamma`. After adding the `b` terms of both null boundaries and the variation of the corner term of (3.15a) I find that no `Upsilon` remains (Section 2.5 step 5). I did not reconstruct the paper's split. It does not enter the results.

## 7. Files and sources

- `derivation.md`, `b6_check.py`, `b6_check_output.txt` in this folder.
- Pages read: `ar5iv.labs.arxiv.org/html/` followed by `1211.3880`, `0712.2541`, `gr-qc/9312002`, `2309.03871`, `1706.05061`, `1802.06135`. No PDF or other file was downloaded.
