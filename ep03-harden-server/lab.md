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

## Scope & rules of engagement
- **In scope:** your lab's wallet-API VM/container. **Out of scope:** any production host.
- Change things reversibly and keep a note of every change.

## Environment setup
A hardenable Ubuntu target (the wallet-API host from the shared stack, or a throwaway
Ubuntu VM). See `environment/README.md`. Tool: **Lynis** (free) for before/after scoring.

## Guided investigation
1. **Baseline.** Install and run `sudo lynis audit system`; record the **Hardening index**.
   - **Decision:** What are the top weaknesses Lynis flags?
2. **SSH.** In `/etc/ssh/sshd_config`: `PermitRootLogin no`, `PasswordAuthentication no` (keys),
   limit users, disable unused auth. Reload sshd.
   - **Decision:** Which settings reduce the most risk, and what could lock you out if careless?
3. **Firewall.** `ufw default deny incoming`, allow only 443 (+22 from admin): enable ufw.
   - **Decision:** What's the minimum set of allowed inbound ports for a wallet API?
4. **Attack surface + updates.** Disable/remove services you don't need; enable `unattended-upgrades`.
   - **Decision:** What did you remove, and how did you decide it was safe to?
5. **Auditing.** Enable `auditd` with a basic ruleset (watch key files, auth).
6. **Re-measure.** Re-run Lynis; compare the index.

### Evidence checkpoints
- [ ] Lynis **before** index  - [ ] sshd_config diff  - [ ] `ufw status`  - [ ] `auditd` status/rules  - [ ] Lynis **after** index

## Deliverable
Fill `deliverable-template.md` → the **hardening report** with before/after and rationale.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** PROTECT — PR.PS/PR.IP (secure configuration, baselines)
- **Security+ SY0-701:** 4.1 secure baselines & hardening targets; 2.x reducing the attack surface

## Stretch goals
1. Apply a subset of the **CIS Ubuntu Benchmark** and cite the control numbers.
2. Measure with **OpenSCAP** against a profile and attach the report.

## Verification questions
1. What was your Lynis hardening index before vs after?
2. Which two SSH settings did you change and why?
3. What is your firewall's default inbound policy, and which ports are allowed?
