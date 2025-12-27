#!/bin/bash
#SBATCH --job-name=hello_slurm
#SBATCH --output=hello_%j.out
#SBATCH --error=hello_%j.err
#SBATCH --time=00:01:00


hostname
date
echo "Hello from Slurm"
