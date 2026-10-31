# Episode 15 — Vulnerability Scan of the Wallet Stack

## Cold open

*Story so far — With the Ep13–14 breach understood, Amara wants to know what *else* is exposed before someone uses it.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Find the holes before they do
>
> I want a vulnerability scan of the wallet stack and a sane list of what to fix first — not
> a 200-page dump. Scan it, strip the false positives, and rank the real issues by risk so I
> can take three things to Tunde this week. — Amara

## Your role & mission objectives
- **Role:** analyst running vulnerability management.
- **Objectives:**
  1. **Scan** the wallet stack (authenticated where possible) with a real scanner.
  2. **Validate** results — separate true findings from **false positives**.
  3. **Prioritise** by risk (CVSS **plus** exposure/exploitability/asset value), not raw severity.
  4. Produce a **remediation-ranked** report.

## Concept Explanation — vulnerability management

Scanning finds known weaknesses; **vulnerability management** is the discipline of scanning,
removing noise, and fixing the *right* things first. A raw scanner report is long and full of
false positives, so the skill is **risk-based prioritisation** — weighing severity (CVSS) against
context (internet-facing? exploited in the wild? on the crown-jewel wallet?) to hand the owner a
short, defensible fix list.

**Key terms**
- **Vulnerability vs exploit** — a weakness that *could* be abused vs code/technique that actually abuses it.
- **Authenticated (credentialed) scan** — scanning with login access; sees patch levels and config, so finds far more than an unauthenticated scan.
- **False positive** — a finding that isn't really exploitable; must be triaged out.
- **CVSS** — the 0–10 Common Vulnerability Scoring System severity score.
- **KEV (Known Exploited Vulnerabilities)** — CISA's list of flaws actively exploited — a strong "fix now" signal.
- **Risk-based prioritisation** — ranking by severity *and* exposure/exploitability, not CVSS alone.

## Scope & rules of engagement
- **In scope:** scanning **your own lab** targets only (wallet containers / a deliberately
  vulnerable target). Authorised testing.
- **Out of scope:** scanning anything you don't own.

## Environment setup
A scanner — **Greenbone/OpenVAS** or **Nessus Essentials** (both free) — plus `nmap` with
NSE. Targets: the wallet stack, or a known-vulnerable VM (e.g. an older Linux image / a
vulnerable web app) so there are real findings.

Scanner: Greenbone Community Edition (OpenVAS) or Nessus Essentials (free, up to 16 IPs).
Plus `nmap` (`-sV`, `--script vuln`). Targets must be **yours**: the wallet containers, or a
deliberately vulnerable VM (e.g. an old Metasploitable/Linux image or a vulnerable web app
in Docker) so the scan returns real findings to triage. Never scan systems you don't own.

## Guided investigation
1. **Discover + scan.** `nmap -sV` for services/versions, then a full scanner run (authenticated if you can).
   - **Decision:** Why does an **authenticated** scan find more than an unauthenticated one?
2. **Triage findings.** Group by host/service; mark likely **false positives** and confirm a couple manually.
   - **Decision:** How do you tell a real finding from a scanner guess?
3. **Prioritise.** Rank by CVSS **and** context: is it internet-facing? exploit available (known-exploited/KEV)? on the crown-jewel wallet?
   - **Decision:** Which 3 fixes go to Tunde first, and why those over higher-CVSS-but-low-risk ones?
4. **Report.** Findings, risk rank, and concrete remediation per item.

### Evidence checkpoints
- [ ] `nmap -sV` output  - [ ] the scanner report (export)  - [ ] your triaged/prioritised list  - [ ] a manually-verified finding

## Commands explained

| Command / action | What it does | Why you use it here |
|---|---|---|
| `nmap -sV <targets>` | detects open services and their versions | first look at what's exposed |
| authenticated scan (OpenVAS/Greenbone, Nessus) | scans with credentials | find missing patches and misconfig, not just open ports |
| manual confirm of a finding | reproduce it by hand | separate a real issue from a scanner guess |
| cross-check against CVSS + KEV | severity + active-exploitation context | prioritise the fixes that actually matter |

## On Windows

**nmap** and the scanners (**Nessus Essentials**, **Greenbone/OpenVAS**) all have Windows builds — run
the scan from Windows unchanged. For a **credentialed** scan of a Windows target, supply a Windows admin
account (and enable WMI/remote registry) instead of SSH keys. CVSS, KEV and risk-based prioritisation are
identical. Windows-native option: **Microsoft Defender Vulnerability Management** / `Get-WindowsUpdate`
for missing-patch context.

## Deliverable
Fill `deliverable-template.md` → the **vuln-scan report + prioritisation**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1016 Vulnerability Scanning, M1051 Update Software (remediate/patch by priority)
- **NIST CSF:** IDENTIFY — ID.RA (risk assessment); PROTECT — PR.IP
- **Security+ SY0-701:** 4.3 vulnerability management; scanning (authenticated/credentialed), CVSS, prioritisation

## Stretch goals
1. Map top findings to **CISA KEV** (known-exploited) and re-rank.
2. Re-scan after a fix to show the finding closed (verification).

## Verification questions
1. Why does a credentialed scan outperform an uncredentialed one?
2. How did you identify and confirm a false positive?
3. Name your top-3 fixes and the risk logic (not just CVSS) behind the order.
