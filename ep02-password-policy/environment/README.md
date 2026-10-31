# Environment — Episode 2
Work on the **wallet-api** target in the shared lab (or your own throwaway Ubuntu VM if you
aren't using `lab-env`). Relevant files/tools: `/etc/login.defs`, `/etc/security/pwquality.conf`,
`pam_pwquality`, `faillock`/`pam_faillock`. All changes are reversible — never touch a shared or
production system. Capture `before` and `after` of each setting into `evidence/`.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api (`docker compose exec wallet-api bash`). Policy file: `/etc/security/pwquality.conf`; lockout goes in `/etc/pam.d/common-auth` (`pam_faillock`).
- Test as a user: `su - chidi` then `passwd`. Tunde's password is `Tunde@2024` — the breached one.
