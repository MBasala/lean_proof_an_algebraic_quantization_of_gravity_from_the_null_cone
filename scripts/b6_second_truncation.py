# Break attempt B6 (handoff.md Section 14.8), second derivation: its finite check, as written by the
# derivation agent on 2026-11-26. Output: notes/b6-second-truncation-output.txt.
# Text: notes/b6-derivation-second.md.
# Run from the repository root:  .venv/Scripts/python.exe -I -X utf8 scripts/b6_second_truncation.py
# q5_truncation.py
# Finite check for Q5 (and the Moyal statements of Q4) of derivation.md.
#
# Truncation of the Q2 form (fixed total corner area, fixed angular identification):
#   K(y)      = K0 + k * Yh(y)                 one non-constant harmonic of the area density
#   lambda(y) = l * Yh(y)   (mod constants)    its conjugate boost mode
#   z^1(v,y)  = W(y) * (a1*R1(v) + a2*R2(v)),  z^2 = 0     two radial modes, one polarization
# Coordinates on the truncated phase space: (l, k, a1, a2).
#
# Q2 form on these variables (orientation sign sH = -1 is the one of (A.14) with b = eps < 1):
#   Omega = int eps0 { dlam ^ dK
#                      + sH * [ (K/2) int_eps^1 v^2 (dz' ^ dz) dv
#                               + dK ^ (1/2) int_eps^1 ( v^2 z' dz + v^3 z' dz' ) dv ] }
# Convention: Omega(V_F, .) = dF, {F, G} = V_F(G) = grad(F)^T P grad(G), P = Omega^{-1}
# (this is Reisenberger's (5), and it gives the same bracket as (3.32)-(3.33) of the paper).
import sympy as sp
import mpmath as mp

x, xp, v, vp, s = sp.symbols('x x_p v v_p s', real=True)
l, k, a1, a2 = sp.symbols('l k a1 a2', real=True)
eps, K0, G = sp.symbols('epsilon K0 G', positive=True)
coords = [l, k, a1, a2]
names = ['l', 'k', 'a1', 'a2']


def build(Yh, W, R1, R2, sH=-1, extra_joint_term=False):
    """Return the 4x4 matrix Omega_IJ = Omega(e_I, e_J) of the Q2 form in (l, k, a1, a2)."""
    def ang(f):
        return 2 * sp.pi * sp.integrate(sp.expand(f), (x, -1, 1))

    def rad(f):
        return sp.integrate(sp.expand(f), (v, eps, 1))

    Kx = K0 + k * Yh
    z = W * (a1 * R1 + a2 * R2)
    zp = sp.diff(z, v)
    dlam = [Yh, 0, 0, 0]
    dK = [0, Yh, 0, 0]
    dz = [0, 0, W * R1, W * R2]
    Om = sp.zeros(4, 4)
    for I in range(4):
        for J in range(4):
            t1 = dlam[I] * dK[J] - dlam[J] * dK[I]
            t3 = Kx / 2 * rad(v**2 * (sp.diff(dz[I], v) * dz[J] - sp.diff(dz[J], v) * dz[I]))
            t45 = sp.Rational(1, 2) * (dK[I] * rad(v**2 * zp * dz[J] + v**3 * zp * sp.diff(dz[J], v))
                                       - dK[J] * rad(v**2 * zp * dz[I] + v**3 * zp * sp.diff(dz[I], v)))
            tot = t1 + sH * (t3 + t45)
            if extra_joint_term:
                # literal substitution b = eps in (A.14): extra -(eps^3/4) dK ^ z'(eps) dz(eps)
                tot += -eps**3 / 4 * (dK[I] * (zp * dz[J]).subs(v, eps) - dK[J] * (zp * dz[I]).subs(v, eps))
            Om[I, J] = sp.simplify(ang(tot))
    return Om, Kx, z


def bracket(F, Gf, P, crd=coords):
    gF = sp.Matrix([sp.diff(F, c) for c in crd])
    gG = sp.Matrix([sp.diff(Gf, c) for c in crd])
    return (gF.T * P * gG)[0, 0]


Yh = sp.sqrt(sp.Rational(5, 4) / sp.pi) * sp.legendre(2, x)       # Y_20, int Yh^2 dOmega = 1
W = Yh                                                            # angular profile of the radiative mode
R1, R2 = v, v**2

print("=" * 76)
print("Q5.1  symplectic matrix, basis (l, k, a1, a2);  Yh = W = Y_20, R1 = v, R2 = v^2")
Om, Kx, z = build(Yh, W, R1, R2)
print("  checks: int Yh = %s, int Yh^2 = %s, int Yh^3 = %s" % (
    2 * sp.pi * sp.integrate(Yh, (x, -1, 1)), 2 * sp.pi * sp.integrate(Yh**2, (x, -1, 1)),
    sp.simplify(2 * sp.pi * sp.integrate(Yh**3, (x, -1, 1)))))
for I in range(4):
    for J in range(I + 1, 4):
        print("  Omega[%s,%s] = %s" % (names[I], names[J], sp.factor(Om[I, J])))
print("  antisymmetric:", sp.simplify(Om + Om.T) == sp.zeros(4, 4))
# closure d Omega = 0
closed = True
for I in range(4):
    for J in range(4):
        for L in range(4):
            cyc = sp.diff(Om[J, L], coords[I]) + sp.diff(Om[L, I], coords[J]) + sp.diff(Om[I, J], coords[L])
            if sp.simplify(cyc) != 0:
                closed = False
print("  closed (d Omega = 0):", closed)
print("  det Omega =", sp.factor(Om.det()))
P = Om.inv().applyfunc(sp.simplify)
print("Q5.2  Poisson matrix P = Omega^{-1}  ({phi^I, phi^J} = P[I,J])")
for I in range(4):
    for J in range(I + 1, 4):
        print("  {%s,%s} = %s" % (names[I], names[J], sp.factor(P[I, J])))

print("=" * 76)
print("Q5.3  brackets of X = int phi K eps0, phi = Yh (so X = k), with the clock ingredients")
X = 2 * sp.pi * sp.integrate(sp.expand(Yh * Kx), (x, -1, 1))
print("  X =", sp.simplify(X))
Yp = Yh.subs(x, xp)
Wp = W.subs(x, xp)
Kp = K0 + k * Yp                                   # K(y')
cF = sp.Function('c_f')(k)                         # normalization "constant" of f_S in (4.23): any function of K
fS = sp.log(Kp) + cF                               # f_S(y')
fS_diff = sp.log((K0 + k * Yh.subs(x, sp.Rational(1, 3))) / (K0 + k * Yh.subs(x, sp.Rational(-4, 5))))
zpt = Wp * (a1 * R1.subs(v, vp) + a2 * R2.subs(v, vp))          # z^1(v', y')
dzs = Wp * (a1 * sp.diff(R1, v) + a2 * sp.diff(R2, v)).subs(v, s)
Xi_vp = sp.Rational(1, 4) * sp.integrate(sp.expand(s * dzs**2), (s, eps, vp))    # (3.26c) = (4.22) with z^2 = 0
Xi_v = Xi_vp.subs(vp, v)
rhoS = sp.sqrt(8 * sp.pi * G * Kp)
ustar = rhoS * sp.Integral(sp.exp(Xi_v), (v, eps, 1))            # (3.27)
num = sp.Integral((rhoS * ustar).subs(xp, x), (x, -1, 1))
den = sp.Integral(rhoS.subs(xp, x), (x, -1, 1))
ubar = num / den                                                 # (3.28)
obs = [("l (boost mode)", l), ("k", k), ("a1", a1), ("a2", a2), ("K(y')", Kp), ("f_S(y')", fS),
       ("f_S(y1)-f_S(y2)", fS_diff), ("z(v',y')", zpt), ("Xi_{y'}(v')", Xi_vp),
       ("u_*(y')", ustar), ("ubar_*", ubar)]
for nm, O in obs:
    print("  {X, %s} = %s" % (nm, sp.simplify(bracket(X, O, P))))

print("=" * 76)
print("Q5.4  for contrast: brackets of the boost mode l with the same quantities")
for nm, O in obs[1:9]:
    print("  {l, %s} = %s" % (nm, sp.factor(sp.simplify(bracket(l, O, P)))))

print("=" * 76)
print("Q5.5  numerical evaluation at a generic point (mpmath quadrature, finite differences)")
mp.mp.dps = 25
pt = {eps: mp.mpf('0.2'), K0: mp.mpf(1), G: 1 / (8 * mp.pi), k: mp.mpf('0.3'), a1: mp.mpf('0.7'), a2: mp.mpf('-0.4'),
      l: mp.mpf('0.11')}
Pn = sp.lambdify(coords, P.subs({eps: pt[eps], K0: pt[K0]}), 'mpmath')
Yh_n = sp.lambdify(x, Yh, 'mpmath')
R1p = sp.lambdify(s, sp.diff(R1, v).subs(v, s), 'mpmath')
R2p = sp.lambdify(s, sp.diff(R2, v).subs(v, s), 'mpmath')


def ustar_num(kk, b1, b2, xx):
    Kloc = pt[K0] + kk * Yh_n(xx)
    rho = mp.sqrt(8 * mp.pi * pt[G] * Kloc)
    w2 = Yh_n(xx)**2

    def Xi(vv):
        return mp.quad(lambda ss: ss * w2 * (b1 * R1p(ss) + b2 * R2p(ss))**2 / 4, [pt[eps], vv])
    return rho * mp.quad(lambda vv: mp.exp(Xi(vv)), [pt[eps], 1])


def ubar_num(kk, b1, b2):
    rho = lambda xx: mp.sqrt(8 * mp.pi * pt[G] * (pt[K0] + kk * Yh_n(xx)))
    return (mp.quad(lambda xx: rho(xx) * ustar_num(kk, b1, b2, xx), [-1, 1]) / mp.quad(rho, [-1, 1]))


def num_grad(fun):
    """gradient with respect to (l, k, a1, a2); fun takes (k, a1, a2) and does not depend on l"""
    h = mp.mpf('1e-6')
    base = [pt[k], pt[a1], pt[a2]]
    g = [mp.mpf(0)]
    for i in range(3):
        up = list(base); dn = list(base)
        up[i] += h; dn[i] -= h
        g.append((fun(*up) - fun(*dn)) / (2 * h))
    return mp.matrix(g)


mp.mp.dps = 15
Pnum = Pn(pt[l], pt[k], pt[a1], pt[a2])
gX = mp.matrix([0, 1, 0, 0])
gl = mp.matrix([1, 0, 0, 0])
for nm, fun in [("u_*(y' : cos theta = 0.3)", lambda kk, b1, b2: ustar_num(kk, b1, b2, mp.mpf('0.3'))),
                ("ubar_*", ubar_num)]:
    gF = num_grad(fun)
    print("  %-26s value = %s" % (nm, mp.nstr(fun(pt[k], pt[a1], pt[a2]), 10)))
    print("     grad (l,k,a1,a2) = %s" % [mp.nstr(gF[i], 8) for i in range(4)])
    print("     {X, .} = %s      {l, .} = %s" % (mp.nstr((gX.T * Pnum * gF)[0], 8), mp.nstr((gl.T * Pnum * gF)[0], 8)))

print("=" * 76)
print("Q5.6  robustness: other radial modes / orientation sign / joint-located term / (3.42b) chart")
for label, kw, modes in [
        ("sH = +1 (opposite orientation of the cone block)", dict(sH=+1), (v, v**2)),
        ("literal b=eps in (A.14): extra -(eps^3/4) dK^z'dz|_eps", dict(extra_joint_term=True), (v, v**2)),
        ("modes R1 = 1/v, R2 = v^3 - v", dict(), (1 / v, v**3 - v))]:
    OmV, _, _ = build(Yh, W, modes[0], modes[1], **kw)
    PV = OmV.inv().applyfunc(sp.simplify)
    print("  %s" % label)
    print("     {k,l} = %s, {k,a1} = %s, {k,a2} = %s, {k,k} = %s ; {l,a1} nonzero: %s, {a1,a2} nonzero: %s" % (
        PV[1, 0], PV[1, 2], PV[1, 3], PV[1, 1], sp.simplify(PV[0, 2]) != 0, sp.simplify(PV[2, 3]) != 0))

# (3.42b) chart: Theta = int eps0 K (alpha - 2 dJ + dGamma)  =>  Omega = d Theta, coordinates (Gam, k, a1, a2)
Gam = sp.symbols('Gamma_1', real=True)
c342 = [Gam, k, a1, a2]
zz = W * (a1 * R1 + a2 * R2)
zzp = sp.diff(zz, v)
Jx = sp.Rational(1, 8) * sp.integrate(sp.expand(v * (1 - v**2) * zzp**2), (v, eps, 1))
dzz = [0, 0, W * R1, W * R2]
theta_comp = []
for I in range(4):
    alpha_I = sp.Rational(1, 2) * sp.integrate(sp.expand(v**2 * zzp * dzz[I]), (v, eps, 1))
    dJ_I = sp.diff(Jx, c342[I])
    dGam_I = Yh if I == 0 else 0
    theta_comp.append(2 * sp.pi * sp.integrate(sp.expand((K0 + k * Yh) * (alpha_I - 2 * dJ_I + dGam_I)), (x, -1, 1)))
Om342 = sp.zeros(4, 4)
for I in range(4):
    for J in range(4):
        Om342[I, J] = sp.simplify(sp.diff(theta_comp[J], c342[I]) - sp.diff(theta_comp[I], c342[J]))
P342 = Om342.inv().applyfunc(sp.simplify)
print("  (3.42b) chart (Gamma_1, k, a1, a2):")
print("     {k,Gamma_1} = %s, {k,a1} = %s, {k,a2} = %s ; {Gamma_1,a1} nonzero: %s" % (
    P342[1, 0], P342[1, 2], P342[1, 3], sp.simplify(P342[0, 2]) != 0))
# relation of the two charts: Omega_342 = - Omega_(A.14 orientation) under l = Gamma_1 - (Xi(1))_1 + ...
Xi1x = sp.Rational(1, 4) * sp.integrate(sp.expand(v * zzp**2), (v, eps, 1))
Xi1_mode = 2 * sp.pi * sp.integrate(sp.expand(Yh * Xi1x), (x, -1, 1))        # Yh-component of Xi_y(1)
lam_of = Gam - Xi1_mode
Jac = sp.Matrix([[sp.diff(e, c) for c in c342] for e in [lam_of, k, a1, a2]])
pulled = (Jac.T * Om * Jac).applyfunc(sp.simplify)
print("     Omega_(3.42b) + pullback of Omega_Q2 under l = Gamma_1 - <Yh, Xi(1)> :",
      (Om342 + pulled).applyfunc(sp.simplify).tolist())

print("=" * 76)
print("Q5.7  adding the joint mode beta_C = bC * Yh:  -eps_C eps^2 dbeta ^ dK   (5 variables)")
bC, eC = sp.symbols('b_C epsilon_C', real=True)
c5 = [l, bC, k, a1, a2]
Om5 = sp.zeros(5, 5)
idx = {0: 0, 1: 2, 2: 3, 3: 4}
for I in range(4):
    for J in range(4):
        Om5[idx[I], idx[J]] = Om[I, J]
Om5[1, 2] = -eC * eps**2          # int Yh^2 = 1
Om5[2, 1] = +eC * eps**2
print("  rank =", Om5.rank(), " kernel =", [list(n_) for n_ in Om5.nullspace()])
Vsym = sp.symbols('V_l V_bC V_k V_a1 V_a2')
gradX5 = sp.Matrix([0, 0, 1, 0, 0])
eqs = list((sp.Matrix(Vsym).T * Om5).T - gradX5)        # Omega(V, .) = dX
sol = sp.solve(eqs, Vsym, dict=True)
print("  general solution of Omega(V_X, .) = dX :", sol)

print("=" * 76)
print("Q4   Darboux chart of the truncated form and Moyal terms")
c0 = 2 * sp.pi * sp.integrate(W**2, (x, -1, 1))
c1_ = sp.simplify(2 * sp.pi * sp.integrate(sp.expand(Yh * W**2), (x, -1, 1)))
Rm = [R1, R2]
A = sp.Matrix(2, 2, lambda m, i: sp.integrate(sp.expand(v**2 * sp.diff(Rm[m], v) * Rm[i]), (v, eps, 1)))
B = sp.Matrix(2, 2, lambda m, n_: sp.integrate(sp.expand(v**3 * sp.diff(Rm[m], v) * sp.diff(Rm[n_], v)), (v, eps, 1)))
w = (A[0, 1] - A[1, 0]) / 2
S = (A + A.T) / 2 + B
avec = sp.Matrix([a1, a2])
sH = -1
Kc = K0 * c0 + k * c1_
Lam = l - sH * c1_ / 4 * (avec.T * S * avec)[0, 0]
at1 = sp.sqrt(Kc) * a1
at2 = sp.sqrt(Kc) * a2
print("  c0 = %s, c1 = %s, w = %s" % (c0, c1_, sp.factor(w)))
print("  {k, Lam} = %s, {at1, at2} * (-sH*w) = %s, {k, at1} = %s, {k, at2} = %s, {Lam, at1} = %s, {Lam, at2} = %s" % (
    sp.simplify(bracket(k, Lam, P)), sp.simplify(bracket(at1, at2, P) * (-sH * w)),
    sp.simplify(bracket(k, at1, P)), sp.simplify(bracket(k, at2, P)),
    sp.simplify(bracket(Lam, at1, P)), sp.simplify(bracket(Lam, at2, P))))
print("  => canonical pairs (q1,p1) = (k, Lam), (q2,p2) = (at1, -sH*w*at2); a_i = at_i/sqrt(K0 c0 + c1 k).")

q1, p1, q2, p2 = sp.symbols('q1 p1 q2 p2', real=True)
y1, y2, y3, y4 = sp.symbols('y1 y2 y3 y4', real=True)
hb, eta, kap = sp.symbols('hbar eta kappa', positive=True)
xs = [q1, p1, q2, p2]
ys = [y1, y2, y3, y4]


def Pn_bidiff(f, g, n):
    """P^n(f,g) with P(f,g) = sum_a (d_qa f d_pa g - d_pa f d_qa g) = {f,g}: n-th Moyal bidifferential term."""
    E = f * g.subs(dict(zip(xs, ys)), simultaneous=True)
    for _ in range(n):
        E = (sp.diff(E, q1, y2) - sp.diff(E, p1, y1) + sp.diff(E, q2, y4) - sp.diff(E, p2, y3))
    return sp.simplify(E.subs(dict(zip(ys, xs)), simultaneous=True))


Ksym, c1s, c0s, ws, ypt = sp.symbols('K0 c1 c0 w Y_p', positive=True)
print("  chart I  (K-mode is a canonical coordinate):  X = q1")
XI = q1
FI = [("a1 = q2/sqrt(K0 c0 + c1 q1)", q2 / sp.sqrt(Ksym * c0s + c1s * q1)),
      ("a2 = p2/(w sqrt(K0 c0 + c1 q1))", p2 / (ws * sp.sqrt(Ksym * c0s + c1s * q1))),
      ("f_S = log(K0 + q1 Y_p)", sp.log(Ksym + q1 * ypt)),
      ("Xi-type: (a1 + 2 a2)^2", (q2 + 2 * p2 / ws)**2 / (Ksym * c0s + c1s * q1))]
for nm, F in FI:
    print("     %-34s P1 = %s, P3 = %s, P5 = %s" % (nm, Pn_bidiff(XI, F, 1), Pn_bidiff(XI, F, 3), Pn_bidiff(XI, F, 5)))
print("  chart II (f-type coordinate: k = kappa*tanh(q1), conjugate p1 = Lam * dk/dq1):  X = kappa*tanh(q1)")
XII = kap * sp.tanh(q1)
FII = [("a1", q2 / sp.sqrt(Ksym * c0s + c1s * kap * sp.tanh(q1))),
       ("f_S", sp.log(Ksym + kap * sp.tanh(q1) * ypt))]
for nm, F in FII:
    print("     %-34s P1 = %s, P3 = %s, P5 = %s" % (nm, Pn_bidiff(XII, F, 1), Pn_bidiff(XII, F, 3), Pn_bidiff(XII, F, 5)))
print("  chart III (nonlinearly related Darboux chart: Q = k + eta*Lam^3, P = Lam):  X = q1 - eta*p1^3")
XIII = q1 - eta * p1**3
FIII = [("a1", q2 / sp.sqrt(Ksym * c0s + c1s * (q1 - eta * p1**3))),
        ("f_S", sp.log(Ksym + (q1 - eta * p1**3) * ypt))]
for nm, F in FIII:
    t1 = Pn_bidiff(XIII, F, 1)
    t3 = Pn_bidiff(XIII, F, 3)
    print("     %-6s P1 = %s" % (nm, t1))
    print("            P3 = %s" % sp.factor(t3))
    print("            => X*F - F*X = i hbar P1 - (i hbar^3/24) P3 + O(hbar^5) = %s + O(hbar^5)" % sp.factor(
        sp.I * hb * t1 - sp.I * hb**3 / 24 * t3))
