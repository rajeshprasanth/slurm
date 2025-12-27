#!/bin/bash
#SBATCH --job-name=mem_test
#SBATCH --mem=1G
#SBATCH --time=00:02:00
#SBATCH --output=mem_%j.out


python3 - <<EOF
import time
x = [0] * (250 * 1024 * 1024) # ~1GB
print("Memory allocated")
time.sleep(30)
EOF
