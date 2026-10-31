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

## Concept Explanation — asset management & least privilege

Before you can defend a network you have to know **what's on it** and **who can touch it**. This
is the **IDENTIFY** function of the NIST Cybersecurity Framework, and every later control
(hardening, monitoring, incident response) assumes you've already done it. The job is
**reconciliation**: compare what *is* live hosts, running services, real accounts against what
*should be*, recorded in the asset register and the staff roster. The gaps are your risks.

**Key terms**
- **Asset inventory**: a maintained record of every hardware, software and data asset an
  organisation owns. You can't patch, monitor or protect what you don't know exists.
- **Shadow asset**: a live system nobody recorded or owns (NovaGrid's forgotten `legacy-billing`
  box). Unpatched and unmonitored, it's a favourite way in for attackers.
- **Least privilege**: the principle that every account or process gets *only* the rights it needs
  to do its job, and no more. It limits the blast radius when an account is misused or compromised.
- **Orphaned account** — an account no longer tied to a current person or purpose (e.g. a leaver who
  still has access). A standing door with nobody left to close it.
- **Over-privileged account**: an account holding more rights than its role needs, such as a backup
  service account granted full passwordless `sudo`.
- **Service account**: a non-human account used by software or automation. Because it often runs
  unattended with elevated rights, it must be tightly scoped and documented.

## Scope & rules of engagement
- **In scope:** your NovaGrid lab (analyst VM + the shared target containers). Authorised internal audit.
- **Out of scope:** scanning anything outside your lab subnet.

## Environment setup

You use the shared NovaGrid lab (`lab-env`): an **analyst** toolbox plus three targets — the
**wallet-api** server, the **logging** collector, and **legacy-billing**, a forgotten box
nobody recorded. Everything in Episode 1 is **read-only enumeration** — you change nothing.
The lab network is `172.28.0.0/24`.

**1. Start the lab** (from the repo root):
```bash
cd lab-env && docker compose up -d --build
bash scripts/check-lab.sh          # every service should say OK
```
(Full lab guide: [lab-env/README.md](../lab-env/README.md).)

**2. Know which shell to use — two shells, two jobs:**
- **`analyst`** → `docker compose exec analyst bash`. Your scanning toolbox. Use it **only for Step 1** (nmap across the network).
- **`wallet-api`** → `docker compose exec wallet-api bash`. The server you're auditing. Run **Steps 2–4 here** (services, packages, accounts, sudo, files). The account/sudo/roster data lives only on this host — running those on `analyst` returns nothing.

**Tools:** `ip`, `ss`, `nmap`, `ps`, `dpkg`, `getent`, `sudo`, `chage`. The Docker containers have
**no `systemctl`** (no systemd) — use `ps`/`ss` for services. `systemctl` and `lastlog` work on a
normal, non-container system (a regular VM or server).

**Key reference files on wallet-api:** `/srv/hr/asset-register.csv` (the official inventory) and
`/srv/hr/staff-roster.csv` (who should have access).

## Guided investigation

Follow the steps in order. Each sub-step is one command; read the note, then answer the **Decision**.

### Step 1 — Map the network *(from the analyst toolbox)*

**a.** Open a shell on the analyst box (your scanning toolbox):
```bash
docker compose exec analyst bash
```

**b.** Discover the live hosts and the services they expose:
```bash
nmap -sV 172.28.0.0/24
```
> **Question:** this scan takes a while to finish. Why do you think it's slow, and what could you
> change to make it faster? *(Hint: a `/24` is 254 addresses and almost all are empty; think about
> DNS lookups and timing. Faster: `nmap -sV -n -T4 172.28.0.0/24`, or once you know the live hosts,
> scan only those.)*

**c.** Look at what a host is listening on, using the current host's own sockets:
```bash
ss -tulpn
```
> From the analyst box this shows almost nothing (it runs no services) — the `nmap` result above is
> your network-wide view. You'll inventory the *server's* listening services in Step 2 on wallet-api.

**Decision:** Which hosts are alive, which services are listening, and are any of them services that shouldn't be exposed?

### Step 2 — Inventory software & services *(on the wallet-api server)*

**a.** Leave the analyst shell:
```bash
exit
```

**b.** Open a shell on the wallet-api server:
```bash
docker compose exec wallet-api bash
```

**c.** Inventory what's **running**, what's **listening**, and what's **installed**:
```bash
ps -ef            # running processes / services
sudo ss -tulpn    # listening services + the process behind each port
dpkg -l           # installed packages
```
> These containers have no `systemctl`. On a normal, non-container system (a regular VM or server)
> you'd list running services with `systemctl list-units --type=service --state=running` instead —
> the same information, just via systemd.

**Decision:** Anything unexpected, unknown, or clearly outdated?

### Step 3 — Enumerate accounts *(on wallet-api — you're still in its shell)*

**a.** List the accounts and their login shells:
```bash
getent passwd
```

**b.** See who holds administrator rights:
```bash
getent group sudo
sudo cat /etc/sudoers.d/*
```

**c.** Check password age and compare every account against the staff roster:
```bash
chage -l webadmin
cat /srv/hr/staff-roster.csv
```
> On a freshly built lab `lastlog` shows everyone "Never logged in", so judge staleness by **password
> age (`chage -l`)** and the **roster**, not `lastlog`. An account on the box but *not* on the roster
> is your red flag.

**Decision:** Which accounts are orphaned (not on the roster), stale (old password), shared, or hold
sudo they don't need?

### Step 4 — Rate criticality *(your analysis — no host needed)*

**a.** Compare the live hosts from Step 1 against the official inventory:
```bash
cat /srv/hr/asset-register.csv
```

**b.** Tag each asset with a criticality rating; the wallet API is the crown jewel.

**Decision:** What's your criticality rating per asset, and why?

### Evidence checkpoints
- [ ] `nmap -sn` + `ss -tulpn` output  - [ ] running-services + package list  - [ ] accounts + sudo + `chage -l` + roster comparison  - [ ] the finished inventory table

## Commands explained

You'll understand your findings far better if you know what each command actually does:

| Command | What it does | Why you run it here |
|---|---|---|
| `ip addr` (`ip -br a`) | shows your host's network interfaces and IP addresses | learn your own address and which subnet to scan |
| `nmap -sV <subnet>` | finds live hosts and the service + version on each | your first network inventory (thorough, but slow across a /24) |
| `nmap -sV -n -T4 <subnet>` (or scan only live IPs) | same scan with no DNS (`-n`) and faster timing (`-T4`) | cut the scan time dramatically |
| `ss -tulpn` | lists listening **t**cp/**u**dp sockets with the **p**rocess and port **n**umbers | inventory the services a host is actually running |
| `ps -ef` | lists every running process | see running services (the container has no `systemctl`) |
| `dpkg -l` | lists installed Debian/Ubuntu packages | inventory installed software and spot outdated packages |
| `getent passwd` | prints the user database (name, UID, login shell) | enumerate accounts; a `/bin/bash` shell means it can log in |
| `getent group sudo` | shows the members of the `sudo` group | find who holds administrator rights |
| `sudo cat /etc/sudoers.d/*` | shows the extra sudo rules dropped in by packages/admins | spot over-privilege, e.g. `NOPASSWD: ALL` on a service account |
| `chage -l <user>` | shows password-ageing info for an account | find stale accounts (password untouched for months) |

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
