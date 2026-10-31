# Episode 6 — Classify NovaGrid's Data

## Cold open
> **From:** Zainab Idris (Compliance)
> **Subject:** What sensitive data do we hold, and where?
>
> For NDPR and the card schemes I need to show we know what sensitive data we hold and
> where it lives. Define how we classify data, then find it — don't just theorise — and
> give me an inventory with handling rules per class. — Zainab

## Your role & mission objectives
- **Role:** analyst building a data classification scheme and inventory.
- **Objectives:**
  1. Define a **classification scheme** (levels + examples + handling rules).
  2. Identify which data is **regulated** (PCI DSS cardholder data; NDPR/PII).
  3. **Find the data** — scan the lab for PII/cardholder patterns (test data only).
  4. Produce a **data inventory** mapping where each data type lives to its class + controls.

## Scope & rules of engagement
- **In scope:** scanning the lab's sample data. **Use only synthetic/test data** — never
  put real personal data into the lab or the repo.

## Environment setup
Analyst VM with the lab's sample datasets. Tools: `grep -E`, `find`, simple regex. See
`environment/README.md`.

## Guided investigation
1. **Define the scheme.** Levels such as Public / Internal / Confidential / Restricted, each with examples and handling rules (who can access, encryption, retention).
   - **Decision:** What goes in "Restricted/Regulated", and which law drives it (PCI DSS, NDPR)?
2. **Find PII.** Scan for emails, phone numbers, and national-ID-style patterns.
   - e.g. `grep -rEI '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' data/`
   - **Decision:** Where does PII live, and is it protected there?
3. **Find cardholder data.** Scan for card-like number patterns (16-digit) in the **test** data.
   - e.g. `grep -rEI '([0-9]{4}[ -]?){4}' data/`
   - **Decision:** Should cardholder data even be stored here? What does PCI DSS say about storing PANs?
4. **Build the inventory.** Map data type → location → class → controls → owner.

### Evidence checkpoints
- [ ] the classification scheme  - [ ] the scan commands + (redacted) results  - [ ] the data inventory

## Deliverable
Fill `deliverable-template.md` → the **classification scheme** + **data inventory**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** IDENTIFY — ID.AM-5 (data classified by sensitivity); PROTECT — PR.DS (data security)
- **Security+ SY0-701:** 1.x data types & classifications (regulated, PII, financial, etc.); 5.x data governance

## Stretch goals
1. Write a small script that classifies files automatically by the patterns they contain.
2. Recommend a DLP rule per class.

## Verification questions
1. Which data class is "regulated", and which law drives it for NovaGrid?
2. Where did you find cardholder-style data, and should it be stored there?
3. Give one handling rule for each class in your scheme.
