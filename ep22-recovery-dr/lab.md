# Episode 22 — Recover & Test the BCP/DR

## Cold open

*Story so far — With the threat contained and eradicated (Ep21), the business needs the wallet service back — without re-opening the hole.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Get us back up — safely — and prove we can do it again
>
> Eradication's done. Rebuild the wallet service, restore clean data, and verify it before
> go-live. Then run a DR test so we can tell the board how fast we recover and how much data
> we'd lose. Write it as a runbook. — Amara

## Your role & mission objectives
- **Role:** responder leading recovery + a DR test.
- **Objectives:**
  1. **Rebuild** the service from a known-good image and **restore** clean data (from Ep8 backups).
  2. **Verify** integrity and that the attacker's access is gone *before* go-live.
  3. Run a **DR test** and measure against **RTO/RPO**.
  4. Capture a reusable **recovery runbook**.

## Scope & rules of engagement
- **In scope:** your lab. Restore into a rebuilt host; don't reintroduce the compromise.

## Environment setup
The rebuilt wallet host/containers + your Ep8 backups. See `environment/README.md`.

## Guided investigation
1. **Rebuild.** Stand up a clean host/container from a trusted image; apply patches + the Ep3 hardening.
   - **Decision:** Why rebuild from image rather than un-quarantine the old host?
2. **Restore.** Restore data from a backup **predating** the intrusion; verify with hashes (Ep8).
   - **Decision:** How do you pick a restore point that isn't already tainted?
3. **Verify before go-live.** Confirm patches applied, cracked creds rotated, monitoring on, no persistence.
   - **Decision:** What's your go-live checklist / sign-off criteria?
4. **DR test + metrics.** Time the recovery; compare to **RTO**; check data loss vs **RPO**.
   - **Decision:** Did you meet RTO/RPO? If not, what change closes the gap?

### Evidence checkpoints
- [ ] rebuild steps  - [ ] restore + hash verification  - [ ] go-live checklist signed  - [ ] DR timing vs RTO/RPO

## Deliverable
Fill `deliverable-template.md` → the **recovery runbook + DR-test report**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1053 Data Backup (recovery from known-good)
- **NIST CSF:** RECOVER — RC.RP (recovery), RC.IM (improvements)
- **Security+ SY0-701:** 3.x resilience (RTO/RPO, backups, site resilience); 4.1 recovery

## Stretch goals
1. Define **MTTR/MTBF** and add them to the metrics.
2. Describe a warm/hot-site or multi-AZ option and its RTO/cost trade-off.

## Verification questions
1. How did you choose a clean restore point, and how did you verify the restore?
2. What were your measured recovery time and data-loss window vs your RTO/RPO?
3. What is your go-live sign-off checklist?
