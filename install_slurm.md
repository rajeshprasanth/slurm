# Slurm Installation and Configuration Guide (Single-Node Fedora)

This document describes a **step-by-step installation and configuration of Slurm** on a **single-node Fedora system** where the same machine acts as both **controller (slurmctld)** and **compute node (slurmd)**.

---

## 1. System Overview

* OS: Fedora
* Cluster type: Single-node (controller + compute)
* Node name: `centaurus`
* Scheduler: Slurm
* Authentication: Munge

---

## 2. Install Required Packages

Install Slurm and Munge packages using DNF:

```bash
sudo dnf install -y \
    slurm \
    slurm-slurmd \
    slurm-slurmctld \
    slurm-slurmrestd \
    munge \
    munge-libs
```

---

## 3. Configure Munge Authentication

Slurm relies on Munge for authentication between daemons.

### 3.1 Set Munge Directory Permissions

```bash
sudo chown -R munge:munge /etc/munge
sudo chmod 700 /etc/munge
sudo chmod 755 /var/lib/munge
sudo chmod 755 /var/log/munge
sudo chmod 755 /run/munge
```

### 3.2 Enable and Start Munge

```bash
sudo systemctl enable munge
sudo systemctl start munge
sudo systemctl status munge
```

### 3.3 Verify Munge Operation

```bash
munge -n | unmunge
sudo -u munge /usr/sbin/mungekey --verbose
```

Ensure the Munge key has correct ownership and permissions:

```bash
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
```

---

## 4. Create Slurm User and Group

Slurm services should run under a dedicated system account.

```bash
sudo groupadd -r slurm
sudo useradd -r -g slurm -d /var/lib/slurm -s /sbin/nologin slurm
```

Verify the users:

```bash
id slurm
id munge
```

---

## 5. Create Required Slurm Directories

```bash
sudo mkdir -p /var/spool/slurm/ctld
sudo mkdir -p /var/spool/slurm/d
sudo mkdir -p /var/log/slurm
sudo mkdir -p /var/lib/slurm
```

Set ownership and permissions:

```bash
sudo chown -R slurm:slurm /var/spool/slurm
sudo chown -R slurm:slurm /var/log/slurm
sudo chown -R slurm:slurm /var/lib/slurm

sudo chmod 755 /var/spool/slurm/ctld
sudo chmod 755 /var/spool/slurm/d
sudo chmod 755 /var/log/slurm
```

---

## 6. Configure Slurm

### 6.1 Main Configuration File

Edit the Slurm configuration file:

```bash
sudo nano /etc/slurm/slurm.conf
```

> The `slurm.conf` file must define at least:
>
> * ClusterName
> * ControlMachine
> * NodeName
> * PartitionName
>
> Example parameters:
>
> ```
> ClusterName=localcluster
> ControlMachine=centaurus
> SlurmUser=slurm
> SlurmctldPort=6817
> SlurmdPort=6818
> NodeName=centaurus CPUs=12 State=UNKNOWN
> PartitionName=compute Nodes=centaurus Default=YES MaxTime=INFINITE State=UP
> ```

Set permissions:

```bash
sudo chown slurm:slurm /etc/slurm/slurm.conf
sudo chmod 644 /etc/slurm/slurm.conf
```

---

## 7. Configure Cgroups (Optional but Recommended)

Create `/etc/slurm/cgroup.conf`:

```bash
sudo tee /etc/slurm/cgroup.conf > /dev/null << 'EOF'
CgroupAutomount=yes
ConstrainCores=yes
ConstrainRAMSpace=yes
EOF
```

Set ownership:

```bash
sudo chown slurm:slurm /etc/slurm/cgroup.conf
sudo chmod 644 /etc/slurm/cgroup.conf
```

---

## 8. Start Slurm Services

Reload systemd units:

```bash
sudo systemctl daemon-reload
```

### 8.1 Start Controller Daemon

```bash
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
sudo systemctl status slurmctld
```

### 8.2 Start Compute Daemon

```bash
sudo systemctl enable slurmd
sudo systemctl start slurmd
sudo systemctl status slurmd
```

---

## 9. Verify Cluster State

### 9.1 Check Logs

```bash
sudo tail -30 /var/log/slurm/slurmctld.log
sudo tail -30 /var/log/slurm/slurmd.log

sudo journalctl -u slurmctld -n 20
sudo journalctl -u slurmd -n 20
```

### 9.2 Check Node and Partition Status

```bash
sinfo
```

If the node is down, resume it:

```bash
sudo scontrol update NodeName=centaurus State=RESUME
```

Recheck:

```bash
sinfo
scontrol show node centaurus
```

Expected output:

```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite      1   idle centaurus
```

---

## 10. Common Slurm Commands

### Cluster Information

```bash
sinfo
scontrol show partition
scontrol show node centaurus
```

### Job Monitoring

```bash
squeue
sacct
```

### Job Control

```bash
scancel <job_id>
scontrol hold <job_id>
scontrol release <job_id>
```

---

## 11. Next Steps

* Submit a test job using `sbatch` or `srun`
* Configure accounting (`slurmdbd`) if needed
* Add additional compute nodes
* Enable advanced scheduling policies

---

**Slurm installation is now complete and ready for use.**
