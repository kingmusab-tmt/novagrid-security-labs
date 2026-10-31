# Incident Report — Episode 13 (worked example)

**Analyst:** A. Analyst  **Date:** 2026-10-29  **Incident:** Marketing-site defacement (NovaGrid)

> Model answer based on the real BOTSv1 scenario. Confirm exact timestamps/hashes against
> your own Splunk instance — do not copy values you did not reproduce.

## 1. Executive summary
NovaGrid's public web server (`imreallynotbatman.com`, 192.168.250.70) was scanned,
brute-forced, and defaced by the Po1s0n1vy actor. The attacker first ran an Acunetix
vulnerability scan from 40.80.148.42, then brute-forced the Joomla `admin` account over
hundreds of attempts until the password `batman` succeeded. They placed and ran an
executable (`3791.exe`) and served a defacement image from attacker infrastructure
(`prankglassinebracket.jumpingcrab.com` / 23.22.63.114). No evidence of data exfiltration
in scope; priority is eradication and safe restoration of the site.

## 2. Timeline (ordered)
| Time (UTC) | Event | Evidence (sourcetype / SPL) |
|------------|-------|-----------------------------|
| *(from data)* | Acunetix vuln scan of the site | `index=botsv1 sourcetype=stream:http src=40.80.148.42` — Acunetix User-Agent; `suricata` alerts |
| *(from data)* | Brute force vs `/administrator` | `sourcetype=stream:http uri="/administrator/index.php" http_method=POST` — count by `form_data`/username |
| *(from data)* | Successful admin login (`batman`) | drop in failed pattern + successful POST; confirm the submitted password value |
| *(from data)* | `3791.exe` placed / executed | `sourcetype=stream:http "3791.exe"` and Windows logs (`wineventlog`/registry) |
| *(from data)* | Defacement image served | request for `poisonivy-is-coming-for-you-batman.jpeg` from attacker host |

## 3. Indicators of Compromise
| Type | Indicator | How found | Enrichment |
|------|-----------|-----------|------------|
| IP | 40.80.148.42 | Scanner source (Acunetix) | reputation check (AbuseIPDB/GreyNoise) |
| IP | 23.22.63.114 | Attacker content host | " |
| Domain | prankglassinebracket.jumpingcrab.com | Hosted defacement/payload | " |
| Tool | Acunetix Web Vulnerability Scanner | User-Agent in web traffic | — |
| File | 3791.exe | Uploaded/run executable | VirusTotal / MalwareBazaar |
| Hash | *(record the 3791.exe MD5 from your data / VT)* | registry/stream | VT → Po1s0n1vy |

## 4. MITRE ATT&CK mapping
| Tactic | Technique (ID) | Evidence |
|--------|----------------|----------|
| Reconnaissance | Active Scanning: Vuln Scanning (T1595.002) | Acunetix scan from 40.80.148.42 |
| Initial Access | Exploit Public-Facing Application (T1190) | Joomla admin targeted |
| Credential Access | Brute Force (T1110) | hundreds of admin POSTs; `batman` succeeds |
| Execution/Persistence | Ingress Tool Transfer (T1105) | `3791.exe` delivered |
| Impact | Defacement (T1491.001) | defacement image served |

## 5. Response
- **Contain:** block 40.80.148.42, 23.22.63.114 and `prankglassinebracket.jumpingcrab.com` at the perimeter; take the defaced page offline / into maintenance.
- **Eradicate:** remove `3791.exe` and any web shell/artifacts; reset the Joomla `admin` credential and all admin sessions.
- **Recover:** restore the site from a known-good backup predating the intrusion; patch Joomla; re-scan before going live.
- **Prevent:** lockout/rate-limit on `/administrator`, strong unique admin password + MFA, WAF rule for Acunetix-style scans, and the Episode 20 detection for admin brute force.

## 6. Reflection (own words)
The scan was easy to spot by User-Agent; the harder part was proving the brute force
*succeeded* rather than just occurred — I had to watch the response pattern change, not
just count attempts. A real-time alert on N failed admin POSTs from one source would have
caught this on day one.
