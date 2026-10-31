# Data Classification & Inventory — Episode 6 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## Classification scheme
| Class | Examples | Handling rules |
|---|---|---|
| Public | marketing site, press | no restriction |
| Internal | runbooks, inventories | staff only |
| Confidential | salaries, contracts | need-to-know; encrypt at rest |
| Restricted (regulated) | cardholder data (PCI), customer PII (NDPR) | strict access + encryption; minimise/avoid storing PANs |

## Data inventory
| Data type | Where it lives | Class | Regulated by | Controls today | Owner |
|---|---|---|---|---|---|
| Customer PII | wallet DB, support exports | Restricted | NDPR | partial (no field encryption) | CFO/Compliance |
| Cardholder PAN (test) | a stray CSV in /data | Restricted | PCI DSS | none — shouldn't be here | Compliance |
| Employee salary | finance share | Confidential | — | access-limited | CFO |

## Findings & recommendations
- A CSV with card-like numbers sits unprotected in `/data` — PCI DSS discourages storing
  PANs; remove/tokenise it. Encrypt customer PII at rest and restrict access.

## Reflection (own words)
The theory is easy; *finding* a stray file of card numbers with one grep made it real —
you can't protect data you didn't know you had.
