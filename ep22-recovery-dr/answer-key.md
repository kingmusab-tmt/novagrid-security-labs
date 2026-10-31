# Instructor Answer Key — Episode 22
- Rebuild from known-good image (don't reuse the compromised host). Restore data from BEFORE the earliest malicious activity (use Ep13 timeline); verify with the Ep8 hash manifest.
- Go-live sign-off: patched, creds rotated + MFA, monitoring/SIEM on, persistence clean, data verified.
- RTO = time to restore service; RPO = acceptable data loss (= backup frequency/age). Students measure both and propose closing any gap (more frequent backups, tagged checkpoints, warm site).
- Verification: (1) clean restore point + verification; (2) measured RTO/RPO; (3) go-live checklist.
