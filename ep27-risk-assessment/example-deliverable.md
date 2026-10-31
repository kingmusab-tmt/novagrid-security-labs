# Risk Register & Treatment Plan — Episode 27 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## Risk register (excerpt)
| ID | Risk | L | I | Inherent | Existing controls | Residual | Treatment | Owner |
|---|---|---|---|---|---|---|---|---|
| R1 | Wallet breach via phishing | 4 | 5 | 20 (High) | MFA, awareness, SIEM | 8 (Med) | Mitigate (continue + phishing sims) | SOC Lead |
| R2 | Ransomware | 3 | 5 | 15 (High) | 3-2-1 backups, EDR | 6 (Med) | Mitigate + transfer (cyber insurance) | CISO |
| R3 | Vendor compromise | 3 | 4 | 12 (Med) | vendor review | 8 (Med) | Mitigate (Ep28) + contract clauses | Compliance |
| R4 | Legacy app can't do MFA | 2 | 3 | 6 (Low) | compensating controls | 4 (Low) | Accept (signed by CFO) | CFO |

## Quantitative example (R1)
- AV = N200,000,000 (wallet exposure);  EF = 0.3 → **SLE = N60,000,000**.
- ARO = 0.5 (once every two years) → **ALE = N30,000,000/yr**.
- A N5,000,000/yr control programme that cuts ARO to 0.1 reduces ALE to N6,000,000 — a
  N24,000,000 annual reduction for N5,000,000: justified.

## Risk appetite / acceptance
Accepted risks require written sign-off by the risk owner (here, CFO for R4). Residual risks
above appetite go to the board.

## Reflection (own words)
Putting money on R1 (ALE) turned "phishing is bad" into "a N5M programme saves N24M" — that's
the language the board funds. Residual risk (after MFA/SIEM) is what you actually carry.
