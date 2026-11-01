# Asset & Account Audit — Episode 1 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-11-01

> A model answer showing the standard and the real findings. Your wording will differ; the facts
> (hosts, ports, accounts) should match what you captured in the lab.

## Asset inventory
| Asset / host | IP | Role | Listening services | Criticality | Notes |
|---|---|---|---|---|---|
| wallet-api | 172.28.0.10 | Payment wallet API | 22/tcp ssh · 8080/tcp API · **8000/tcp** file server | Critical | crown jewel (customer funds + PII); 8000 is a stray debug file server |
| logging | 172.28.0.20 | Central log collector | **514/tcp** syslog | High | restrict to the lab subnet |
| legacy-billing | 172.28.0.30 | Old billing box | 22/tcp ssh · 8081/tcp admin page | High | **UNMANAGED — not in the asset register** |
| analyst | 172.28.0.5 | Analyst toolbox | none (all ports closed) | Low | my scanning host; runs no services |

## Account review (wallet-api)
| Account | Shell | Admin rights | Issue |
|---|---|---|---|
| amara | /bin/bash | sudo | legitimate (SOC Lead, on roster) |
| tunde | /bin/bash | sudo | legitimate (Sysadmin, on roster) |
| chidi | /bin/bash | — | legitimate (CFO, on roster) |
| svc-backup | /bin/bash | **`NOPASSWD: ALL`** | over-privileged — service account with full passwordless root; roster says it "needs only tar and rsync" |
| webadmin | /bin/bash | sudo | **orphaned** — on the box but NOT on the staff roster; password last changed Jan 10, 2026 (**stale**) |
| contractor | /bin/bash | sudo | **leaver** — roster marks "leaving 2026-10-31" but the account and sudo are still active |

## Findings memo (top risks)
1. **Unmanaged host.** `legacy-billing` (172.28.0.30) is live with SSH and an admin page but is absent
   from the asset register — unknown, unpatched, unmonitored. Add it to the inventory with an owner, or decommission it.
2. **Data exposure.** `wallet-api:8000` is an open directory server exposing `old_payments_backup.csv`
   to anyone on the network. Shut the service down and move the file to protected storage.
3. **Over-privileged service account.** `svc-backup` has `NOPASSWD: ALL` sudo; scope it down to only
   the backup commands it needs.
4. **Orphaned admin account.** `webadmin` is not on the staff roster and its password is months old —
   disable it per the joiner/leaver process.
5. **Leaver not offboarded.** `contractor` is past its leaving date but still has an active account and
   sudo — disable and revoke.

## Reflection (own words)
The scan itself was quick; the eye-opener was the gap between what's *running* and what's *recorded* —
a whole billing host nobody listed, and a file server quietly handing out old card data. I'd shut the
:8000 server and the unmanaged host's exposure first, then fix the accounts.
