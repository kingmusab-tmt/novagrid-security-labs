# Server-Hardening Report — Episode 3 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Host:** wallet-api

## 1. Baseline
- Lynis hardening index (before): ~56
- Top weaknesses: root SSH allowed, password auth on, no firewall, no auditd, updates manual.

## 2. Changes applied
| Area | Change | Why | Evidence |
|---|---|---|---|
| SSH | PermitRootLogin no; PasswordAuthentication no (keys only) | removes brute-forceable root/password login | sshd_config diff |
| Firewall | ufw default deny in; allow 443, and 22 from admin subnet | minimal inbound surface | `ufw status` |
| Services/updates | removed unused services; enabled unattended-upgrades | fewer listeners; auto-patch | service list diff |
| Auditing | enabled auditd + rules on /etc/passwd, sudoers, auth | records key changes | `auditctl -l` |

## 3. Result
- Lynis hardening index (after): ~78
- Residual: some kernel-hardening items deferred (app compatibility) — tracked.

## 4. Reflection (own words)
Biggest single win was turning off password SSH + root login — that alone kills the attack
from Episode 13. I kept a second session open while editing sshd so I didn't lock myself out.
