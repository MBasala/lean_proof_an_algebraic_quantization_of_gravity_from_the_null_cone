# Break attempt B6 (handoff.md Section 14.8), first derivation: its sympy checks, as written by the
# derivation agent on 2026-11-26. Output: notes/b6-first-check-output.txt. Text: notes/b6-derivation-first.md.
# Run from the repository root:  .venv/Scripts/python.exe -I -X utf8 scripts/b6_first_check.py
# -*- coding: utf-8 -*-
"""
B6, first derivation: sympy checks.

Run:  python -I -X utf8 b6_check.py > b6_check_output.txt

Parts
  A  pointwise identities for the conformal metric (4.21) and the target metric g = diag(1, exp(2 z1))
  B  identities among Xi, J_eps, W_eps (capped analogues of (3.26c), (3.42d))
  C  one generator, flat target: the two forms (N2') and (N2'') of the null block agree;
     the form "(A.14) with b = eps held fixed and no term at v = eps" is not closed;
     the Hamiltonian vector field of the K-conjugate reproduces Reisenberger's {mu, lambda}
  D  the truncated phase space of Q5: symplectic matrix, inverse, V_X, all brackets with the clock
  E  a frame-dressed observable has a nonzero bracket with X (illustration)
  F  Moyal brackets in two Darboux charts (Q4)
  G  the corner identities of derivation.md Section 2.5 (steps 3, 4 and 8)
Conventions: Omega = (1/2) Omega_IJ d phi^I ^ d phi^J, Omega_IJ = d_I theta_J - d_J theta_I for Theta = theta_I d phi^I.
Paper (3.32),(3.33): dH = Omega(delta, V_H), {O, H} = V_H(O); hence V_H = Omega^{-1} grad H and
{F, G} = grad F . Omega^{-1} . grad G.  For Theta = p dq this gives {q, p} = 1.
"""
import sympy as sp

def hdr(s):
    print()
    print("=" * 100)
    print(s)
    print("=" * 100)

# --------------------------------------------------------------------------------------------
# Part A
# --------------------------------------------------------------------------------------------
hdr("PART A. Pointwise identities for (4.21)")

Z1, Z2 = sp.symbols('z1 z2', real=True)
def qbar(a, b):
    return sp.Matrix([[sp.exp(a), sp.exp(a)*b], [sp.exp(a)*b, sp.exp(-a) + sp.exp(a)*b**2]])

q = qbar(Z1, Z2)
print("A1. det qbar =", sp.simplify(q.det()))

d1, d2, e1, e2 = sp.symbols('d1 d2 e1 e2', real=True)   # two variations (d1,d2) and (e1,e2) of (z1,z2)
dq = q.diff(Z1)*d1 + q.diff(Z2)*d2
eq = q.diff(Z1)*e1 + q.diff(Z2)*e2
qi = q.inv()
lhs = sp.Rational(1, 2)*(qi*dq*qi*eq).trace()
rhs = d1*e1 + sp.exp(2*Z1)*d2*e2
print("A2. (4.21b): (1/2) qbar^AC qbar^BD dq_AB d'q_CD - [d z1 d'z1 + exp(2 z1) d z2 d'z2] =", sp.simplify(lhs - rhs))

v, s = sp.symbols('v s', positive=True)
z = [sp.Function('z1')(v), sp.Function('z2')(v)]
a = [sp.Function('a1')(v), sp.Function('a2')(v)]   # first variation
b = [sp.Function('b1')(v), sp.Function('b2')(v)]   # second variation
def gmat(zz):
    return sp.diag(1, sp.exp(2*zz[0]))
def gdot(zz, X, Y):
    G = gmat(zz)
    return sum(G[i, j]*X[i]*Y[j] for i in range(2) for j in range(2))
# Christoffel symbols of g = diag(1, exp(2 z1)): Gamma^1_22 = -exp(2 z1), Gamma^2_12 = Gamma^2_21 = 1
def nabla_v(zz, X):
    zd = [sp.diff(c, v) for c in zz]
    return [sp.diff(X[0], v) - sp.exp(2*zz[0])*zd[1]*X[1],
            sp.diff(X[1], v) + zd[0]*X[1] + zd[1]*X[0]]
t = sp.symbols('t')
def theta(zz, dz):          # theta(delta) = g_ab zdot^a delta z^b
    return gdot(zz, [sp.diff(c, v) for c in zz], dz)
zt_a = [z[i] + t*a[i] for i in range(2)]
zt_b = [z[i] + t*b[i] for i in range(2)]
curl = sp.diff(theta(zt_a, b), t).subs(t, 0) - sp.diff(theta(zt_b, a), t).subs(t, 0)
claim = gdot(z, nabla_v(z, a), b) - gdot(z, nabla_v(z, b), a)
print("A3. delta(g zdot . delta z) - [g(nabla_v d1 z, d2 z) - g(nabla_v d2 z, d1 z)] =", sp.simplify(sp.expand(curl - claim)))

kappa_v = lambda zz: v/4*gdot(zz, [sp.diff(c, v) for c in zz], [sp.diff(c, v) for c in zz])
dk = sp.diff(kappa_v(zt_a), t).subs(t, 0)
claim = v/2*gdot(z, [sp.diff(c, v) for c in z], nabla_v(z, a))
print("A4. delta kappa_v - (v/2) g(zdot, nabla_v delta z) =", sp.simplify(sp.expand(dk - claim)))

zd = [sp.diff(c, v) for c in z]
qv = qbar(z[0], z[1])
qvi = qv.inv()
lhs = sp.Rational(1, 8)*(qvi*qv.diff(v)*qvi*qv.diff(v)).trace()
rhs = sp.Rational(1, 4)*gdot(z, zd, zd)
print("A5. (1/8)(d_v qbar)^AB d_v qbar_AB - (1/4) g(zdot,zdot) =", sp.simplify(sp.expand(lhs - rhs)),
      "  [integrand of (3.26c) equals that of (4.22),(C.16b)]")

# --------------------------------------------------------------------------------------------
# Part B
# --------------------------------------------------------------------------------------------
hdr("PART B. Xi, J_eps, W_eps with h(v) = g(zdot,zdot) a generic cubic")
eps = sp.symbols('epsilon', positive=True)
c0, c1, c2, c3 = sp.symbols('c0:4')
w = sp.symbols('w', positive=True)
h = lambda x: c0 + c1*x + c2*x**2 + c3*x**3
Xi = lambda x: sp.Rational(1, 4)*sp.integrate(w*h(w), (w, eps, x))
Jeps = sp.Rational(1, 8)*sp.integrate(v*(1 - v**2)*h(v), (v, eps, 1))
Weps = sp.Rational(1, 4)*sp.integrate(v**3*h(v), (v, eps, 1))
print("B1. int_eps^1 v Xi(v) dv - J_eps =", sp.simplify(sp.integrate(v*Xi(v), (v, eps, 1)) - Jeps))
print("B2. W_eps - Xi(1) + 2 J_eps      =", sp.simplify(Weps - Xi(1) + 2*Jeps))
print("B3. int_eps^1 v^2 Xi'(v) dv - W_eps =", sp.simplify(sp.integrate(v**2*sp.diff(Xi(v), v), (v, eps, 1)) - Weps),
      "  [kappa_v = Xi', (A.23d)]")

# --------------------------------------------------------------------------------------------
# Part C: one generator, flat target (one polarization), generic polynomial data
# --------------------------------------------------------------------------------------------
hdr("PART C. One generator, one polarization (flat target): the null block")
K = sp.symbols('K', positive=True)
zc = sp.symbols('zc0:5')
z_f = sum(zc[i]*v**i for i in range(5))                     # background z(v)
ac = sp.symbols('ac0:5'); bc = sp.symbols('bc0:5')
da = sum(ac[i]*v**i for i in range(5))                      # first variation of z at fixed v
db = sum(bc[i]*v**i for i in range(5))                      # second variation
dK1, dK2 = sp.symbols('dK1 dK2')
zdot = sp.diff(z_f, v)

def N2p(dK1, d1, dK2, d2):
    """(N2'): (K/2) int v^2 (d1' d2 - d2' d1) + (1/2) dK ^ int [v^2 zdot dz + v^3 zdot dz'] """
    rad = K/2*sp.integrate(v**2*(sp.diff(d1, v)*d2 - sp.diff(d2, v)*d1), (v, eps, 1))
    m = lambda dz: sp.integrate(v**2*zdot*dz + v**3*zdot*sp.diff(dz, v), (v, eps, 1))
    return rad + sp.Rational(1, 2)*(dK1*m(d2) - dK2*m(d1))

def N2pp(dK1, d1, dK2, d2, with_eps_term=True):
    """(N2''): (K/2) int v^2 (do1' do2 - do2' do1) + (1/4) dK^(zdot dz)|_1 - (eps^3/4) dK^(zdot dz)|_eps,
       do = dz - (v/2)(dK/K) zdot  (A.13)."""
    o1 = d1 - v/2*dK1/K*zdot
    o2 = d2 - v/2*dK2/K*zdot
    rad = K/2*sp.integrate(sp.expand(v**2*(sp.diff(o1, v)*o2 - sp.diff(o2, v)*o1)), (v, eps, 1))
    end = lambda x: (dK1*(zdot*d2) - dK2*(zdot*d1)).subs(v, x)
    out = rad + sp.Rational(1, 4)*end(1)
    if with_eps_term:
        out = out - eps**3/4*end(eps)
    return out

diff_forms = sp.simplify(sp.expand(N2p(dK1, da, dK2, db) - N2pp(dK1, da, dK2, db)))
print("C1. (N2') - (N2'') on generic quartic data =", diff_forms)
diff_lit = sp.factor(sp.simplify(sp.expand(N2p(dK1, da, dK2, db) - N2pp(dK1, da, dK2, db, with_eps_term=False))))
print("C2. (N2') - [(N2'') without the term at v = eps] =")
print("    ", diff_lit)
print("    i.e. -(eps^3/4) dK ^ (zdot dz)|_{v=eps}: the term that (A.14) does not display when b = eps is held fixed.")

# C3: closedness.  Coordinates (K, zc0..zc4).  Build the matrix of a 2-form and take d.
coords_C = [K] + list(zc)
def matrix_of(form):
    n = len(coords_C)
    M = sp.zeros(n, n)
    basis = []
    for I in range(n):
        dKI = 1 if I == 0 else 0
        dzI = v**(I - 1) if I > 0 else sp.Integer(0)
        basis.append((dKI, dzI))
    for I in range(n):
        for J in range(n):
            M[I, J] = sp.simplify(form(basis[I][0], basis[I][1], basis[J][0], basis[J][1]))
    return M
def d_of(M):
    n = len(coords_C)
    worst = 0
    comps = {}
    for I in range(n):
        for J in range(I + 1, n):
            for L in range(J + 1, n):
                val = sp.simplify(sp.diff(M[J, L], coords_C[I]) + sp.diff(M[L, I], coords_C[J]) + sp.diff(M[I, J], coords_C[L]))
                if val != 0:
                    comps[(str(coords_C[I]), str(coords_C[J]), str(coords_C[L]))] = sp.factor(val)
    return comps
M_full = matrix_of(lambda x1, y1, x2, y2: N2pp(x1, y1, x2, y2, True))
M_lit = matrix_of(lambda x1, y1, x2, y2: N2pp(x1, y1, x2, y2, False))
print("C3. d(Omega_H) with the term at v = eps: nonzero components =", d_of(M_full))
dlit = d_of(M_lit)
print("C4. d(Omega_H) without the term at v = eps: number of nonzero components =", len(dlit))
some = list(dlit.items())[:3]
for k_, val in some:
    print("     e.g.", k_, ":", val)

# C5: Hamiltonian vector field of the K-conjugate (smeared with psi): V_K = psi, V_z = (psi/2K)(v zdot + zdot(1)/v).
psi = sp.symbols('psi')
Vz = psi/(2*K)*(v*zdot + zdot.subs(v, 1)/v)
# Omega_H(delta, V) for a test variation delta = (0, da): everything except the term at v = eps must cancel
val = N2pp(0, da, psi, Vz)   # N2pp is polynomial-only in the radial integral if Vz is; Vz has a 1/v term -> integrate directly
left_over = sp.simplify(sp.expand(val))
expected = sp.simplify(sp.expand((psi/2*da*(eps**3/2*zdot - eps/2*zdot.subs(v, 1))).subs(v, eps)))
# careful: zdot.subs(v,1) inside expected must not be substituted again; rebuild explicitly
zd1 = zdot.subs(v, 1); zde = zdot.subs(v, eps); dae = da.subs(v, eps)
expected = sp.simplify(sp.expand(psi/2*dae*(eps**3/2*zde - eps/2*zd1)))
print("C5. Omega_H(delta_z, V) with V_K = psi, V_z = (psi/2K)(v zdot + zdot(1)/v):")
print("    result - [term at v = eps only] =", sp.simplify(left_over - expected))
print("    so in the bulk and at v = 1 the equation Omega(delta, V) = psi * delta(Lambda) is solved by")
print("    {z(v,y), Lambda(y')} = (1/(2K)) [ v d_v z + (1/v) d_v z|_{v=1} ] delta(y,y')   (one branch, flat target);")
print("    the first term is Reisenberger 0712.2541 (17), 4 pi G/rho_0 = 1/(2K).  The left-over at v = eps is closed by")
print("    the cap and joint variables, which the truncation below does not contain.")

# --------------------------------------------------------------------------------------------
# Part D: the truncated phase space of Q5
# --------------------------------------------------------------------------------------------
hdr("PART D. Truncated phase space: coordinates (Lambda_1, kappa, a_1, a_2)")
Kb, G = sp.symbols('Kbar G_N', positive=True)
L1, kap, a1, a2, phi1 = sp.symbols('Lambda_1 kappa a_1 a_2 phi_1', real=True)
cL, N0, N1 = sp.symbols('c_Lambda N_0 N_1', real=True)
sH = sp.symbols('s_H', real=True)       # +1 or -1; (A.14) as displayed with b = eps < 1 gives s_H = -1
avec = [a1, a2]
coords = [L1, kap, a1, a2]
cnames = ["Lambda_1", "kappa", "a_1", "a_2"]

def build(A, B):
    """Theta = int eps_0 [ Lambda dK + s_H ( K alpha_eps - W_eps dK ) ] pulled back to the truncation:
       K = Kbar (1 + kappa Y), Lambda = Lambda_0 + Lambda_1 Y, z^1 = chi(y) sum_i a_i psi_i(v);
       A_ij = int_eps^1 v^2 psi_i' psi_j dv, B_ij = int_eps^1 v^3 psi_i' psi_j' dv,
       c_Lambda = int Y^2 eps_0, N_0 = int chi^2 eps_0, N_1 = int Y chi^2 eps_0."""
    Wt = sp.Rational(1, 4)*sum(avec[i]*avec[j]*B[i, j] for i in range(2) for j in range(2))
    theta = [sp.Integer(0),
             Kb*(cL*L1 - sH*N1*Wt),
             sH*Kb*(N0 + kap*N1)*sp.Rational(1, 2)*sum(avec[i]*A[i, 0] for i in range(2)),
             sH*Kb*(N0 + kap*N1)*sp.Rational(1, 2)*sum(avec[i]*A[i, 1] for i in range(2))]
    Om = sp.Matrix(4, 4, lambda I, J: sp.simplify(sp.diff(theta[J], coords[I]) - sp.diff(theta[I], coords[J])))
    return Wt, theta, Om

# (i) generic radial basis: A_ij and B_ij (symmetric) kept as symbols
A11, A12, A21, A22, B11, B12, B22 = sp.symbols('A_11 A_12 A_21 A_22 B_11 B_12 B_22', real=True)
A_g = sp.Matrix([[A11, A12], [A21, A22]]); B_g = sp.Matrix([[B11, B12], [B12, B22]])
Wt_g, theta_g, Om_g = build(A_g, B_g)
print("(i) Generic radial basis psi_1, psi_2.  Theta = theta_I d phi^I with")
for nme, th in zip(cnames, theta_g):
    print("     theta[%s] = %s" % (nme, sp.factor(th)))
print("    Symplectic matrix, Omega = (1/2) Omega_IJ d phi^I ^ d phi^J; upper triangle (the matrix is antisymmetric):")
for I in range(4):
    for Jx in range(I + 1, 4):
        print("     Omega[%s, %s] = %s" % (cnames[I], cnames[Jx], sp.factor(Om_g[I, Jx])))
print("    det Omega =", sp.factor(Om_g.det()))
Jg = Om_g.inv().applyfunc(sp.simplify)
print("    Inverse J = Omega^{-1} ({F,G} = d_I F J^{IJ} d_J G); upper triangle:")
for I in range(4):
    for Jx in range(I + 1, 4):
        print("     J[%s, %s] = %s" % (cnames[I], cnames[Jx], sp.factor(Jg[I, Jx])))
Xg = Kb*cL*phi1*kap
VXg = (Jg*sp.Matrix([sp.diff(Xg, cc) for cc in coords])).applyfunc(sp.simplify)
print("    V_X = J grad X for X = Kbar c_Lambda phi_1 kappa:", list(VXg), " in the order", cnames)
print()

# (ii) explicit radial modes psi_1 = v, psi_2 = v^2
psi_r = [v, v**2]
A = sp.Matrix(2, 2, lambda i, j: sp.integrate(v**2*sp.diff(psi_r[i], v)*psi_r[j], (v, eps, 1)))
B = sp.Matrix(2, 2, lambda i, j: sp.integrate(v**3*sp.diff(psi_r[i], v)*sp.diff(psi_r[j], v), (v, eps, 1)))
print("(ii) Explicit radial modes psi_1 = v, psi_2 = v^2:")
print("    A_ij = int_eps^1 v^2 psi_i' psi_j dv =", A.applyfunc(sp.simplify).tolist())
print("    B_ij = int_eps^1 v^3 psi_i' psi_j' dv =", B.applyfunc(sp.simplify).tolist())
Wt, theta, Om = build(A, B)
om12 = sp.simplify(A[0, 1] - A[1, 0])
print("    omega_12 = A_12 - A_21 =", om12)
M_mixed = (A + B).applyfunc(sp.simplify)
print("    M_ij = A_ij + B_ij =", M_mixed.tolist())
print("    Symplectic matrix, upper triangle:")
for I in range(4):
    for Jx in range(I + 1, 4):
        print("     Omega[%s, %s] = %s" % (cnames[I], cnames[Jx], sp.factor(Om[I, Jx])))
print("    det Omega =", sp.factor(Om.det()))
Jm = Om.inv().applyfunc(sp.simplify)
print("    Inverse, upper triangle:")
for I in range(4):
    for Jx in range(I + 1, 4):
        print("     J[%s, %s] = %s" % (cnames[I], cnames[Jx], sp.factor(Jm[I, Jx])))

def grad(F):
    return sp.Matrix([sp.diff(F, c) for c in coords])
def pb(F, Gf):
    return sp.simplify((grad(F).T*Jm*grad(Gf))[0, 0])

X = Kb*cL*phi1*kap                      # X = int phi K eps_0 with phi = phi_1 Y, int Y eps_0 = 0
VX = (Jm*grad(X)).applyfunc(sp.simplify)
print()
print("X = int phi K eps_0 = Kbar c_Lambda phi_1 kappa")
print("V_X (paper convention dX = Omega(delta, V_X)), components along (Lambda_1, kappa, a_1, a_2):", list(VX))
print("check Omega . V_X - grad X =", list((Om*VX - grad(X)).applyfunc(sp.simplify)))

print()
print("Brackets {coordinate, X} = V_X(coordinate):")
for c in coords:
    print("   {", c, ", X } =", pb(c, X))
print("Other brackets among the coordinates:")
print("   {kappa, Lambda_1} =", pb(kap, L1))
print("   {a_1, a_2}        =", sp.factor(pb(a1, a2)))
print("   {a_1, Lambda_1}   =", sp.factor(pb(a1, L1)))
print("   {a_2, Lambda_1}   =", sp.factor(pb(a2, L1)))
print("   {a_1, kappa}      =", pb(a1, kap), "   {a_2, kappa} =", pb(a2, kap), "   {kappa, kappa} =", pb(kap, kap))

# closedness of the truncated form
bad = []
for I in range(4):
    for Jx in range(I + 1, 4):
        for Lx in range(Jx + 1, 4):
            val = sp.simplify(sp.diff(Om[Jx, Lx], coords[I]) + sp.diff(Om[Lx, I], coords[Jx]) + sp.diff(Om[I, Jx], coords[Lx]))
            if val != 0:
                bad.append((I, Jx, Lx, val))
print("d Omega (truncated) nonzero components:", bad)

# Darboux coordinates of the truncated form:
#   Theta = Pi_kappa d kappa + ptil d qtil + exact,
#   Pi_kappa = Kbar [ c_Lambda Lambda_1 - s_H N_1 ( Wt + (1/4) a^T A_sym a ) ],
#   qtil = R a_2, ptil = R a_1, R^2 = s_H Kbar (N_0 + kappa N_1) omega_12 / 2   (positive for s_H = -1, omega_12 < 0)
As = (A + A.T)/2
Pi_k = Kb*(cL*L1 - sH*N1*(Wt + sp.Rational(1, 4)*sum(avec[i]*avec[j]*As[i, j] for i in range(2) for j in range(2))))
R2 = sH*Kb*(N0 + kap*N1)*(A[0, 1] - A[1, 0])/2
Rr = sp.sqrt(R2)
qt, pt = Rr*a2, Rr*a1
print()
print("Darboux chart (kappa, Pi_kappa; qtil, ptil):  Pi_kappa =", sp.factor(Pi_k))
print("   R^2 =", sp.factor(R2), ";  qtil = R a_2, ptil = R a_1")
names = ["kappa", "Pi_kappa", "qtil", "ptil"]
funs = [kap, Pi_k, qt, pt]
for I in range(4):
    for Jx in range(I + 1, 4):
        print("   {", names[I], ",", names[Jx], "} =", sp.simplify(pb(funs[I], funs[Jx])))
print("   In this chart X = Kbar c_Lambda phi_1 kappa is linear, and a_1 = ptil/R(kappa), a_2 = qtil/R(kappa).")

# ---- the clock, concrete angular profiles ----
print()
print("Concrete angular data: x = cos(theta), Y = P_2(x) (j = 2), z^1(v,y) = chi(y) (a_1 v + a_2 v^2), chi = x.")
x = sp.symbols('x', real=True)
Yx = (3*x**2 - 1)/2
chi = x
cL_v = 2*sp.pi*sp.integrate(Yx**2, (x, -1, 1))
N0_v = 2*sp.pi*sp.integrate(chi**2, (x, -1, 1))
N1_v = 2*sp.pi*sp.integrate(Yx*chi**2, (x, -1, 1))
print("   c_Lambda = int Y^2 eps_0 =", cL_v, ";  N_0 = int chi^2 eps_0 =", N0_v, ";  N_1 = int Y chi^2 eps_0 =", N1_v)
subsang = {cL: cL_v, N0: N0_v, N1: N1_v}

# second, independent construction of the matrix: from (N2'') with delta^o, integrated over the sphere
dL = sp.symbols('dL_a dL_b'); dkp = sp.symbols('dk_a dk_b'); dA1 = sp.symbols('da1_a da1_b'); dA2 = sp.symbols('da2_a da2_b')
Kx = Kb*(1 + kap*Yx)
z_tr = chi*(a1*v + a2*v**2)
zdot_tr = sp.diff(z_tr, v)
def var(i):
    return (Kb*Yx*dkp[i], chi*(dA1[i]*v + dA2[i]*v**2))
def OmH_bilinear(with_eps_term=True):
    (dKa, dza), (dKb_, dzb) = var(0), var(1)
    oa = dza - v/2*dKa/Kx*zdot_tr
    ob = dzb - v/2*dKb_/Kx*zdot_tr
    integrand = sp.cancel(sp.together(Kx/2*v**2*(sp.diff(oa, v)*ob - sp.diff(ob, v)*oa)))
    rad = sp.integrate(sp.expand(integrand), (v, eps, 1))
    end = lambda xx: (dKa*zdot_tr*dzb - dKb_*zdot_tr*dza).subs(v, xx)
    dens = rad + sp.Rational(1, 4)*end(1)
    if with_eps_term:
        dens = dens - eps**3/4*end(eps)
    return 2*sp.pi*sp.integrate(sp.expand(dens), (x, -1, 1))
def bilinear_to_matrix(expr_H, corner=True):
    # corner term: int eps_0 dLambda ^ dK = c_Lambda Kbar (dL_a dk_b - dL_b dk_a)
    total = sH*expr_H
    if corner:
        total = total + cL_v*Kb*(dL[0]*dkp[1] - dL[1]*dkp[0])
    va = [dL[0], dkp[0], dA1[0], dA2[0]]
    vb = [dL[1], dkp[1], dA1[1], dA2[1]]
    M = sp.zeros(4, 4)
    total = sp.expand(total)
    for I in range(4):
        for Jx in range(4):
            M[I, Jx] = sp.simplify(total.coeff(va[I], 1).coeff(vb[Jx], 1))
    return M
Om2 = bilinear_to_matrix(OmH_bilinear(True))
print("   Omega from the potential (D) minus Omega from (N2'') integrated over S:")
print("   ", (Om.subs(subsang) - Om2).applyfunc(sp.simplify))
Om_lit = bilinear_to_matrix(OmH_bilinear(False))
bad = []
for I in range(4):
    for Jx in range(I + 1, 4):
        for Lx in range(Jx + 1, 4):
            val = sp.simplify(sp.diff(Om_lit[Jx, Lx], coords[I]) + sp.diff(Om_lit[Lx, I], coords[Jx]) + sp.diff(Om_lit[I, Jx], coords[Lx]))
            if val != 0:
                bad.append(((str(coords[I]), str(coords[Jx]), str(coords[Lx])), sp.factor(val)))
print("   d Omega for the form without the term at v = eps (nonzero components):", bad)

Jc = Jm.subs(subsang).applyfunc(sp.simplify)
def pbc(F, Gf):
    gF = sp.Matrix([sp.diff(F, c) for c in coords]); gG = sp.Matrix([sp.diff(Gf, c) for c in coords])
    return sp.simplify((gF.T*Jc*gG)[0, 0])
Xc = X.subs(subsang)

vv = sp.symbols('v_0', positive=True)     # the fixed value of v at which z and Xi are evaluated
ww = sp.symbols('w', positive=True)
K_y = Kb*(1 + kap*Yx)                                     # K(y)
rho2_y = 8*sp.pi*G*K_y                                    # rho_S(y)^2
rhoS = sp.sqrt(rho2_y)
f_S = sp.log(1 + kap*Yx)                                  # (4.23) with int exp(f_S) eps_0 = 4 pi; A = 32 pi^2 G Kbar
z_y = chi*(a1*vv + a2*vv**2)                              # z^1(v_0, y)
Xi_y = lambda up: sp.Rational(1, 4)*chi**2*sp.integrate(ww*(a1 + 2*a2*ww)**2, (ww, eps, up))   # (3.26c),(4.22), one polarization
ustar = rhoS*sp.Integral(sp.exp(Xi_y(ww).subs(ww, sp.Symbol('r', positive=True))), (sp.Symbol('r', positive=True), eps, 1))   # (3.27)
ubar = sp.Integral(rhoS*ustar, (x, -1, 1))/sp.Integral(rhoS, (x, -1, 1))                       # (3.28), 2 pi cancels
area = 2*sp.pi*sp.integrate(rho2_y, (x, -1, 1))
print("   total area int rho_S^2 eps_0 =", sp.simplify(area), " (independent of kappa: fixed total area)")
print("   check (4.23): A exp(f_S)/int exp(f_S) eps_0 - rho_S^2 =",
      sp.simplify(area*sp.exp(f_S)/(2*sp.pi*sp.integrate(sp.exp(f_S), (x, -1, 1))) - rho2_y))
print()
print("Brackets of X with the ingredients of the clock (paper convention {O, X} = V_X(O)); y = the point x, v = v_0:")
ingredients = [("K(y)", K_y), ("rho_S(y)^2", rho2_y), ("f_S(y)", f_S), ("z^1(v_0,y)", z_y),
               ("d_v z^1(v_0,y)", sp.diff(z_y, vv)), ("Xi_y(v_0)", Xi_y(vv)), ("exp(Xi_y(v_0))", sp.exp(Xi_y(vv))),
               ("u_*(y)", ustar), ("ubar_*", ubar)]
for name, F in ingredients:
    print("   {", name, ", X } =", pbc(F, Xc))
print()
print("For contrast, brackets with the K-conjugate mode Lambda_1 (not zero):")
for name, F in ingredients[:6]:
    print("   {", name, ", Lambda_1 } =", sp.factor(pbc(F, L1)))
val = pbc(ustar, L1)
print("   { u_*(y), Lambda_1 } is zero? ", val == 0)

# --------------------------------------------------------------------------------------------
# Part E: a frame-dressed observable
# --------------------------------------------------------------------------------------------
hdr("PART E. Illustration: the conformal metric at fixed frame-normalized affine parameter s_0")
print("Model (assumption, see derivation.md): the K-conjugate is the log-normalization of the corner frame, so that the")
print("affine parameter measured from S in that frame is  s(v;y) = exp(Lambda(y)) int_1^v exp(Xi_y(w) - Xi_y(1)) dw.")
r = sp.Symbol('r', positive=True)
Lam_y = L1*Yx
s_of_v = sp.exp(Lam_y)*sp.Integral(sp.exp(Xi_y(r) - Xi_y(1)), (r, 1, vv))
ds_dv = sp.exp(Lam_y)*sp.exp(Xi_y(vv) - Xi_y(1))
ds_dL1 = Yx*s_of_v
# z_dressed(s_0) = z(v(s_0)); at fixed s_0: dv/dLambda_1 = -(ds/dLambda_1)/(ds/dv)
dzF_dL1 = sp.diff(z_y, vv)*(-ds_dL1/ds_dv)
VX_L1 = (Jc*sp.Matrix([sp.diff(Xc, c) for c in coords]))[0]
brk = sp.simplify(dzF_dL1*VX_L1)
print("   V_X(Lambda_1) =", sp.simplify(VX_L1))
print("   { z_dressed(s_0, y), X } = (d z_dressed/d Lambda_1) V_X(Lambda_1) =")
print("      ", brk)
I_s = sp.Symbol('I_s')                    # stands for int_1^v exp(Xi_y(w) - Xi_y(1)) dw
s_sym = sp.exp(Lam_y)*I_s
brk_sym = sp.diff(z_y, vv)*(-(Yx*s_sym)/ds_dv)*VX_L1
check_E = sp.simplify(brk_sym - phi1*Yx*s_sym*sp.diff(z_y, vv)/ds_dv)
print("   the same with the integral kept as a symbol, minus  phi(y) * s * (d_v z / d_v s)  =", check_E)
print("   so { z_dressed(s_0,y), X } = phi(y) s d_s z_dressed, phi(y) = phi_1 Y(y): a dilation of the dressed profile in s.")
print("   It does not vanish. (The overall sign follows the sign chosen for Lambda in the model for s.)")

# --------------------------------------------------------------------------------------------
# Part F: Moyal brackets in two Darboux charts
# --------------------------------------------------------------------------------------------
hdr("PART F. Moyal bracket (C.9) of X with clock ingredients in two Darboux charts")
hb = sp.symbols('hbar', positive=True)
def moyal_comm(f, g, pairs, nmax=5):
    """f*g - g*f = 2 sum_{n odd} (1/n!) (i hbar/2)^n P^n(f,g),  P = sum_i (d_qi (x) d_pi - d_pi (x) d_qi).
       Returns dict {n: coefficient of hbar^n} for odd n <= nmax."""
    prim = {}
    for (qq, pp) in pairs:
        prim[qq] = sp.Symbol(str(qq) + "_prime"); prim[pp] = sp.Symbol(str(pp) + "_prime")
    gp = g.subs(prim, simultaneous=True)
    def D(expr):
        out = 0
        for (qq, pp) in pairs:
            out += sp.diff(expr, qq, prim[pp]) - sp.diff(expr, pp, prim[qq])
        return out
    res = {}
    cur = f*gp
    back = {val: key for key, val in prim.items()}
    for n in range(1, nmax + 1):
        cur = D(cur)
        if n % 2 == 1:
            Pn = cur.subs(back, simultaneous=True)
            res[n] = sp.simplify(2*(sp.I/2)**n/sp.factorial(n)*Pn)
    return res

kq, Pk, qr, pr = sp.symbols('kappa Pi_kappa q p', real=True)
c, y0, n0, n1, g1 = sp.symbols('c y_0 n_0 n_1 g_1', positive=True)
pairsA = [(kq, Pk), (qr, pr)]
print("Chart A (K-adapted): canonical pairs (kappa, Pi_kappa), (q, p); a_1 ~ p/sqrt(n_0 + n_1 kappa), a_2 ~ q/sqrt(n_0 + n_1 kappa).")
XA = c*kq
FA = [("f_S(y) = log(1 + kappa y_0)", sp.log(1 + kq*y0)),
      ("z-mode a_1 = p/sqrt(n_0 + n_1 kappa)", pr/sp.sqrt(n0 + n1*kq)),
      ("z-mode a_2 = q/sqrt(n_0 + n_1 kappa)", qr/sp.sqrt(n0 + n1*kq)),
      ("exp(Xi)-type: exp(g_1 (p + 2 q)^2/(n_0 + n_1 kappa))", sp.exp(g1*(pr + 2*qr)**2/(n0 + n1*kq))),
      ("u_*-type: sqrt(1 + kappa y_0) exp(g_1 p^2/(n_0 + n_1 kappa))", sp.sqrt(1 + kq*y0)*sp.exp(g1*pr**2/(n0 + n1*kq)))]
for name, F in FA:
    print("   [X, F]_* coefficients of hbar^1, hbar^3, hbar^5 for F =", name, ":", moyal_comm(XA, F, pairsA))
print("   two nonlinear functions of the area distribution: [log(1+kappa y_0), 1/(1+kappa y_0)^2]_* :",
      moyal_comm(sp.log(1 + kq*y0), 1/(1 + kq*y0)**2, pairsA))
print("   a function of kappa with a function independent of Pi_kappa: [log(1+kappa y_0), exp(g_1 p^2/(n_0+n_1 kappa))]_* :",
      moyal_comm(sp.log(1 + kq*y0), sp.exp(g1*pr**2/(n0 + n1*kq)), pairsA))
print("   but the z-modes among themselves: [a_1, a_2]_* :", moyal_comm(pr/sp.sqrt(n0 + n1*kq), qr/sp.sqrt(n0 + n1*kq), pairsA, nmax=3))

print()
print("Chart B (not adapted): canonical pair (Q, P) with kappa = Q - (b/3) P^3, Pi_kappa = P  (a canonical map: {kappa, Pi_kappa} = 1).")
Q, P, bq = sp.symbols('Q P b', real=True)
pairsB = [(Q, P)]
kapB = Q - bq/3*P**3
print("   {kappa, Pi_kappa} in chart B =", sp.simplify(sp.diff(kapB, Q)*sp.diff(P, P) - sp.diff(kapB, P)*sp.diff(P, Q)))
XB = c*kapB
FB = sp.log(1 + kapB*y0)
resB = moyal_comm(XB, FB, pairsB)
print("   X = c (Q - b P^3/3),  F = f_S(y) = log(1 + y_0 (Q - b P^3/3))")
for n in sorted(resB):
    print("   coefficient of hbar^%d in X*F - F*X:" % n, sp.factor(sp.simplify(resB[n].subs(Q, kq + bq/3*P**3))), " (written with kappa = Q - b P^3/3)")
print("   The hbar^1 term is i hbar {X,F} = 0 (step 1). The hbar^3 term is  -(i hbar^3/24) P^3(X,F) = -(i hbar^3/12) b c f_S'''(kappa) != 0.")

# --------------------------------------------------------------------------------------------
# Part G: the two algebraic identities of derivation.md Section 2.5 (steps 4 and 8)
# --------------------------------------------------------------------------------------------
hdr("PART G. Corner identities of Section 2.5")
tt = sp.symbols('t')
# normal plane with an arbitrary t-dependent metric and two arbitrary t-dependent vectors l_p, l_q
g11, g12, g22 = [sp.Function(n)(tt) for n in ('g11', 'g12', 'g22')]
gm = sp.Matrix([[g11, g12], [g12, g22]])
lp = sp.Matrix([sp.Function('p1')(tt), sp.Function('p2')(tt)])
lq = sp.Matrix([sp.Function('q1')(tt), sp.Function('q2')(tt)])
ip = lambda a_, b_: (a_.T*gm*b_)[0, 0]
Ecor = -ip(lp, lq)
n_p = lq/Ecor
n_q = lp/Ecor
def Ups(l_, n_):
    return (ip(l_, sp.diff(n_, tt)) - ip(n_, sp.diff(l_, tt)))/(2*(-ip(l_, n_)))
print("G1. Upsilon_p + Upsilon_q - d log(-l_p . l_q) =", sp.simplify(Ups(lp, n_p) + Ups(lq, n_q) - sp.diff(sp.log(Ecor), tt)))
# rescaling: l = e^a L, n = e^{-a} N with L.N = -1
af = sp.Function('a')(tt)
print("G2. Upsilon[e^a l, e^-a n] - Upsilon[l, n] - da =",
      sp.simplify(Ups(sp.exp(af)*lp, sp.exp(-af)*n_p) - Ups(lp, n_p) - sp.diff(af, tt)))
# step 8: the one-form  -(1-eps^2) K dP + K dXi1 + [eps^2 P - P + Xi1 + log 2] dK  is closed
Ks, Ps, X1 = sp.symbols('K P Xi_1')
cK = eps**2*Ps - Ps + X1 + sp.log(2); cP = -(1 - eps**2)*Ks; cX = Ks
closed = [sp.simplify(sp.diff(cK, Ps) - sp.diff(cP, Ks)), sp.simplify(sp.diff(cK, X1) - sp.diff(cX, Ks)), sp.simplify(sp.diff(cP, X1) - sp.diff(cX, Ps))]
pot = -(1 - eps**2)*Ks*Ps + Ks*X1 + sp.log(2)*Ks
exact = [sp.simplify(sp.diff(pot, Ks) - cK), sp.simplify(sp.diff(pot, Ps) - cP), sp.simplify(sp.diff(pot, X1) - cX)]
print("G3. curl of the P- and Xi(1)-dependent one-form of step 8:", closed, "; minus d[-(1-eps^2) K P + K Xi(1) + K log 2]:", exact)
