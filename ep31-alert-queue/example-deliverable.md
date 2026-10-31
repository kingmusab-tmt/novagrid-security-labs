# NovaGrid SOC — Shift Report (Episode 31) — WORKED EXAMPLE

> A model answer to show the standard. Your queue is seeded differently, so your alert
> IDs and the exact escalations will differ — copy the **shape and rigour**, not the IDs.

**Analyst:** A. Analyst · **Shift:** 2026-10-30, 08:00–08:31 · **Alerts in queue:** 120

## 1. Queue summary
| Verdict | Count | % |
|---|---|---|
| Benign | 61 | 51% |
| False positive | 55 | 46% |
| Escalated (true positive) | 4 | 3% |

**Time to clear the queue:** 31:00 · **False-positive rate (my escalations that were noise):** 0%

## 2. Escalations

### [ALRT-1016] — Successful admin login from new geo — severity HIGH
- **What it is:** root login to legacy-billing (172.28.0.30) from 203.0.113.66.
- **Why it's real:** that host is the forgotten box from Episode 1, it has no business
  being reached from outside 172.28.0.0/24, and 203.0.113.66 has never appeared before.
  No change ticket.
- **ATT&CK technique:** T1078 Valid Accounts.
- **Next step:** disable the session, pull auth.log on legacy-billing, check what the session did.

### [ALRT-1022] — Brute force then success — severity CRITICAL
- **What it is:** 32 failed admin logins to the finance portal in 90s from 203.0.113.66, then one success.
- **Why it's real:** failed-then-success from the *same IP as 1016* = guessing that worked.
- **ATT&CK technique:** T1110 Brute Force → T1078.
- **Next step:** escalate to Tier-2 now; this is an active compromise, not an event.

### [ALRT-1038] — Rogue account with sudo — severity CRITICAL
- **What it is:** new account `support-svc` added to sudo, no change ticket.
- **Why it's real:** privileged account with no paperwork = persistence foothold.
- **ATT&CK technique:** T1098 Account Manipulation / T1136 Create Account.
- **Next step:** disable the account, preserve its home dir, find who created it and when.

### [ALRT-1062] — Data staged in web root — severity HIGH
- **What it is:** customers.csv copied into the public /srv/admin web dir on legacy-billing.
- **Why it's real:** PII placed where it can be pulled over HTTP = exfil prep.
- **ATT&CK technique:** T1074 Data Staged / T1041 Exfil over C2 channel.
- **Next step:** remove public access, hash the file, check web access logs for pulls.

## 3. Correlation
All four tie to **legacy-billing** and three share the IP **203.0.113.66**. Read: this is
**one connected intrusion** — brute force (1022) → valid-account access (1016) →
persistence (1038) → data staging (1062), all on the box nobody owns. This is the opening
of a Sable Finch-style campaign, not four coincidences.

## 4. Rule tuning
| Rule | Why it's noisy | Proposed change |
|---|---|---|
| Port scan detected | fires every scan window from the analyst box | suppress when src = analyst (172.28.0.5) during the 02:00–03:00 window |
| Antivirus signature match | monthly EICAR self-test trips it | allow-list the EICAR hash from the self-test path |
| New admin account created | fires on every approved onboarding | correlate against the change calendar; only alert when no ticket matches |

## 5. Self-assessment
Score: ~92/100. Caught all four true positives with no false escalations and correlated
them into one story. Next time I'd log my per-alert timing to prove I stayed under 20s each.
