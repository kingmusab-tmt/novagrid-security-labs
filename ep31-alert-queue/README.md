# Episode 31 — Shift at the Console: Triage the Alert Queue

**Season 3 · Resilience & command · difficulty: intermediate**
**Security+ SY0-701:** 4.0 Security Operations (alerting & monitoring, incident response)

A realistic Tier-1 SOC shift: ~120 alerts, mostly noise, a few that matter. You triage the
queue **under a clock**, escalate only what's real, and write a shift report — the core
day-one skill of a SOC analyst. The alerts you escalate here are the opening of the
Season 3 capstone (Episode 32).

**Tools:** a spreadsheet or `grep`/`python` (required); Splunk (optional stretch).
Artifact: alert-triage shift report.

## Files
- `lab.md` — the full lab (start here)
- `environment/data/alert-queue.csv` · `.jsonl` — your shift's alerts
- `generator/generate_queue.py` — makes a fresh, seeded queue (instructor tool)
- `deliverable-template.md` · `example-deliverable.md` · `rubric.md` · `answer-key.md`
- `evidence/` — your triaged queue, escalations, timings
