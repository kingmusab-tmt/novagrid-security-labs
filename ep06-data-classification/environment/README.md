# Environment — Episode 6
Analyst VM with the lab's SAMPLE datasets (CSV/text). If none are present, create a tiny
synthetic set (fake names, test emails, and test card numbers like 4111 1111 1111 1111).
**Never use real personal data.** Redact matches before putting any result in the repo.
Tools: `grep -rEI`, `find`. Regex is enough — no special software.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Look in `/srv/wallet/data/`, `/srv/wallet/exports/` and `/etc/wallet/` on wallet-api — and check what `http://172.28.0.10:8000/` exposes to the network.
- All data is synthetic; card numbers are standard test numbers. Still redact anything you put in the repo.
