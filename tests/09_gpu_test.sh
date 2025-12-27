#!/bin/bash
#SBATCH --job-name=gpu_test
#SBATCH --gres=gpu:1
#SBATCH --time=00:02:00
#SBATCH --output=gpu_%j.out


nvidia-smi
