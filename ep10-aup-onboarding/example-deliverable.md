# AUP + Joiner/Leaver Procedures — Episode 10 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## Part A — AUP (summary)
Purpose: define acceptable use of NovaGrid systems. Acceptable: business use, strong auth,
report suspicious activity. Unacceptable: credential sharing, disabling security controls,
personal crypto-mining, exfiltrating data. Monitoring notice: systems may be monitored for
security (so there's no expectation of total privacy — and it makes evidence admissible).
Consequences: up to termination/legal. Acknowledgement: signed at hire + annually.

## Part B — Onboarding
Unique account → least-privilege role → MFA enrolled → password manager issued → AUP signed.
Key step: least privilege at joining — easier to add later than to claw back.

## Part C — Offboarding
Disable (not delete) → strip sudo/groups → revoke SSH keys/tokens → rotate shared secrets →
collect laptop/badge → retain data per policy, delete after a 30-day hold.
Why disable first: preserves data/evidence and is reversible if they return or it's an error;
rotate anything they knew (shared service passwords, API tokens).

## Part D — Offboarding executed (evidence)
- Account `contractor`: `usermod -L` (locked), shell set to nologin, removed from sudo,
  `authorized_keys` cleared, account expiry set. Verified: login refused, `groups` shows no sudo.

## Reflection (own words)
The leaver problem is a process gap, not a tech gap. The disable-before-delete rule matters:
delete-first destroys evidence and is unrecoverable if the termination was a mistake.
