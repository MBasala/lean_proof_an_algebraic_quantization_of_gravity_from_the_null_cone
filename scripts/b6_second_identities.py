# Break attempt B6 (handoff.md Section 14.8), second derivation: checks of the identities it uses, as
# written by the derivation agent on 2026-11-26. Output: notes/b6-second-identities-output.txt.
# Run from the repository root:  .venv/Scripts/python.exe -I -X utf8 scripts/b6_second_identities.py
# check_A_identities.py
# Consistency checks used in Q2 of derivation.md.
#
# A1. One polarization (flat target), two radial modes: the one-sheet bulk + mixed
#     terms of the paper's (A.14) equal  - delta(Theta_b), where
#         Theta_b = K*alpha_b - N_b*deltaK,
#         alpha_b = (1/2) int_b^1 v^2 z' dz dv,   N_b = int_b^1 v^2 mu dv,
#         mu = 1/v + (v/4) z'^2      [from (A.30b) with rho^2 = rho_S^2 v^2],
#     when the outer cut is at fixed area density, b^2 K = C   [(A.17a)].
# A2. With the cap condition (3.18), b = eps fixed, the two differ by one term
#     located at the cut:  -(eps^3/4) dK ^ z'(eps) dz(eps).
# A3. Same as A1, A2 with both polarizations and the curved target metric
#     g = diag(1, exp(2 z^1)) of (4.21c): numerical quadrature at a random point.
# A4. 2J = Xi(1) - M   [relation between (3.42d) and the fixed-v potential].
# A5. Contraction of the cone block with  V = -d/dK - (v/2K) z' d/dz  is a pure
#     boundary term (bulk part of Reisenberger's bracket (17)).
import sympy as sp
import mpmath as mp

v = sp.symbols('v', positive=True)
K, eps, C = sp.symbols('K epsilon C', positive=True)
a1, a2, c1, c2 = sp.symbols('a1 a2 c1 c2', real=True)

print("=" * 72)
print("A1/A2: one polarization, R1 = v, R2 = v^2 + v^3")
R = [v, v**2 + v**3]
z = a1 * R[0] + a2 * R[1]
zp = sp.diff(z, v)
coords = [K, a1, a2]
dK = [1, 0, 0]
dz = [0, R[0], R[1]]
# delta^o z = delta z - (v/2) (delta K / K) z'      (A.13) with K = rho_S^2/(8 pi G)
dzo = [dz[i] - sp.Rational(1, 2) * v * dK[i] / K * zp for i in range(3)]


def A14_block(b):
    """one-sheet terms 3 and 4 of (A.14), in units where 1/(16 pi G) rho_S^2 = K/2"""
    M = sp.zeros(3, 3)
    for i in range(3):
        for j in range(3):
            t3 = -sp.Rational(1, 4) * (dK[i] * (zp * dz[j]).subs(v, 1)
                                       - dK[j] * (zp * dz[i]).subs(v, 1))
            integrand = v**2 * (sp.diff(dzo[i], v) * dzo[j] - sp.diff(dzo[j], v) * dzo[i])
            t4 = K / 2 * sp.integrate(sp.expand(integrand), (v, 1, b))
            M[i, j] = t3 + t4
    return M


def dTheta(b):
    """exterior derivative of Theta_b = K alpha_b - N_b dK ; b may depend on K"""
    Nb = sp.integrate(sp.expand(v + v**3 * zp**2 / 4), (v, b, 1))
    comp = [-Nb] + [K / 2 * sp.integrate(sp.expand(v**2 * zp * R[i]), (v, b, 1)) for i in range(2)]
    M = sp.zeros(3, 3)
    for i in range(3):
        for j in range(3):
            M[i, j] = sp.diff(comp[j], coords[i]) - sp.diff(comp[i], coords[j])
    return M


bR = sp.sqrt(C / K)          # (A.17a): b^2 K = C fixed
resA1 = (A14_block(bR) + dTheta(bR)).applyfunc(sp.simplify)
print("A1  (A.14) block + d(Theta_b), b^2 K = C :", resA1.tolist())

diffA2 = (A14_block(eps) + dTheta(eps)).applyfunc(sp.simplify)
expect = sp.zeros(3, 3)
for i in range(3):
    for j in range(3):
        expect[i, j] = -eps**3 / 4 * (dK[i] * (zp * dz[j]).subs(v, eps) - dK[j] * (zp * dz[i]).subs(v, eps))
print("A2  (A.14) block + d(Theta_eps) - [-(eps^3/4) dK^z'dz|_eps] :",
      (diffA2 - expect).applyfunc(sp.simplify).tolist())
print("    the extra term itself, (K,a1) and (K,a2) entries:",
      [sp.factor(expect[0, 1]), sp.factor(expect[0, 2])])

print("=" * 72)
print("A3: two polarizations, g = diag(1, exp(2 z1)), numerical quadrature")
mp.mp.dps = 30
z1 = a1 * v + a2 * v**2
z2 = c1 * v + c2 * v**3
zz = [z1, z2]
zzp = [sp.diff(z1, v), sp.diff(z2, v)]
g = sp.diag(1, sp.exp(2 * z1))
# Christoffel symbols of g: Gamma^1_22 = -exp(2 z1), Gamma^2_12 = Gamma^2_21 = 1
Gam = [[[0, 0], [0, -sp.exp(2 * z1)]], [[0, 1], [1, 0]]]
crd = [K, a1, a2, c1, c2]
n = 5
dK5 = [1, 0, 0, 0, 0]
dz5 = [[0, 0], [v, 0], [v**2, 0], [0, v], [0, v**3]]      # (delta z^1, delta z^2) per coordinate
dzo5 = [[dz5[i][al] - sp.Rational(1, 2) * v * dK5[i] / K * zzp[al] for al in range(2)] for i in range(n)]


def nab(X):
    """covariant derivative along the curve, (A.15)"""
    return [sp.diff(X[al], v) + sum(Gam[al][be][ga] * zzp[be] * X[ga] for be in range(2) for ga in range(2))
            for al in range(2)]


def gdot(X, Y):
    return sum(g[al, be] * X[al] * Y[be] for al in range(2) for be in range(2))


vals = {K: mp.mpf('1.3'), a1: mp.mpf('0.4'), a2: mp.mpf('-0.7'), c1: mp.mpf('0.25'), c2: mp.mpf('0.6')}
epsv = mp.mpf('0.3')
Cv = vals[K] * epsv**2


def num_int(expr, lo, hi):
    f = sp.lambdify(v, expr.subs(vals), 'mpmath')
    return mp.quad(f, [lo, hi])


def A14_block_num(i, j, b):
    t3 = -sp.Rational(1, 4) * (dK5[i] * gdot(zzp, dz5[j]) - dK5[j] * gdot(zzp, dz5[i]))
    t3 = t3.subs(v, 1).subs(vals)
    integrand = v**2 * (gdot(nab(dzo5[i]), dzo5[j]) - gdot(nab(dzo5[j]), dzo5[i]))
    return mp.mpf(sp.N(t3, 30)) + vals[K] / 2 * num_int(integrand, 1, b)


Nb_int = v + v**3 * gdot(zzp, zzp) / 4
th_int = [None] + [K / 2 * v**2 * gdot(zzp, dz5[i]) for i in range(1, n)]


def dTheta_num(i, j, b, fixed_area_density):
    """d_i Theta_j - d_j Theta_i with Theta_K = -int_b^1 Nb_int, Theta_i = int_b^1 th_int[i]."""
    def d_comp(jj, ii):
        # derivative of component jj with respect to coordinate ii
        if jj == 0:
            val = -num_int(sp.diff(Nb_int, crd[ii]), b, 1)
            if fixed_area_density and ii == 0:      # db/dK = -b/(2K), d/db(-int_b^1 f) = f(b)
                val += mp.mpf(sp.N(Nb_int.subs(v, b).subs(vals), 30)) * (-b / (2 * vals[K]))
            return val
        val = num_int(sp.diff(th_int[jj], crd[ii]), b, 1)
        if fixed_area_density and ii == 0:          # d/db(int_b^1 f) = -f(b)
            val += -mp.mpf(sp.N(th_int[jj].subs(v, b).subs(vals), 30)) * (-b / (2 * vals[K]))
        return val
    return d_comp(j, i) - d_comp(i, j)


worst1 = mp.mpf(0)
worst2 = mp.mpf(0)
for i in range(n):
    for j in range(i + 1, n):
        r1 = A14_block_num(i, j, epsv) + dTheta_num(i, j, epsv, True)     # b^2 K = C at the point b = eps
        worst1 = max(worst1, abs(r1))
        extra = -epsv**3 / 4 * mp.mpf(sp.N((dK5[i] * gdot(zzp, dz5[j]) - dK5[j] * gdot(zzp, dz5[i])).subs(v, epsv).subs(vals), 30))
        r2 = A14_block_num(i, j, epsv) + dTheta_num(i, j, epsv, False) - extra
        worst2 = max(worst2, abs(r2))
print("A3  max |(A.14) block + d(Theta_b)| over all 10 entries, cut at fixed area density:", mp.nstr(worst1, 5))
print("A3  max |(A.14) block + d(Theta_eps) + (eps^3/4) dK^g(z',dz)|_eps|, cut at fixed b=eps :", mp.nstr(worst2, 5))

print("=" * 72)
print("A4: 2J = Xi(1) - M for a generic profile (one polarization)")
f = sp.Function('f')(v)          # f = g(z', z')
J = sp.Rational(1, 8) * sp.Integral(v * (1 - v**2) * f, (v, eps, 1))
Xi1 = sp.Rational(1, 4) * sp.Integral(v * f, (v, eps, 1))
M = sp.Rational(1, 4) * sp.Integral(v**3 * f, (v, eps, 1))
comb = sp.Rational(1, 4) * v * (1 - v**2) * f - (sp.Rational(1, 4) * v * f - sp.Rational(1, 4) * v**3 * f)
print("    integrand of 2J - (Xi(1) - M):", sp.simplify(comb))

print("=" * 72)
print("A5: contraction of the cone block with V_K = -1, V_z = -(v/2K) z'")
zf = sp.Function('z')(v)
ze = sp.Function('zeta')(v)        # arbitrary variation delta z
Vz = -v / (2 * K) * sp.diff(zf, v)
# cone block (A.14 orientation):  -(K/2) v^2 (dz1' dz2 - dz2' dz1) - dK1 (1/2)(v^2 z' dz2 + v^3 z' dz2') + (1<->2)
# contracted with V in the first slot, delta z = zeta, delta K = 0 in the second slot:
integrand = (-(K / 2) * v**2 * (sp.diff(Vz, v) * ze - sp.diff(ze, v) * Vz)
             - (-1) * sp.Rational(1, 2) * (v**2 * sp.diff(zf, v) * ze + v**3 * sp.diff(zf, v) * sp.diff(ze, v)))
bdy = v**3 / 4 * sp.diff(zf, v) * ze
print("    integrand - d/dv[(v^3/4) z' zeta] :", sp.simplify(integrand - sp.diff(bdy, v)))
print("    => Omega(V, dz) = [(v^3/4) z' dz]_eps^1 : no bulk term, i.e. {z, lambda} = (v/2K) z' in the bulk,")
print("       which is Reisenberger's (17) with 4 pi G / rho_0 = 1/(2K).")
