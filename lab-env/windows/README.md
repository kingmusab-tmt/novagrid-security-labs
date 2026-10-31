# NovaGrid Windows target (optional)

Most episodes run on the Linux lab (`lab-env/`), but the security *activities* in many of
them apply just as much to Windows. This optional Windows target lets you do the Windows
version of Episodes **1–8, 10, 21, 23 and 24** — account/asset auditing, password & lockout
policy, hardening, logging, access review, data discovery, MFA, backup, offboarding,
containment/eradication and forensics — using **PowerShell and native Windows tooling**.

Each of those episodes has an **"On Windows"** section that assumes this target exists.

> **Lab use only.** The provisioner plants deliberately weak settings and synthetic data on
> the VM. Run it **only** on a throwaway evaluation VM, isolated from any real or work network.

## 1. Get a free Windows VM

You supply the Windows image (we can't bundle licensed Windows). Free, time-limited options
from Microsoft:

- **Windows 11 development environment VM** — a ready-made VM for VMware/Hyper-V/VirtualBox/Parallels,
  free (~90-day eval). Search Microsoft for "Windows 11 development environment" (the *Virtual
  Machines* download page). Easiest option — it boots straight to a desktop.
- **Windows Server 2022/2025 evaluation** — a 180-day eval ISO from the **Microsoft Evaluation
  Center** (`microsoft.com/evalcenter`). Use this if you want the Server tooling.

Give the VM **4 GB RAM** and put it on the **same host-only network as your Linux analyst VM**
so the two can reach each other (note its IP with `ipconfig`). Keep it off bridged/NAT to the
internet except for the initial setup.

## 2. Provision the NovaGrid state

Copy this `windows\` folder into the VM (shared folder, or clone the repo inside it), then in an
**elevated PowerShell** from this folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\setup-windows.ps1
```

**Take a VM snapshot now** — that's your one-click reset. Then verify:

```powershell
.\check-windows.ps1      # every item should say OK
```

## 3. What it plants (the Windows ground truth)

| Finding | Mirrors the Linux lab's… |
|---|---|
| Local users amara/tunde/chidi/svc-backup/webadmin/contractor | the wallet-api accounts |
| `svc-backup` in **Administrators** (only needs backup rights) | the `NOPASSWD: ALL` service account |
| `webadmin` password **never expires**, not on the roster | the stale/orphaned account |
| `contractor` **still enabled** and admin | the leaver who kept access |
| `net accounts` min length 6, **lockout off** | weak `pwquality` / no `faillock` |
| `C:\NovaGrid\wallet\…` with PII + test PANs | `/srv/wallet` data |
| `wallet.conf` readable by **Everyone** | the world-readable (644) secret |
| **WalletExports** SMB share over the card data | the leaking `:8000` debug server |
| **RDP enabled** + allowed through the firewall | the exposed attack surface |
| `NovaGridUpdater` scheduled task + `NovaGridSync` Run key (both **inert**) | the eradication targets for Ep21 |

## 4. Reset

Revert to your post-setup **snapshot** (best), or run `.\reset-windows.ps1` to remove the
artifacts.

## 5. Which Windows tools map to the Linux ones

| Activity | Linux | Windows |
|---|---|---|
| List accounts | `getent passwd` | `Get-LocalUser` |
| Admin group members | `getent group sudo` | `Get-LocalGroupMember Administrators` |
| Listening services | `ss -tulpn` | `Get-NetTCPConnection -State Listen` |
| Running services | `ps -ef` / `systemctl` | `Get-Service` / `Get-Process` |
| Installed software | `dpkg -l` | `Get-CimInstance Win32_Product` / winget list |
| Password/lockout policy | `pwquality` / `faillock` | `net accounts` / `secpol.msc` |
| Host firewall | `ufw` | `Get-NetFirewallRule` / `New-NetFirewallRule` |
| Hashing | `sha256sum` | `Get-FileHash` |
| Search for PII/PANs | `grep -rEI` | `Select-String` / `findstr` |
| Scheduled jobs | `cron` | `Get-ScheduledTask` / Task Scheduler |
| Logs | `/var/log`, rsyslog | Event Viewer / `Get-WinEvent` / `wevtutil` |
