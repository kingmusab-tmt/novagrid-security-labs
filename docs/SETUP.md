# Setting up the NovaGrid labs

End-to-end setup: how an **instructor** prepares and hands out the labs, and how a
**student** gets the shared lab running on their own machine. For the per-episode workflow
(evidence, reports, posting), see [docs/portfolio/PORTFOLIO-GUIDE.md](portfolio/PORTFOLIO-GUIDE.md).

> **Safety first.** The lab is *intentionally vulnerable*. It runs only on a student's own
> isolated VM. Never run it on a work, home-production, or shared network, and never expose
> its ports.

---

## Distribution model (recommended): one canonical repo, students fork it

The cleanest setup for a class:

1. You keep **one canonical student repo** (public), built from your private master.
2. Each student clicks **Fork** on GitHub → their own copy, which becomes their portfolio.
3. When you publish an update to the canonical repo, students pull it into their fork
   (GitHub's **"Sync fork"**, or `git pull upstream main`).

Why this and not a separate repo per student: a fork keeps a link to the canonical repo, so
your updates can flow to every student with a pull. Two unrelated repos can't do that.

**It is safe** because students fork the *sanitized* canonical repo — which has no answer keys
and none of your master's history (it starts from a single "Student copy" commit). They never
fork your master.

**The one rule that keeps forks working:** never rebuild the canonical repo with `--init`
again — a fresh `--init` makes a new root history and breaks every fork's ability to sync.
Create it once with `--init`, then **always update it with `--update`** (continuous history).

```bash
# once — create and publish the canonical repo
tools/make-student-copy.sh --out ../novagrid-labs-student --init
cd ../novagrid-labs-student && gh repo create novagrid-labs-student --public --source=. --push

# every time after — publish changes from the master (students then Sync fork / git pull)
tools/make-student-copy.sh --update ../novagrid-labs-student
cd ../novagrid-labs-student && git push
```

`--update` overwrites the instructor content and keeps the repo's history **and every student
file** (`evidence/`, `report.md`). Updates land in lab files, student work lives in `evidence/`
and `report.md`, so a student's `git pull` merges cleanly; the only conflicts are if a student
edited a lab file you also changed.

**Trade-off:** one shared forkable repo means everyone gets the **same** Episode 11 phishing
sample — you lose the per-student unique generator (`--student`). If uniqueness matters more
than easy forking, build a separate copy per student with `--student` instead, and accept that
updating them all is a per-repo job. Otherwise rely on the "own words" reflections, the
verification questions, and each student's own lab evidence for authenticity.

**Mid-cohort:** pushing changes while students are working can be disruptive. Many instructors
freeze the canonical repo during a cohort and only `--update` it between cohorts.

---

## A. Instructor — prepare and distribute (once per cohort)

The master repo contains answer keys, worked examples and generators. **Never hand students
the master.** Build a sanitized copy instead.

**1. Make a clean student copy.** From the repo root:
```bash
tools/make-student-copy.sh --out ../novagrid-labs-student
```
The copy has **no** `answer-key.md`, `example-deliverable.md`, generators, `_instructor_answers.*`
or `tools/`. Its front page (`README.md`) becomes the portfolio **case-file template**, and the
episode index moves to `EPISODES.md`.

**2. (Optional) Unique per-student phishing sample.** So no two Episode 11 artifacts — or their
hashes — match:
```bash
tools/make-student-copy.sh --student "Jane Doe" --init
```
`--init` makes the copy a ready-to-push git repo. Repeat per student.

**3. Distribute.** Either zip the folder, or push the student copy to a GitHub repo each student
forks/clones. Since the student copy *is* their portfolio, a per-student repo they later make
public is cleanest.

---

## B. Student — one-time machine setup

Pick one path.

### Path 1 — Ubuntu analyst VM in VirtualBox (recommended)
Container IPs (172.28.0.x) route directly, so students can scan them from the VM.
1. Install **VirtualBox**; create an **Ubuntu 22.04 or 24.04** VM (4 GB RAM, ~4 GB free disk).
2. Inside that VM:
   ```bash
   sudo apt-get update && sudo apt-get install -y docker.io docker-compose-v2 git
   sudo usermod -aG docker $USER      # then log out and back in
   ```
3. **Put your copy of the repo *inside the VM*** (not on your Windows/macOS host — Docker runs in the VM):
   ```bash
   git clone <your-student-repo-url>      # or copy/unzip the folder your instructor gave you
   cd <repo>/lab-env
   ```
   The repo is your working tree: Docker builds the lab from `lab-env/`, and you write your
   reports and drop evidence into the `epNN-.../` folders. So it lives on the machine where
   Docker runs, not just somewhere you read it.

### Path 2 — Docker Desktop on Windows/macOS (simpler, one caveat)
1. Install **Docker Desktop** and **git** on your Windows/macOS host.
2. Put your copy of the repo **on the host** (Docker Desktop runs there):
   `git clone <your-student-repo-url>` (or unzip the folder your instructor gave you), then `cd <repo>/lab-env`.

Works fine, but Docker Desktop **can't route the 172.28.0.x container IPs** from the host. On
this path, do everything from inside the lab network:
```bash
docker compose exec analyst bash
```
`scripts/check-lab.sh` already probes from inside the network, so it works on either path.

---

## C. Student — run the lab

From the student copy's `lab-env/` folder:
```bash
docker compose up -d --build     # first build downloads Ubuntu packages (a few minutes, needs internet)
bash scripts/check-lab.sh        # every service should report OK
```
Get onto the lab network as the analyst and start Episode 1:
```bash
docker compose exec analyst bash
nmap -sn 172.28.0.0/24
```

Day-to-day controls:

| Want to… | Command |
|---|---|
| Pause (keep your changes) | `docker compose stop` |
| Resume | `docker compose start` |
| Restart a service after a config change | inside a container: `lab-restart ssh` / `rsyslog` / `cron` / `wallet-api` / `debug-server` |
| Read forwarded logs | `docker compose exec logging bash` → `/var/log/remote/<host>/` |

**Your fixes survive `stop`/`start`.** Only `docker compose down` or `scripts/reset-lab.sh`
wipes the lab back to its original weak state. So **capture evidence into each episode's
`evidence/` folder as you go** — a reset throws away your changes.

The hosts you'll meet:

| Host | IP | Role |
|---|---|---|
| wallet-api | 172.28.0.10 | the crown-jewel payment server (ssh, API :8080, a stray debug server :8000) |
| logging | 172.28.0.20 | central log collector (:514) |
| legacy-billing | 172.28.0.30 | a forgotten, unmanaged box (ssh, admin page :8081) |
| analyst | 172.28.0.5 | your toolbox (nmap, ssh, curl, dig, nc) |

Lab credentials and the full host guide are in [../lab-env/README.md](../lab-env/README.md).

---

## D. Reset between re-runs / next student
```bash
bash scripts/reset-lab.sh        # down -v, rebuild, re-check — a fresh weak baseline
```

## E. Offline / air-gapped classroom
After the first build the lab runs offline. To avoid every student needing internet on day one,
build once on a connected machine, export the images, and load them on each student machine:
```bash
# on a connected machine, from lab-env/
docker compose build
docker save novagrid/wallet-api:lab novagrid/logging:lab novagrid/legacy-host:lab novagrid/analyst:lab -o novagrid-images.tar
# on each student machine
docker load -i novagrid-images.tar
docker compose up -d           # no --build needed; images are already present
```

## Optional — full VM target (Vagrant)
A few hardening steps (auditd, kernel settings, real systemd) want a full OS rather than a
container. `lab-env/vagrant/` builds the wallet-api as a VirtualBox VM with the **same** setup,
so findings are identical:
```bash
cd lab-env/vagrant
vagrant up          # first run downloads the Ubuntu 22.04 box (~600 MB)
vagrant ssh
vagrant destroy -f  # throw it away
```

## Troubleshooting
- **Can't reach 172.28.0.x from my machine** — you're on Docker Desktop; work from
  `docker compose exec analyst bash` (see Path 2).
- **`bad interpreter` / `\r` errors** — files checked out with Windows line endings; the repo's
  `.gitattributes` prevents this, so re-clone if it appears.
- **A service won't come back** — `bash scripts/check-lab.sh`, then `docker compose logs <service>`.
- **Messed something up** — `bash scripts/reset-lab.sh`.
