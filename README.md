# Slurm Local Setup & Administration Guide

This repository provides a **complete, practical guide for installing, configuring, operating, and maintaining a local Slurm workload manager** on a single node or small cluster (Fedora/RHEL-based systems).

It is designed for:

* HPC beginners setting up Slurm for the first time
* Researchers running local job schedulers (Quantum ESPRESSO, MPI, etc.)
* System administrators managing small to medium Slurm clusters

---

## 📁 Repository Structure

```text
config/
README.md
config_slurm_accounting.md
install_slurm.md
remove_slurm.md
slurm_cheatsheet.md
slurm_commands.md
```

---

## 📄 File Descriptions

### `README.md`

Project overview and navigation guide (this file).

---

### `config/`

Contains configuration files and templates related to Slurm setup.

Typical contents may include:

* `slurm.conf`
* `slurmdbd.conf`
* `cgroup.conf`
* `gres.conf`

These files can be adapted based on your hardware and cluster topology.

---

### `install_slurm.md`

Step-by-step instructions to **install and configure Slurm**.

Includes:

* Package installation (Fedora/RHEL)
* MUNGE setup
* slurmctld / slurmd configuration
* Initial cluster validation

Use this document to bring up Slurm from scratch.

---

### `config_slurm_accounting.md`

Detailed guide for **Slurm accounting configuration** using `slurmdbd`.

Covers:

* MariaDB/MySQL setup
* `slurmdbd.conf`
* Cluster registration
* User and account creation (`sacctmgr`)
* Common accounting errors and fixes

Required for job history, fairshare, and priority scheduling.

---

### `remove_slurm.md`

Instructions to **cleanly remove Slurm** from a system.

Includes:

* Stopping services
* Removing packages
* Cleaning configuration files
* Database cleanup (optional)

Useful for reinstallation or system decommissioning.

---

### `slurm_commands.md`

Comprehensive **Slurm command reference manual**.

Includes:

* Job submission and control
* Monitoring and accounting
* Node and partition management
* Administrative commands

Best suited as a detailed reference document.

---

### `slurm_cheatsheet.md`

A **wall-poster style Slurm cheat sheet**.

Features:

* High-frequency commands only
* Minimal explanations
* Optimized for printing (A3/A2)

Ideal for quick lookup in labs and shared environments.

---

## 🚀 Getting Started

1. Install Slurm:

   ```bash
   cat install_slurm.md
   ```

2. Configure accounting (recommended):

   ```bash
   cat config_slurm_accounting.md
   ```

3. Learn daily usage:

   ```bash
   cat slurm_cheatsheet.md
   ```

4. Deep dive into commands:

   ```bash
   cat slurm_commands.md
   ```

---

## 🧪 Typical Use Cases

* Local job scheduling on multi-core workstations
* Small research clusters
* Teaching HPC and job schedulers
* Running MPI / Quantum ESPRESSO / DFT workflows

---

## ⚠️ Supported Platforms

* Fedora
* RHEL / Rocky Linux / AlmaLinux

(Other distributions may require minor changes.)

---

## 📌 Notes

* Slurm accounting (`slurmdbd`) is optional but **strongly recommended**
* Ensure system clocks are synchronized (chrony / ntpd)
* Always verify configuration using:

  ```bash
  slurmctld -t
  ```

---

## 📚 References

* Slurm Official Documentation: [https://slurm.schedmd.com/](https://slurm.schedmd.com/)
* Slurm man pages (`man sbatch`, `man squeue`, etc.)

---

## 📝 License

This documentation is provided for educational and research use.
You are free to modify and adapt it for your cluster environment.

---

**Maintained as a practical, no-nonsense Slurm reference for real systems.**
