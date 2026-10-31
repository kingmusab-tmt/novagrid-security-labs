# Episode 30 Deliverable — worked example

**Facilitator/Author:** A. Analyst  **Exercise date:** 2026-10-31  **Scenario:** "Sable Finch Returns"

> Model answer showing the standard and tone. Your decisions/gaps come from your own run.

---
# Part A — After-Action Report (AAR)

## 1. Exercise overview
- **Objectives:** (1) test the end-to-end IR plan under a recurrence; (2) confirm
  decision-owners for service-down and notification; (3) measure notification timeliness.
- **Participants:** SOC Lead, Sysadmin, CFO, Compliance, Facilitator.
- **Scope:** decision-making over the incident lifecycle. Out of scope: hands-on forensics.

## 2. Inject decision log (excerpt)
| Inject | Decision made | Owner | Time target | Gap exposed |
|--------|---------------|-------|-------------|-------------|
| 1 Detection | Treat SIEM brute-force hit as an incident candidate; triage immediately | SOC analyst | 15 min | None |
| 2 Escalation | SOC Lead declares the incident, opens bridge | SOC Lead | 20 min | No written declaration criteria |
| 3 Containment | Take wallet offline if customer funds at risk | **CFO + SOC Lead jointly** | 30 min | Authority was unclear at first — no documented owner |
| 5 Legal/customer | Compliance assesses NDPR/PCI duty; notify if PII confirmed | Compliance Officer | 72 h / per scheme | No pre-agreed notification clock or template |
| 7 PR | Only the CEO or delegate speaks to press; hold statement ready | CEO's office | — | No holding statement existed |

## 3. What went well
- The Ep20 detection fired early; triage was fast and the IR process (Eps 13/21) was followed.

## 4. Gaps & findings (ranked by risk)
| # | Gap | Risk if unaddressed | Severity |
|---|-----|---------------------|----------|
| 1 | No documented owner/threshold for taking the wallet offline | Delay or wrong call during a live incident; customer-fund exposure | High |
| 2 | No pre-agreed regulator/customer notification clock + templates | Missed legal deadline; fines; reputational damage | High |
| 3 | No approved media holding statement | Rumour/mis-statement to press | Medium |

## 5. Remediation actions
| Action | Owner | Due | Priority |
|--------|-------|-----|----------|
| Document service-down decision authority + trigger in the IR plan | SOC Lead | 2 weeks | High |
| Create NDPR/PCI notification playbook with clocks + templates | Compliance | 3 weeks | High |
| Draft + approve a media holding statement | Comms/CEO office | 2 weeks | Medium |

---
# Part B — Board Brief (one page)

**To:** Board of Directors  **From:** A. Analyst  **Date:** 2026-10-31  **Classification:** Confidential

## What happened
We ran a planned exercise simulating a repeat attack on our customer wallet. The team
detected and contained the simulated attack successfully, but the exercise revealed gaps
in *who decides what, and how fast*, during a real crisis.

## Business impact & residual risk
In a real recurrence today, we could contain the technical threat, but we risk a **delayed
decision to protect customer funds** and a **missed regulatory notification deadline** —
both carry financial, legal and reputational cost. Residual risk is currently assessed as
**High** until the decision-ownership and notification gaps are closed.

## What we have done
- Confirmed detection and the incident-response process work end to end.
- Identified and ranked three concrete gaps.
- Assigned owners and dates to fix all three within three weeks.

## What we are doing next
1. Document who can take the wallet offline, and when (SOC Lead, 2 weeks).
2. Build a regulator/customer notification playbook with legal deadlines (Compliance, 3 weeks).
3. Approve a media holding statement (Comms, 2 weeks).

## The ask
We request the board's **approval to adopt the updated incident-response policy** (with the
service-down and notification authorities) at the next sitting, and **sign-off on the
notification playbook** so the obligations are pre-agreed before the next incident.
