# GroundStateDuo: Potential Energy Curve of H2 with DFT and a Quantum Algorithm

Qiskit Fall Fest 2026 (UIQC). Team: Thomas Adesoye Adeoye (tadeoye137), Damilare Jeremiah Ojo.

We computed the ground-state energy of H2 against the H-H distance with
(1) exact diagonalisation (reference), (2) VQE in Qiskit (noise-free simulator, STO-3G) and
(3) DFT in Quantum ESPRESSO (PBE), then compared bond length, vibration and binding energy.

## Results

| Method | Bond length (A) | Vibration (cm-1) | Binding energy (eV) |
| --- | --- | --- | --- |
| Exact diagonalisation (STO-3G) | 0.7346 | 5015 | 5.555 |
| VQE (STO-3G) | 0.7346 | 5015 | 5.555 |
| DFT, PBE, spin-broken | 0.750 | about 4315 | about 4.5 |
| Experiment | 0.7414 | 4401 | 4.747 |

VQE matches exact diagonalisation to better than 5e-7 Ha at every distance. Spin-restricted PBE
overestimates the binding energy by about 1.6 eV at 3 A; spin-broken-symmetry PBE removes that error.

## Contents (all files are in this folder)

- `GroundStateDuo_uiqc-qff-project.pdf`: the final report.
- `h2_analysis.py`: exact diagonalisation and VQE (Qiskit) on the 0.60-0.90 A fine grid, quartic fit, writes `h2_fine_curve.csv`.
- `h2_dft_local.sh`, `analyse_dft.py`: Quantum ESPRESSO scan (restricted and spin-broken) and analysis, local-computer version.
- `dft_convergence.txt`: cutoff and box-size tests at 0.74 A (60 to 80 Ry changes the energy by about 8e-6 Ha; boxes of 18 to 30 bohr agree within about 4e-6 Ha at 50 Ry).
- `h2_comparison.png`, `h2_curve_explained.png`: the comparison plot and the annotated curve.
- Cluster files: h2_dft.sh and job_h2_*.sh (Quantum ESPRESSO runs on the ICTP-EAIFR cluster); dft_curve.csv (restricted and spin-broken energies, 23 distances); dft_far.csv (stretched points); dft_atom.csv (single H-atom run, unstable and not used for the results).

## Settings

Qiskit: STO-3G, Parity mapper with 2-qubit reduction, UCCSD from Hartree-Fock, SLSQP (200 iterations), StatevectorEstimator.
DFT: Quantum ESPRESSO 7.4.1, PBE, pseudopotential `H.pbe-rrkjus_psl.1.0.0.UPF`, 60/480 Ry cutoffs, 24 bohr cubic box, Gamma point.
The isolated H atom was numerically unstable with this pseudopotential, so the DFT binding energy is taken from the stretched spin-broken molecule (3 and 4 A: 4.52 eV).
