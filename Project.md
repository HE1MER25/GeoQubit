# Project Submissions
**[Deadline: 11:59PM WAT 21 October, 2026]**

This page contains the projects intented to be completed by participating teams during the **University of Ibadan Quantum Computing Club (UIQC Club) Qiskit Fall Fest 2026**.

After completing final submission, team's project repository is to be added to the table below.

## Projects

### 1. Praise Ayobami Ajulo-Omojesu & John Wonderful
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
|  Team GeoQubit         | Quantum-Enhanced Subsurface Parameter Estimation: A Toy Model for Resistivity Inversion | Traditional geophysical inversion methods (such as mapping subsurface resistivity or layer thicknesses from surface electrical measurements) face high computational bottlenecks when evaluating complex, non-linear parameter spaces. This project builds a parameterized quantum circuit (PQC) framework using Qiskit and AerSimulator. The objective is to construct a variational quantum optimization routine that minimizes the error between synthetic surface observations and modeled subsurface layer responses, serving as a foundational proof-of-concept for quantum computational geophysics.|       to be added after project submission  |


### 2. Chiagoziem Mushinwa & Glory Ogunsola
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Team CG  | End-to-End Implementation of the Full Sample-Based Quantum Diagonalization (SQD) Pipeline | Our project focuses on completing the advanced challenge notebook, 03_the_full_sqd_pipeline.ipynb. We aim to implement the full Sample-Based Quantum Diagonalization (SQD) workflow using Qiskit, spanning quantum state preparation, bitstring sampling, subspace expansion, and classical matrix diagonalization. We will evaluate ground-state energies against classical benchmarks and validate our results using the classroom grader module. |    to be added after project submission |

### 3. Thomas Adesoye Adeoye and Damilare Jeremiah Ojo
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| GroundStateDuo | Potential Energy Curve of H2 with DFT and a Quantum Algorithm | We will compute the ground-state energy of the H2 molecule as a function of the H-H distance using exact diagonalisation and the Variational Quantum Eigensolver (VQE) in Qiskit, and density functional theory (DFT) in Quantum ESPRESSO. We will compare the equilibrium bond length, vibration frequency and binding energy from each method, and examine the stretched-bond region where DFT is known to struggle. As a stretch goal, we will fit a Morse potential to the energy curve and run a short molecular dynamics simulation to obtain the vibration frequency. The project is motivated by a University of Illinois course module that solves the same problem with DFT, molecular dynamics and a quantum computer. |    https://github.com/tadeoye137/qff26xUIQC/tree/main/GroundStateDuo |

### 4. Jehovah-nissi Njoagwuani and Michael Mokuolu
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Team Minq | Sample-Based Quantum Diagonalization (SQD): Completing Challenge Notebooks 01 to 03 |We will complete the SQD challenge notebooks in the repository (01_sample_then_diagonalize, 02_molecules_as_bitstrings and 03_the_full_sqd_pipeline), working through all of their exercises and checkpoints. SQD samples bitstrings from a quantum circuit, crops the molecular Hamiltonian to the sampled configurations, and diagonalizes it classically. We will build the pipeline step by step across the three notebooks, from a toy magnet model to H2 to stretched N2, and make sure both of us can explain every stage. |    https://github.com/HOVA63/Team-Minq |

### 5. Richard Sanasi Joshua and Solomon Oluwarotimi Oki
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| CAC (Collapse and Compute) | Sample, Then Diagonalize: Exploring Sample-Based Quantum Diagonalization Using Qiskit | Our project will explore sample-based quantum diagonalization (SQD) using the beginner notebook provided by the UIQC Club. Using a simplified quantum spin model, we aim to understand how measurement samples obtained from quantum circuits can be used to identify relevant bitstrings and estimate ground-state energy through classical diagonalization. We will work through the notebook, examine the role of measurement sampling, and investigate how the number and selection of candidate bitstrings affects the resulting energy estimates. We will also discuss the limitations of the method and compare our observations with the reference results available in the notebook. As beginners in quantum computing, our goal is to develop a practical understanding of the relationship between quantum circuits, measurement, and classical computation. |    to be added after project submission |

### 6. Daisi Williams Oloyede and Oluyede Titilayo Olufunke
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Quantum Explorers | Mathematical Modeling and Simulation of Quantum Gate operations |Quantum computing exploits the principles of quantum mechanics, including superposition, interference, and unitary evolution, to process quantum information. Quantum gates constitute the fundamental operations through which quantum states are manipulated in quantum circuits. This project proposes a mathematical and computational investigation of fundamental single-qubit quantum gates using the Qiskit quantum computing framework. The study will examine the Hadamard, Pauli-X, Pauli-Y, Pauli-Z, and parameterized rotation gates. Their matrix representations and effects on selected quantum states will be derived analytically and subsequently verified through numerical simulations. The evolution of quantum states will be visualized using Bloch sphere representations, while measurement probabilities and state fidelities will be used to evaluate agreement between mathematical predictions and simulation results. Furthermore, the project will investigate the dependence of quantum-state transformations on rotation angles and gate sequences. The expected outcome is a reproducible computational framework that demonstrates the relationship between linear algebra, quantum mechanics, and quantum circuit operations. |    to be added after project submission |


### 7. Mustapha Awwal and  Adedeji Oluwole Precious
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Nameless Quantum |Sample, Then Diagonalize: Ground-State Energies with Sample-based Quantum Diagonalization (SQD) | We will complete the three-part SQD challenge series. Sample-based quantum diagonalization uses a quantum circuit to sample the most important basis states (bitstrings) of a system. A classical computer then diagonalizes the Hamiltonian only within that small subspace, which avoids the exponential cost of full diagonalization. Notebook 01 – Sample, Then Diagonalize: build the SQD method on an 8-spin transverse-field Ising chain. We will implement the subspace (cropped) diagonalization and show that sampled bitstrings give far better energies than random ones. We will also show that a rough, unoptimized circuit's samples give a much more accurate energy than the circuit's own expectation value. Notebook 02 – Molecules as Bitstrings: represent the electron configurations of H₂ as bitstrings, and use solve_fermion from qiskit-addon-sqd to diagonalize in small determinant subspaces. Along a bond-breaking curve, we will compare the results with Hartree-Fock and with the exact (FCI) solution. Notebook 03 – The Full SQD Pipeline: run the complete workflow on stretched N₂ (16 qubits). The steps are: molecular integrals from PySCF, a CCSD-informed UCJ ansatz built with ffsim, sampling on a simulator, and configuration recovery with projected diagonalization. We will study how sampling noise and the number of recovery iterations affect accuracy, then apply the pipeline to a new molecule, water (H₂O). |    to be added after project submission |

### 8. ASHIRU MUHD IDRIS and HAMZAT FARUQ ADEGOKE
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Team Mensia |Studying Ground-State Energy Estimation Through Quantum Sampling | This project will explore sample-based quantum diagonalization (SQD) using Qiskit and Python. The aim is to understand how measurement outcomes can be used to identify a smaller set of computational basis states and estimate the ground-state energy of a quantum system. We will study the transverse-field Ising chain described by a Hamiltonian matrix. Using the supplied challenge notebook, we will examine the relationship between matrix diagonalization, eigenvalues, quantum-state sampling, and ground-state energy estimation. Our work will focus on implementing the reduced-subspace energy calculation and investigating how the estimated energy changes as the number of measurement samples increases. We will also compare the results with those obtained from randomly selected basis states of similar sizes. This comparison will help us understand why the choice of sampled states can matter more than the number of states alone. We intend to present the mathematical ideas, implementation process, numerical results, and limitations of the method. The project will be completed using the provided challenge materials, with any additional experiments and assistance properly documented. |    to be added after project submission |

### 9.  Promise Adesemoye and Ifeyemi Opeyemi 
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
| Planck's Konstant | Simulating the BB84 Protocol for Secure Key Distribution Using Qiskit | Conventional cryptographic systems often rely on mathematical problems that are computationally difficult to solve. The security of some widely used public-key cryptography systems could be threatened by sufficiently capable quantum computers. Quantum key distribution offers a different approach: using quantum-mechanical properties to establish secret keys and detect certain forms of eavesdropping. |    to be added after project submission |

### 10. NameOfMember1 and NameOfMember2
| Team Name | Project Title | Brief Description | Project Repository |
|-----------|---------------|-------------------|--------------------|
|           |               |                   |    to be added after project submission |
