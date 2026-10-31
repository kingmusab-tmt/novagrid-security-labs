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

## Concept Explanation — digital forensics

Forensics is evidence handling done so the results would stand up to scrutiny — in court or an
audit. You collect in **order of volatility** (the most fleeting data first), make a **bit-for-bit
image** and prove it's unaltered with a **hash**, analyse only a *copy*, and document an unbroken
**chain of custody**. Skip any of those and the evidence can be challenged.

**Key terms**
- **Order of volatility** — collect the most ephemeral data first: CPU cache → RAM → swap → disk → logs/archives.
- **Bit-for-bit image** — an exact sector-level copy of the source (via `dd`/forensic imager), not a file copy.
- **Hash verification** — matching source and image hashes to prove the image is identical and unaltered.
- **Write-blocker** — hardware/software that prevents any change to the original evidence during imaging.
- **Chain of custody** — the documented record of who held the evidence, when, and every handoff.
- **Admissibility** — whether evidence can be used; broken custody or an unverified image can make it inadmissible.

## Scope & rules of engagement
- **In scope:** evidence from the lab incident (a memory/disk sample or triage image). Analysis on copies only.

## Environment setup
Use a real practice image: a public **memory sample** (MemLabs / Volatility test images) or a
**disk/triage image** (CyberDefenders, Digital Corpora). Tools: `dd`, `sha256sum`, a
**write-blocker** concept, **Volatility 3** (memory), **Autopsy/Sleuth Kit** (disk). See
the setup below.

Practice on a REAL image you can download: a memory sample (MemLabs, or the Volatility
Foundation's sample images) or a disk/triage image (CyberDefenders, Digital Corpora).
Tools: `dd` (imaging), `sha256sum` (integrity), Volatility 3 (memory analysis), Autopsy +
The Sleuth Kit (disk). Always work on a COPY; hash source and copy and keep them equal.
Treat the original as read-only (write-blocker concept).

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

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `dd if=<source> of=image.dd bs=4M` | makes a bit-for-bit image of the source | capture an exact forensic copy |
| `sha256sum <source>` and `sha256sum image.dd` | hashes both | prove the image matches the original |
| mount read-only / use a write-blocker | prevents altering the evidence | preserve admissibility |
| Volatility 3 plugins (`pslist`, `netscan`, …) | parse a RAM capture for processes/connections | place the attacker on the host |
| `strings` / Autopsy timeline | surface artefacts and order them | build the forensic timeline |

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
