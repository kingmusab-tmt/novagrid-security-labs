# Environment — Episode 31 (alert queue)

No containers needed. Your shift's alerts are already here:

- `data/alert-queue.csv` — open in a spreadsheet, or `grep`/`csvlook`/`python` it.
- `data/alert-queue.jsonl` — one alert per line, handy for `jq` or Splunk ingest.

Each row: `id, timestamp, severity, rule, domain, description`. **Don't trust the
`severity` column** — the SIEM over- and under-rates, which is the whole exercise.

## Generate a fresh / unique queue
Same seed = same queue; a different seed = a different shift (good for per-student copies):
```bash
python3 generator/generate_queue.py --seed "Your Name" --alerts 120 --out environment/data
```
Options: `--alerts N` (queue size), `--seed STRING` (determinism). It writes
`alert-queue.csv`, `alert-queue.jsonl`, and an instructor-only `_instructor_answers.csv`.

> `_instructor_answers.csv` and `generator/` are the answer key — they're removed from
> student copies by `tools/make-student-copy.sh`.

## Optional: triage in Splunk
If you built Splunk in Episode 13/20, ingest the CSV and triage from SPL:
```
| inputlookup alert-queue.csv | stats count by rule, severity
```
