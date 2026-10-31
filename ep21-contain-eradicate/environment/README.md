# Environment — Episode 21
Use the Ep13 compromised lab host/containers. Isolation options: `docker network disconnect
<net> <container>`, `ufw deny`/NIC down, or ACL. Review persistence: `crontab -l`, systemd
units/timers, `~/.ssh/authorized_keys`, (Windows) Run keys/services. Preserve first
(snapshot / triage copy) so Ep23 forensics still has evidence. Reversible on the lab.
