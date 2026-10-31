# Episode 32 — Capstone: The Sable Finch Case File

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** Tell the whole story — one case file
>
> You've worked Sable Finch piece by piece all year: the phishing email, the traffic, the
> compromised host, the rogue account, the staged data. Leadership doesn't want thirty
> reports — they want **one case file** that tells the whole story, start to finish, with the
> evidence behind every claim and a clear account of how we detected, contained, recovered,
> and what we changed. This is the document you'll show in an interview and hand to an
> auditor. Make it the best thing in your portfolio. — Amara

## Your role & mission objectives
- **Role:** lead incident analyst and author of the consolidated case file.
- **Objectives:**
  1. **Reconstruct the campaign** end to end across the kill chain, using the findings you produced in Episodes 11–31 (see `environment/campaign-brief.md` for the storyline).
  2. **Build one incident case file** — a single, employer-grade document covering detection → analysis → containment → eradication → recovery → lessons learned.
  3. **Map the whole campaign to MITRE ATT&CK** as a kill-chain table, and to NIST CSF functions.
  4. **Write a one-page executive brief** (reuse/extend your Episode 30 board brief).
  5. **Produce a kill-chain diagram** showing Sable Finch's path and where each control stopped (or should have stopped) them.

## Concept Explanation — putting it together: the incident case file

The capstone is synthesis: you turn a year of scattered findings into one coherent story an employer
or a board can follow end to end. The spine is a **master timeline** anchored at **T0** (the earliest
confirmed malicious event, not when you first noticed), mapped onto the **MITRE ATT&CK** kill chain
and the five **NIST CSF** functions, and closed with the single control that would have stopped the
campaign earliest.

## Scope & rules of engagement
- **In scope:** assembling and analysing evidence you already generated; writing the case file, the diagram, and the exec brief.
- **Out of scope:** no new attacks and no new exploitation — this episode is **synthesis**. If you're missing evidence for a stage, go back and do that episode first, or re-run it against `lab-env`.
- **Prerequisite:** you should have completed a good spread of Episodes 11–31. The capstone is only as strong as the evidence behind it.

## Environment setup
No new environment. Your inputs are:
- `environment/campaign-brief.md` — the Sable Finch storyline mapped to episodes.
- **Your own `evidence/` and `report.md` files from Episodes 11–31** — gather them.
- Optionally, the shared `lab-env` (to re-capture any evidence you're missing).

Nothing to install. This episode is **synthesis** — you assemble the story from work you've
already done.

### Your inputs
- `campaign-brief.md` — the Sable Finch storyline, each stage mapped to the episode you worked it in.
- **Your own `report.md` + `evidence/` from Episodes 11–31** — gather the relevant findings.
- Optional: the shared `lab-env` (`../lab-env/`), to re-capture any evidence you're missing.

### If you're missing a stage
The capstone is only as strong as the evidence behind it. If you haven't done an episode a
kill-chain stage depends on (see the table in `campaign-brief.md`), do that episode first or
re-run it against `lab-env`, then come back.

### Diagram tools (pick one)
- **Mermaid** (text-based, renders on GitHub) — good for the kill-chain flow.
- **draw.io / Excalidraw** — export a PNG into `evidence/`.
- **Hand-drawn** and photographed — perfectly acceptable if it's legible.

## Guided synthesis
This is a writing-and-analysis episode. Work it like a real post-incident consolidation.

1. **Build the master timeline.** Pull the key events from each episode into one chronological
   timeline: timestamp, event, source host, evidence reference. This is the backbone.
   - **Decision:** What is your T0 — the earliest confirmed malicious event — and how do you know it's the start and not just the first thing you detected?

2. **Map the kill chain.** For each stage in `campaign-brief.md`, state what happened, the
   evidence, the **ATT&CK technique**, and the **control** that caught it (or the gap that let it through).
   - **Decision:** Where was the **earliest point** you could realistically have stopped Sable Finch? Defend your choice — that's your headline lesson.

3. **Write detection & analysis.** How was it found (which alert, which episode), and how did
   triage confirm it was an incident? Tie back to your Episode 31 escalations.

4. **Write containment & eradication.** What you isolated, what you removed (rogue account,
   key, staged data), and how you verified the attacker was out. Reuse Episode 21.

5. **Write recovery.** How the wallet service came back safely, what had to be true before
   go-live, and the restore test. Reuse Episode 22.

6. **Lessons learned.** Run (or summarise) the Episode 30 tabletop. The top gaps become
   dated, **owned** remediation actions.
   - **Decision:** Of everything you'd change, which **one** control would have prevented the most of this campaign? Lead the exec brief with it.

7. **Draw the kill-chain diagram.** A single diagram: Sable Finch's path left-to-right across
   the stages, with a marker at each control that stopped (green) or failed (red) them.
   Mermaid, draw.io, or hand-drawn and photographed — all fine.

8. **Write the executive brief.** One page, plain language: what happened, business impact,
   what's fixed, residual risk, and the single ask of leadership.

### Evidence checkpoints
Save to `evidence/`:
- [ ] The **master timeline** (T0 → recovery)
- [ ] The **ATT&CK kill-chain table** (stage · technique · evidence · control/gap)
- [ ] The **kill-chain diagram**
- [ ] The finished **case file** and **one-page executive brief**

## Key terms & frameworks

**Core terms**
- **Incident case file** — one consolidated document: timeline, kill-chain map, analysis, recovery, lessons, and an executive brief.
- **T0** — the earliest *confirmed malicious* event; distinguishing it from "first detected" is a key analytical point.
- **Dwell time** — how long the attacker was active before detection; the gap between T0 and detection.
- **Master timeline** — the chronological backbone, every entry tied to an evidence reference.

**Frameworks you map against:**
- **MITRE ATT&CK** — present the campaign as a kill-chain table: stage → technique (Txxxx) → your evidence → the control that caught it or the gap → the **mitigation** (Mxxxx) that closes it.
- **NIST CSF** — show that your case file touches all five functions: **IDENTIFY, PROTECT, DETECT, RESPOND, RECOVER**.
- **Cyber kill chain** — recon → initial access → execution → persistence → lateral movement → collection → exfiltration → impact; the narrative order of the story.

**The headline:** name the **earliest realistic stop point** and the one control (e.g. MFA on admin
logins) that would have prevented the most of the campaign — that single insight leads the executive
brief, the one-page, plain-language summary that makes a single, concrete ask of leadership.

## Deliverable
Fill `deliverable-template.md` → **the Sable Finch incident case file** plus the **executive
brief**, with the kill-chain diagram embedded or linked. See `example-deliverable.md` for the
standard. **This is your portfolio centerpiece** — the one document a recruiter should read if
they read only one. Link to it from the top of your case-file README.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** the full chain — Reconnaissance (T1595), Phishing (T1566), Valid Accounts (T1078), Brute Force (T1110), Command & Scripting (T1059), Account Manipulation (T1098), Lateral Movement, C2 (T1071), Data Staged (T1074), Exfiltration (T1041), Impact (T1489). Present it as a kill-chain table, with the **mitigation** (Mxxxx) for each.
- **NIST CSF:** all five functions — IDENTIFY, PROTECT, DETECT, RESPOND, RECOVER — this capstone touches every one. Map your sections to them.
- **Security+ SY0-701:** spans 1.0–5.0, with the weight on 4.0 (incident response, the full lifecycle) and 5.0 (communicating risk to leadership).

## Stretch goals
1. **Threat-actor profile.** Write a one-page Sable Finch profile: TTPs, likely motivation, and the detections that would catch them earlier next time.
2. **Detection pack.** Consolidate every detection you wrote (Ep 20, Ep 31) into one rule set mapped to the kill chain — show your coverage and your gaps.
3. **5-minute talk.** Turn the case file into a short deck or recorded walkthrough — exactly the interview "tell me about an incident you worked" answer (told honestly as a lab).

## Verification questions (instructor sign-off)
1. What is your T0, and what evidence establishes it as the true start of the campaign?
2. Where was the earliest realistic point to stop Sable Finch, and what single control would have done it?
3. Walk your kill-chain table: for one stage, give the technique, your evidence, and whether a control caught it or it was a gap.
