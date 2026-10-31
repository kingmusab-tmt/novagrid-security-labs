# Containment & Eradication Runbook — Episode 21 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Incident:** Sable Finch (wallet host)

## 1. Containment
| Step | Action | Evidence | Business impact |
|---|---|---|---|
| Isolate | removed host from prod network (ACL), kept powered | `ufw status`/ACL | wallet to maintenance page |
| Preserve | snapshot + RAM/triage capture | hashes recorded | none |

## 2. Evidence preserved
Memory + disk triage captured and hashed before any change (hand-off to Ep23 forensics).

## 3. Eradication
| Foothold | How found | Removal | Verified |
|---|---|---|---|
| Malicious exe | from Ep13/Ep14 | deleted, hash blocklisted | not on disk |
| Process | `ps`/`ss` beacon | killed | gone; no new C2 |
| Persistence | cron/Run key/service review | removed entry | re-check clean |
| Cracked admin | Ep13 brute force | disabled + password reset + sessions revoked | login denied |

## 4. Rebuild vs clean
**Rebuild from a known-good image** for the wallet host — on a payments system you can't be
certain you found every artifact; rebuild + restore clean data (Ep22) is the safer choice.

## 5. Reflection (own words)
I isolated but kept the host powered so forensics could get RAM. The hard part isn't the
obvious file — it's proving persistence is gone; that's why I chose rebuild over clean.
