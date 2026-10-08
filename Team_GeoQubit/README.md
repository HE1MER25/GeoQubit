# Team GeoQubit: Quantum-Enhanced Subsurface Parameter Estimation

## Overview
Welcome to the official repository for **Team GeoQubit**'s Qiskit Fall Fest project. This project serves as a foundational proof-of-concept for **Quantum Computational Geophysics**, exploring how hybrid quantum-classical algorithms can be applied to solve geophysical inverse problems.

## Project Title
**Quantum-Enhanced Subsurface Parameter Estimation: A Toy Model for Resistivity Inversion**

## Team Members
* Praise Ajulo-Omojesu
* Wonderful John Monday

## Objective
Traditional geophysical inversion techniques (such as estimating subsurface layer thicknesses or electrical resistivity from surface measurements) often encounter heavy computational bottlenecks when evaluating complex parameter spaces. This project implements a Parameterized Quantum Circuit (PQC) framework using Qiskit and AerSimulator to optimize and solve a simplified 1D layered-media inverse problem.

## Methodology
1. **Forward Modeling:** Formulating a simplified mathematical response function for a synthetic layered Earth model.
2. **Quantum Circuit Architecture:** Constructing a variational quantum circuit using rotation and entanglement gates to parameterize the solution space.
3. **Optimization Loop:** Utilizing a classical optimizer with Qiskit to minimize the error between modeled synthetic responses and target observations.

## Repository Structure
```text
Team-GeoQubit/
│
├── notebooks/           # Jupyter notebooks containing the Qiskit code and experiments
├── docs/                # Project plans and final reports (PDF / Markdown)
└── README.md            # Project documentation
