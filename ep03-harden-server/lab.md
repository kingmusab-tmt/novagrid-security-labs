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
- `auditd` and kernel hardening need a real OS — use the Vagrant VM in `lab-env/vagrant/` for those steps.

## Guided investigation
1. **Baseline.** Install and run `sudo lynis audit system`; record the **Hardening index**.
   - **Decision:** What are the top weaknesses Lynis flags?
2. **SSH.** Set `PermitRootLogin no`, `PasswordAuthentication no` (keys), limit users, disable
   unused auth. Then **reload and verify the effective config with `sudo sshd -T`** (reload via
   `lab-restart ssh`, which refuses a broken config so you can't lock yourself out).
   - **Decision:** Which settings reduce the most risk, and what could lock you out if careless?
   - **If `sshd -T` still shows the old value**, something is overriding your edit — Ubuntu reads
     `/etc/ssh/sshd_config.d/*.conf` *before* the main file and the first value wins. Find what's
     there and fix it at the source. (Editing only `sshd_config` when a drop-in overrides it is the
     single most common way this step silently fails.)
3. **Firewall.** `ufw default deny incoming`, then allow only what the service needs plus admin SSH,
   and enable ufw. In this lab the wallet API listens on **8080** (not 443 — there's no TLS yet),
   so don't blackhole it; `nmap`/`ss` tells you what's actually listening.
   - **Decision:** What's the minimum set of allowed inbound ports for this wallet API, and would
     putting TLS (443) in front of 8080 change your answer?
4. **Attack surface + updates.** Disable/remove services you don't need; enable `unattended-upgrades`.
   - **Decision:** What did you remove, and how did you decide it was safe to?
5. **Auditing.** Enable `auditd` with a basic ruleset (watch key files, auth). `auditd` needs a real
   kernel, so do this on the **Vagrant VM** (`lab-env/vagrant/`); on the Docker container it won't
   run — note that in your report and cover it on the VM.
6. **Re-measure.** Re-run Lynis; compare the index.

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
| `auditd` + rules | records auth and file-change events | add detective logging (on the Vagrant VM) |

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
