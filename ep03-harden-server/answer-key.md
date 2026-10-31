# Instructor Answer Key — Episode 3
- Expect Lynis index to rise materially (rough baseline ~55–65 → ~75–85; exact varies).
- SSH: `PermitRootLogin no` + `PasswordAuthentication no` (keys) are the must-haves.
- Firewall: `ufw default deny incoming`, allow 443 (+22 restricted).
- Surface: remove/disable unused services; `unattended-upgrades` on; `auditd` enabled.
- Caution students to keep a session open while editing sshd (lockout risk) and to snapshot first.
- Verification: before/after index; the two SSH changes; firewall default + allowed ports.

## Ground truth in the reference lab (lab-env)
- Lynis baseline in the reference lab: **58**.
- The catch: weak SSH settings are in the **drop-in** `sshd_config.d/00-novagrid-lab.conf`, so editing only `sshd_config` seems to do nothing — `sshd -T` shows the effective values. Good teaching moment.
- Also expected: debug server on 8000 removed; root password `toor` changed / root login off; `/etc/wallet/wallet.conf` is world-readable (644) with a DB password → `chmod 640`.
