#!/bin/bash
#SBATCH --job-name=pending_test
#SBATCH --ntasks=64
#SBATCH --time=00:10:00
#SBATCH --output=pending_%j.out


sleep 600
