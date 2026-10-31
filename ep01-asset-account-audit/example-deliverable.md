# Asset & Account Audit — Episode 1 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

> Illustrative — your values come from your own lab.

## Asset inventory
| Asset / host | IP | Role | Listening services | Criticality | Notes |
|---|---|---|---|---|---|
| wallet-api | 172.x.x.10 | Payment wallet API | 443/tcp, 22/tcp | Critical | internet-facing; crown jewel |
| logging | 172.x.x.20 | Log collector | 514/udp, 22/tcp | High | should not be public |
| analyst-vm | 172.x.x.5 | Analyst workstation | 22/tcp | Medium | tools host |

## Account review
| Account | Shell? | Groups / sudo | Last login | Issue |
|---|---|---|---|---|
| tunde | yes | sudo | 2 days ago | admin rights; candidate for MFA |
| svc-backup | yes | sudo | **never** | service acct with a shell + sudo — over-privileged |
| webadmin | yes | — | 60+ days | stale; disable |

## Findings memo (top risks)
1. A service account (`svc-backup`) has an interactive shell and sudo but has never logged in — remove shell/sudo.
2. The logging host exposes 514/udp; restrict to the lab subnet only.
3. A stale admin (`webadmin`) hasn't logged in for 60+ days — disable per joiner/leaver process.

## Reflection (own words)
The scan was quick; the eye-opener was how much a "service" account could do. I'd lock down
`svc-backup` first — least privilege on non-human accounts is easy to forget.
