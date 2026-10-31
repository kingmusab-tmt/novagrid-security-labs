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

## Concept Explanation — backups, resilience & the 3-2-1 rule

Backups are only as good as your last successful *restore* — an untested backup is a guess. The
**3-2-1 rule** (3 copies, 2 media/locations, 1 off-site) and an **offline/immutable** copy are what
survive a ransomware event that encrypts everything online. You size backups to the business's
tolerance for loss and downtime (**RPO** and **RTO**) and prove integrity with checksums.

**Key terms**
- **3-2-1 rule** — keep **3** copies of data, on **2** different media/locations, with **1** off-site.
- **RPO (Recovery Point Objective)** — how much data you can afford to lose (how far back the last backup is).
- **RTO (Recovery Time Objective)** — how quickly you must be back up after an incident.
- **Checksum manifest** — a file of `sha256` hashes used to prove a restore is byte-for-byte correct.
- **Immutable / offline backup** — a copy that can't be altered or reached from the live network, so ransomware can't encrypt it.
- **Restore test** — actually recovering from backup to confirm it works — the step most often skipped.

## Scope & rules of engagement
- **In scope:** your lab's wallet data/config. Test restores into a scratch location, not over live data.

## Environment setup
Analyst VM / wallet host. Tools: `tar`, `sha256sum`, `cron`.

Analyst VM or wallet host. Back up a sample data/config directory. Use `tar czf`,
`sha256sum ... > manifest.sha256`, and `sha256sum -c manifest.sha256` to verify. Restore
into a scratch dir (e.g. `/tmp/restore-test`) — never over live data. Schedule with `cron`.
For the "off-site" copy, a second directory/mounted volume is fine for the lab.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Back up `/srv/wallet` and `/etc/wallet` on wallet-api. `/backup` and `/offsite` are two separate Docker volumes — your two media/locations for 3-2-1.
- Restore-test into `/tmp/restore-test`. `cron` is running for scheduling.

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

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `tar czf backup.tgz /srv/wallet /etc/wallet` | creates a compressed archive of the targets | make the backup |
| `sha256sum ... > manifest.sha256` | records a hash of each file | capture integrity evidence |
| `sha256sum -c manifest.sha256` | re-checks files against the manifest | prove the restore is byte-for-byte correct |
| `crontab -e` / a `cron` entry | schedules the backup to run automatically | automate it (no human to forget) |
| restore into `/tmp/restore-test` | unpacks the backup to a scratch dir | test recovery without touching live data |

## Deliverable
Fill `deliverable-template.md` → the **backup plan** + **restore-test evidence**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1053 Data Backup (offline/offsite copies defeat T1486 ransomware impact)
- **NIST CSF:** PROTECT — PR.DS (data security/backups); RECOVER — RC.RP (recovery)
- **Security+ SY0-701:** 3.x resilience & recovery; backups; 2.x ransomware mitigation

## Stretch goals
1. **Encrypt** the backups (e.g. `gpg`/`openssl`) and manage the key.
2. Keep an **offline/immutable** copy and restore from a *different* machine.

## Verification questions
1. State the 3-2-1 rule and how your setup meets it.
2. How did you prove the restore worked (not just that files reappeared)?
3. What's the difference between RPO and RTO in your plan?
