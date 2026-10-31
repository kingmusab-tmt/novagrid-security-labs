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
| 1 | [Asset & Account Audit](ep01-asset-account-audit/) | 1.0 General Concepts | ✅ built | Asset inventory + findings memo |
| 2 | [Password Policy & IAM Baseline](ep02-password-policy/) | 1.0 / 4.0 | ✅ built | Password policy + IAM checklist |
| 3 | [Harden the Wallet-API Server](ep03-harden-server/) | 4.0 Operations | ✅ built | Hardening report (before/after) |
| 4 | [Centralized Logging & Baseline](ep04-central-logging/) | 4.0 Operations | ✅ built | Logging config + dashboard |
| 5 | [Access Review (Least Privilege)](ep05-access-review/) | 4.0 Operations | ✅ built | Access-review report |
| 6 | [Classify NovaGrid's Data](ep06-data-classification/) | 1.0 / 5.0 | ✅ built | Data classification scheme + inventory |
| 7 | [Roll Out MFA](ep07-mfa-rollout/) | 1.0 / 4.0 | ✅ built | MFA deployment write-up |
| 8 | [Backup & Restore (3-2-1)](ep08-backup-restore/) | 3.0 / 4.0 | ✅ built | Backup plan + restore test |
| 9 | [Map Control Types](ep09-control-types/) | 1.0 General Concepts | ✅ built | Security control inventory |
| 10 | [AUP + Onboarding/Offboarding](ep10-aup-onboarding/) | 5.0 Governance | ✅ built | Policy + procedure doc |
| 11 | [Phishing to the CFO](ep11-phishing-cfo/) | 2.0 Threats / 5.0 Awareness | ✅ built (pilot) | Phishing-analysis report + IOCs |
| 12 | [Triage Suspicious Traffic (Wireshark)](ep12-traffic-triage/) | 4.0 Security Operations | ✅ built | Network-analysis report + IOCs |
| 13 | [Host Compromise in Splunk](ep13-host-compromise/) | 4.0 Security Operations | ✅ built | Incident report + ATT&CK mapping |
| 14 | [Malware Triage in a Sandbox](ep14-malware-analysis/) | 2.0 / 4.0 | ✅ built | Malware-analysis report |
| 15 | [Vulnerability Scan](ep15-vuln-scan/) | 4.0 Operations | ✅ built | Vuln-scan report + prioritisation |
| 16 | [Web Attacks (SQLi & XSS)](ep16-web-attacks/) | 2.0 Threats | ✅ built | Web-vuln findings + fixes |
| 17 | [Weak TLS / Cert Assessment](ep17-tls-assessment/) | 1.0 / 3.0 | ✅ built | Crypto-config assessment |
| 18 | [Credential Stuffing](ep18-credential-stuffing/) | 2.0 Threats | ✅ built | Detection + mitigation write-up |
| 19 | [Rogue Access Point](ep19-rogue-ap/) | 2.0 / 3.0 | ✅ built | Wireless assessment report |
| 20 | [Author SIEM Detections](ep20-siem-detections/) | 4.0 Security Operations | ✅ built | Detection pack (SPL + ATT&CK) |
| 30 | [Tabletop & Board Report](ep30-tabletop-board-report/) | 4.0 Operations / 5.0 Governance | ✅ built | After-action report + board brief |

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
