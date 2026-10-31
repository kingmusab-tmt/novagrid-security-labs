# Episode 23 — Digital Forensics & Chain of Custody

## Cold open

*Story so far — The compromised host from Eps 13 and 21 may become evidence. Handle it so it stands up in court.*

> **From:** Zainab Idris (Compliance)
> **Subject:** Make the evidence court-ready
>
> Legal may pursue this. Whatever we collected from the compromised host has to be handled
> so it's admissible — properly acquired, hashed, and with a chain of custody nobody can
> poke holes in. Produce the forensic report and the custody form. — Zainab

## Your role & mission objectives
- **Role:** analyst performing sound digital forensics.
- **Objectives:**
  1. Acquire evidence by the **order of volatility** without modifying originals.
  2. Create a **forensic image** and prove integrity with **hashing**.
  3. Analyse a **copy** (never the original) for the attacker's artifacts/timeline.
  4. Maintain a documented **chain of custody**.

## Scope & rules of engagement
- **In scope:** evidence from the lab incident (a memory/disk sample or triage image). Analysis on copies only.

## Environment setup
Use a real practice image: a public **memory sample** (MemLabs / Volatility test images) or a
**disk/triage image** (CyberDefenders, Digital Corpora). Tools: `dd`, `sha256sum`, a
**write-blocker** concept, **Volatility 3** (memory), **Autopsy/Sleuth Kit** (disk). See
`environment/README.md`.

## Guided investigation
1. **Order of volatility.** Decide collection order: cache → RAM → swap/pagefile → disk → logs/network.
   - **Decision:** Why collect RAM before disk, and what did Ep21 do right by not powering off?
2. **Image + hash.** Make a bit-for-bit image (`dd`) and hash source and image; write-protect the original.
   - **Decision:** How does a matching hash prove the image is unaltered?
3. **Analyse a copy.** In Volatility/Autopsy, pull the attacker artifacts (processes, network, files, registry/web history) and build a timeline.
   - **Decision:** What artifacts place the attacker on the host and when?
4. **Chain of custody.** Record who collected what, when, where it's stored, every handoff.
   - **Decision:** What breaks a chain of custody, and how do you prevent it?

### Evidence checkpoints
- [ ] order-of-volatility plan  - [ ] image + matching source/image hashes  - [ ] key artifacts/timeline from the copy  - [ ] completed chain-of-custody form

## Deliverable
Fill `deliverable-template.md` → the **forensic report + chain-of-custody form**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** RESPOND — RS.AN (analysis); evidence handling per NIST SP 800-86
- **Security+ SY0-701:** 4.x digital forensics (acquisition, order of volatility, hashing, chain of custody, admissibility)

## Stretch goals
1. Compute a **hash of the whole drive** before and after imaging to prove the process didn't alter it.
2. Produce a **super-timeline** and correlate with the Ep13 SIEM timeline.

## Verification questions
1. State the order of volatility and why RAM comes before disk.
2. How do hashes establish image integrity, and what is a write-blocker for?
3. What must a chain-of-custody record contain, and what invalidates it?
