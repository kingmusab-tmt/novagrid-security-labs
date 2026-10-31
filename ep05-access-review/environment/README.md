# Environment — Episode 5
Work on the **wallet-api** target (or your own VM if not using `lab-env`). Read entitlements
with `getent passwd`, `getent group`, `sudo cat /etc/sudoers.d/*`, `id <user>`, and
`chage -l <user>` for password age. Reconcile every account against the staff roster — that,
not `lastlog` (which reads "Never logged in" on a freshly built lab), is how you spot
orphaned/stale access. Make reversible changes (e.g. `gpasswd -d user sudo`) and record
before/after. No production systems.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api. Reconcile accounts and sudo rights against `/srv/hr/staff-roster.csv` — the roster is the source of truth for who should have access.
