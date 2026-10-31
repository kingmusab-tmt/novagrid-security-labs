# NovaGrid Lab Environment

The shared, **intentionally vulnerable** lab used by Season 1 (Episodes 1–10) and reused later.
It recreates a slice of NovaGrid: the wallet API server, a central log collector, a forgotten
legacy host, and an analyst toolbox — all on a private network inside your analyst VM.

> **Lab use only.** These systems are deliberately weak. Run them only on your own analyst VM.
> Never publish their ports, never run them on a shared or work network.

## What you get

| Host | IP | Ports | Role in the story |
|---|---|---|---|
| `wallet-api` | 172.28.0.10 | 22 ssh · 8080 wallet API · 8000 debug server | NovaGrid's crown-jewel payment server (default install, never hardened) |
| `logging` | 172.28.0.20 | 514 syslog (tcp/udp) | Central log collector — receives nothing until you configure forwarding |
| `legacy-billing` | 172.28.0.30 | 22 ssh · 8081 admin page | An old box nobody remembers owning |
| `analyst` | 172.28.0.5 | — | Your toolbox inside the lab network (nmap, ssh, curl, dig, nc) |

Optional: `vagrant/` builds the same wallet-api as a **full Ubuntu VM** (192.168.56.10) for
hardening steps that need a real OS (auditd, kernel settings, systemd).

## Requirements

- An **Ubuntu analyst VM in VirtualBox** (22.04 or 24.04) — 4 GB RAM recommended, ~4 GB free disk.
- Docker Engine + the Compose plugin inside that VM:
  ```bash
  sudo apt-get update && sudo apt-get install -y docker.io docker-compose-v2
  sudo usermod -aG docker $USER     # then log out and back in
  ```
- Internet for the **first build only** (it downloads Ubuntu packages). After that the lab runs offline.

## Start, check, stop, reset

From this `lab-env/` folder:

```bash
docker-compose up -d --build     # first build takes a few minutes
bash scripts/check-lab.sh        # every service should say OK
docker compose stop              # pause — your changes are kept
docker compose start             # resume
bash scripts/reset-lab.sh        # wipe ALL your changes and start fresh
```

Your fixes survive `stop`/`start`. `reset-lab.sh` (or `docker compose down`) returns the lab
to its original weak state — handy for re-running an episode or starting a new student.

## How you work in the lab

| You want to… | Do this |
|---|---|
| Scan / test from the network | `docker compose exec analyst bash` (or from your VM directly: `nmap 172.28.0.0/24`) |
| Administer the wallet server as root | `docker compose exec wallet-api bash` |
| Log in like a user over SSH | from the analyst shell: `ssh tunde@172.28.0.10` |
| Restart a service after a config change | inside wallet-api: `lab-restart ssh` · `lab-restart rsyslog` · `lab-restart cron` · `lab-restart wallet-api` · `lab-restart debug-server` |
| Read the collected logs | `docker compose exec logging bash` → `/var/log/remote/<host>/` |

Containers have no `systemctl`, so use `lab-restart`. It refuses to restart SSH if your config
has an error, so you can't lock yourself out — and `docker compose exec wallet-api bash` always
gets you back in as root even if SSH is broken.

## Lab credentials (fake, lab only)

| Account | Password | Notes |
|---|---|---|
| `root` (wallet-api) | `toor` | yes, root SSH login is allowed — that's a finding |
| `tunde` | `Tunde@2024` | the reused password from Episode 2's story |
| `amara`, `chidi`, `svc-backup`, `webadmin`, `contractor` | `NovaGrid!2026` | |
| `root` (legacy-billing) | `admin` | |

Reference files on wallet-api: `/srv/hr/staff-roster.csv` (who should have access) and
`/srv/hr/asset-register.csv` (the official inventory).

## Which episodes use what

| Episode | What you do in the lab |
|---|---|
| 1 Asset & account audit | scan 172.28.0.0/24, compare with the asset register, review accounts |
| 2 Password policy | fix `pwquality` and add `faillock` on wallet-api |
| 3 Harden the server | Lynis before/after, SSH, firewall (ufw), disable the debug server; auditd → Vagrant VM |
| 4 Central logging | forward wallet-api → logging, build queries on `/var/log/auth.log` and `/var/log/wallet/access.log` |
| 5 Access review | reconcile accounts and sudo against the staff roster |
| 6 Data classification | find PII and card data on wallet-api (and what the debug server exposes) |
| 7 MFA | enable TOTP for SSH on wallet-api |
| 8 Backup & restore | back up `/srv/wallet` + `/etc/wallet` to `/backup` and `/offsite`, restore-test |
| 10 Offboarding | offboard the `contractor` account |

## Optional: full VM (Vagrant)

Install VirtualBox and Vagrant on the host, then:

```bash
cd lab-env/vagrant
vagrant up       # downloads the Ubuntu 22.04 box on first run
```

The VM runs the same `targets/wallet/setup.sh`, with real systemd, so use `systemctl` there
instead of `lab-restart`. `vagrant destroy -f` throws it away.

## Troubleshooting

- **Can't reach 172.28.0.x from my machine** — you're probably on Docker Desktop (Windows/macOS),
  which doesn't route container IPs. Work from `docker compose exec analyst bash` instead.
- **`bad interpreter` / `\r` errors** — the files were checked out with Windows line endings.
  The repo's `.gitattributes` prevents this; if it still happens, re-clone the repo.
- **A service won't come back** — `bash scripts/check-lab.sh`, then `docker compose logs <service>`.
- **Messed something up** — `bash scripts/reset-lab.sh`.
