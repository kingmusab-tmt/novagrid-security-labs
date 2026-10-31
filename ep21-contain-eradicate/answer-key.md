# Instructor Answer Key — Episode 21
- Isolate but keep powered → RAM holds volatile evidence (ties to order of volatility, Ep23). Power-off destroys it.
- Preserve before eradicating (snapshot/triage + hashes) or you taint the forensics.
- Eradication must cover ALL footholds: malicious file, running process, persistence (cron/service/Run key), and the compromised account (disable + reset + revoke sessions). IOC-sweep other hosts.
- Rebuild from known-good beats clean-in-place for a high-value host (can't prove you found everything).
- Verification: (1) isolate-not-poweroff reason; (2) persistence checked/removed; (3) rebuild vs clean choice.
