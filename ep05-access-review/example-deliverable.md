# Access-Review Report — Episode 5 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## Access matrix
| Account | Owner / role | Groups | Sudo rights | Justified? | Action |
|---|---|---|---|---|---|
| amara | SOC Lead | sudo | full | yes | keep |
| tunde | Sysadmin | sudo | full | yes (+MFA) | keep, enforce MFA |
| chidi | CFO | users | none | yes | keep |
| webadmin | ex-contractor | sudo | full | **no** (left company) | disable |
| svc-deploy | service acct | sudo | full | **no** (needs 2 commands only) | scope to those commands |

## Strays
| Account | Issue | Evidence | Decision |
|---|---|---|---|
| webadmin | orphaned/stale | no login 60d, owner gone | disable, then delete after 30d hold |

## Changes applied (before/after)
- `gpasswd -d svc-deploy sudo`; added a narrow sudoers rule for its two commands.
- Disabled `webadmin` (`usermod -L`, shell → nologin).

## Reflection (own words)
Service accounts were the worst offenders — "full sudo" because it was easy. Scoping
`svc-deploy` to two commands is textbook least privilege and cuts blast radius if it's abused.
