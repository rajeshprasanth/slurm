# SLURM WALL‑POSTER CHEAT SHEET

**Quick reference for daily Slurm usage**
*(Designed for printing & lab walls)*

---

## 🚀 JOB SUBMISSION

```bash
sbatch job.sh                 # Submit batch job
sbatch --wrap="cmd"           # Submit one‑line command
srun ./a.out                  # Run job (interactive/parallel)
salloc                        # Interactive allocation
```

---

## 👀 JOB MONITORING

```bash
squeue                        # Show all jobs
squeue -u $USER               # Show your jobs
squeue -j <jobid>             # Specific job
```

**Why is my job pending?**

```bash
squeue -o "%.18i %.9P %.20j %.8u %.2t %R"
```

---

## ⛔ JOB CONTROL

```bash
scancel <jobid>               # Cancel job
scancel -u $USER              # Cancel all your jobs
scontrol requeue <jobid>      # Requeue job
```

---

## 📊 JOB DETAILS & HISTORY

```bash
scontrol show job <jobid>     # Detailed job info
sacct                        # Completed jobs
sacct -j <jobid>
sstat -j <jobid>              # Live usage
```

---

## 🖥️ NODES & CLUSTER

```bash
sinfo                        # Partition status
sinfo -N                     # Node view
scontrol show node           # Full node info
```

---

## 🧾 COMMON #SBATCH OPTIONS

```bash
#SBATCH --job-name=myjob
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --output=out.%j
#SBATCH --error=err.%j
```

**GPU jobs**

```bash
#SBATCH --gres=gpu:1
```

---

## 🌍 ENVIRONMENT VARIABLES

```bash
$SLURM_JOB_ID
$SLURM_JOB_NAME
$SLURM_NTASKS
$SLURM_NODELIST
```

```bash
scontrol show hostname $SLURM_NODELIST
```

---

## ⚖️ PRIORITY & FAIRSHARE

```bash
sprio
sshare
sshare -u $USER
```

---

## 🧮 MPI & HYBRID JOBS

```bash
srun --mpi=pmix ./mpi_program
```

```bash
export OMP_NUM_THREADS=4
```

---

## 🔧 ADMIN (QUICK)

```bash
systemctl restart slurmctld
systemctl restart slurmd
systemctl restart slurmdbd
```

---

## 📂 LOG FILES

```text
/var/log/slurm/slurmctld.log
/var/log/slurm/slurmd.log
/var/log/slurm/slurmdbd.log
```

---

## 🆘 HELP

```bash
man sbatch
man squeue
man scontrol
```

---

### ⭐ MOST IMPORTANT LINE

```bash
squeue -o "%.18i %.9P %.20j %.8u %.2t %R"
```

*(Shows exact reason a job is pending)*

---

**Designed for A3/A2 printing – Slurm at a glance**
