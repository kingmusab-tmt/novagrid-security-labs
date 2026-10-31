# Environment — Episode 8
Analyst VM or wallet host. Back up a sample data/config directory. Use `tar czf`,
`sha256sum ... > manifest.sha256`, and `sha256sum -c manifest.sha256` to verify. Restore
into a scratch dir (e.g. `/tmp/restore-test`) — never over live data. Schedule with `cron`.
For the "off-site" copy, a second directory/mounted volume is fine for the lab.

## Using the NovaGrid lab (lab-env)
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Back up `/srv/wallet` and `/etc/wallet` on wallet-api. `/backup` and `/offsite` are two separate Docker volumes — your two media/locations for 3-2-1.
- Restore-test into `/tmp/restore-test`. `cron` is running for scheduling.
