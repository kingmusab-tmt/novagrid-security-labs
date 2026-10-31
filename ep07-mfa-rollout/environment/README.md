# Environment — Episode 7
Analyst VM. Install: `sudo apt-get install -y libpam-google-authenticator`. Run
`google-authenticator` as the user (save the scratch/recovery codes!). Add
`auth required pam_google_authenticator.so` to `/etc/pam.d/sshd` and set
`KbdInteractiveAuthentication yes` in `/etc/ssh/sshd_config`, then restart sshd.
**Keep a second SSH session open** while testing so a misconfig can't lock you out.
Any TOTP app works (Google Authenticator, Aegis, FreeOTP).
