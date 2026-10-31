# Recovery Runbook & DR Test — Episode 22 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Rebuild
Fresh container from a trusted base image; applied updates + Ep3 hardening (SSH, ufw, auditd).

## 2. Restore
- Restore point: the nightly backup from **before** the first Ep13 scan timestamp.
- Verified with `sha256sum -c` against the Ep8 manifest — all match.

## 3. Go-live checklist (sign-off)
Patched ✓, admin creds rotated + MFA ✓, central logging + SIEM alert (Ep20) on ✓, persistence
re-checked clean ✓, data verified ✓ → approved for go-live.

## 4. DR metrics
| Metric | Target | Actual |
|---|---|---|
| RTO | 2h | 1h40 |
| RPO | 24h | ~18h (last clean nightly) |

## 5. Gaps & improvements
Met RTO/RPO, but choosing the clean restore point took longer than expected — add
pre-tagged backup checkpoints and more frequent backups to shrink RPO.

## 6. Reflection (own words)
The subtle risk is restoring a backup that's *already* tainted — I chose a point before the
first malicious timestamp from Ep13. Verifying against the hash manifest made go-live defensible.
