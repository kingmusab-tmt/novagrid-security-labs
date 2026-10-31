# MFA Deployment Write-up — Episode 7 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Why MFA (factors)
| Factor | Example | Notes |
|---|---|---|
| know | password/PIN | phishable alone |
| have | TOTP app, FIDO2 key | key is phishing-resistant |
| are | fingerprint/face | device-bound |
MFA = two *different* categories; "password + security question" is two know-factors = not MFA.

## 2. Method choice by audience
| Audience | Method | Why |
|---|---|---|
| Admins | FIDO2 hardware key | strongest, phishing-resistant — they're the top target |
| Remote staff | TOTP app or push | good balance; avoid SMS |
| All staff | TOTP app | cheap, works on any phone |

## 3. Demo (TOTP on SSH)
- Installed `libpam-google-authenticator`, enrolled the user, added it to PAM + enabled
  keyboard-interactive in sshd.
- Logged in: password **then** 6-digit code required — screenshot saved.
- Saved the scratch codes to the team password manager (not on the host).

## 4. Rollout plan
Order: admins + remote first → all staff in 4 weeks. Enrolment via a short guide + helpdesk
session. Recovery: scratch codes + helpdesk re-enrol with ID check. Break-glass: one
emergency account with offline codes, monitored.

## 5. Reflection (own words)
Admins get hardware keys because they're the juiciest phishing target — and FIDO2 can't be
replayed to a fake login page the way a typed TOTP sometimes can.
