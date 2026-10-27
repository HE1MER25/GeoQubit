import csv
import numpy as np
from pyscf import gto, scf
from qiskit.primitives import StatevectorEstimator
from qiskit_algorithms import VQE, NumPyMinimumEigensolver
from qiskit_algorithms.optimizers import SLSQP
from qiskit_nature.second_q.drivers import PySCFDriver
from qiskit_nature.second_q.mappers import ParityMapper
from qiskit_nature.second_q.circuit.library import UCCSD, HartreeFock
from qiskit_nature.units import DistanceUnit

# fine grid around the minimum, so we can measure the curvature accurately
DISTANCES = [round(x, 2) for x in np.arange(0.60, 0.9001, 0.02)]

def solve(d):
    driver = PySCFDriver(atom=f"H 0 0 0; H 0 0 {d}", basis="sto3g", charge=0, spin=0,
                         unit=DistanceUnit.ANGSTROM)
    problem = driver.run()
    mapper = ParityMapper(num_particles=problem.num_particles)
    op = mapper.map(problem.hamiltonian.second_q_op())
    shift = problem.nuclear_repulsion_energy
    exact = NumPyMinimumEigensolver().compute_minimum_eigenvalue(op).eigenvalue.real + shift
    ansatz = UCCSD(problem.num_spatial_orbitals, problem.num_particles, mapper,
                   initial_state=HartreeFock(problem.num_spatial_orbitals, problem.num_particles, mapper))
    vqe = VQE(StatevectorEstimator(), ansatz, SLSQP(maxiter=200),
              initial_point=np.zeros(ansatz.num_parameters))
    vqe_e = vqe.compute_minimum_eigenvalue(op).eigenvalue.real + shift
    return exact, vqe_e

# energy of ONE hydrogen atom in the same STO-3G basis (one electron, so UHF is exact)
mol = gto.M(atom="H 0 0 0", basis="sto3g", spin=1, verbose=0)
E_H = scf.UHF(mol).kernel()

# unit conversions
HA_TO_EV = 27.211386
HA_TO_J = 4.3597447e-18
ANG = 1e-10
AMU = 1.66053907e-27
C_CM = 2.99792458e10          # speed of light in cm/s
MU = 1.00782503 * AMU / 2     # reduced mass of H2 (two equal masses)

def analyse(d, e):
    """Fit a quartic near the minimum, return bond length, frequency and binding energy."""
    p = np.polyfit(d, e, 4)
    roots = np.roots(np.polyder(p))
    roots = roots[np.isreal(roots)].real
    re = roots[(roots > d.min()) & (roots < d.max())][0]
    emin = np.polyval(p, re)
    k_ha_per_A2 = np.polyval(np.polyder(p, 2), re)       # d2E/dR2 in Ha/A^2
    k_si = k_ha_per_A2 * HA_TO_J / ANG**2                # N/m
    wavenumber = np.sqrt(k_si / MU) / (2 * np.pi * C_CM) # cm^-1
    de_ha = 2 * E_H - emin
    return re, emin, k_si, wavenumber, de_ha

rows = []
for dist in DISTANCES:
    ex, v = solve(dist)
    rows.append((dist, ex, v))
    print(f"d={dist:4.2f}  exact={ex:.6f}  vqe={v:.6f}  diff={abs(ex-v):.1e}", flush=True)

with open("h2_fine_curve.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["distance_A", "exact_Ha", "vqe_Ha"])
    w.writerows(rows)

d = np.array([r[0] for r in rows])
ex = np.array([r[1] for r in rows])
vq = np.array([r[2] for r in rows])

print("\nSingle H atom (STO-3G): %.6f Ha" % E_H)
print("\n%-8s %10s %12s %14s %12s" % ("method", "Re (A)", "k (N/m)", "freq (cm^-1)", "De (eV)"))
for name, e in [("exact", ex), ("VQE", vq)]:
    re, emin, k, wn, de = analyse(d, e)
    print("%-8s %10.4f %12.1f %14.0f %12.3f" % (name, re, k, wn, de * HA_TO_EV))
print("%-8s %10.4f %12s %14.0f %12.3f" % ("expt.", 0.7414, "575", 4401, 4.747))
print("\nSaved h2_fine_curve.csv")
