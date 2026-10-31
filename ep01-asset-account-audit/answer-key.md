# Instructor Answer Key — Episode 1
> Values depend on each student's lab; grade the method.
- Services: student must use `ss -tulpn`/`nmap` and distinguish localhost-only vs exposed.
- Accounts: must check `getent passwd` shells, `sudo` group, `sudoers`, and `lastlog`.
- Classic finds to look for: a service account with a shell+sudo, a stale admin, an over-exposed port.
- Verification: (1) counts exposed services, not just all ports; (2) identifies stale/over-privileged accounts via lastlog/sudoers; (3) names the wallet API as the critical asset.
