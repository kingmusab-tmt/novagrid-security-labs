# Instructor Answer Key — Episode 1
> Values depend on each student's lab; grade the method.
- Services: student must use `ss -tulpn`/`nmap` and distinguish localhost-only vs exposed.
- Accounts: must check `getent passwd` shells, `sudo` group, `sudoers`, and `lastlog`.
- Classic finds to look for: a service account with a shell+sudo, a stale admin, an over-exposed port.
- Verification: (1) counts exposed services, not just all ports; (2) identifies stale/over-privileged accounts via lastlog/sudoers; (3) names the wallet API as the critical asset.

## Ground truth in the reference lab (lab-env)
- Live hosts: 172.28.0.5 analyst · 172.28.0.10 wallet-api (22, 8000, 8080) · 172.28.0.20 logging (514) · 172.28.0.30 legacy-billing (22, 8081).
- **Unmanaged asset:** legacy-billing — not in the asset register; its admin page advertises default `admin/admin`.
- **Unapproved service:** port 8000 on wallet-api (a debug file server, not in the register) — it serves the export folder, including card data.
- **Accounts:** `svc-backup` has full passwordless sudo; `webadmin` is in sudo, absent from the roster, password unchanged since 2026-01-10; `contractor` is in sudo and leaving today; root SSH login is allowed.
- Critical asset: wallet-api.
