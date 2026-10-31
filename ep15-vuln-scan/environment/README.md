# Environment — Episode 15
Scanner: Greenbone Community Edition (OpenVAS) or Nessus Essentials (free, up to 16 IPs).
Plus `nmap` (`-sV`, `--script vuln`). Targets must be **yours**: the wallet containers, or a
deliberately vulnerable VM (e.g. an old Metasploitable/Linux image or a vulnerable web app
in Docker) so the scan returns real findings to triage. Never scan systems you don't own.
