#!/bin/bash
#SBATCH --job-name=parallel_test
#SBATCH --ntasks=8
#SBATCH --time=00:02:00
#SBATCH --output=parallel_%j.out


srun bash -c 'echo Task $SLURM_PROCID running on $(hostname); sleep 30'
