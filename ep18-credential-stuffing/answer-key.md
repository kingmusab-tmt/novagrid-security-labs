# Instructor Answer Key — Episode 18
- Stuffing = known user:pass pairs replayed across MANY accounts (high fail, few wins); brute force = many passwords vs ONE account; spraying = few common passwords vs many accounts (low-and-slow to dodge lockout).
- Detection signature: one source → many DISTINCT usernames + high failure rate (+ velocity/geo). FP control: exclude NATs/proxies; require the distinct-account spread.
- Compromise: failure→success from a stuffing source, or success from new geo/device → force reset + revoke sessions.
- Best single mitigation: MFA (breaks ATO even with a valid password); pair with breached-password screening + rate limiting + risk-based auth.
- Verification: (1) the three definitions; (2) detection logic + FP handling; (3) top mitigation + UX cost.
