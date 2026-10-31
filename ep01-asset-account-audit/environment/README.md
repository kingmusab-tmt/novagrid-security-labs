# Environment — Episode 1
Use the shared lab: the analyst VM + the target containers (wallet API, logging, a victim
host). Start the target stack per the blueprint's Environment baseline. Everything here is
read-only enumeration — no changes. Find your lab subnet with `ip addr` (e.g. `ip -br a`).

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Scan from the analyst toolbox: `docker compose exec analyst bash` → `nmap -sV 172.28.0.0/24`.
- The official inventory is `/srv/hr/asset-register.csv` and the staff list is `/srv/hr/staff-roster.csv` (both on wallet-api).
- Review accounts as root: `docker compose exec wallet-api bash`.
