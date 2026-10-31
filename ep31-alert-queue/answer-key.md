# Answer key — Episode 31 (instructor only)

> Do **not** include in student copies. Each student's queue is seeded differently, so the
> alert IDs below are for the default `--seed novagrid` queue. The *pattern* is identical in
> every seed: ~6 true positives hidden in ~95% noise, all tied to legacy-billing / one IP.

## How to get the ground truth
Every generated queue writes `environment/data/_instructor_answers.csv` with a `verdict`
and `why_it_matters` column for each alert. Grade against that:
```bash
# the student's escalations vs the real true-positives
grep true-positive environment/data/_instructor_answers.csv
```

## The true positives (default seed) and why they're real
| Alert rule | Verdict | Why it's a true positive |
|---|---|---|
| Successful admin login from new geo | escalate | root on legacy-billing from an external IP, no ticket (T1078) |
| Brute force then success | escalate | failed→success from the same IP = guessing worked (T1110→T1078) |
| Rogue account with sudo | escalate | privileged account, no change ticket = persistence (T1098/T1136) |
| Data staged in web root | escalate | PII in a public web dir = exfil prep (T1074/T1041) |
| Outbound to unknown host from server | escalate | beaconing to a non-allow-listed host (T1071/T1041) |

## The traps (students commonly over-escalate these — they are NOT incidents)
- **New admin account created** → matches onboarding ticket CHG-2041 (false positive).
- **Port scan detected** → the scheduled scan window from the analyst box (false positive).
- **Antivirus signature match / EICAR** → the monthly AV self-test (false positive).
- **Multiple failed logins then success** → user fat-fingered the new password, confirmed (false positive).
- **Large outbound transfer** → the approved weekly offsite backup replication (false positive).

## Grading guidance
- **Precision** is the headline metric: a student who escalates 30 alerts "to be safe"
  has failed the core skill even if they caught all the real ones. Weight precision ≥ recall.
- A strong student **correlates** the escalations into one legacy-billing intrusion and
  names it as the opening of the Sable Finch campaign (sets up Episode 32).
- Good tuning suggestions suppress the noisy rule **without** killing a real detection —
  reject any tuning that would have suppressed a true positive.

## Ground truth in the reference lab (lab-env)
The true positives mirror real weaknesses planted in `lab-env`: legacy-billing
(172.28.0.30) is the unmanaged host from Episode 1, and the over-privileged / rogue
accounts echo the `svc-backup` NOPASSWD sudo and the leaver's SSH key. Students who did
Season 1 should recognise the terrain.
