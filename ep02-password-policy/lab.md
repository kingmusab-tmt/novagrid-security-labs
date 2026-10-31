# Episode 2 — Password Policy & IAM Baseline

## Cold open
> **From:** Amara Okafor (SOC Lead)
> **Subject:** Tunde's password was in a breach dump
>
> Tunde reused the same password for his admin account and his personal email, and it's in
> a public breach list. Before this bites us, write NovaGrid's password standard and an IAM
> checklist — based on current guidance, not 2005 folklore — and set the basics on the VM. — Amara

## Your role & mission objectives
- **Role:** analyst defining the password standard and IAM baseline.
- **Objectives:**
  1. Assess current password settings on the VM.
  2. Write a password standard aligned to **current NIST SP 800-63B** guidance.
  3. Write an IAM checklist (unique accounts, least privilege, MFA, manager, no shared creds).
  4. Apply the basics on the Linux VM and capture before/after.

## Concept Explanation — authentication & modern password policy

Authentication is how a system proves you are who you claim to be, and the password is still the
most common (and most attacked) factor. Modern guidance (NIST SP 800-63B) flips the old habits:
favour **length over complexity**, screen passwords against known-breached lists, and **stop forcing
periodic rotation** (which just produces `Password1`, `Password2`…). You pair that with **lockout**
to blunt guessing and **MFA** so a stolen password alone isn't enough.

**Key terms**
- **pam_pwquality** — the Linux module that enforces password-strength rules (minimum length, how
  many characters must change) when a password is set.
- **Password entropy / length** — a measure of how hard a password is to guess; a long passphrase
  beats a short "complex" one.
- **Breached-password screening** — rejecting passwords that appear in known breach corpora, so
  attackers can't reuse leaked credentials.
- **Account lockout (faillock)** — locking an account after N failed attempts to slow brute-force
  and credential-guessing.
- **MFA (multi-factor authentication)** — requiring two factors from *different* categories
  (know / have / are), so one stolen secret isn't enough.

## Scope & rules of engagement
- **In scope:** policy writing + light config on your analyst VM. **Out of scope:** changing production systems.

## Environment setup
Analyst VM. Inspect `/etc/login.defs`, PAM `pw_quality`/`pam_pwquality`, and `faillock`.

Work on the **wallet-api** target in the shared lab (or your own throwaway Ubuntu VM if you
aren't using `lab-env`). Relevant files/tools: `/etc/login.defs`, `/etc/security/pwquality.conf`,
`pam_pwquality`, `faillock`/`pam_faillock`. All changes are reversible — never touch a shared or
production system. Capture `before` and `after` of each setting into `evidence/`.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api (`docker compose exec wallet-api bash`). Policy file: `/etc/security/pwquality.conf`; lockout goes in `/etc/pam.d/common-auth` (`pam_faillock`).
- Test as a user: `su - chidi` then `passwd`. Tunde's password is `Tunde@2024` — the breached one.

## Guided investigation

Work on the **wallet-api** server. Each sub-step is one action; read the note, then answer the **Decision**.

### Step 1 — See what's enforced today

**a.** Open a shell on the server:
```bash
docker compose exec wallet-api bash
```

**b.** Check the password-ageing defaults:
```bash
grep PASS /etc/login.defs
```

**c.** Check the strength rules currently in force:
```bash
cat /etc/security/pwquality.conf        # look at minlen / difok
grep -r pwquality /etc/pam.d/            # is pam_pwquality actually wired in?
```

**Decision:** What does the box enforce right now — length, ageing, lockout? What's missing?

### Step 2 — Set a modern standard

Base it on NIST 800-63B: long passphrases (>= 12–14), screen against breached lists, **no** forced
periodic rotation, lockout on repeated failures, MFA for admin/remote access. *(Exam note: SY0-701
still references complexity and 90-day rotation — state the modern stance and note the exam's framing.)*

**a.** Raise the strength rules in `/etc/security/pwquality.conf`:
```bash
sudo sed -i 's/^.*minlen.*/minlen = 14/' /etc/security/pwquality.conf
# add/adjust: difok = 4
```

**b.** Add lockout with `pam_faillock` in `/etc/pam.d/common-auth` (deny after N failures, unlock after a delay).

**Decision:** What minimums do you set, and how do you justify them against the old "complexity + 90-day rotation" habit?

### Step 3 — Test it

**a.** Try to set a weak password and confirm it's rejected:
```bash
su - chidi -c 'passwd'      # try a short/common password — it should be refused
```

**b.** (Optional) Trigger the lockout with repeated bad logins, then confirm the account locks.

**Decision:** Did the policy actually block a weak password? What did the lockout do?

### Step 4 — IAM checklist

Write the baseline the whole org should follow: unique per-person accounts, least privilege, MFA,
an approved password manager, no shared credentials, and breached-password screening.

**Decision:** Which of these is the single biggest improvement for NovaGrid, and why?

### Evidence checkpoints
- [ ] current `login.defs`/pwquality settings  - [ ] the written standard  - [ ] applied config (before/after)  - [ ] the IAM checklist

## Commands explained

| Command / file | What it does | Why you use it here |
|---|---|---|
| `grep PASS /etc/login.defs` | shows the system's password-ageing defaults (max/min days, warning) | see what the box enforces today |
| `/etc/security/pwquality.conf` (`minlen`, `difok`) | the rules `pam_pwquality` applies to new passwords | set a sane minimum length and change requirement |
| `pam_faillock` in `/etc/pam.d/common-auth` | locks an account after repeated failed logins | add brute-force throttling (not configured by default) |
| `passwd <user>` | sets/changes a password | test that your new policy is actually enforced |
| `chage -l <user>` | shows an account's password-ageing status | confirm ageing settings and spot stale passwords |

## On Windows

On the **Windows target**, the same policy lives in the local/Domain password & lockout policy.

**a.** See what's enforced now (cf. `grep PASS /etc/login.defs`):
```powershell
net accounts
```
**b.** Set a modern baseline (length over complexity, add lockout):
```powershell
net accounts /minpwlen:14 /lockoutthreshold:10 /lockoutduration:15
# or: secpol.msc -> Account Policies -> Password Policy / Account Lockout Policy
```
**c.** Check per-account state:
```powershell
Get-LocalUser | Select-Object Name,PasswordRequired,PasswordExpires
```
In a domain these are Group Policy settings (`Get-ADDefaultDomainPasswordPolicy`), with
fine-grained password policies for exceptions. Breached-password screening maps to Entra ID /
Azure AD Password Protection.

## Deliverable
Fill `deliverable-template.md` → the **password policy** + **IAM checklist**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1027 Password Policies, M1036 Account Use Policies (lockout), M1032 Multi-factor Authentication
- **NIST:** SP 800-63B (digital identity / authenticators); CSF PROTECT (PR.AC/PR.AA)
- **Security+ SY0-701:** identity & access management; password concepts; MFA

## Stretch goals
1. Screen new passwords against the Have I Been Pwned (Pwned Passwords) list.
2. Stand up a shared team password manager and document the rollout.

## Verification questions
1. What is the current NIST stance on forced periodic password rotation, and why?
2. What `minlen` did you set, and what lockout threshold did you configure?
3. Which accounts must have MFA, and why those first?
