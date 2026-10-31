# Episode 20 — Author SIEM Detections

**Season 2 · Under attack · difficulty: intermediate**
**Security+ SY0-701:** 4.0 Security Operations (monitoring, alerting, detection)

You investigated the breach in Episode 13 *after* it happened. Now build the detections
that would have caught Sable Finch in real time — scanning, brute force, the successful
login, the malware, the defacement — and save them as Splunk alerts.

**Builds on Episode 13.** Same Splunk + BOTSv1 environment. Artifact: a documented
detection pack (SPL + logic + tuning + ATT&CK) — the kind of work a SOC specifically hires for.

## Files
- `lab.md` — the full lab (start here)
- `environment/README.md` — reuse the Ep13 Splunk/BOTS setup + how to save alerts
- `deliverable-template.md` · `example-deliverable.md` · `rubric.md` · `answer-key.md`
- `evidence/` — your SPL, screenshots of each detection firing, saved-alert configs
