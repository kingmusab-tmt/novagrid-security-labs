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

## Concept Explanation — recovery & disaster recovery

Recovery is the disciplined return to normal *after* eradication — rebuilt clean, restored from a
backup that predates the intrusion, verified, and only then brought back online. It's governed by two
numbers the business cares about: **RTO** (how fast you must be back) and **RPO** (how much data you
can lose). A **DR test** proves you can actually hit them before a real disaster forces the question.

**Key terms**
- **Recovery** — restoring systems and data to normal operation after an incident.
- **Known-good image** — a trusted, clean build you rebuild from, rather than disinfecting the compromised host.
- **Restore point** — the backup you recover from; it must predate the intrusion so you don't restore the attacker too.
- **Go-live criteria** — the checklist that must pass before a system returns (patched, creds rotated, monitoring on, no persistence).
- **RTO / RPO** — Recovery Time / Point Objectives: the downtime and data-loss limits you design to.
- **DR test** — a rehearsal of recovery that measures actual RTO/RPO against the targets.

## Scope & rules of engagement
- **In scope:** your lab. Restore into a rebuilt host; don't reintroduce the compromise.

## Environment setup
The rebuilt wallet host/containers + your Ep8 backups.

Rebuild the wallet host/container from a clean base image; restore the Ep8 backup
(`sha256sum -c` to verify). Keep the compromised host isolated until forensics (Ep23) is
done. Time the rebuild+restore to measure RTO; note the backup age to measure RPO. Lab only.

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

## Commands explained

| Command / action | What it does | Why you use it here |
|---|---|---|
| `docker compose up -d --build` from a clean checkout | rebuilds the host from a trusted image | start from known-good, not the tainted host |
| restore the Ep8 backup + `sha256sum -c manifest` | recovers data and verifies integrity | restore clean data, proven byte-for-byte |
| choose a pre-intrusion restore point | selects a backup from before the attack | avoid restoring the compromise itself |
| `sshd -T`, `ss -tulpn`, re-run Lynis | re-verify hardening and exposure | confirm go-live criteria before online |
| time the recovery; compare to RTO/RPO | measures the DR test | prove (or expose) your recovery capability |

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
