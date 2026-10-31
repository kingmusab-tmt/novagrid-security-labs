# Episode 8 — Backup & Restore Baseline (3-2-1)

## Cold open
> **From:** Tunde Bello (Sysadmin)
> **Subject:** Are our backups actually... real?
>
> We "have backups" but I've never tried restoring one, and after the ransomware scare that
> scares me. Set up a proper backup for the wallet data and config, and — this is the bit I
> care about — prove we can restore it and the data's intact. — Tunde

## Your role & mission objectives
- **Role:** analyst implementing and testing a backup baseline.
- **Objectives:**
  1. Apply the **3-2-1 rule** (3 copies, 2 media/locations, 1 off-site/offline).
  2. **Script a backup** of the wallet data + config, with integrity hashes.
  3. **Restore-test** it (simulate loss, restore, verify hashes match).
  4. Note **RPO/RTO** and an **offline/immutable** copy against ransomware.

## Scope & rules of engagement
- **In scope:** your lab's wallet data/config. Test restores into a scratch location, not over live data.

## Environment setup
Analyst VM / wallet host. Tools: `tar`, `sha256sum`, `cron`. See `environment/README.md`.

## Guided investigation
1. **Scope + strategy.** Decide what must be backed up and how 3-2-1 applies here.
   - **Decision:** What's your RPO (how much data can you lose) and RTO (how fast must you restore)?
2. **Script the backup.** `tar` the targets, write a `sha256sum` manifest, store a second copy in another location.
   - **Decision:** Why keep a checksum manifest at all?
3. **Schedule it.** Add a `cron` entry; note where the off-site/offline copy goes.
4. **Restore test.** Delete/rename the original, restore from the backup into a scratch dir, and verify every file's hash matches the manifest.
   - **Decision:** How do you *prove* the restore is byte-for-byte correct?
5. **Ransomware angle.** Explain why an **offline/immutable** copy matters (online backups get encrypted too).

### Evidence checkpoints
- [ ] the backup script  - [ ] a backup archive + checksum manifest  - [ ] restore-test log showing hashes match  - [ ] cron entry

## Deliverable
Fill `deliverable-template.md` → the **backup plan** + **restore-test evidence**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** PROTECT — PR.DS (data security/backups); RECOVER — RC.RP (recovery)
- **Security+ SY0-701:** 3.x resilience & recovery; backups; 2.x ransomware mitigation

## Stretch goals
1. **Encrypt** the backups (e.g. `gpg`/`openssl`) and manage the key.
2. Keep an **offline/immutable** copy and restore from a *different* machine.

## Verification questions
1. State the 3-2-1 rule and how your setup meets it.
2. How did you prove the restore worked (not just that files reappeared)?
3. What's the difference between RPO and RTO in your plan?
