# Episode 13 — Host Compromise: Investigate in Splunk

**Season 2 · Under attack · difficulty: intermediate**
**Security+ SY0-701:** 4.0 Security Operations (incident response, SIEM, investigation)

NovaGrid's public marketing site has been defaced and a server is behaving strangely.
You have the logs in Splunk. Reconstruct what Sable Finch did — recon, brute force,
exploitation, defacement and malware — from real SIEM data, and write the incident report.

**Real data:** this lab runs on Splunk's **Boss of the SOC v1 (BOTSv1)** dataset — genuine
attack telemetry, not toy logs. You'll produce an incident report + ATT&CK mapping.

## Files
- `lab.md` — the full lab (start here)
- `deliverable-template.md` · `example-deliverable.md` · `rubric.md` · `answer-key.md`
- `evidence/` — your SPL queries and result screenshots

> NovaGrid framing wraps the real BOTSv1 scenario: treat the BOTSv1 web server
> (`imreallynotbatman.com`) as NovaGrid's marketing site for the story.
