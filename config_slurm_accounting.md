# Slurm Accounting Configuration Guide (slurmdbd + MariaDB)

This document explains how to enable **Slurm job accounting** using **slurmdbd** backed by **MariaDB** on a Fedora system. Once configured, Slurm can record completed jobs and allow querying via `sacct` and `sacctmgr`.

---

## 1. Overview

Components involved:

* **slurmdbd** – Slurm accounting daemon
* **MariaDB** – Database backend
* **slurmctld / slurmd** – Slurm controller and compute daemon

Typical workflow:

1. Install and configure MariaDB
2. Configure `slurmdbd.conf`
3. Enable accounting in `slurm.conf`
4. Register cluster, accounts, and users
5. Verify job accounting

---

## 2. Install slurmdbd

Install the Slurm accounting daemon:

```bash
sudo dnf install slurm-slurmdbd -y
```

---

## 3. Install and Configure MariaDB

### 3.1 Install MariaDB

```bash
sudo dnf install mariadb-server mariadb -y
```

Enable and start the database service:

```bash
sudo systemctl enable mariadb
sudo systemctl start mariadb
```

### 3.2 Secure MariaDB

Run the secure installation wizard:

```bash
sudo mysql_secure_installation
```

Recommended options:

* Set root password
* Remove anonymous users
* Disable remote root login
* Remove test database

---

## 4. Create Slurm Accounting Database

Login to MariaDB:

```bash
sudo mysql -u root -p
```

Create database and user:

```sql
CREATE DATABASE slurm_acct_db;
CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'YOUR_PASSWORD';
GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

> ⚠️ Save the database password securely; it will be required in `slurmdbd.conf`.

---

## 5. Configure slurmdbd

Edit the configuration file:

```bash
sudo vi /etc/slurm/slurmdbd.conf
```

Example configuration:

```ini
AuthType=auth/munge
DbdHost=localhost
SlurmUser=slurm
StorageType=accounting_storage/mysql
StorageHost=localhost
StorageUser=slurm
StoragePass=YOUR_PASSWORD
StorageLoc=slurm_acct_db
LogFile=/var/log/slurm/slurmdbd.log
PidFile=/var/run/slurmdbd.pid
```

Set correct permissions:

```bash
sudo chown slurm:slurm /etc/slurm/slurmdbd.conf
sudo chmod 600 /etc/slurm/slurmdbd.conf
```

---

## 6. Enable Accounting in slurm.conf

Edit the main Slurm configuration file:

```bash
sudo vi /etc/slurm/slurm.conf
```

Ensure the following parameters exist:

```ini
AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageHost=localhost
AccountingStorageUser=slurm
AccountingStorageLoc=slurm_acct_db
JobAcctGatherType=jobacct_gather/linux
```

---

## 7. Start slurmdbd and Restart Slurm

Enable and start the accounting daemon:

```bash
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
```

Restart Slurm services to apply accounting changes:

```bash
sudo systemctl restart slurmctld
sudo systemctl restart slurmd
```

Verify service status:

```bash
systemctl status slurmdbd
```

---

## 8. Register Cluster with Accounting Database

Register the Slurm cluster:

```bash
sacctmgr -i add cluster name=localhost
```

List registered clusters:

```bash
sacctmgr list clusters
```

---

## 9. Create Accounts and Users

### 9.1 Create an Account

```bash
sacctmgr add account mygroup Description="My research group"
```

### 9.2 Add User to Account

```bash
sacctmgr add user rajeshpr DefaultAccount=mygroup
```

Verify:

```bash
sacctmgr list accounts
sacctmgr list users
```

---

## 10. Submit and Track Jobs

Submit a test job:

```bash
sbatch test_job.sh
```

View completed job accounting:

```bash
sacct -o JobID,JobName,User,Partition,State,Elapsed,ExitCode
```

---

## 11. Troubleshooting

### slurmdbd not starting

```bash
sudo journalctl -u slurmdbd -n 50
```

Common issues:

* Wrong database password
* MariaDB not running
* Incorrect file permissions on `slurmdbd.conf`

### sacct shows no data

* Ensure job completed successfully
* Confirm `AccountingStorageType` is set correctly
* Restart `slurmctld` after configuration changes

---

## 12. Next Steps

* Enable per-user or per-account limits
* Integrate QOS policies
* Export accounting data for reports
* Configure multi-cluster accounting

---

**Slurm accounting with slurmdbd is now fully operational.**
