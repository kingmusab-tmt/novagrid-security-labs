# Environment — Episode 13 (Splunk + BOTSv1)

You need a running Splunk with the **Boss of the SOC v1** dataset loaded. Do this once;
it's reused in Episodes 15, 20 and 24.

## 1. Install Splunk
- On your analyst VM (or a dedicated 4 GB VM), install **Splunk Enterprise**.
- Use the **free 60-day trial**, then it converts to the **Free** license — fine for labs.
- Download: https://www.splunk.com/en_us/download/splunk-enterprise.html
- Start it, log in at `http://localhost:8000`.

## 2. Get BOTSv1
- Repo: https://github.com/splunk/botsv1
- Download the **dataset-only** package (the README links it; it is several GB).
- Pre-download once and keep it on a USB/shared drive for bandwidth-limited setups.

## 3. Load it as an app/index
- Unpack to `$SPLUNK_HOME/etc/apps/` (the package installs as an app that defines
  `index=botsv1`), then restart Splunk:
  ```
  $SPLUNK_HOME/bin/splunk restart
  ```
- Verify:
  ```
  index=botsv1 earliest=0 | stats count by sourcetype
  ```
  You should see dozens of sourcetypes and a large event count.

## 4. Time range
BOTSv1 data is from **August 2016**. Set the time picker to **All time** (or Aug 2016),
or searches return nothing.

## Tips
- Install the free **Splunk Security Essentials** app for guided searches (optional).
- Keep your own working SPL in `evidence/` as you go — those searches are part of the artifact.
- No internet needed to search once the data is loaded (handy for low-bandwidth settings).
