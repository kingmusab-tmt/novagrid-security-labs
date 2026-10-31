# Environment — Episode 8
Analyst VM or wallet host. Back up a sample data/config directory. Use `tar czf`,
`sha256sum ... > manifest.sha256`, and `sha256sum -c manifest.sha256` to verify. Restore
into a scratch dir (e.g. `/tmp/restore-test`) — never over live data. Schedule with `cron`.
For the "off-site" copy, a second directory/mounted volume is fine for the lab.
