# Episode 1 — Asset & Account Audit

## Cold open
> **From:** Zainab Idris (Compliance)
> **Subject:** We need an asset & account list before the inspection
>
> The auditors arrive next week and we can't produce a current list of our servers,
> services, or who has accounts. Enumerate what's really there, flag anything unmanaged or
> over-privileged, and give me an inventory plus a short memo of what worries you. — Zainab

## Your role & mission objectives
- **Role:** junior analyst performing an internal asset & account audit.
- **Objectives:**
  1. Enumerate hosts, listening services, and installed software in the lab.
  2. Enumerate user accounts, groups, shells, sudo rights, and last-login.
  3. Flag unmanaged assets, stale/shared accounts, and over-privilege.
  4. Produce an asset inventory + a findings memo.

## Scope & rules of engagement
- **In scope:** your NovaGrid lab (analyst VM + the shared target containers). Authorised internal audit.
- **Out of scope:** scanning anything outside your lab subnet.

## Environment setup
Use your analyst toolbox and the shared target stack (see `environment/README.md`). Tools used:
`ip`, `ss`, `nmap`, `ps`, `dpkg`, `getent`, `sudo`, `chage`. On the Docker lab there is **no
`systemctl`** (containers don't run systemd) — use `ps`/`ss` for services; `systemctl` and
`lastlog` are available on the Vagrant VM if you use it.

**Which host do I run things on?** Two shells, two jobs:
- **`analyst`** (`docker compose exec analyst bash`) — your scanning toolbox. Use it **only** for Step 1 (nmap across the network).
- **`wallet-api`** (`docker compose exec wallet-api bash`) — the server you're auditing. Run **Steps 2–4 here** (services, packages, accounts, sudo, files). The account/sudo/roster data lives only on this host — running those on `analyst` returns nothing.

## Guided investigation
1. **Map the network** (from the **analyst** toolbox — `docker compose exec analyst bash`). `ip addr` to see your own network, then `nmap -sn -n <your-lab-subnet>` to find live hosts
   (the lab subnet is `172.28.0.0/24`). This is the *network* view — you'll capture each host's
   own listening sockets with `ss -tulpn` in Step 2, on the host itself. Tip: a `/24`
   probes 254 addresses and only a handful exist, so add **`-n`** (skip reverse-DNS, the main
   source of lag) and **`-T4`**, and once you know the live hosts, scan just those:
   `nmap -Pn -n -T4 -p 22,514,8000,8080,8081 <live-ips>`.
   - **Decision:** Which services are listening, and are any of them ones that shouldn't be exposed?
2. **Inventory software/services** (run these **on wallet-api**, the server you're auditing —
   `docker compose exec wallet-api bash`). List what's actually running with `ps -ef` and the
   listening services with `sudo ss -tulpn`; list installed packages with `dpkg -l`. (On the
   Vagrant VM you can use `systemctl list-units --type=service --state=running` instead — but
   the container has no systemd, so `ps`/`ss` are how you see services there.)
   - **Decision:** Anything unexpected, unknown, or clearly outdated?
3. **Enumerate accounts** (**on wallet-api** — you're already in its shell from Step 2). `getent passwd` (shells), `getent group sudo`, `sudo cat /etc/sudoers.d/*`, then `chage -l <user>` for password age and compare every account against `/srv/hr/staff-roster.csv` (who *should* have access).
   - Note: on a freshly built lab `lastlog` shows everyone "Never logged in", so don't rely on it for staleness — use **password age (`chage -l`)** and the **roster** instead. An account on the box but *not* on the roster is your real red flag.
   - **Decision:** Which accounts are orphaned (not on the roster), stale (old password, e.g. untouched since January), shared, or hold sudo they don't need?
4. **Rate criticality** (your own analysis — no host needed). Tag each asset (the wallet API is the crown jewel).
   - **Decision:** What's your criticality rating per asset, and why?

### Evidence checkpoints
- [ ] `nmap -sn` + `ss -tulpn` output  - [ ] running-services + package list  - [ ] accounts + sudo + `chage -l` + roster comparison  - [ ] the finished inventory table

## Deliverable
Fill `deliverable-template.md` → the **asset inventory** + **findings memo**.

## Rubric
See `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1047 Audit (account/asset reconciliation), M1018 User Account Management
- **NIST CSF:** IDENTIFY — ID.AM (asset management)
- **Security+ SY0-701:** 1.x asset management & inventory; supports 4.x operations

## Stretch goals
1. Script the inventory (one script that dumps hosts/services/accounts to a file) and schedule it with cron.
2. Diff this week's inventory against next week's to detect change.

## Verification questions
1. How many listening services did you find, and which are exposed beyond localhost?
2. Which account(s) are stale or over-privileged, and how did you tell?
3. What is the single most critical asset, and what protects it today?
