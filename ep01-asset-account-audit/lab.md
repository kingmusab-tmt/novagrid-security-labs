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
bash scripts/check-lab.sh   # every service should say OK
docker compose start        # start containers 
docker compose stop         # stop containers once you are done
docker compose ps           # check running containers services
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

## Instructions

Work through each task **in order**. Every lettered step is one action: type the command exactly as
shown, then compare what you see to the **Expected output** below it. If your output looks different,
re-read the step before moving on. Save the files you're told to into the `evidence/` folder — those
become your report.

> Two shells: **Task 2–4 run on the `analyst` box** (your scanning toolbox); **Task 5–7 run on the
> `wallet-api` server** (the machine you're auditing). Each task says which one you're on.

### Task 1 — Start the lab

a. On your analyst VM, go to the `lab-env/` folder and start the lab:
```bash
cd lab-env
docker compose up -d
```

b. Confirm every service came up:
```bash
bash scripts/check-lab.sh
```
Expected output:
```
NovaGrid lab health check
  OK    wallet-api ssh           172.28.0.10:22
  OK    wallet-api API           172.28.0.10:8080
  OK    logging collector        172.28.0.20:514
  OK    legacy-billing ssh       172.28.0.30:22
  OK    legacy-billing admin     172.28.0.30:8081
  NOTE  debug server 172.28.0.10:8000 is OPEN (a Season 1 finding — expected until you fix it)
All core services up.
```

### Task 2 — Open the analyst shell and discover live hosts

a. Open a shell on the analyst toolbox:
```bash
docker compose exec analyst bash
```
Your prompt changes to `root@analyst:/#`. You are now **inside the analyst machine**.

b. Sweep the lab network to find which hosts are alive:
```bash
nmap -sn -n 172.28.0.0/24
```
Expected output (the order of lines may differ):
```
Nmap scan report for 172.28.0.1
Host is up (0.00001s latency).
Nmap scan report for 172.28.0.5
Host is up (0.00001s latency).
Nmap scan report for 172.28.0.10
Host is up (0.00001s latency).
Nmap scan report for 172.28.0.20
Host is up (0.00001s latency).
Nmap scan report for 172.28.0.30
Host is up (0.00001s latency).
Nmap done: 256 IP addresses (5 hosts up) scanned in 2.XX seconds
```
Five addresses answer: `172.28.0.1` is the network **gateway** (not a NovaGrid host), `172.28.0.5` is
**you** (the analyst box), and `172.28.0.10`, `.20`, `.30` are the three targets.

**Question 1:** The scan checked 256 addresses but only 5 answered. What makes a `/24` sweep slow, and
what two flags would speed it up? *(Write your answer in your report.)*

### Task 3 — Find each host's services *(still on analyst)*

a. Scan the four hosts for the service ports:
```bash
nmap -n -Pn -p 22,514,8000,8080,8081 172.28.0.5 172.28.0.10 172.28.0.20 172.28.0.30
```
Expected output (trimmed — one block per host):
```
Nmap scan report for 172.28.0.5
PORT     STATE  SERVICE
22/tcp   closed ssh
514/tcp  closed shell
8000/tcp closed http-alt
8080/tcp closed http-proxy
8081/tcp closed blackice-icecap

Nmap scan report for 172.28.0.10
22/tcp   open   ssh
514/tcp  closed shell
8000/tcp open   http-alt
8080/tcp open   http-proxy
8081/tcp closed blackice-icecap

Nmap scan report for 172.28.0.20
514/tcp  open   shell
(22, 8000, 8080, 8081 all closed)

Nmap scan report for 172.28.0.30
22/tcp   open   ssh
8081/tcp open   blackice-icecap
(514, 8000, 8080 all closed)
```
What this tells you:
- **172.28.0.5 (you / analyst):** every port **closed** — it runs no services, it's only your toolbox.
- **172.28.0.10 (wallet-api):** ssh (22), the wallet API (8080), **and a service on 8000 that shouldn't be there.**
- **172.28.0.20 (logging):** **514/tcp** — the central syslog collector (note: TCP).
- **172.28.0.30 (legacy-billing):** ssh (22) and an admin web page (8081).

b. Save this scan to evidence. Highlight/copy the output and paste it into a file:
```bash
nmap -n -Pn -p 22,514,8000,8080,8081 172.28.0.10 172.28.0.20 172.28.0.30 > /tmp/nmap.txt
cat /tmp/nmap.txt
```
(then copy `/tmp/nmap.txt` into your episode's `evidence/` folder as `01-nmap-services.txt`.)

**Question 2:** Which service looks out of place, and on which host?

### Task 4 — Investigate the suspicious port 8000 *(still on analyst)*

a. Ask the mystery service on wallet-api what it is:
```bash
curl http://172.28.0.10:8000/
```
Expected output (an HTML directory listing — the key line is):
```
<a href="old_payments_backup.csv">old_payments_backup.csv</a>
```
This is a plain file server exposing **`old_payments_backup.csv`** to anyone on the network — an
unprotected directory of old payment data. Record it as a data-exposure finding.

**Question 3:** Why is an open directory listing of a file called `old_payments_backup` a serious problem?

### Task 5 — Move to the server and inventory its services *(now on wallet-api)*

a. Leave the analyst shell:
```bash
exit
```

b. Open a shell on the wallet-api server:
```bash
docker compose exec wallet-api bash
```
Your prompt now shows the wallet-api container. **Everything from here runs on the server you're auditing.**

c. List what the server is actually running and listening on:
```bash
ss -tulpn
```
Expected output (the lines that matter):
```
tcp   LISTEN 0 128  0.0.0.0:22    0.0.0.0:*  users:(("sshd",...))
tcp   LISTEN 0 5    0.0.0.0:8080  0.0.0.0:*  users:(("python3",...))
tcp   LISTEN 0 5    0.0.0.0:8000  0.0.0.0:*  users:(("python3",...))
```
This matches your scan: ssh, the wallet API (8080), and the stray file server (8000).

d. See the installed software (it's a long list — skim it for anything odd):
```bash
dpkg -l | less
```
(press `q` to quit `less`.)

### Task 6 — Audit the accounts *(on wallet-api)*

a. List the human user accounts:
```bash
getent passwd | awk -F: '$3>=1000 && $3<65534 {print $1" ("$5")"}'
```
Expected output:
```
amara (Amara Okafor - SOC Lead)
tunde (Tunde Bello - Sysadmin)
chidi (Chidi Nwosu - CFO)
svc-backup (Backup service account - owner tunde)
webadmin (Web admin (2025 contractor))
contractor (PayBridge integration contractor)
```

b. See who holds administrator (sudo) rights:
```bash
getent group sudo
```
Expected output:
```
sudo:x:27:amara,tunde,webadmin,contractor
```

c. Check for extra sudo rules:
```bash
sudo cat /etc/sudoers.d/*
```
Expected output (the finding):
```
svc-backup ALL=(ALL) NOPASSWD: ALL
```
`svc-backup` can run **anything as root, with no password** — far more than a backup job needs.

d. Check when `webadmin` last changed its password:
```bash
chage -l webadmin
```
Expected (the key line):
```
Last password change					: Jan 10, 2026
```
That's stale — the password hasn't been touched in months.

e. Compare the accounts against who *should* have access:
```bash
cat /srv/hr/staff-roster.csv
```
Expected output:
```
username,full_name,role,status,notes
amara,Amara Okafor,SOC Lead,active,
tunde,Tunde Bello,Sysadmin,active,
chidi,Chidi Nwosu,CFO,active,
contractor,PayBridge Integration,Contractor,leaving 2026-10-31,contract ends today
svc-backup,(service account),Backup job,active,owner tunde; needs only tar and rsync
```
Notice **`webadmin` is on the server but NOT on the roster** (an orphaned account), and **`contractor`
is marked "leaving"** yet still has an account and sudo.

**Question 4:** List every problem account you found and say what's wrong with each (over-privileged,
orphaned, stale, or leaver).

### Task 7 — Compare live hosts to the official inventory *(on wallet-api)*

a. Read the asset register (the official list of NovaGrid's systems):
```bash
cat /srv/hr/asset-register.csv
```
Expected output:
```
hostname,ip,role,owner,criticality,approved_services
wallet-api,172.28.0.10,Payment wallet API,tunde,Critical,ssh(22) wallet-api(8080)
logging,172.28.0.20,Central log collector,amara,High,syslog(514)
```
b. Compare this with the live hosts from Task 2/3. The register lists only **wallet-api** and
**logging** — but you found a third live host, **legacy-billing (172.28.0.30)**, with SSH and an admin
page. It is an **unmanaged asset** nobody recorded.

**Question 5:** Which live host is missing from the register, and why is an unmanaged host dangerous?

### Task 8 — Rate criticality and write the report

a. Tag each asset with a criticality rating: wallet-api is the **crown jewel** (customer funds + PII),
legacy-billing is **high** (unmanaged + exposed), logging is **supporting**.

b. Fill in `deliverable-template.md` with your **asset inventory** (host · IP · services · owner ·
criticality) and a short **findings memo** naming: the unmanaged legacy host, the exposed `:8000`
file server, `svc-backup`'s excess sudo, the orphaned `webadmin`, and the leaver `contractor`.

### Evidence checkpoints
Save these into `evidence/`:
- [ ] `01-nmap-services.txt` — your Task 3 port scan
- [ ] the `:8000` directory listing from Task 4
- [ ] the accounts / sudo / `chage` / roster output from Task 6
- [ ] your finished inventory table

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

## On Windows

Do the same audit on the **NovaGrid Windows target** (`lab-env/windows/`) with PowerShell (run elevated).

**a.** List listening services on the box (cf. `ss -tulpn`):
```powershell
Get-NetTCPConnection -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess
```
**b.** Enumerate accounts, admins and installed software (cf. `getent` / `dpkg -l`):
```powershell
Get-LocalUser
Get-LocalGroupMember Administrators
Get-CimInstance Win32_Product | Select-Object Name,Version
```
**c.** Reconcile against the roster and spot the findings:
```powershell
Get-LocalUser | Select-Object Name,Enabled,PasswordExpires
Get-Content C:\NovaGrid\hr\staff-roster.csv
```
You should find `svc-backup` in Administrators (over-privileged), `webadmin` with a non-expiring
password and absent from the roster (stale/orphaned), and `contractor` still enabled (the leaver).
Same deliverable: inventory + findings memo. Network discovery still uses `nmap` (cross-platform).

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
