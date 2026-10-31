# Environment — Episode 4
Two hosts from the shared stack: wallet-API (log source) and logging (collector). On the
collector, enable rsyslog TCP input (`imtcp`, port 514); on the source, add a forwarding
rule (`*.* @@collector:514`). Ensure both run NTP (`timedatectl`/`chronyc`). Set retention
in `/etc/logrotate.conf` or per-service. Optional: install `lnav` for nicer log browsing.
