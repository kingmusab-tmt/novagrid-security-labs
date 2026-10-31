# Vendor Risk Assessment — Episode 28 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Vendor:** PayBridge Ltd

## 1. Due diligence
| Area | Finding | Concern? |
|---|---|---|
| Reputation/breach | one minor breach 3y ago, disclosed + remediated | low (transparency is a plus) |
| Financials | profitable, 6y | low |
| Data residency | a DC outside customers' jurisdiction | **yes** — NDPR/cross-border transfer question |

## 2. Evidence
| Evidence | Provided? | Gap / follow-up |
|---|---|---|
| SOC 2 Type II | **no (Type I only)** | demand Type II — Type I is design-only, not operating effectiveness |
| ISO 27001 | yes (current) | verify scope covers the service |
| Pen-test summary | **no** | require recent summary before go-live |
| Security questionnaire | not yet | send SIG/CAIQ; review answers |

## 3. Required contract clauses
- Right-to-audit (or accept independent audit reports).
- Breach notification within **72 hours** (aligns with NDPR/GDPR expectations).
- Data ownership stays NovaGrid; defined handling, return, and secure destruction on exit.
- Subcontractors disclosed and held to equivalent controls (fourth-party risk).
- SLAs for availability + security response.

## 4. Ongoing monitoring + overall rating
Annual re-assessment + continuous monitoring (breach news, cert expiry) + an exit plan.
**Rating: CONDITIONAL go** — proceed only after SOC 2 Type II, a pen-test summary, resolved
data-residency, and subcontractor disclosure.

## 5. Reflection (own words)
The vendor looked fine on paper (ISO cert, profitable) but SOC 2 **Type I** and the
undisclosed subcontractors are exactly the gaps that caused the Season-1 vendor breach.
Conditional-go with evidence requirements is the responsible call.
