# Episode 4 — Centralized Logging & Baseline

## Cold open
> **From:** Amara Okafor (SOC Lead)
> **Subject:** We were blind last time — fix our logging
>
> During the last incident we could barely reconstruct anything because logs lived on each
> box and some weren't kept at all. Set up central logging for the important events, make
> sure timestamps line up, decide how long we keep things, and give me a few go-to queries
> so we can actually answer "who logged in / who used sudo / what failed". — Amara

## Your role & mission objectives
- **Role:** analyst building the logging & monitoring baseline.
- **Objectives:**
  1. Decide **what to log** (auth, sudo, web, firewall, audit).
  2. **Centralize** logs from the wallet host to the logging host.
  3. Ensure **time sync** and set **retention**.
  4. Build a small **query set** ("dashboard") for common questions and validate it.

## Scope & rules of engagement
- **In scope:** your lab's wallet-API host (log source) + logging host (collector).

## Environment setup
Two hosts from the shared stack: the **wallet-API** (source) and the **logging** host
(collector). Uses `rsyslog`/`journald`, `chrony`/`timesyncd`,
`logrotate`, and `journalctl`/`grep` (optionally `lnav`).

Two hosts from the shared stack: wallet-API (log source) and logging (collector). On the
collector, enable rsyslog TCP input (`imtcp`, port 514); on the source, add a forwarding
rule (`*.* @@collector:514`). Ensure both run NTP (`timedatectl`/`chronyc`). Set retention
in `/etc/logrotate.conf` or per-service. Optional: install `lnav` for nicer log browsing.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Source: wallet-api. Collector: `logging` at 172.28.0.20, already listening on 514 TCP/UDP.
- Forward by adding `/etc/rsyslog.d/90-forward.conf` on wallet-api, then `lab-restart rsyslog`. Collected logs land in `/var/log/remote/<host>/<program>.log` on the collector.
- The wallet API's web log is `/var/log/wallet/access.log` (a file, not syslog). Containers use the analyst VM's clock — check time sync there with `timedatectl`.

## Guided investigation
1. **Pick the sources & events.** auth/SSH, sudo, web access, firewall (ufw), auditd.
   - **Decision:** Which events matter for *detection* and *investigation*, and why those?
2. **Forward centrally.** Configure the wallet host's `rsyslog` to ship to the logging host (TCP/514); confirm the collector receives.
   - **Decision:** TCP vs UDP for log shipping — which do you choose and why?
3. **Time + retention.** Ensure NTP (`chrony`/`timesyncd`) so timestamps align; set `logrotate` retention.
   - **Decision:** Why does time sync matter for an investigation? What retention do you set?
4. **Build the "dashboard" queries.** Write saved queries for: failed SSH logins, sudo usage, top source IPs, web 4xx/5xx spikes.
5. **Validate.** Trigger a failed SSH login; confirm it appears **on the collector**.

### Evidence checkpoints
- [ ] rsyslog client + server config  - [ ] a centrally-collected event (screenshot)  - [ ] your query set + sample output  - [ ] retention + time-sync proof

## Deliverable
Fill `deliverable-template.md` → the **logging config** + the **sample dashboard** (queries + output).

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1047 Audit (centralised logging enables it); the logs feed the detections in Ep20
- **NIST CSF:** DETECT — DE.CM (monitoring); PROTECT — PR.PT (audit/log)
- **Security+ SY0-701:** 4.6 logging & monitoring; log aggregation; time synchronization

## Stretch goals
1. Ship the logs into **Wazuh** (single-node, Docker) and rebuild the queries as Wazuh rules/alerts — this becomes the feed for Episodes 13 & 20.
2. Add an alert for >N failed SSH logins in 5 minutes.

## Verification questions
1. Which log records failed SSH logins, and how did you confirm it reached the collector?
2. Why does time synchronization matter when reconstructing an incident?
3. What retention did you set, and what drove the number?
