# [Your Name] — Security Case Files

> **Blue-team / GRC home-lab portfolio** · CompTIA Security+ (SY0-701) aligned · [City, Country]
> [LinkedIn](https://www.linkedin.com/in/your-handle) · [email@example.com](mailto:email@example.com)

*These case files are hands-on training scenarios set at **NovaGrid Energy**, a fictional company.
All systems were my own lab VMs/containers and all data is synthetic or from public training datasets
(Splunk BOTS, malware-traffic-analysis.net). No real organisation was tested.*

<!-- HOW TO USE THIS TEMPLATE: replace every [bracketed] item, delete rows you haven't done yet
(or leave them as ⏳), and keep this comment out of your final version. See docs/portfolio/PORTFOLIO-GUIDE.md -->

## About me

[2–3 sentences: who you are, what role you're aiming for (SOC analyst, GRC analyst, security engineer),
and what this portfolio shows. Example: "Aspiring SOC analyst. Over 30 lab cases I hardened a Linux
server, investigated a compromise in Splunk, triaged real malware pcaps, and wrote a board-level
incident report."]

## Highlights — start here

Pick your 3 strongest cases. A recruiter will read these and nothing else.

| Case | What I did | Result |
|---|---|---|
| [#13 Host Compromise in Splunk](ep13-host-compromise/) | [investigated a web-server compromise in BOTSv1] | [identified attacker IP, initial access and defacement in ~X hours; mapped 6 ATT&CK techniques] |
| [#NN Title](epNN-folder/) | [action] | [measurable result] |
| [#NN Title](epNN-folder/) | [action] | [measurable result] |

## All cases

### Season 1 — Build the Foundation

| # | Case | Security+ domain | Deliverable | Status |
|---|---|---|---|---|
| 1 | [Asset & Account Audit](ep01-asset-account-audit/) | 1.0 General Concepts | [Asset inventory + findings memo](ep01-asset-account-audit/report.md) | ⏳ |
| 2 | [Password Policy & IAM Baseline](ep02-password-policy/) | 1.0 / 4.0 | [Password policy + IAM checklist](ep02-password-policy/report.md) | ⏳ |
| 3 | [Harden the Wallet-API Server](ep03-harden-server/) | 4.0 Operations | [Hardening report (before/after)](ep03-harden-server/report.md) | ⏳ |
| 4 | [Centralized Logging & Baseline](ep04-central-logging/) | 4.0 Operations | [Logging config + dashboard](ep04-central-logging/report.md) | ⏳ |
| 5 | [Access Review (Least Privilege)](ep05-access-review/) | 4.0 Operations | [Access-review report](ep05-access-review/report.md) | ⏳ |
| 6 | [Classify NovaGrid's Data](ep06-data-classification/) | 1.0 / 5.0 | [Data classification scheme + inventory](ep06-data-classification/report.md) | ⏳ |
| 7 | [Roll Out MFA](ep07-mfa-rollout/) | 1.0 / 4.0 | [MFA deployment write-up](ep07-mfa-rollout/report.md) | ⏳ |
| 8 | [Backup & Restore (3-2-1)](ep08-backup-restore/) | 3.0 / 4.0 | [Backup plan + restore test](ep08-backup-restore/report.md) | ⏳ |
| 9 | [Map Control Types](ep09-control-types/) | 1.0 General Concepts | [Security control inventory](ep09-control-types/report.md) | ⏳ |
| 10 | [AUP + Onboarding/Offboarding](ep10-aup-onboarding/) | 5.0 Governance | [Policy + procedure doc](ep10-aup-onboarding/report.md) | ⏳ |

### Season 2 — Under Attack

| # | Case | Security+ domain | Deliverable | Status |
|---|---|---|---|---|
| 11 | [Phishing to the CFO](ep11-phishing-cfo/) | 2.0 Threats / 5.0 Awareness | [Phishing-analysis report + IOCs](ep11-phishing-cfo/report.md) | ⏳ |
| 12 | [Triage Suspicious Traffic (Wireshark)](ep12-traffic-triage/) | 4.0 Security Operations | [Network-analysis report + IOCs](ep12-traffic-triage/report.md) | ⏳ |
| 13 | [Host Compromise in Splunk](ep13-host-compromise/) | 4.0 Security Operations | [Incident report + ATT&CK mapping](ep13-host-compromise/report.md) | ⏳ |
| 14 | [Malware Triage in a Sandbox](ep14-malware-analysis/) | 2.0 / 4.0 | [Malware-analysis report](ep14-malware-analysis/report.md) | ⏳ |
| 15 | [Vulnerability Scan](ep15-vuln-scan/) | 4.0 Operations | [Vuln-scan report + prioritisation](ep15-vuln-scan/report.md) | ⏳ |
| 16 | [Web Attacks (SQLi & XSS)](ep16-web-attacks/) | 2.0 Threats | [Web-vuln findings + fixes](ep16-web-attacks/report.md) | ⏳ |
| 17 | [Weak TLS / Cert Assessment](ep17-tls-assessment/) | 1.0 / 3.0 | [Crypto-config assessment](ep17-tls-assessment/report.md) | ⏳ |
| 18 | [Credential Stuffing](ep18-credential-stuffing/) | 2.0 Threats | [Detection + mitigation write-up](ep18-credential-stuffing/report.md) | ⏳ |
| 19 | [Rogue Access Point](ep19-rogue-ap/) | 2.0 / 3.0 | [Wireless assessment report](ep19-rogue-ap/report.md) | ⏳ |
| 20 | [Author SIEM Detections](ep20-siem-detections/) | 4.0 Security Operations | [Detection pack (SPL + ATT&CK)](ep20-siem-detections/report.md) | ⏳ |

### Season 3 — Respond, Recover, Govern

| # | Case | Security+ domain | Deliverable | Status |
|---|---|---|---|---|
| 21 | [Contain & Eradicate](ep21-contain-eradicate/) | 4.0 Operations | [Containment/eradication runbook](ep21-contain-eradicate/report.md) | ⏳ |
| 22 | [Recover & Test BCP/DR](ep22-recovery-dr/) | 3.0 / 4.0 | [Recovery runbook + DR test](ep22-recovery-dr/report.md) | ⏳ |
| 23 | [Digital Forensics](ep23-forensics/) | 4.0 Operations | [Forensic report + chain of custody](ep23-forensics/report.md) | ⏳ |
| 24 | [Threat Hunting](ep24-threat-hunting/) | 4.0 Operations | [Threat-hunt report](ep24-threat-hunting/report.md) | ⏳ |
| 25 | [Segmentation & Zero Trust](ep25-segmentation-zerotrust/) | 3.0 Architecture | [Architecture diagram + control mapping](ep25-segmentation-zerotrust/report.md) | ⏳ |
| 26 | [Secure Cloud Architecture](ep26-cloud-security/) | 3.0 Architecture | [Cloud security design](ep26-cloud-security/report.md) | ⏳ |
| 27 | [Risk Assessment & Register](ep27-risk-assessment/) | 5.0 Governance | [Risk register + treatment plan](ep27-risk-assessment/report.md) | ⏳ |
| 28 | [Third-Party Vendor Assessment](ep28-vendor-assessment/) | 5.0 Governance | [Vendor risk assessment](ep28-vendor-assessment/report.md) | ⏳ |
| 29 | [Compliance & Privacy Gap Analysis](ep29-compliance-gap/) | 5.0 Governance | [Compliance brief + gap analysis](ep29-compliance-gap/report.md) | ⏳ |
| 30 | [Tabletop & Board Report](ep30-tabletop-board-report/) | 4.0 Operations / 5.0 Governance | [After-action report + board brief](ep30-tabletop-board-report/report.md) | ⏳ |

Status key: ✅ complete · 🟡 in progress · ⏳ not started. Link the Deliverable cell to your finished report.

## Skills & tools demonstrated

Fill in the cases where you actually used each one — evidence beats a skills list.

| Area | Tools / techniques | Cases |
|---|---|---|
| Asset & vulnerability management | nmap, Lynis, OpenVAS/Greenbone | [#1, #3, #15] |
| Identity & access | PAM, pwquality/faillock, sudoers review, TOTP MFA | [#2, #5, #7] |
| Logging & SIEM | rsyslog, Splunk SPL, detection engineering | [#4, #13, #20] |
| Network analysis | Wireshark, Zeek, tcpdump | [#12, #19] |
| Malware & phishing | email header analysis, static triage, hashes/IOCs | [#11, #14] |
| Web & app security | OWASP Top 10, Burp/ZAP, TLS testing | [#16, #17, #18] |
| Incident response & forensics | containment, recovery, timeline, chain of custody | [#21, #22, #23, #24] |
| Architecture & cloud | segmentation, zero trust, cloud IAM | [#25, #26] |
| GRC | risk register, vendor assessment, compliance gap, board reporting | [#27, #28, #29, #30] |
| Frameworks | MITRE ATT&CK, NIST CSF, CIS Controls | [all] |

## How to read a case

Each case folder contains:

- `lab.md` — the scenario brief I was given (the story, scope and rules of engagement)
- `report.md` — **my deliverable** (start here)
- `evidence/` — screenshots, exports and queries backing every finding
- `rubric.md` — the grading criteria, with my self-assessment

## Certifications & learning

- [CompTIA Security+ — status/date]
- [Other courses, CTFs, TryHackMe/HTB rooms]
