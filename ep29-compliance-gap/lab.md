# Episode 29 — Compliance & Privacy Gap Analysis

## Cold open

*Story so far — Regulators will ask whether NovaGrid met its obligations through all of this. Find the gaps before they do.*

> **From:** Zainab Idris (Compliance)
> **Subject:** Where do we stand on PCI DSS and NDPR?
>
> We take card payments and hold customer PII, so we're on the hook for PCI DSS and NDPR
> (and GDPR for any EU customers). I need an honest gap analysis — where we comply, where we
> don't — and a prioritised plan I can take to the board. — Zainab

## Your role & mission objectives
- **Role:** analyst running a compliance & privacy gap analysis.
- **Objectives:**
  1. Identify which regulations apply and **why** (cardholder data → PCI DSS; personal data → NDPR/GDPR).
  2. Assess NovaGrid against key requirements using everything built in Seasons 1–3.
  3. Produce a **gap analysis** (requirement → status → gap → remediation → owner).
  4. Write a short **leadership brief** with the priorities.

## Concept Explanation — compliance & privacy

Compliance is proving you meet the obligations the law and standards place on you — related to
security but not the same thing (you can be compliant and still insecure, or secure and
non-compliant). A **gap analysis** maps each requirement to your actual controls, marks where you
fall short, and turns the shortfalls into an owned, prioritised remediation plan.

## Scope & rules of engagement
- **In scope:** an assessment/documentation deliverable using the NovaGrid scenario.

## Environment setup
No tools required. Draw on the controls and findings from Episodes 1–28.

No lab build. Use the NovaGrid scenario and the controls from Episodes 1–28 as your evidence
base. References: PCI DSS (high-level requirement areas), NDPR (Nigeria Data Protection
Regulation) and GDPR (for EU customers). Deliver a gap-analysis table + a one-page brief.

## Guided investigation
1. **Applicability.** Map data types to laws: cardholder data → **PCI DSS**; customer PII → **NDPR** (and **GDPR** for EU residents).
   - **Decision:** Which regulation drives which obligations here?
2. **Assess key requirements.** e.g. PCI: protect stored data / encrypt transmission / access control / logging / testing. NDPR/GDPR: lawful basis, data-subject rights (incl. right to be forgotten), breach notification, data inventory/retention.
   - **Decision:** For each, is NovaGrid compliant, partial, or non-compliant — with evidence from earlier episodes?
3. **Gap analysis.** Record status, the gap, remediation, owner, and priority.
   - **Decision:** Which gaps carry legal/financial exposure if unaddressed?
4. **Brief leadership.** One page: posture, top gaps, the plan, and the ask.
   - **Decision:** What single ask do you make of the board?

### Evidence checkpoints
- [ ] applicability mapping  - [ ] the gap-analysis table  - [ ] prioritised remediation + owners  - [ ] the leadership brief

## Key terms & frameworks

**Core terms**
- **Compliance vs security** — meeting required controls/obligations vs actually reducing risk; aim for both.
- **Gap analysis** — comparing requirements against current state to find and rank shortfalls.
- **Control evidence / attestation** — the proof (configs, logs, policies from earlier episodes) that a requirement is met.

**The regulations in play:**
- **PCI DSS** — governs cardholder data: protect stored data, encrypt transmission, restrict access, log, and test regularly.
- **NDPR** — Nigeria's data-protection regulation: lawful basis for processing, data-subject rights, breach notification, data inventory and retention.
- **GDPR** — applies to EU residents' data: similar rights (including the **right to be forgotten**), strict breach-notification timelines, and accountability.

**Data-subject rights** — individuals' rights over their personal data (access, correction, erasure,
portability); your processes must be able to honour them.

**Breach notification** — the legal obligation to notify regulators and/or affected people within a
set time; each regime sets its own clock, which is why Episode 30's tabletop forces the question of
*who authorises it and how fast*.

**The deliverable** marks each requirement **compliant / partial / non-compliant** with evidence,
then leads with the gaps that carry the most legal or financial exposure.

## Deliverable
Fill `deliverable-template.md` → the **compliance brief + gap analysis**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** GOVERN — GV.OC/GV.PO (compliance obligations, policy)
- **Security+ SY0-701:** 5.4 compliance (regulations, audits, attestation) & privacy (data roles, right to be forgotten, retention)

## Stretch goals
1. Map each gap to the **specific control** from an earlier episode that closes it.
2. Add a **RACI** for the remediation plan.

## Verification questions
1. Which regulations apply to NovaGrid and why?
2. Name two concrete gaps you found and the remediation for each.
3. What's the single highest-priority fix, and what's the exposure if it's left?
