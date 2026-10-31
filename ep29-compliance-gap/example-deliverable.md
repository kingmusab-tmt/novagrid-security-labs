# Compliance & Privacy Gap Analysis — Episode 29 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Applicability
| Data type | Regulation | Why |
|---|---|---|
| Cardholder data (PAN) | PCI DSS | NovaGrid processes card payments |
| Customer PII | NDPR | Nigerian personal data |
| EU customer PII | GDPR | EU residents' data, regardless of location |

## 2. Gap analysis (excerpt)
| Requirement | Status | Evidence | Gap | Remediation | Owner | Priority |
|---|---|---|---|---|---|---|
| Protect/limit stored cardholder data (PCI) | Partial | Ep6 found a stray plaintext PAN file | PANs stored unprotected | tokenise/remove; encrypt | Compliance | **High** |
| Encrypt data in transit (PCI) | Partial | Ep17 weak TLS | TLS 1.0/1.1, weak ciphers | enforce TLS 1.2+ | Sysadmin | High |
| Logging & monitoring (PCI 10) | Y | Ep4/Ep20 logging + SIEM | — | maintain | SOC | — |
| Breach notification (NDPR/GDPR) | Partial | Ep30 tabletop found no clock | no defined timeline/owner | notification playbook (72h) | Compliance | High |
| Right to be forgotten / retention (NDPR/GDPR) | Partial | Ep6 inventory; no deletion workflow | can't action erasure reliably | data inventory + retention + deletion process | Compliance | Medium |

## 3. Leadership brief (one page)
- Posture: strong on detection/logging (Seasons 1–2 work), weak on stored-data protection and privacy processes.
- Top gaps: unprotected cardholder data, weak TLS, no breach-notification clock, no erasure workflow.
- Plan: fix TLS now; tokenise/remove PANs; stand up the notification playbook; build the retention/erasure process.
- The ask: board approval + budget for tokenisation and a formal compliance programme.

## 4. Reflection (own words)
The gap analysis ties the whole series together — Ep6's stray PAN file and Ep17's weak TLS
aren't just technical findings, they're PCI gaps with real penalties. Compliance made the
technical work legible to the board.
