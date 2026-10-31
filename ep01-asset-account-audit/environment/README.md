# Environment — Episode 1
Use the shared NovaGrid lab (`lab-env`): your **analyst** toolbox plus three targets — the
**wallet-api** server, the **logging** collector, and **legacy-billing**, a forgotten box
nobody recorded. Start it as shown below. Everything in Episode 1 is **read-only
enumeration** — you make no changes. The lab network is `172.28.0.0/24`.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- **Step 1 — scan from the analyst toolbox:** `docker compose exec analyst bash`, then
  `nmap -sn -n 172.28.0.0/24` to find live hosts (add `-sV` only on the few live hosts — it's slow across a whole /24).
- The official inventory is `/srv/hr/asset-register.csv` and the staff list is `/srv/hr/staff-roster.csv` (both on wallet-api).
- **Steps 2–4 — on wallet-api:** `docker compose exec wallet-api bash` (services, packages, accounts, sudo, the files above). The account/sudo/roster data exists only here, not on `analyst`.
