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

## Scope & rules of engagement
- **In scope:** writing the documents + running offboarding on a *lab* account. Reversible changes.

## Environment setup
Analyst VM with a "leaver" account (e.g. `webadmin`/a contractor account). Tools:
`usermod`, `passwd`, `gpasswd`, `chage`, key/SSH files. See `environment/README.md`.

## Guided investigation
1. **Write the AUP.** Purpose; acceptable & unacceptable use; monitoring/privacy notice; consequences; **acknowledgement/signature**.
   - **Decision:** Which elements are non-negotiable, and why include a monitoring notice?
2. **Onboarding procedure.** Create account → grant **least-privilege** role access → enrol **MFA** → issue password manager → **sign the AUP**.
   - **Decision:** Why is least privilege the key step at joining?
3. **Offboarding procedure.** **Disable** (not immediately delete) → revoke sudo/SSH keys → rotate any shared secrets they knew → collect devices/badge → retain data per policy.
   - **Decision:** Why disable before delete, and what do you rotate?
4. **Execute offboarding.** Run the checklist on the leaver account; capture proof (account locked, sudo removed, key revoked).

### Evidence checkpoints
- [ ] the AUP  - [ ] onboarding checklist  - [ ] offboarding checklist  - [ ] proof offboarding was executed (account disabled, sudo removed)

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
