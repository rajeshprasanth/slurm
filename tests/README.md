# Slurm Test Scripts (Named Scripts)

This directory contains **named, ready-to-run Slurm test scripts**. Each script validates a specific Slurm feature and can be submitted using `sbatch` unless noted otherwise.

---

## 01_hello_slurm.sh — Basic Sanity Test

**Purpose:** Verify Slurm submission, execution, and logging.

```bash
#!/bin/bash
#SBATCH --job-name=hello_slurm
#SBATCH --output=hello_%j.out
#SBATCH --error=hello_%j.err
#SBATCH --time=00:01:00

hostname
date
echo "Hello from Slurm"
```

Submit:

```bash
sbatch 01_hello_slurm.sh
```

---

## 02_cpu_test.sh — CPU Allocation Test

**Purpose:** Confirm allocated CPU cores.

```bash
#!/bin/bash
#SBATCH --job-name=cpu_test
#SBATCH --ntasks=4
#SBATCH --time=00:02:00
#SBATCH --output=cpu_%j.out

srun hostname
srun nproc
```

---

## 03_parallel_test.sh — Parallel Task Execution

**Purpose:** Validate multiple task execution.

```bash
#!/bin/bash
#SBATCH --job-name=parallel_test
#SBATCH --ntasks=8
#SBATCH --time=00:02:00
#SBATCH --output=parallel_%j.out

srun bash -c 'echo Task $SLURM_PROCID running on $(hostname); sleep 30'
```

---

## 04_memory_test.sh — Memory Limit Test

**Purpose:** Verify memory allocation enforcement.

```bash
#!/bin/bash
#SBATCH --job-name=mem_test
#SBATCH --mem=1G
#SBATCH --time=00:02:00
#SBATCH --output=mem_%j.out

python3 - <<EOF
import time
x = [0] * (250 * 1024 * 1024)  # ~1GB
print("Memory allocated")
time.sleep(30)
EOF
```

---

## 05_pending_test.sh — Pending State Test

**Purpose:** Validate queueing and scheduling reasons.

```bash
#!/bin/bash
#SBATCH --job-name=pending_test
#SBATCH --ntasks=64
#SBATCH --time=00:10:00
#SBATCH --output=pending_%j.out

sleep 600
```

Check pending reason:

```bash
squeue -o "%.18i %.9P %.20j %.8u %.2t %R"
```

---

## 06_accounting_test.sh — Accounting Validation

**Purpose:** Verify `slurmdbd` job accounting.

```bash
#!/bin/bash
#SBATCH --job-name=acct_test
#SBATCH --time=00:01:00
#SBATCH --output=acct_%j.out

sleep 10
```

Check accounting:

```bash
sacct -j <jobid>
```

---

## 07_interactive_test.sh — Interactive Allocation Test

**Purpose:** Validate interactive jobs.

```bash
salloc --time=00:05:00
hostname
exit
```

---

## 08_mpi_test.sh — MPI Job Test

**Purpose:** Validate MPI integration (MPI required).

```bash
#!/bin/bash
#SBATCH --job-name=mpi_test
#SBATCH --ntasks=4
#SBATCH --time=00:02:00
#SBATCH --output=mpi_%j.out

srun --mpi=pmix hostname
```

---

## 09_gpu_test.sh — GPU Allocation Test

**Purpose:** Validate GPU scheduling (GPU nodes only).

```bash
#!/bin/bash
#SBATCH --job-name=gpu_test
#SBATCH --gres=gpu:1
#SBATCH --time=00:02:00
#SBATCH --output=gpu_%j.out

nvidia-smi
```

---

## 10_admin_node_state_test.sh — Node Drain/Resume (Admin)

**Purpose:** Validate node state management.

```bash
scontrol update NodeName=node1 State=DRAIN Reason="test"
scontrol update NodeName=node1 State=RESUME
```

---

## 📌 Usage Notes

```bash
chmod +x *.sh
```

Run scripts in numeric order for systematic validation.

---

**This set forms a complete Slurm functional test suite for local and small clusters.**
