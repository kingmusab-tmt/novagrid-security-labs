# Instructor Answer Key — Episode 25
- Zones: public/DMZ, app, data (PII/cardholder = most protected), management, user; default-deny between zones.
- Zero trust (NIST 800-207): no trust by network location; verify explicitly (identity+device+MFA); least-privilege per-request; assume breach + microsegmentation of east-west traffic.
- Must show the DMZ web host has NO direct path to the data zone (kills Ep13 pivot).
- Verification: (1) zones + default policy; (2) three ZT principles applied; (3) how it stops web→wallet lateral movement.
