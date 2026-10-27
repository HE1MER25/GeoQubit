# Reads h2_dft_run/dft_curve.csv (and dft_far.csv if present); prints bond length,
# vibration wavenumber and binding energy. Needs numpy only.   Usage: python3 analyse_dft.py
import csv, os, numpy as np

D = "h2_dft_run"
HA_EV, HA_J, ANG, AMU, C_CM = 27.211386, 4.3597447e-18, 1e-10, 1.66053907e-27, 2.99792458e10
MU = 1.00782503 * AMU / 2

rows = list(csv.DictReader(open(os.path.join(D, "dft_curve.csv"))))
d  = np.array([float(r["distance_A"]) for r in rows])
res = np.array([float(r["restricted_Ha"]) for r in rows])
sb  = np.array([float(r["spinbroken_Ha"]) for r in rows])

def fit(e):
    m = (d >= 0.6) & (d <= 0.9)
    p = np.polyfit(d[m], e[m], 4)
    roots = np.roots(np.polyder(p)); roots = roots[np.isreal(roots)].real
    re = roots[(roots > 0.6) & (roots < 0.9)][0]
    k = np.polyval(np.polyder(p, 2), re) * HA_J / ANG**2          # N/m
    return re, np.polyval(p, re), k, np.sqrt(k / MU) / (2 * np.pi * C_CM)

print("%-14s %9s %10s %12s" % ("", "Re (A)", "k (N/m)", "freq (cm-1)"))
for name, e in [("restricted", res), ("spin-broken", sb)]:
    re, emin, k, w = fit(e)
    print("%-14s %9.4f %10.1f %12.0f" % (name, re, k, w))
print("%-14s %9.4f %10s %12d" % ("experiment", 0.7414, "575", 4401))

emin = fit(sb)[1]
far = {3.0: sb[np.isclose(d, 3.0)][0]}
fp = os.path.join(D, "dft_far.csv")
if os.path.exists(fp):
    for r in csv.DictReader(open(fp)):
        far[float(r["distance_A"])] = float(r["spinbroken_Ha"])
print("\nBinding energy De = E(stretched, spin-broken) - E(minimum), in eV (experiment 4.747):")
for x, e in sorted(far.items()):
    print("  at %.1f A: %.3f eV" % (x, (e - emin) * HA_EV))
r3 = res[np.isclose(d, 3.0)][0]
print("\nAt 3.0 A restricted minus spin-broken: %.2f eV (restricted is too high)" % ((r3 - far[3.0]) * HA_EV))
