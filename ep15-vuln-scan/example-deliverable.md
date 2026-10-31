# Vulnerability-Scan Report — Episode 15 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Scope:** wallet stack

## 1. Method
- Greenbone (OpenVAS) authenticated scan + `nmap -sV`. Targets: wallet-api, logging host.

## 2. Findings (prioritised)
| Rank | Finding | Host | CVSS | Exposure / exploitability | TP? | Fix |
|---|---|---|---|---|---|---|
| 1 | Outdated web server, known-exploited CVE | wallet-api (internet-facing) | 9.8 | public + in CISA KEV | yes | patch now |
| 2 | Weak TLS config | wallet-api | 7.4 | public | yes | fix ciphers (Ep17) |
| 3 | Default creds on admin panel | wallet-api | 8.0 | internal | yes | rotate + restrict |
| 4 | "Vulnerable" library flagged | logging | 7.5 | not actually loaded | **no (FP)** | document, ignore |

## 3. Top 3 to fix first (and why)
1. The KEV-listed internet-facing RCE — public, exploited in the wild, on the crown jewel.
2. Default admin creds — trivial to abuse, high impact.
3. Weak TLS — public-facing, feeds the Ep17 work.
(The CVSS 7.5 library flag outranks #3 on paper but is a false positive — context beats the number.)

## 4. False positives
The library finding: confirmed the vulnerable version isn't actually loaded/used → benign.

## 5. Reflection (own words)
The lesson was ranking by *context*, not CVSS. A 9.8 that's internet-facing and in KEV beats
a 7.5 that isn't exploitable here — and a scary-looking finding turned out to be a false positive.
