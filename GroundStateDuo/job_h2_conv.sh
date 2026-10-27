#!/bin/bash
#$ -pe mpi 32
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q all.q@compute-0-1

module purge
module load gnu/7.3.1
module load openmpi/4.1.4_gnu7.3.1
module load fftw/fftw-3.3.10

bash h2_dft.sh conv
