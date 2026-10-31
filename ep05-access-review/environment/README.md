# Environment — Episode 5
Analyst VM + shared hosts. Read entitlements with `getent passwd`, `getent group`,
`sudo cat /etc/sudoers /etc/sudoers.d/*`, `lastlog`, `id <user>`. Make reversible changes
on the VM (e.g. `gpasswd -d user sudo`) and record before/after. No production systems.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api. Reconcile accounts and sudo rights against `/srv/hr/staff-roster.csv` — the roster is the source of truth for who should have access.
