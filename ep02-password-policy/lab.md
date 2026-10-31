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

## Scope & rules of engagement
- **In scope:** policy writing + light config on your analyst VM. **Out of scope:** changing production systems.

## Environment setup
Analyst VM. Inspect `/etc/login.defs`, PAM `pw_quality`/`pam_pwquality`, and `faillock`.

## Guided investigation
1. **Assess current.** `cat /etc/login.defs | grep PASS`, check for `libpam-pwquality`.
   - **Decision:** What does the box enforce today (length, ageing, lockout)?
2. **Write the standard (modern).** Base it on NIST 800-63B: **long** passwords/passphrases
   (>=12–14), **screen against breached-password lists**, **no forced periodic rotation**
   (rotate only on suspicion of compromise), throttle/lockout on repeated failures, and
   **MFA for all admin/remote access**.
   - **Decision:** What minimums do you set, and what's your justification vs. old
     "complexity + 90-day rotation" habits? *(Exam note: SY0-701 still references complexity
     and age — state the modern stance and note the exam's framing.)*
3. **Apply basics.** Set `minlen`/`difok` in pwquality; configure `faillock` lockout; document each change.
4. **IAM checklist.** Unique per-person accounts, least privilege, MFA, approved password manager, ban shared credentials, breached-password screening.

### Evidence checkpoints
- [ ] current `login.defs`/pwquality settings  - [ ] the written standard  - [ ] applied config (before/after)  - [ ] the IAM checklist

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
