# Team GeoQubit: Quantum-Enhanced Subsurface Parameter Estimation

## Overview
Welcome to the official repository for **Team GeoQubit**'s Qiskit Fall Fest project. This project serves as a foundational proof-of-concept for **Quantum Computational Geophysics**, demonstrating how hybrid quantum-classical algorithms (Variational Quantum Circuits) can be applied to solve non-linear geophysical inverse problems. We invert synthetic 1D Wenner array electrical resistivity sounding data to recover the top-layer thickness ($h$) and subsurface reflection coefficient ($k = \frac{\rho_2 - \rho_1}{\rho_2 + \rho_1}$) of a two-layer Earth model, rigorously benchmarked against classical bounded least-squares inversion.

## Project Title
**Quantum-Enhanced Subsurface Parameter Estimation: A Toy Model for Resistivity Inversion**

## Team Members
* **Praise Ayobami Ajulo-Omojesu** — MSc Candidate in Applied Geophysics, University of Ibadan (Project Lead, Geophysical Theory, Forward Modeling & Validation)
* **John Wonderful Monday** — Undergraduate in Physics, Obafemi Awolowo University (Quantum Circuit Architecture, Variational Optimization & Simulation)

## Objective
Traditional geophysical inversion techniques (such as estimating subsurface layer thicknesses or electrical resistivity from surface measurements) often encounter heavy computational bottlenecks when evaluating complex parameter spaces. This project implements a Parameterized Quantum Circuit (PQC) framework using Qiskit and statevector simulation to optimize and solve a 1D layered-media inverse problem.

## Technical Highlights & Upgrades
1. **Advanced Physics Engine:** Adaptive image theory convergence ($N = \text{clip}\left(\left\lceil \frac{\ln(\text{tol} \cdot (1-\vert{}k\vert{})/2)}{\ln(\vert{}k\vert{})} \right\rceil, 20, 5000\right)$) and exact Hankel transform forward modeling using Gauss-Kronrod quadrature (`scipy.integrate.quad`) over Stefanescu’s kernel with $J_0$ Bessel functions (`scipy.special.j0`).
2. **Hardware-Ready Qiskit Architecture:** Built using `ParameterVector("t", 18)` across a 3-qubit, 3-layer Variational Quantum Circuit ($RY/RZ$ rotation layers paired with a periodic $CX$ entangling ring) and explicit Pauli-$Z$ observable measurements via `SparsePauliOp`.
3. **Optimization & Diagnostic Suite:** Hybrid optimization via COBYLA and SPSA, accompanied by an exhaustive plotting suite (sounding curves, convergence tracking, and the misfit landscape equivalence valley) benchmarked against classical least-squares.

## Workflow Architecture
```text
Classical Parameters (18 Angles θ)
         │
         ▼
 ┌───────────────┐
 │ PQC (3 Qubits)│  ---> 3-Layer RY/RZ + CX Ring
 └───────┬───────┘
         │
         ▼
  Measure <Z₀>, <Z₁>    ---> SparsePauliOp Observables
         │
         ▼
 Decode (k̂, ĥ)           ---> Bounded Linear Transformation
         │
         ▼
 Forward Model ρa(a)     ---> Adaptive Image Series / Hankel Integration
         │
         ▼
 Misfit Evaluation       ---> Mean Squared Error (log10 ρa)
         │
         ▼
 Classical Optimizer     ---> COBYLA / SPSA Updates Angles θ
