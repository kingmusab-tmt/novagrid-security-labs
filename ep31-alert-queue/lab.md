# Episode 31 — Shift at the Console: Triage the Alert Queue

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Tier-1 Analyst)
> **Subject:** Your shift — the queue is backing up
>
> Welcome to the console. Overnight the SIEM piled up ~120 alerts and the day team
> hasn't touched them. Most of it is noise — backups, the scan window, people fat-
> fingering the new password. But somewhere in there is the real thing, and if you
> escalate everything you'll burn out by 10am and the analysts above you will stop
> trusting your tickets. Work the queue: decide benign / false-positive / escalate for
> each, and hand me a short shift report with the handful that actually matter. You've
> got the shift — don't drown. — Amara

## Your role & mission objectives
- **Role:** Tier-1 SOC analyst working a live alert queue under time pressure.
- **Objectives:**
  1. **Triage every alert** in `environment/data/alert-queue.csv` into **benign**, **false positive**, or **escalate (true positive)**.
  2. **Justify each escalation** in one line — what makes it real, and what you'd do next.
  3. Keep your **false-positive rate low**: don't escalate noise. Precision is the skill here.
  4. Produce a **shift report**: the queue summary, the escalations, and 2–3 tuning suggestions so the noisiest rules stop crying wolf.

## Concept Explanation — SOC triage & alert fatigue

A real SOC console is mostly noise with a few alerts that matter, and the Tier-1 skill is clearing
it fast *without* escalating everything. The metric that counts is **precision** — escalate the real
threats and leave the noise — because an analyst who floods Tier-2 with false positives loses their
trust. You bucket each alert, justify every escalation, and **correlate** related ones into a single
story.

## Scope & rules of engagement
- **In scope:** reading and triaging the provided alert data; writing the report.
- **Out of scope:** no live systems — this is console work on exported alerts. (Optional: pull the same alerts into Splunk from Ep13/Ep20 to practise in a real SIEM.)
- **Clock:** time-box it. Target **30 minutes** for a first full pass of 120 alerts — that's ~15 seconds an alert, which is realistic. Note your start/stop time; speed under control is part of the grade.

## Environment setup
No containers required. The queue is pre-generated in `environment/data/`:
- `alert-queue.csv` / `alert-queue.jsonl` — your shift's alerts (id, time, severity, rule, domain, description).

To generate a **fresh, unique queue** (e.g. per student, so no two match), see the setup below:
```bash
python3 generator/generate_queue.py --seed "Your Name" --out environment/data
```

No containers needed. Your shift's alerts are already here:

- `data/alert-queue.csv` — open in a spreadsheet, or `grep`/`csvlook`/`python` it.
- `data/alert-queue.jsonl` — one alert per line, handy for `jq` or Splunk ingest.

Each row: `id, timestamp, severity, rule, domain, description`. **Don't trust the
`severity` column** — the SIEM over- and under-rates, which is the whole exercise.

### Generate a fresh / unique queue
Same seed = same queue; a different seed = a different shift (good for per-student copies):
```bash
python3 generator/generate_queue.py --seed "Your Name" --alerts 120 --out environment/data
```
Options: `--alerts N` (queue size), `--seed STRING` (determinism). It writes
`alert-queue.csv`, `alert-queue.jsonl`, and an instructor-only `_instructor_answers.csv`.

> `_instructor_answers.csv` and `generator/` are the answer key — they're removed from
> student copies by `tools/make-student-copy.sh`.

### Optional: triage in Splunk
If you built Splunk in Episode 13/20, ingest the CSV and triage from SPL:
```
| inputlookup alert-queue.csv | stats count by rule, severity
```

## Guided investigation
Work the queue top to bottom — but don't trust the severity column; the SIEM over- and under-rates things, which is the point.

1. **Set your buckets.** Decide your triage columns up front: `id | verdict | why | next step`. Open the CSV in a spreadsheet or grep it.
   - **Decision:** Before you start — which rule names are you going to treat as *auto-noise* on sight, and which as *always look*? Write that down; it's your playbook.

2. **Sort the noise fast.** Most alerts describe something with a benign cause already in the text (a scan window, a change ticket, a self-test, an approved backup). Mark those **benign/FP** and move on — don't over-investigate noise.
   - Evidence checkpoint: save your triaged sheet to `evidence/` as you go.

3. **Catch the ones that bite.** Look for the alert whose description has **no innocent explanation**: a successful admin login from an IP you've never seen, a privileged account with no change ticket, sensitive data copied somewhere public, a server beaconing to an unknown host.
   - **Decision:** For each candidate escalation — is this an *event* (log it) or an *incident* (escalate now)? Say why in one line.

4. **Correlate.** Do any escalations share an IP, a host, or a user? Two alerts from the same source that are each "medium" can be one "critical" story. Note the links.
   - **Decision:** Do your escalations look like one connected intrusion or several unrelated issues? What's your read?

5. **Tune.** Pick the 2–3 rules that generated the most false positives and suggest a concrete tuning (e.g. "suppress port-scan alerts sourced from the analyst box during the 02:00–03:00 scan window").

### Evidence checkpoints
Save to `evidence/`:
- [ ] Your **triaged queue** (every alert with a verdict + one-line reason)
- [ ] Your **escalation tickets** (the true positives, each with "why real" + "next step")
- [ ] Your **start/stop time** and alert count (how fast did you clear the queue?)
- [ ] Your **tuning suggestions**

## Commands explained

The queue is a CSV/JSONL; triage it in a spreadsheet, with `grep`/`awk`, or in Splunk.

| Command / action | What it does | Why you use it here |
|---|---|---|
| open `environment/data/alert-queue.csv` in a spreadsheet | view all alerts in a sortable grid | work the queue top to bottom |
| `column -s, -t < alert-queue.csv \| less -S` | pretty-prints the CSV in the terminal | read it without a spreadsheet |
| `grep -i "<rule>" alert-queue.csv` | filters to one alert type | batch-handle a noisy rule |
| sort/count by rule (spreadsheet or `cut`+`sort`+`uniq -c`) | ranks the noisiest rules | pick tuning candidates |
| (optional) Splunk `\| inputlookup alert-queue.csv \| stats count by rule, severity` | triages in a SIEM | practise on a real console |

*Don't trust the `severity` column* — the SIEM over- and under-rates; that's the exercise.

## On Windows

Triage the same queue in PowerShell instead of a spreadsheet/`grep`:
```powershell
Import-Csv .\alert-queue.csv | Group-Object rule | Sort-Object Count -Descending   # noisiest rules
Import-Csv .\alert-queue.csv | Where-Object {$_.description -match '203.0.113'}      # pivot on an IP
Import-Csv .\alert-queue.csv | Where-Object {$_.severity -eq 'critical'}            # (but don't trust severity!)
```
The skill — precision over escalating everything, correlating related alerts — is identical.

## Deliverable
Fill `deliverable-template.md` → a **shift report**: queue stats (counts by verdict),
your escalations with justification, the correlation read, and your tuning suggestions.
See `example-deliverable.md` for the standard. This proves you can run a console without
drowning — the single most-tested Tier-1 skill.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** the true positives map to Initial Access / Valid Accounts (T1078), Brute Force (T1110), Account Manipulation (T1098), and Exfiltration-over-web / C2 patterns (T1041, T1071) — name the technique on each escalation.
- **MITRE ATT&CK (defensive):** this whole episode is detection & triage — the mitigations are M1047 (Audit) and alert tuning; name them in your report.
- **NIST CSF:** DETECT (DE.AE — events analysed, DE.CM — continuous monitoring); RESPOND (RS.AN — analysis).
- **Security+ SY0-701:** 4.3 (alerting & monitoring, SIEM), 4.1 (incident response — detection & analysis), 2.4 (indicators of malicious activity).

## Stretch goals (more real tooling)
1. **Do it in Splunk.** Ingest `alert-queue.csv` into the Splunk you built in Ep13/Ep20 and triage from SPL instead of a spreadsheet. Build a dashboard: alerts by verdict, by rule, by hour.
2. **Measure yourself.** Compute your precision (true escalations ÷ total escalations) and recall (true positives found ÷ true positives present) against your own second pass.
3. **Write one detection.** Turn your best escalation into a reusable detection rule (SPL or sigma) — this feeds Episode 20.
4. **Chain it.** The escalations here are the *opening moves* of the capstone (Episode 32). Keep your tickets — you'll reuse them.

## Verification questions (instructor sign-off)
1. How many alerts did you escalate, and what was your false-positive rate?
2. Which alerts did you correlate into a single story, and what tied them together?
3. Give one rule you'd tune and the exact condition you'd change — without losing a real detection.
