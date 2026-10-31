# Instructor Answer Key — Episode 3
- Expect Lynis index to rise materially (rough baseline ~55–65 → ~75–85; exact varies).
- SSH: `PermitRootLogin no` + `PasswordAuthentication no` (keys) are the must-haves.
- Firewall: `ufw default deny incoming`, allow 443 (+22 restricted).
- Surface: remove/disable unused services; `unattended-upgrades` on; `auditd` enabled.
- Caution students to keep a session open while editing sshd (lockout risk) and to snapshot first.
- Verification: before/after index; the two SSH changes; firewall default + allowed ports.
