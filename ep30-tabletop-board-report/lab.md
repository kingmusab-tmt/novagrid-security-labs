# Episode 30 — Tabletop Exercise & Board Report

## Cold open

*Story so far — The Sable Finch incident is closed. Now prove to the board that the organisation actually learned from it.*

> **From:** Zainab Idris (Compliance) & Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** Board wants assurance — run the tabletop, write it up
>
> The Sable Finch incident is closed, but the board is asking hard questions: were we
> ready, did we notify the right people in time, and what happens if it recurs? Help us
> run a tabletop over the incident, capture every point where we hesitated or lacked a
> decision-owner, and give me two things: an after-action report for the team and a
> **one-page brief for the board** — in their language, not ours. — Zainab

## Your role & mission objectives
- **Role:** exercise facilitator + report author (the analyst who can also communicate upward).
- **Objectives:**
  1. **Run the tabletop** using the injects in `environment/injects.md`, capturing the decision at each stage.
  2. **Identify the gaps** — missing decision-owners, slow notifications, unclear thresholds.
  3. Write an **after-action report** (AAR) with prioritised, owned remediation actions.
  4. Write a **one-page board brief** that frames risk and action for non-technical executives.

## Scope & rules of engagement
- **In scope:** facilitating the discussion and writing the two documents.
- **Out of scope:** no systems, no live data — this is a discussion-based exercise.
- **Framing:** a tabletop is blameless. The goal is to find gaps in the *plan*, not fault people.

## Environment setup
None technical. You can run this **solo** (play all roles and reason through each inject)
or **with a group** (assign the roles below). See `environment/README.md`. The scenario
and injects are in `environment/injects.md`.

Roles: SOC Lead (Amara), Sysadmin (Tunde), CFO (Chidi), Compliance (Zainab), and the
Facilitator (you).

## Guided exercise
Work through the injects. At each one, record the **decision made**, **who owns it**, and
any **gap** exposed. Don't narrate the attack — drive the *decisions*.

1. **Prepare.** Set the exercise objectives, participants, scope and the ground rules
   (blameless, time-boxed, "we test the plan").
   - **Decision:** What are the 3 objectives for this tabletop, and what's explicitly out of scope?

2. **Run the injects** (from `injects.md`): detection → triage/escalation → containment →
   internal comms → legal/regulatory & customer notification → recovery → public/PR.
   - At **each inject**, capture: the decision, the owner, the time target, and the gap (if any).
   - **Key decisions to force:** Who declares an "incident"? Who can authorise taking the
     wallet service offline? Who approves notifying regulators and customers, and on what
     clock? Who speaks to the press?

3. **Harvest the gaps.** Turn the hesitations into a concrete gap list.
   - **Decision:** Which gap is the single biggest risk, and why?

4. **Write the After-Action Report.** What went well, what didn't, and prioritised,
   *owned*, dated remediation actions.

5. **Write the Board Brief.** One page: what happened (plainly), the business impact and
   residual risk, what's being done, and the one decision/assurance you need from the board.
   - **Decision:** What is the single ask of the board (budget, policy sign-off, risk acceptance)?

### Evidence checkpoints
Save to `evidence/`:
- [ ] The **inject decision log** (decision · owner · time target · gap, per inject)
- [ ] The **gap list**, ranked by risk
- [ ] The finished **after-action report**
- [ ] The finished **one-page board brief**

## Deliverable
Fill `deliverable-template.md` → the **After-Action Report** and the **Board Brief**. See
`example-deliverable.md` for the standard. These two documents are the portfolio artifact:
they prove you can run an exercise and communicate to leadership.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** n/a directly — this exercises the response *program* over the campaign (ties back to Eps 11–24).
- **NIST CSF:** RECOVER (RC.IM — improvements) · GOVERN/IDENTIFY (roles, risk) · IR testing per NIST SP 800-61.
- **Security+ SY0-701:** 4.1 (incident response — training & testing, tabletop exercises), 5.1 (governance, roles & responsibilities), 5.2/5.4 (risk & compliance communication).

## Stretch goals
1. **Remediation roadmap.** Turn the gap list into a dated roadmap with owners (feeds a RACI).
2. **3-slide exec deck.** Convert the board brief into three slides for a 5-minute readout.
3. **Metrics.** Define 3 IR metrics the board should see quarterly (e.g. mean time to detect/contain).

## Verification questions (instructor sign-off)
1. In your exercise, who owns the decision to take the wallet service offline, and what's the trigger?
2. What is the customer/regulator notification clock you set, and who authorises it?
3. What single, specific ask does your board brief make — and is it a decision the board can actually give?
