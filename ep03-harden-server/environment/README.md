# Environment — Episode 3
A disposable **Ubuntu** target you can break safely — the wallet-API host from the shared
stack or a fresh Ubuntu VM. Install Lynis: `sudo apt-get update && sudo apt-get install -y lynis auditd`.
Keep a second shell/session open while editing sshd so you don't lock yourself out. Snapshot
the VM first if you can, so you can roll back.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api. **SSH settings live in a drop-in**, `/etc/ssh/sshd_config.d/00-novagrid-lab.conf`, which overrides the main file — check what's really active with `sshd -T`.
- Restart after changes with `lab-restart ssh` (it refuses a broken config). The firewall (`ufw`) works in this container.
- To remove the debug server: delete or rename `/etc/novagrid/enable-debug-server`, then `lab-restart debug-server`.
- `auditd` and kernel hardening need a real OS — use the Vagrant VM in `lab-env/vagrant/` for those steps.
