#!/bin/bash
#SBATCH --job-name=mpi_test
#SBATCH --ntasks=4
#SBATCH --time=00:02:00
#SBATCH --output=mpi_%j.out


srun --mpi=pmix hostname
