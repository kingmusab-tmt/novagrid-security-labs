# Environment — Episode 5
Analyst VM + shared hosts. Read entitlements with `getent passwd`, `getent group`,
`sudo cat /etc/sudoers /etc/sudoers.d/*`, `lastlog`, `id <user>`. Make reversible changes
on the VM (e.g. `gpasswd -d user sudo`) and record before/after. No production systems.
