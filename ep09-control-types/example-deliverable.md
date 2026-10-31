# Security Control Inventory — Episode 9 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## Control matrix
| Control | Where | Category | Type(s) |
|---|---|---|---|
| Host firewall (ufw) | wallet host | Technical | Preventive |
| MFA | admin/remote | Technical | Preventive |
| Central logging | all hosts | Technical | Detective |
| auditd file watches | wallet host | Technical | Detective |
| Server hardening/baseline | wallet host | Technical/Operational | Preventive |
| Backups + restore test | wallet data | Technical | Corrective |
| Access review | all accounts | Operational | Detective/Corrective |
| Password policy | org-wide | Managerial | Preventive/Directive |
| AUP (Ep10) | all staff | Managerial | Directive/Deterrent |
| "No unauthorised access" sign on server room | DC | Physical | Deterrent |
| Read-only portal for a legacy app that can't do MFA | legacy | Technical | Compensating |

## Gaps
| Gap | Why it matters | Proposed control |
|---|---|---|
| No real-time alerting (only logs) | detection is after-the-fact | SIEM alerts (Ep20) — detective/preventive |
| No DLP on cardholder data | PII could leave undetected | DLP rule — preventive/detective |

## Reflection (own words)
The exercise exposed that we're strong on *preventive* and *detective* but thin on *corrective
automation* and real-time *alerting* — which is exactly what Season 2/3 adds.
