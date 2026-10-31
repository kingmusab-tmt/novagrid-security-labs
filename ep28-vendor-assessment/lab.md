# Episode 28 — Third-Party Vendor Assessment

## Cold open

*Story so far — Part of NovaGrid's exposure came in through a third party. Time to assess the vendors themselves.*

> **From:** Zainab Idris (Compliance)
> **Subject:** New payments vendor — vet them properly
>
> We're about to hand a new payments processor access to customer funds and data. After what
> happened through a vendor last time, I want a real assessment before we sign: what evidence
> we demand, what the contract must say, and how we keep watching them. — Zainab

## Your role & mission objectives
- **Role:** analyst running third-party / supply-chain risk assessment.
- **Objectives:**
  1. Perform **due diligence** (reputation, financials, security posture, compliance).
  2. Demand the right **evidence** (SOC 2 Type II / ISO 27001, pen-test summary, a security questionnaire).
  3. Specify **contract clauses** (right-to-audit, breach notification, data handling, subcontractor/fourth-party).
  4. Define **ongoing monitoring** (not just a point-in-time check).

## Concept Explanation — third-party / vendor risk

Your security is only as strong as the vendors you hand data to — Sable Finch-style breaches often
enter through a supplier. **Third-party risk management** is due diligence before you trust a vendor,
evidence that their controls are real, contract terms that protect you, and *ongoing* monitoring so a
vendor assessed once isn't trusted forever.

## Scope & rules of engagement
- **In scope:** an assessment deliverable using a (fictional) vendor profile.

## Environment setup
No tools required. Use the vendor profile in `environment/vendor-profile.md`.

No lab build. Use `vendor-profile.md` as the vendor you're assessing. Produce the assessment
as a document. References: SOC 2 (Type I vs II), ISO/IEC 27001, SIG/CAIQ questionnaires.

## Guided investigation
1. **Due diligence.** Reputation, financial stability, breach history, where they operate (data residency).
   - **Decision:** Which findings would be deal-breakers?
2. **Evidence.** Request SOC 2 Type II / ISO 27001 cert, latest pen-test summary, and a completed security questionnaire (SIG/CAIQ).
   - **Decision:** Why is SOC 2 **Type II** stronger than Type I, and what does a questionnaire add that a cert doesn't?
3. **Contract.** Right-to-audit, breach-notification timeline, data ownership/handling/return/destruction, subcontractor (fourth-party) controls, SLAs.
   - **Decision:** What's the minimum breach-notification clause you'd accept, and why?
4. **Ongoing monitoring.** Periodic re-assessment, continuous monitoring, and an off-boarding/exit plan.
   - **Decision:** How do you avoid "assessed once, trusted forever"?

### Evidence checkpoints
- [ ] due-diligence findings  - [ ] evidence requested/reviewed  - [ ] required contract clauses  - [ ] ongoing-monitoring plan + risk rating

## Key terms & frameworks

**Core terms**
- **Third-party / supply-chain risk** — risk introduced by vendors, partners, and their subcontractors.
- **Due diligence** — pre-contract vetting: reputation, financial stability, breach history, data residency.
- **SOC 2 Type I vs Type II** — an auditor's report on a vendor's controls: Type I is *design at a point in time*; **Type II** tests *operating effectiveness over a period* — stronger.
- **ISO 27001** — certification that a vendor runs a formal information-security management system.
- **SIG / CAIQ questionnaire** — standardised security questionnaires that probe specifics a certificate doesn't cover.
- **Right-to-audit** — a contract clause letting you (or a proxy) verify the vendor's controls.
- **Fourth-party risk** — the vendor's *own* subcontractors, who also touch your data.
- **Data residency** — where the vendor stores/processes data, which drives legal obligations.

**Contract must-haves:** a defined **breach-notification timeline** (demand a short, specific clock —
e.g. 72 hours or sooner), data ownership/handling/return/destruction terms, subcontractor controls,
and SLAs.

**Ongoing monitoring:** periodic re-assessment and continuous monitoring, plus an off-boarding/exit
plan — so "assessed once" never becomes "trusted forever".

## Deliverable
Fill `deliverable-template.md` → the **vendor risk assessment**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** GOVERN — GV.SC (supply chain); ID.RA
- **Security+ SY0-701:** 5.3 third-party risk (vendor assessment/selection/monitoring, right-to-audit, SLA, agreements)

## Stretch goals
1. Map the questionnaire gaps to **required remediations before go-live**.
2. Address **fourth-party** (your vendor's vendors) risk explicitly.

## Verification questions
1. SOC 2 Type I vs Type II — what's the difference and why does it matter?
2. Name three contract clauses you require and why.
3. How do you keep assessing the vendor after onboarding?
