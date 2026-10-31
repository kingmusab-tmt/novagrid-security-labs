# Episode 18 — Credential Stuffing on Customer Accounts

## Cold open
> **From:** Amara Okafor (SOC Lead)
> **Subject:** Customers locked out — are we being stuffed?
>
> Support is flooded with "I'm locked out" and we're seeing logins from odd places. I think
> it's credential stuffing — reused passwords from other breaches being replayed against our
> login. Prove it from the logs, then tell me how we stop it without locking out real
> customers. — Amara

## Your role & mission objectives
- **Role:** analyst detecting an account-takeover campaign and designing mitigations.
- **Objectives:**
  1. Distinguish **credential stuffing** from brute force and password spraying.
  2. **Detect** the pattern in auth/web logs (many accounts, few IPs, high failure rate, some successes).
  3. Identify **compromised accounts** (failure→success, new geo/device).
  4. Design **mitigations** that stop it without harming legitimate users.

## Scope & rules of engagement
- **In scope:** analysing provided/lab auth logs and writing the detection + mitigation plan.
- **Out of scope:** actually running any credential attack.

## Environment setup
Use auth/web logs from your lab (the wallet portal access log / auth log), or a sample auth
log. Optionally query them in **Splunk** (reuse the Ep13 instance). See `environment/README.md`.

## Guided investigation
1. **Define the attack.** Credential stuffing (known user:pass pairs, many accounts) vs brute
   force (many passwords, one account) vs spraying (few common passwords, many accounts).
   - **Decision:** Which signature distinguishes stuffing in the logs?
2. **Detect.** Find sources attempting logins across **many distinct accounts** with a **high
   failure rate** and a **low but non-zero success rate**; note velocity and geo spread.
   - **Decision:** What thresholds/queries flag stuffing but not a busy normal day?
3. **Scope compromise.** Identify accounts with a failure→**success** from a stuffing source, or logins from a new country/device.
   - **Decision:** Which accounts are likely taken over, and what's the immediate action?
4. **Mitigate.** Design layered controls and weigh user friction.
   - **Decision:** Which controls stop stuffing with least impact on real customers?

### Evidence checkpoints
- [ ] the detection query/logic + result  - [ ] list of suspected compromised accounts  - [ ] the attack-type justification  - [ ] the mitigation plan

## Deliverable
Fill `deliverable-template.md` → the **detection + mitigation write-up**.

## Framework mapping
- **MITRE ATT&CK:** T1110.004 (credential stuffing), T1078 (valid accounts)
- **NIST CSF:** DETECT (DE.CM, DE.AE) · PROTECT (PR.AA)
- **Security+ SY0-701:** 2.4 password attacks (stuffing/spraying/brute force); 4.6 detection; MFA & mitigations

## Stretch goals
1. Write the detection as a **Splunk/Sigma** rule (feeds Episode 20).
2. Model **impossible-travel** detection (two logins too far apart in time/space).

## Verification questions
1. How does credential stuffing differ from brute force and from spraying?
2. What log pattern did you use to detect it, and how did you avoid false positives?
3. Which single mitigation helps most, and what's its user-experience cost?
