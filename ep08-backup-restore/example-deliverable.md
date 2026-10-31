# Backup Plan & Restore Test — Episode 8 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Strategy
- Back up: wallet data dir + `/etc` configs.
- 3-2-1: live copy + local backup dir (media 1) + off-site volume (media 2, offline) = 3 copies.
- RPO: 24h (nightly). RTO: 2h.

## 2. Backup implementation
- Script: `tar czf wallet-$(date +%F).tgz /srv/wallet /etc/wallet && sha256sum wallet-*.tgz > manifest.sha256`, then copy to the off-site volume.
- Schedule: nightly `cron` at 01:30.
- Manifest: `manifest.sha256` kept with each archive.

## 3. Restore test
- Simulated loss: renamed `/srv/wallet` to `/srv/wallet.bak`.
- Restored archive into `/tmp/restore-test`; ran `sha256sum -c` against a manifest of the originals.
- Result: **all hashes match** — byte-for-byte identical.

## 4. Ransomware resilience
- One copy is offline (volume detached after backup); ransomware can't encrypt what isn't mounted.

## 5. Reflection (own words)
The restore test is the whole point — the archive existed for weeks but nobody had proven it
restores. The hash check is what turns "the files came back" into "the data is intact".
