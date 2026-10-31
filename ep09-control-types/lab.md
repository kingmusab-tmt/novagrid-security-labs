# Episode 9 — Map the Security Control Types

## Cold open
> **From:** Zainab Idris (Compliance)
> **Subject:** Auditor wants our controls categorised
>
> The auditor asked for a list of our security controls, each tagged by category and type.
> We've actually built a lot this season — classify what we have, and show me where we're
> missing a layer. — Zainab

## Your role & mission objectives
- **Role:** analyst building a control inventory.
- **Objectives:**
  1. Explain the control **categories** (Technical, Managerial, Operational, Physical).
  2. Explain the **functional types** (Preventive, Deterrent, Detective, Corrective, Compensating, Directive).
  3. **Inventory** NovaGrid's controls (from Episodes 1–8) and classify each.
  4. Identify **gaps** (e.g. a stage with no detective control).

## Scope & rules of engagement
- **In scope:** a documentation/classification exercise over controls already in place.

## Environment setup
No tools needed — this is analysis. Pull your controls from Episodes 1–8 (firewall, MFA,
logging, hardening, backups, access review, auditd, policies). See `environment/README.md`.

## Guided investigation
1. **Define the two axes.** Category (technical/managerial/operational/physical) vs type (preventive/deterrent/detective/corrective/compensating/directive).
   - **Decision:** What's the difference between a *category* and a *type*? (one answers "what kind of control", the other "what it does")
2. **Inventory the controls.** List each control NovaGrid now has and where it applies.
3. **Classify each.** Tag category + type (a control can be more than one type).
   - **Decision:** Give an example of a **compensating** control and when you'd use one.
4. **Find gaps.** Where is there no detective control? No corrective? No directive policy?
   - **Decision:** Which single gap is riskiest to leave?

### Evidence checkpoints
- [ ] the control matrix (control → category → type → where)  - [ ] the gap list

## Deliverable
Fill `deliverable-template.md` → the **control inventory matrix** + gap notes.

## Framework mapping
- **NIST CSF:** cross-cuts IDENTIFY/PROTECT/DETECT/RESPOND/RECOVER
- **Security+ SY0-701:** 1.1 security control categories & types

## Stretch goals
1. Map each control additionally to a **NIST CSF function** or a **CIS Control**.
2. Propose one control to close the riskiest gap.

## Verification questions
1. Difference between a control *category* and a control *type*?
2. Give an example of a compensating control and why it's used.
3. What's one gap in NovaGrid's current controls, and how would you close it?
