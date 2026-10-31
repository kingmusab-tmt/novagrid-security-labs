# Credential-Stuffing Detection & Mitigation — Episode 18 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Attack identification
Stuffing: a few source IPs attempt logins across **hundreds of distinct customer accounts**,
~95% failures with a handful of successes — not many passwords against one account (brute
force) nor one common password across many (spraying).

## 2. Detection
- Logic: per source IP in a 10-min window, count distinct usernames and failure rate; flag
  if distinct_users > 50 AND failure_rate > 0.8.
- Result: 2 IPs touched ~400 accounts, 96% failures, 11 successes.
- FP handling: exclude the corporate NAT/known proxies; require the distinct-account spread
  (a busy single user won't hit hundreds of accounts).

## 3. Compromised accounts
| Account | Signal | Action |
|---|---|---|
| cust_8842 | failure→success from a stuffing IP | force reset + session revoke |
| cust_1290 | success from a new country | step-up MFA + verify |

## 4. Mitigations
| Control | Effect | User friction |
|---|---|---|
| MFA | breaks ATO even with valid password | medium (one-time setup) |
| Breached-password screening | stops reused leaked creds | low |
| Rate limiting / progressive lockout | slows the campaign | low if tuned |
| CAPTCHA / bot detection | blocks automation | medium |
| Impossible-travel / risk-based auth | catches ATO logins | low (invisible unless risky) |

## 5. Reflection (own words)
The giveaway was one IP touching hundreds of *different* accounts — that's stuffing's
fingerprint. MFA is the highest-value fix; breached-password screening stops the fuel.
