# Forensic Report & Chain of Custody — Episode 23 (worked example — illustrative)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Case:** Sable Finch

## 1. Acquisition
- Order: cache → RAM → swap → disk → logs (collected RAM first; host was kept powered in Ep21).
- Imaged with `dd`; `sha256sum` of source and image **match** → unaltered. Original write-protected.

## 2. Analysis (on the copy)
| Artifact | Tool | Finding |
|---|---|---|
| Processes | Volatility 3 | malicious process + parent (from the dropper) |
| Network | Volatility | C2 connection to the Ep13 attacker host |
| Files/registry | Autopsy/TSK | dropped payload in %APPDATA%; Run-key persistence |
| Timeline | Autopsy | execution lines up with the Ep13 brute-force success |

## 3. Chain of custody
| Item | Collected by | Date/time | Storage | Handoffs |
|---|---|---|---|---|
| RAM image | A. Analyst | 2026-10-31 09:50 | evidence safe, tagged E-01 | A.Analyst → Legal (signed) |
| Disk image | A. Analyst | 2026-10-31 10:10 | evidence safe, tagged E-02 | — |

## 4. Conclusions
Evidence corroborates the Ep13 timeline: brute force → execution → persistence → C2. Images
are hash-verified and the chain is unbroken, so findings are admissible.

## 5. Reflection (own words)
Analysing the *copy* and keeping hashes equal is the whole game — one edit to the original
and a defence lawyer sinks the evidence. The chain-of-custody form is as important as the analysis.
