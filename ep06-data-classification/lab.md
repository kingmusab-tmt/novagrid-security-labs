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

## Concept Explanation — data classification & protection

You protect data according to how sensitive it is — but first you have to find it and label it.
**Data classification** sorts information into levels (Public → Restricted) each with handling rules,
so controls like encryption and access limits are applied where they matter. Regulated data (payment
card numbers under **PCI DSS**, personal data under Nigeria's **NDPR**) carries legal obligations, and
the first finding is often that sensitive data is sitting somewhere it shouldn't be.

**Key terms**
- **Data classification** — assigning each piece of data a sensitivity level with defined handling rules.
- **PII (personally identifiable information)** — data that identifies a person (name, email, phone, national ID).
- **PAN / cardholder data** — the Primary Account Number on a payment card; PCI DSS restricts storing it at all.
- **PCI DSS** — the payment-card industry security standard governing cardholder data.
- **NDPR** — the Nigeria Data Protection Regulation, governing personal-data handling.
- **Data owner** — the accountable person for a given data set's classification and protection.

## Scope & rules of engagement
- **In scope:** scanning the lab's sample data. **Use only synthetic/test data** — never
  put real personal data into the lab or the repo.

## Environment setup
Analyst VM with the lab's sample datasets. Tools: `grep -E`, `find`, simple regex. See
the setup below.

Analyst VM with the lab's SAMPLE datasets (CSV/text). If none are present, create a tiny
synthetic set (fake names, test emails, and test card numbers like 4111 1111 1111 1111).
**Never use real personal data.** Redact matches before putting any result in the repo.
Tools: `grep -rEI`, `find`. Regex is enough — no special software.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Look in `/srv/wallet/data/`, `/srv/wallet/exports/` and `/etc/wallet/` on wallet-api — and check what `http://172.28.0.10:8000/` exposes to the network.
- All data is synthetic; card numbers are standard test numbers. Still redact anything you put in the repo.

## Guided investigation

Work on **wallet-api**, where NovaGrid's data lives. One action per sub-step.

### Step 1 — Define the scheme

Set levels (Public / Internal / Confidential / Restricted), each with handling rules (who can access,
encryption, retention).

**Decision:** What goes in "Restricted/Regulated", and which law drives it (PCI DSS, NDPR)?

### Step 2 — Find PII

**a.** Open a shell and go to the data:
```bash
docker compose exec wallet-api bash
cd /srv
```

**b.** Search for email-address patterns:
```bash
grep -rEI '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' /srv
```

**Decision:** Where does PII live, and is it protected there?

### Step 3 — Find cardholder data

**a.** Search for 16-digit card-like patterns (synthetic test data):
```bash
grep -rEI '([0-9]{4}[ -]?){4}' /srv
```

**b.** Check what the stray debug server exposes to the network:
```bash
ls -l /srv/wallet/exports     # and recall port 8000 from Episode 1
```

**Decision:** Should cardholder data even be stored here? What does PCI DSS say about storing PANs?

### Step 4 — Build the inventory

Map each finding: data type → location → classification → controls → owner.

**Decision:** Which data set is most at risk right now, and what one control would help most?

### Evidence checkpoints
- [ ] the classification scheme  - [ ] the scan commands + (redacted) results  - [ ] the data inventory

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `grep -rEI '<email-regex>' data/` | recursively searches text files for email-address patterns | locate PII |
| `grep -rEI '([0-9]{4}[ -]?){4}' data/` | searches for 16-digit card-like patterns (in **test** data) | locate cardholder data that shouldn't be stored |
| `grep -rEI` (the `-r -E -I` flags) | **r**ecursive, **E**xtended-regex, **I**gnore-binary-files | scan a tree of files cleanly without regex escaping pain |
| `find data/ -type f` | lists every file to scan | know the scope of what you're classifying |

*(All data here is synthetic; still redact any match before putting it in your report.)*

## Deliverable
Fill `deliverable-template.md` → the **classification scheme** + **data inventory**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1057 Data Loss Prevention, M1041 Encrypt Sensitive Information (classification drives both)
- **NIST CSF:** IDENTIFY — ID.AM-5 (data classified by sensitivity); PROTECT — PR.DS (data security)
- **Security+ SY0-701:** 1.x data types & classifications (regulated, PII, financial, etc.); 5.x data governance

## Stretch goals
1. Write a small script that classifies files automatically by the patterns they contain.
2. Recommend a DLP rule per class.

## Verification questions
1. Which data class is "regulated", and which law drives it for NovaGrid?
2. Where did you find cardholder-style data, and should it be stored there?
3. Give one handling rule for each class in your scheme.
