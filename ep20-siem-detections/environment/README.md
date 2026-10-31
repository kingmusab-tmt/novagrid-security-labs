# Environment — Episode 20 (reuses Episode 13)

No new environment. Use the Splunk + **BOTSv1** instance from Episode 13
(`../ep13-host-compromise/environment/README.md`).

## Saving a detection as an alert
1. Run and validate your SPL (time picker on **All time** — BOTSv1 is Aug 2016).
2. **Save As → Alert**.
3. Set **trigger** (e.g. "Number of Results > 0"), **schedule** (cron or real-time),
   **severity**, and an **action** (log / email / webhook for the write-up).
4. Note: in a real SOC you'd schedule these; on the historical BOTSv1 data you're proving
   the *logic* fires on known-bad events, then documenting the schedule you'd use live.

## Field-name note
BOTSv1 parses web traffic under `sourcetype=stream:http` with fields like `src_ip`,
`dest_ip`, `http_method`, `uri_path`, `http_user_agent`, `status`. Exact field names can
vary by Splunk/app version — if a search returns nothing, run a bare
`index=botsv1 sourcetype=stream:http | head 1` and read the real field names, then adjust.
Validating and tuning your own SPL is part of the skill.
