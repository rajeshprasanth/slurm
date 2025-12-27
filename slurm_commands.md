# Slurm Command Reference Manual

This document provides a complete and structured reference of **Slurm workload manager commands**, intended for **users, power users, and administrators**. It follows the same documentation style as the previous Slurm setup guide.

---

## 1. Job Submission Commands

### sbatch – Submit batch jobs

```bash
sbatch job.sh
sbatch --wrap="command"
```

### srun – Run parallel or interactive jobs

```bash
srun ./a.out
srun --ntasks=4 ./mpi_program
```

### salloc – Allocate resources interactively

```bash
salloc
```

---

## 2. Job Monitoring Commands

### squeue – View job queue

```bash
squeue
squeue -u username
squeue -j jobid
squeue -p partition
```

Custom output:

```bash
squeue -o "%.18i %.9P %.20j %.8u %.2t %.10M %.6D %R"
```

### scontrol – Detailed job inspection

```bash
scontrol show job <jobid>
scontrol show jobid -dd <jobid>
```

---

## 3. Job Accounting & History (slurmdbd required)

### sacct – Job accounting

```bash
sacct
sacct -j jobid
sacct -u username
sacct -X
```

Custom fields:

```bash
sacct -o JobID,JobName,State,Elapsed,MaxRSS
```

### sstat – Live job statistics

```bash
sstat -j jobid
```

---

## 4. Job Control Commands

### scancel – Cancel jobs

```bash
scancel jobid
scancel -u username
scancel -p partition
```

### Requeue jobs

```bash
scontrol requeue jobid
```

---

## 5. Node and Cluster Information

### sinfo – Cluster and node status

```bash
sinfo
sinfo -N
sinfo -l
```

Custom format:

```bash
sinfo -o "%20N %10P %5c %10m %10t"
```

### Node details

```bash
scontrol show node
scontrol show node nodename
```

---

## 6. Partitions, QoS, and Priority

### Partitions

```bash
scontrol show partition
```

### QoS

```bash
sacctmgr show qos
```

### Priority and fairshare

```bash
sprio
sshare
sshare -u username
```

---

## 7. SBATCH Directives (Job Script Options)

```bash
#SBATCH --job-name=myjob
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --output=out.%j
#SBATCH --error=err.%j
```

GPU jobs:

```bash
#SBATCH --gres=gpu:1
```

---

## 8. Environment Variables

```bash
SLURM_JOB_ID
SLURM_JOB_NAME
SLURM_NTASKS
SLURM_CPUS_PER_TASK
SLURM_NODELIST
```

Expand node list:

```bash
scontrol show hostname $SLURM_NODELIST
```

---

## 9. Administrative Commands

### Service control

```bash
systemctl start slurmctld
systemctl restart slurmctld
systemctl start slurmd
systemctl restart slurmd
systemctl start slurmdbd
```

### Service status

```bash
systemctl status slurmctld
systemctl status slurmd
systemctl status slurmdbd
```

---

## 10. Accounting Management (sacctmgr)

### Cluster

```bash
sacctmgr add cluster mycluster
```

### Accounts

```bash
sacctmgr add account mygroup Description="My research group"
sacctmgr show account
```

### Users

```bash
sacctmgr add user username DefaultAccount=mygroup
sacctmgr show user
```

### Associations

```bash
sacctmgr show assoc
```

---

## 11. Node State Management

```bash
scontrol update NodeName=node1 State=DOWN Reason="maintenance"
scontrol update NodeName=node1 State=RESUME
scontrol update NodeName=node1 State=DRAIN Reason="issue"
```

---

## 12. Debugging and Logs

### Configuration checks

```bash
slurmctld -t
slurmd -C
```

### Debug level

```bash
scontrol setdebug 5
```

### Log files

```text
/var/log/slurm/slurmctld.log
/var/log/slurm/slurmd.log
/var/log/slurm/slurmdbd.log
```

---

## 13. MPI and Hybrid Jobs

```bash
srun --mpi=pmix ./mpi_program
```

Hybrid MPI + OpenMP:

```bash
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=6
export OMP_NUM_THREADS=6
```

---

## 14. Help and Documentation

```bash
man sbatch
man squeue
man scontrol
man sacct
man sinfo
```

---

**End of Document**
