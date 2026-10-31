# Episode 27 — Risk Assessment & Register

## Cold open

*Story so far — The technical fight (Eps 21–26) is over. Now leadership needs the risks written down, ranked, and owned.*

> **From:** Zainab Idris (Compliance)
> **Subject:** How exposed are we, really?
>
> The board wants a risk assessment, not vibes. Build a risk register for NovaGrid — the real
> risks we've seen this year — size them, and tell me for each whether we accept, mitigate,
> transfer, or avoid it, with the money where you can. — Zainab

## Your role & mission objectives
- **Role:** analyst performing a risk assessment.
- **Objectives:**
  1. Identify risks (asset × threat × vulnerability) from the NovaGrid story.
  2. Assess **qualitatively** (likelihood × impact) and, where data allows, **quantitatively** (SLE, ARO, ALE).
  3. Distinguish **inherent vs residual** risk (after existing controls).
  4. Choose a **treatment** per risk (mitigate / transfer / avoid / accept) with rationale.

## Concept Explanation — risk assessment & management

Risk management is how security decisions get *justified*: you identify what could go wrong, rate
how likely and how damaging it is, and decide what to do about it. Ratings can be **qualitative**
(likelihood × impact on a scale) or **quantitative** (money, via SLE/ALE), and the output is a **risk
register** with an *owner* and a chosen *treatment* for each risk.

## Scope & rules of engagement
- **In scope:** a documentation/analysis deliverable using the NovaGrid scenario.

## Environment setup
No tools required. Draw on Episodes 1–26 for assets, threats, and controls.

No lab build. Use the NovaGrid scenario (Episodes 1–26) for assets (wallet, PII, brand),
threats (Sable Finch, ransomware, insider, vendor), vulnerabilities (flat network, weak TLS,
etc.) and existing controls. A spreadsheet or Markdown table is enough. NIST SP 800-30 is a
good reference for method.

## Guided investigation
1. **Identify.** List top risks (e.g. wallet breach via phishing, ransomware, insider, vendor compromise, non-compliance).
   - **Decision:** For each, what's the asset, the threat, and the vulnerability?
2. **Assess qualitatively.** Rate likelihood × impact (e.g. 1–5 each) → a risk score; plot high/medium/low.
   - **Decision:** Which risks are in the red zone?
3. **Assess quantitatively (where possible).** `SLE = Asset Value × Exposure Factor`; `ALE = SLE × ARO`.
   - **Decision:** For one risk, compute ALE and use it to justify spend (control cost < ALE reduction?).
4. **Treat.** Pick mitigate/transfer(insurance)/avoid/accept; note inherent vs residual after controls.
   - **Decision:** Which risks do you accept, and who signs off on accepting a risk?

### Evidence checkpoints
- [ ] the risk register  - [ ] one worked quantitative (SLE/ARO/ALE) example  - [ ] inherent vs residual noted  - [ ] treatment + owner per risk

## Key terms & frameworks

**Core terms**
- **Asset / threat / vulnerability** — what you're protecting / what could harm it / the weakness that lets the threat succeed.
- **Likelihood × Impact** — the qualitative method: rate each (e.g. 1–5) and multiply for a risk score to plot high/medium/low.
- **Qualitative vs quantitative** — descriptive ratings vs monetary estimates; most assessments blend both.
- **Risk appetite / tolerance** — how much risk the organisation is willing to accept.
- **Inherent vs residual risk** — risk before controls vs what remains after them.
- **Risk register & risk owner** — the living record of risks, and the named person accountable for each.

**Quantitative formulas (SY0-701 favourites):**
- **SLE = Asset Value × Exposure Factor** — the loss from a *single* occurrence.
- **ALE = SLE × ARO** — the expected *annual* loss (ARO = annualised rate of occurrence).
- **Use it to justify spend:** a control is worth it when its cost is less than the reduction in ALE it buys.

**Treatment options:** **mitigate** (add controls), **transfer** (insurance / outsource),
**avoid** (stop the activity), or **accept** (document and sign off). Accepting a risk requires a
named approver — risk acceptance is a management decision, not a technical one.

## Deliverable
Fill `deliverable-template.md` → the **risk register + treatment plan**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** GOVERN / IDENTIFY — ID.RA, ID.RM (risk assessment & management); NIST SP 800-30
- **Security+ SY0-701:** 5.2 risk management (qualitative/quantitative, SLE/ALE/ARO, appetite, treatment, register)

## Stretch goals
1. Add a **risk appetite** statement and show which risks exceed it.
2. Build a simple **risk heat-map** (likelihood × impact grid).

## Verification questions
1. Compute SLE, ARO, and ALE for one risk and show your working.
2. What's the difference between inherent and residual risk?
3. Name the four risk-treatment options and give an example of each for NovaGrid.
