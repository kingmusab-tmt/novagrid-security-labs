# Environment — Episode 4
Two hosts from the shared stack: wallet-API (log source) and logging (collector). On the
collector, enable rsyslog TCP input (`imtcp`, port 514); on the source, add a forwarding
rule (`*.* @@collector:514`). Ensure both run NTP (`timedatectl`/`chronyc`). Set retention
in `/etc/logrotate.conf` or per-service. Optional: install `lnav` for nicer log browsing.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Source: wallet-api. Collector: `logging` at 172.28.0.20, already listening on 514 TCP/UDP.
- Forward by adding `/etc/rsyslog.d/90-forward.conf` on wallet-api, then `lab-restart rsyslog`. Collected logs land in `/var/log/remote/<host>/<program>.log` on the collector.
- The wallet API's web log is `/var/log/wallet/access.log` (a file, not syslog). Containers use the analyst VM's clock — check time sync there with `timedatectl`.
