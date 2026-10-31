# NovaGrid Security Labs — Analyst Case File

A scenario-based practical lab series aligned to **CompTIA Security+ (SY0-701)**.
Every lab is an episode at **NovaGrid Energy** (a fictional Nigerian solar-fintech).
You play a security analyst, work a real task, and leave behind a documented artifact.

This repository **is** the portfolio: each folder is one investigation, with the
write-up, the evidence, and the framework mapping an employer can read.

> Simulated work for training. NovaGrid Energy and its staff are fictional.
> All "attacker" activity is performed only inside an isolated lab.

## Case file

| # | Episode | Security+ domain | Status | Artifact |
|---|---------|------------------|--------|----------|
| 11 | [Phishing to the CFO](ep11-phishing-cfo/) | 2.0 Threats / 5.0 Awareness | ✅ built (pilot) | Phishing-analysis report + IOCs |
| 13 | [Host Compromise in Splunk](ep13-host-compromise/) | 4.0 Security Operations | ✅ built | Incident report + ATT&CK mapping |
| 20 | [Author SIEM Detections](ep20-siem-detections/) | 4.0 Security Operations | ✅ built | Detection pack (SPL + ATT&CK) |

*(Episodes 1–30 are defined in the [blueprint](docs/BLUEPRINT.md); more land here as they are built.)*

> Episode 11 ships a per-student sample generator (`ep11-phishing-cfo/generator/`) so every student's phishing email — and its hash — is unique.

## How to use a lab
1. Open the episode's `lab.md` and read the brief.
2. Stand up its `environment/` as described.
3. Work the investigation, capturing evidence into `evidence/` as you go.
4. Fill in `deliverable-template.md` → your finished report.
5. Self-check against `rubric.md`.

## About
Author: Musab Mubaraq Mburaimoh · Instructor-built training series.
