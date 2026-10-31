# Environment — Episode 10
Analyst VM with a "leaver" account to offboard (create one if needed: `sudo useradd -m -s
/bin/bash contractor && sudo usermod -aG sudo contractor`). Offboarding commands (reversible):
`sudo usermod -L contractor` (lock), `sudo usermod -s /usr/sbin/nologin contractor`,
`sudo gpasswd -d contractor sudo`, remove `~/.ssh/authorized_keys`, `sudo chage -E 0 contractor`.
Capture before/after proof into `evidence/`.
