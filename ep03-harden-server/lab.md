# Episode 3 — Harden the Wallet-API Server

## Cold open
> **From:** Tunde Bello (Sysadmin)
> **Subject:** New wallet-API box — can you make it safe before Friday?
>
> I spun up a new Ubuntu server for the wallet API but it's a default install. It goes live
> Friday. Can you harden it and give me a before/after so I can show Amara it's locked down? — Tunde

## Your role & mission objectives
- **Role:** analyst hardening a server to a secure baseline.
- **Objectives:**
  1. Measure a **baseline** hardening score.
  2. Lock down **SSH** and the **host firewall**.
  3. **Reduce attack surface** (remove/disable unneeded services) and enable **automatic updates** + **auditing**.
  4. **Re-measure** and document before/after with justification.

## Concept Explanation — secure baselines & hardening

Hardening means shrinking a system down to only what it needs, so there's less for an attacker to
use. A **secure baseline** is the documented "known-good" configuration you hold every server to;
measuring against it (here with Lynis) gives you a before/after you can defend to management. The
big levers are **reducing attack surface** (remove services, close ports), **securing remote
access** (SSH), a **host firewall**, and **keeping software patched**.

**Key terms**
- **Hardening index** — Lynis's 0–100 score of how locked-down a system is; useful as a relative
  before/after, not an absolute grade.
- **Attack surface** — everything an attacker could interact with (open ports, running services,
  accounts); smaller is safer.
- **Drop-in config** — a `*.conf` file in a `.d` directory (e.g. `/etc/ssh/sshd_config.d/`) that
  overrides the main file; the *effective* value is what matters, which is why you verify with `sshd -T`.
- **Host firewall** — per-machine inbound/outbound filtering (here `ufw`), independent of any network firewall.
- **Unattended-upgrades** — automatic installation of security patches, closing the patch gap.
- **auditd** — the Linux kernel audit daemon that records security-relevant events (needs a real kernel, so a VM, not a container).

## Scope & rules of engagement
- **In scope:** your lab's wallet-API VM/container. **Out of scope:** any production host.
- Change things reversibly and keep a note of every change.

## Environment setup
A hardenable Ubuntu target (the wallet-API host from the shared stack, or a throwaway
Ubuntu VM). Tool: **Lynis** (free) for before/after scoring.

A disposable **Ubuntu** target you can break safely — the wallet-API host from the shared
stack or a fresh Ubuntu VM. Install Lynis: `sudo apt-get update && sudo apt-get install -y lynis auditd`.
Keep a second shell/session open while editing sshd so you don't lock yourself out. Snapshot
the VM first if you can, so you can roll back.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api. **SSH settings live in a drop-in**, `/etc/ssh/sshd_config.d/00-novagrid-lab.conf`, which overrides the main file — check what's really active with `sshd -T`.
- Restart after changes with `lab-restart ssh` (it refuses a broken config). The firewall (`ufw`) works in this container.
- To remove the debug server: delete or rename `/etc/novagrid/enable-debug-server`, then `lab-restart debug-server`.
- `auditd` and kernel hardening need a real OS — run those steps on a **non-container system** (a normal Linux VM or server), not the Docker container.

## Guided investigation

Work on the **wallet-api** server (`docker compose exec wallet-api bash`). One action per sub-step.

### Step 1 — Baseline the hardening

**a.** Run an audit and record the score:
```bash
sudo lynis audit system        # note the Hardening index
```

**Decision:** What are the top weaknesses Lynis flags?

### Step 2 — Lock down SSH

**a.** Set the safe values (`PermitRootLogin no`, `PasswordAuthentication no`, limit users) in the SSH config.

**b.** Reload SSH safely and verify the *effective* config:
```bash
lab-restart ssh        # validates first — refuses a broken config, so you can't lock yourself out
sudo sshd -T | grep -Ei 'permitrootlogin|passwordauthentication'
```

**c.** If `sshd -T` still shows the old value, a drop-in is overriding you — Ubuntu reads
`/etc/ssh/sshd_config.d/*.conf` first and the first value wins. Fix it there:
```bash
sudo ls /etc/ssh/sshd_config.d/
```

**Decision:** Which settings reduce the most risk, and what could lock you out if careless?

### Step 3 — Host firewall

**a.** Set deny-by-default and allow only what's needed, then enable it:
```bash
sudo ufw default deny incoming
sudo ufw allow 8080/tcp        # the wallet API in this lab (not 443 — no TLS yet)
sudo ufw allow 22/tcp          # admin SSH
sudo ufw enable
```

**Decision:** What's the minimum set of allowed inbound ports here, and would putting TLS (443) in front of 8080 change it?

### Step 4 — Attack surface + updates

**a.** Disable or remove services you don't need (e.g. the stray debug server):
```bash
sudo rm -f /etc/novagrid/enable-debug-server && lab-restart debug-server
```

**b.** Turn on automatic security patching:
```bash
sudo apt-get install -y unattended-upgrades
```

**Decision:** What did you remove, and how did you decide it was safe to?

### Step 5 — Auditing

Enable `auditd` with a basic ruleset (watch key files + auth). `auditd` needs a real kernel, so do
this on a **non-container system** (a normal VM or server); it won't run in the Docker container —
note that in your report.

### Step 6 — Re-measure

**a.** Re-run the audit and compare:
```bash
sudo lynis audit system        # compare the new Hardening index to Step 1
```

**Decision:** How much did the index improve, and which change moved it most?

### Evidence checkpoints
- [ ] Lynis **before** index  - [ ] sshd_config diff  - [ ] `ufw status`  - [ ] `auditd` status/rules  - [ ] Lynis **after** index

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `sudo lynis audit system` | audits the host and prints a hardening index + findings | baseline before, measure after |
| `sudo sshd -T` | prints SSH's *effective* configuration | confirm your change actually took (beats a drop-in override) |
| `lab-restart ssh` | validates then reloads sshd in the lab (refuses a broken config) | apply SSH changes without locking yourself out |
| `ufw default deny incoming` / `ufw allow <port>` | sets a deny-by-default firewall, then allows only needed ports | cut the inbound attack surface |
| `unattended-upgrades` | enables automatic security patching | close the patch gap |
| `auditd` + rules | records auth and file-change events | add detective logging (on a non-container system) |

## On Windows

Harden the **Windows target** with the same ideas; the tools differ.

**a.** Review running services and the firewall (cf. Lynis / `ufw`):
```powershell
Get-Service | Where-Object Status -eq Running
Get-NetFirewallProfile | Select-Object Name,Enabled,DefaultInboundAction
```
**b.** Set deny-by-default inbound and allow only what's needed:
```powershell
Set-NetFirewallProfile -All -Enabled True -DefaultInboundAction Block
New-NetFirewallRule -DisplayName "Wallet API" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
```
**c.** Reduce attack surface — turn off the lab's weak RDP exposure once you've set your policy:
```powershell
Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' fDenyTSConnections 1
```
For a measured baseline (the Lynis equivalent) use the **CIS Benchmark / CIS-CAT** or Microsoft's
**Security Compliance Toolkit** (LGPO). Keep patching current with Windows Update.

## Deliverable
Fill `deliverable-template.md` → the **hardening report** with before/after and rationale.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1042 Disable/Remove Feature or Program, M1028 OS Configuration, M1037 Filter Network Traffic (host firewall), M1026 Privileged Account Management, M1051 Update Software
- **NIST CSF:** PROTECT — PR.PS/PR.IP (secure configuration, baselines)
- **Security+ SY0-701:** 4.1 secure baselines & hardening targets; 2.x reducing the attack surface

## Stretch goals
1. Apply a subset of the **CIS Ubuntu Benchmark** and cite the control numbers.
2. Measure with **OpenSCAP** against a profile and attach the report.

## Verification questions
1. What was your Lynis hardening index before vs after?
2. Which two SSH settings did you change and why?
3. What is your firewall's default inbound policy, and which ports are allowed?
