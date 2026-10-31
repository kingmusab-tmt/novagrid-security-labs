# Episode 28 — Third-Party Vendor Assessment

## Cold open
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

## Scope & rules of engagement
- **In scope:** an assessment deliverable using a (fictional) vendor profile.

## Environment setup
No tools required. Use the vendor profile in `environment/vendor-profile.md`. See `environment/README.md`.

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
