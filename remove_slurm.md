# Slurm Removal and Cleanup Guide (Fedora)

This document describes a **safe and complete removal of Slurm** from a **Fedora system**. It is intended for **single-node or small clusters** where Slurm was installed using DNF packages.

> ⚠️ **Warning**: This process permanently removes Slurm services, configuration files, logs, state data, and the Slurm system user. Ensure no important job data is needed before proceeding.

---

## 1. Stop Slurm Services

Stop all running Slurm daemons:

```bash
sudo systemctl stop slurmd slurmctld slurmrestd 2>/dev/null
```

Verify they are stopped:

```bash
systemctl status slurmd slurmctld slurmrestd
```

---

## 2. Disable Slurm Services

Prevent Slurm services from starting at boot:

```bash
sudo systemctl disable slurmd slurmctld slurmrestd 2>/dev/null
```

---

## 3. Remove Slurm Packages

Uninstall all Slurm-related RPM packages:

```bash
sudo dnf remove slurm* -y
```

Confirm removal:

```bash
rpm -qa | grep slurm
```

---

## 4. Remove Slurm Configuration and State Files

Delete all Slurm-related directories:

```bash
sudo rm -rf /etc/slurm
sudo rm -rf /var/spool/slurm
sudo rm -rf /var/log/slurm
sudo rm -rf /var/lib/slurm
sudo rm -rf /var/run/slurm*
```

These directories typically contain:

* `slurm.conf` and cgroup configuration
* Controller and daemon state files
* Job accounting logs
* Runtime sockets and PID files

---

## 5. Remove Slurm User and Group

Delete the Slurm system account and group:

```bash
sudo userdel -r slurm 2>/dev/null
sudo groupdel slurm 2>/dev/null
```

Verify removal:

```bash
id slurm
```

---

## 6. Stop and Clean Munge (Optional)

If Munge was installed **only for Slurm**, stop the service:

```bash
sudo systemctl stop munge
```

Remove the Munge authentication key:

```bash
sudo rm -f /etc/munge/munge.key
```

> ℹ️ Do **not** remove Munge if it is used by other services or clusters.

---

## 7. Reload systemd

Clean up any leftover unit references:

```bash
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

---

## 8. Verification Checklist

Ensure Slurm is fully removed:

```bash
which srun sbatch sinfo squeue
```

Expected output:

```
which: no srun in (...)
```

Check running services:

```bash
systemctl list-units | grep slurm
```

Check leftover files:

```bash
find / -name '*slurm*' 2>/dev/null
```

---

## 9. Optional: Clean Package Cache

```bash
sudo dnf autoremove -y
sudo dnf clean all
```

---

## 10. Reinstall Preparation (Optional)

If you plan to reinstall Slurm later:

* Reboot the system (recommended)
* Recreate Munge key cleanly
* Regenerate `slurm.conf`
* Ensure hostname and node names are correct

---

**Slurm has now been completely removed from the system.**
