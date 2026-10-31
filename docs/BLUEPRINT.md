# NovaGrid Security Labs — Design Blueprint

A scenario/story-based practical lab series aligned to CompTIA Security+ (SY0-701).
Students build a portfolio of documented investigations. Three progressive seasons,
10 episodes each. Runs on VirtualBox + Docker on a modest laptop.

## The model
Every lab is an episode in one company's story. The student plays a role, is handed a
real task in-character, works it in a reproducible environment, and produces one
documented artifact for the portfolio.

## Company & cast
**NovaGrid Energy** — a mid-sized Nigerian firm running a mobile-money wallet for
off-grid solar customers (regulated financial data + critical infrastructure).

| Character | Role |
|-----------|------|
| Amara Okafor | SOC Lead / the student's manager |
| Tunde Bello | IT Sysadmin (overstretched; his shortcuts cause incidents) |
| Chidi Nwosu | CFO (high-value phishing target) |
| Zainab Idris | Compliance Officer |
| "Sable Finch" | Recurring external adversary group |

## Season arc (30 episodes)

### Season 1 — Foundations (beginner)
| # | Episode | Domain | Artifact |
|---|---------|--------|----------|
| 1 | Asset & account audit | 1.0 | Asset inventory + findings memo |
| 2 | Password policy after a reuse incident | 1.0/4.0 | Password-policy & IAM checklist |
| 3 | Harden the wallet-API server | 4.0 | Server-hardening report |
| 4 | Centralized logging & baseline | 4.0 | Logging config + dashboard |
| 5 | Access review (least privilege) | 4.0 | Access-review report |
| 6 | Classify NovaGrid's data | 1.0/5.0 | Data classification scheme |
| 7 | Roll out MFA | 1.0/4.0 | MFA deployment write-up |
| 8 | Backup & restore baseline (3-2-1) | 3.0/4.0 | Backup plan + restore test |
| 9 | Map control types | 1.0 | Security control inventory |
| 10 | AUP + onboarding/offboarding | 5.0 | Policy + procedure doc |

### Season 2 — Under attack (intermediate)
| # | Episode | Domain | Artifact |
|---|---------|--------|----------|
| 11 | Phishing email to the CFO | 2.0/5.0 | Phishing-analysis report + IOCs |
| 12 | Triage suspicious traffic | 4.0 | Alert triage + pcap write-up |
| 13 | Host compromise investigation | 4.0 | Incident report (IR + ATT&CK) |
| 14 | Malware triage in a sandbox | 2.0/4.0 | Malware-analysis report |
| 15 | Vulnerability scan of the stack | 4.0 | Vuln-scan report + priorities |
| 16 | SQLi/XSS on the wallet portal | 2.0 | Web-vuln findings + fix |
| 17 | Weak TLS / certificate problem | 1.0/3.0 | Crypto-config assessment |
| 18 | Credential stuffing on accounts | 2.0 | Detection + mitigation |
| 19 | Rogue access point at a branch | 2.0/3.0 | Wireless assessment |
| 20 | Author SIEM detections | 4.0 | Detection rules + use case |

### Season 3 — Resilience & command (advanced)
| # | Episode | Domain | Artifact |
|---|---------|--------|----------|
| 21 | Contain & eradicate the breach | 4.0 | Containment/eradication runbook |
| 22 | Recover; test BCP/DR | 3.0/4.0 | Recovery runbook + DR test |
| 23 | Digital forensics | 4.0 | Forensic report + chain of custody |
| 24 | Threat hunting | 4.0 | Threat-hunt report |
| 25 | Segment network; zero trust | 3.0 | Architecture diagram + controls |
| 26 | Secure cloud architecture | 3.0 | Cloud security design |
| 27 | Risk assessment | 5.0 | Risk register + treatment plan |
| 28 | Third-party vendor assessment | 5.0 | Vendor risk assessment |
| 29 | Compliance & privacy gap analysis | 5.0 | Compliance brief + gaps |
| 30 | Tabletop + board report | 4.0/5.0 | After-action + exec report |
| 31 | Shift at the console: alert-queue triage | 4.0 | Alert-triage shift report |
| 32 | Capstone: the Sable Finch case file | 1.0–5.0 | Incident case file + exec brief + kill-chain |

## Real tools & real data
| Tool | Use | Free source | Episodes |
|------|-----|-------------|----------|
| Splunk (Free / 60-day trial) | SIEM investigation on real attack data | Boss of the SOC BOTSv1 & v3 | 11,13,15,20,24 |
| Wireshark | Packet analysis of real malware traffic | malware-traffic-analysis.net; Netresec | 12,16,19 |
| Security Onion | Replay pcaps through a full NSM stack | securityonionsolutions.com | 12,20,24 |
| Wazuh | Free SIEM/XDR + endpoint detection | wazuh.com | 4,5,13,21 |
| Sysmon + Event Logs | Real endpoint telemetry | SwiftOnSecurity config; EVTX-ATTACK-SAMPLES | 13,23,24 |
| abuse.ch + VirusTotal | IOC enrichment & reputation | MalwareBazaar/URLhaus/ThreatFox; VT free | 11,14,18 |
| Volatility 3 | Memory forensics | MemLabs; Volatility samples | 23 |
| Atomic Red Team + Caldera | Generate real ATT&CK telemetry | both free | 20,24,capstone |
| CyberDefenders | Extra graded DFIR challenges | cyberdefenders.org | stretch/capstone |

Safety: real malware is only detonated in the isolated sandbox VM or Any.Run — never on the host.

## Standard lab template
See [lab-template.md](lab-template.md). Every lab uses the same skeleton:
cold open → role & objectives → scope → environment → guided investigation (decision
points) → evidence checkpoints → deliverable → rubric → framework mapping → stretch goals.

### Bonus episodes (31–32)
Two added in the standards-realism pass: **31** a high-volume alert-queue triage drill (a generator plants ~6 true positives in ~95% noise; the skill is precision under a clock), and **32** the series **capstone**, which consolidates the student's Episode 11–31 findings into one employer-grade Sable Finch incident case file (timeline, ATT&CK kill-chain, diagram, exec brief).

## Authenticity
Per-student unique artifacts, a reflection in the student's own words, and verification
questions only answerable by doing the lab.
