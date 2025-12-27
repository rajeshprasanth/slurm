#!/bin/bash
#SBATCH --job-name=cpu_test
#SBATCH --ntasks=4
#SBATCH --time=00:02:00
#SBATCH --output=cpu_%j.out


srun hostname
srun nproc
