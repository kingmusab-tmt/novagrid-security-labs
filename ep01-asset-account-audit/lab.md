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
Use your analyst VM and the shared target stack (see `environment/README.md`). Tools used:
`ip`, `ss`, `nmap`, `systemctl`, `dpkg`/`rpm`, `getent`, `sudo`, `lastlog`.

## Guided investigation
1. **Map the network.** `ip addr`, then `nmap -sn <your-lab-subnet>` to find live hosts, then `sudo ss -tulpn` for listening services.
   - **Decision:** Which services are listening, and are any of them ones that shouldn't be exposed?
2. **Inventory software/services.** `systemctl list-units --type=service --state=running` and `dpkg -l` (or `rpm -qa`).
   - **Decision:** Anything unexpected, unknown, or clearly outdated?
3. **Enumerate accounts.** `getent passwd` (shells), `getent group sudo`, `sudo cat /etc/sudoers.d/*`, then `chage -l <user>` for password age and compare every account against `/srv/hr/staff-roster.csv` (who *should* have access).
   - Note: on a freshly built lab `lastlog` shows everyone "Never logged in", so don't rely on it for staleness — use **password age (`chage -l`)** and the **roster** instead. An account on the box but *not* on the roster is your real red flag.
   - **Decision:** Which accounts are orphaned (not on the roster), stale (old password, e.g. untouched since January), shared, or hold sudo they don't need?
4. **Rate criticality.** Tag each asset (the wallet API is the crown jewel).
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
