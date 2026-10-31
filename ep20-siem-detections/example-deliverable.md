# Detection Pack — Episode 20 (worked example)

**Analyst:** A. Analyst  **Date:** 2026-10-30  **Scope:** NovaGrid web-server attack (BOTSv1)

> SPL below is a validated starting point against BOTSv1; confirm field names in your
> instance (see environment note). Thresholds are examples — tune to your baseline.

---
### Detection: Web vulnerability scanning (Acunetix / high-volume)
- **What it catches:** a source hammering many unique URLs, or carrying a scanner User-Agent.
- **Data source / sourcetype:** stream:http
- **SPL:**
  ```
  index=botsv1 sourcetype=stream:http
  | stats dc(uri_path) AS urls count AS hits values(http_user_agent) AS ua by src_ip
  | where urls > 100 OR like(mvjoin(ua," "), "%Acunetix%")
  ```
- **Logic:** scanners touch far more distinct paths than a human; the UA is a precise bonus signal.
- **Threshold / schedule:** urls > 100 in a 5-min window (schedule every 5 min live).
- **False-positive tuning:** allowlist known vuln-scan jobs and uptime monitors by src_ip.
- **Severity:** Medium — recon, not yet access.
- **Response:** enrich the src_ip, watch for follow-on auth attempts, consider a WAF block.
- **MITRE ATT&CK:** T1595.002
- **Validated:** returns the Acunetix source **40.80.148.42**.

---
### Detection: Admin brute force
- **What it catches:** many admin-login POSTs from one source in a short window.
- **Data source / sourcetype:** stream:http
- **SPL:**
  ```
  index=botsv1 sourcetype=stream:http uri_path="/administrator/index.php" http_method=POST
  | bin _time span=5m
  | stats count by _time src_ip
  | where count > 20
  ```
- **Logic:** humans don't submit the admin form 20+ times in 5 minutes; one source doing so is brute force.
- **Threshold / schedule:** > 20 POSTs / 5 min / src_ip.
- **False-positive tuning:** exclude the real admin's IP during known maintenance; raise threshold if noisy.
- **Severity:** High — active credential attack.
- **Response:** rate-limit/lock the admin login, block the src_ip, alert on-call.
- **MITRE ATT&CK:** T1110
- **Validated:** flags the attacker source against the Joomla `/administrator` login.

---
### Detection: Successful brute force (failure → success)
- **What it catches:** a source that was failing admin logins then gets a success.
- **Data source / sourcetype:** stream:http
- **SPL:**
  ```
  index=botsv1 sourcetype=stream:http uri_path="/administrator/index.php" http_method=POST
  | eval outcome=if(status=303 OR status=302,"success","fail")
  | stats count(eval(outcome=="fail")) AS fails count(eval(outcome=="success")) AS wins by src_ip
  | where fails > 20 AND wins > 0
  ```
- **Logic:** a redirect (303/302) after the POST indicates an accepted login; many fails then a win = cracked.
- **Threshold / schedule:** fails > 20 AND at least one success, per src_ip.
- **False-positive tuning:** validate the success signal in your data (status vs response size); adjust the `outcome` eval accordingly.
- **Severity:** Critical — the attacker is now authenticated.
- **Response:** force-reset the admin credential, kill sessions, begin IR (Episode 13 flow).
- **MITRE ATT&CK:** T1110 (+ T1190 context)
- **Validated:** returns the attacker source with fails>20 and a success.

---
### Detection: Malicious executable delivery
- **What it catches:** an `.exe` moving to/through the web server (e.g. `3791.exe`).
- **Data source / sourcetype:** stream:http (web-layer); corroborate with wineventlog/registry (host-layer)
- **SPL:**
  ```
  index=botsv1 sourcetype=stream:http uri_path="*.exe"
  | stats count by src_ip dest_ip uri_path
  ```
- **Logic:** a web server serving/receiving executables is abnormal; host logs confirm execution/persistence.
- **Threshold / schedule:** any match (then triage); schedule every 5–10 min.
- **False-positive tuning:** allowlist legitimate software-distribution paths/hosts.
- **Severity:** High.
- **Response:** isolate the host, capture the file + hash, enrich (VT/MalwareBazaar), eradicate.
- **MITRE ATT&CK:** T1105
- **Validated:** returns the `3791.exe` delivery.

---
### Detection: Defacement / attacker-infrastructure callout
- **What it catches:** requests for the defacement image or traffic to attacker infra.
- **Data source / sourcetype:** stream:http
- **SPL:**
  ```
  index=botsv1 sourcetype=stream:http (uri_path="*poisonivy*" OR dest="prankglassinebracket.jumpingcrab.com" OR dest_ip="23.22.63.114")
  | stats count by src_ip dest dest_ip uri_path
  ```
- **Logic:** IOC-based detection catches *this* actor instantly; pair with a behavioural "web content changed" monitor for strategic coverage.
- **Threshold / schedule:** any match.
- **False-positive tuning:** IOC list is specific (low FP) but narrow — review/retire IOCs over time.
- **Severity:** High — impact stage.
- **Response:** take the page offline, restore from clean backup, block the infra, open IR.
- **MITRE ATT&CK:** T1491.001
- **Validated:** returns the defacement/attacker-host traffic.
