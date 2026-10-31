# Rubric — Episode 31 (100 pts)

| Area | What "good" looks like | Pts |
|------|------------------------|-----|
| Full coverage | Every alert in the queue has a verdict (benign / FP / escalate) | 15 |
| Precision | Real threats escalated; low false-positive rate — noise not escalated | 25 |
| Recall | All the true positives in the queue were caught (none missed) | 20 |
| Justification | Each escalation has a one-line "why real" + an ATT&CK technique | 15 |
| Correlation | Related alerts linked into a single story where they belong | 10 |
| Tuning | 2–3 concrete, safe rule-tuning suggestions | 10 |
| Speed under control | Queue cleared in the time-box, with start/stop recorded | 5 |

**Evidence required in `evidence/`:** the triaged queue, the escalation tickets, your
start/stop timing, and the tuning suggestions. Escalating everything ("to be safe") caps
Precision at 0 — in a real SOC that's how an analyst loses trust.
