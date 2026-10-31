# Episode 10 — AUP + Onboarding/Offboarding

## Cold open
> **From:** Zainab Idris (Compliance)
> **Subject:** A leaver still had access — we need policy + process
>
> A contractor left last month and we just found their account still active with sudo. We
> need an Acceptable Use Policy everyone signs, and real onboarding/offboarding procedures
> so this never happens again. Write them — and show me the offboarding actually run on that
> account. — Zainab

## Your role & mission objectives
- **Role:** analyst authoring policy + procedures and executing offboarding.
- **Objectives:**
  1. Write an **Acceptable Use Policy (AUP)** with the standard elements.
  2. Write an **onboarding** procedure (provision with least privilege, MFA, AUP sign).
  3. Write an **offboarding** procedure (disable, revoke, collect, rotate).
  4. **Execute** the offboarding checklist on a leaver account on the VM.

## Concept Explanation — governance: AUP & the identity lifecycle

Policies turn good intentions into repeatable practice. An **Acceptable Use Policy (AUP)** sets the
rules for using company systems and — crucially — is *acknowledged* by signature so it can be
enforced. The **identity lifecycle** (joiner → mover → leaver) makes sure access is granted correctly
at the start and, just as importantly, fully removed at the end — the lingering leaver account is a
classic breach path.

**Key terms**
- **AUP (Acceptable Use Policy)** — the documented rules for using company systems, including a monitoring notice and a signature line.
- **Joiner / Mover / Leaver (JML)** — the stages of the identity lifecycle; access should change with each.
- **Onboarding** — create account, grant least-privilege role access, enrol MFA, sign the AUP.
- **Offboarding** — disable access, revoke sudo/keys, rotate shared secrets, recover devices.
- **Disable before delete** — lock an account first (preserving data and evidence) rather than deleting immediately.
- **Break-glass account** — a tightly controlled emergency admin account, used only when normal access fails.

## Scope & rules of engagement
- **In scope:** writing the documents + running offboarding on a *lab* account. Reversible changes.

## Environment setup
Analyst VM with a "leaver" account (e.g. `webadmin`/a contractor account). Tools:
`usermod`, `passwd`, `gpasswd`, `chage`, key/SSH files.

Analyst VM with a "leaver" account to offboard (create one if needed: `sudo useradd -m -s
/bin/bash contractor && sudo usermod -aG sudo contractor`). Offboarding commands (reversible):
`sudo usermod -L contractor` (lock), `sudo usermod -s /usr/sbin/nologin contractor`,
`sudo gpasswd -d contractor sudo`, remove `~/.ssh/authorized_keys`, `sudo chage -E 0 contractor`.
Capture before/after proof into `evidence/`.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- The leaver to offboard is `contractor` on wallet-api — still in `sudo` and still holding an SSH key in `/home/contractor/.ssh/authorized_keys`.

## Guided investigation

You'll offboard the leaver account on **wallet-api**. One action per sub-step.

### Step 1 — Write the AUP

Cover purpose; acceptable/unacceptable use; a monitoring/privacy notice; consequences; and an
acknowledgement/signature line.

**Decision:** Which elements are non-negotiable, and why include a monitoring notice?

### Step 2 — Onboarding procedure

Create account → grant **least-privilege** role access → enrol **MFA** → issue a password manager → **sign the AUP**.

**Decision:** Why is least privilege the key step at joining?

### Step 3 — Offboarding procedure

Disable (not delete) → revoke sudo/SSH keys → rotate shared secrets they knew → collect devices → retain data per policy.

**Decision:** Why disable before delete, and what exactly do you rotate?

### Step 4 — Execute the offboarding

**a.** Open a shell:
```bash
docker compose exec wallet-api bash
```

**b.** Run the checklist on the leaver (`contractor`), capturing proof as you go:
```bash
sudo usermod -L contractor                       # lock the password
sudo usermod -s /usr/sbin/nologin contractor     # no shell
sudo gpasswd -d contractor sudo                   # remove admin
sudo rm -f /home/contractor/.ssh/authorized_keys  # revoke their SSH key
sudo chage -E 0 contractor                        # expire the account now
```

**Decision:** How do you prove the leaver can no longer get in — by password *or* by key?

### Evidence checkpoints
- [ ] the AUP  - [ ] onboarding checklist  - [ ] offboarding checklist  - [ ] proof offboarding was executed (account disabled, sudo removed)

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `sudo usermod -L <user>` | locks the account's password | disable a leaver (reversible) before deleting |
| `sudo usermod -s /usr/sbin/nologin <user>` | changes the login shell so they can't get a shell | block interactive login |
| `sudo gpasswd -d <user> sudo` | removes the user from sudo | revoke admin rights |
| `rm ~/<user>/.ssh/authorized_keys` | removes their SSH key | cut key-based access (passwords aren't the only way in) |
| `sudo chage -E 0 <user>` | expires the account immediately | enforce the leaver date |

## On Windows

Run the offboarding checklist on the **Windows target**'s leaver (`contractor`).

**a.** Disable (don't delete) and revoke admin:
```powershell
Disable-LocalUser -Name contractor
Remove-LocalGroupMember -Group Administrators -Member contractor
```
**b.** Remove stored access and rotate shared secrets they knew (`cmdkey /list` for saved creds; clear RDP).

**c.** In a domain: `Disable-ADAccount`, move to a disabled OU, reset manager/ownership, and revoke tokens.
Same decision: disable-before-delete preserves data/evidence; prove they can't log on by password *or* saved credential.

## Deliverable
Fill `deliverable-template.md` → the **AUP + onboarding/offboarding procedures** (and the executed offboarding evidence).

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1018 User Account Management (joiner/mover/leaver), M1017 User Training (AUP)
- **NIST CSF:** PROTECT — PR.AC (identity lifecycle); GOVERN (policy)
- **Security+ SY0-701:** 5.1 governance (policies, procedures); onboarding/offboarding; AUP

## Stretch goals
1. Build a **RACI** for joiner/mover/leaver (who does what).
2. **Script** the offboarding steps into one reviewed command set.

## Verification questions
1. Name three required elements of an AUP.
2. On offboarding, why disable before deleting, and what secrets do you rotate?
3. What is the single most important onboarding step from a security view, and why?
