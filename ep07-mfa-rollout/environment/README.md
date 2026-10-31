# Environment — Episode 7
Analyst VM. Install: `sudo apt-get install -y libpam-google-authenticator`. Run
`google-authenticator` as the user (save the scratch/recovery codes!). Add
`auth required pam_google_authenticator.so` to `/etc/pam.d/sshd` and set
`KbdInteractiveAuthentication yes` in `/etc/ssh/sshd_config`, then restart sshd.
**Keep a second SSH session open** while testing so a misconfig can't lock you out.
Any TOTP app works (Google Authenticator, Aegis, FreeOTP).

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api SSH. The TOTP module is preinstalled. Edit `/etc/pam.d/sshd` and set `KbdInteractiveAuthentication yes` in the SSH drop-in, then `lab-restart ssh`.
- You can't lock yourself out: `docker compose exec wallet-api bash` always gets you back in as root.
