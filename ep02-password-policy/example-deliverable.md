# Password Policy & IAM Baseline — Episode 2 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Current state (before)
`PASS_MAX_DAYS 99999`, no pwquality installed, no lockout — effectively no policy.

## 2. Password standard
| Rule | Setting | Rationale (NIST 800-63B) |
|---|---|---|
| Minimum length | >= 14 (passphrases encouraged) | length beats complexity; longer resists guessing |
| Passphrases allowed | yes, allow spaces, full ASCII/Unicode | usability raises real-world strength |
| Breached-password screening | block known-pwned passwords | stops reuse of exposed creds (Tunde's case) |
| Rotation | no scheduled rotation; change on compromise only | forced rotation drives weak, patterned passwords |
| Lockout / throttling | faillock: 5 fails → 15-min lock | throttles online guessing |
| MFA | required for all admin + SSH/remote | password alone is not enough |

## 3. Applied changes (after)
- `pwquality.conf`: `minlen = 14`, `difok = 4`.
- `faillock`: `deny = 5`, `unlock_time = 900`.
- Documented; verified a weak/short password is now rejected.

## 4. IAM checklist
(unique accounts; least privilege; MFA on admin+SSH; team password manager; pwned screening; joiner/leaver process) — all checked with owners.

## 5. Reflection (own words)
The counter-intuitive part is dropping 90-day rotation — but forced rotation is why people
pick `Password1!`, `Password2!`. Length + breach screening + MFA is the stronger combination.
