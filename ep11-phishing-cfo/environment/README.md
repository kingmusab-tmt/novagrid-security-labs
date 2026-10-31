# Environment — Episode 11

This episode is **light: no heavy VM required**. You can work it on your analyst VM,
a Linux box, or Windows + WSL.

## What's provided
- `data/phishing-sample.eml` — the reported email (raw, headers included). **Start here.**
- `data/NovaGrid_Payment_Advice.html` — the decoded attachment, provided so you can hash
  and inspect it without an email client. It is **inert** and uses a fictional domain.

## Tools to have ready
- Terminal with `python3`, `file`, `strings`, `sha256sum`
- A browser for OSINT enrichment:
  - VirusTotal — https://www.virustotal.com
  - URLhaus / ThreatFox (abuse.ch) — https://urlhaus.abuse.ch · https://threatfox.abuse.ch
  - AbuseIPDB — https://www.abuseipdb.com
- Optional sandbox for URL/attachment behaviour: **Any.Run** (free) — https://app.any.run

## Safety
Do **not** open the attachment in a browser as a live page, visit the phishing URL
normally, or submit real credentials. Analyse statically; detonate only in a sandbox.

## Stretch (real data)
1. Grab a current malspam exercise (email + pcap) from
   https://www.malware-traffic-analysis.net — the "traffic analysis exercises" and the
   blog's malspam entries include the email, the pcap, and the IOCs.
2. Open the pcap in **Wireshark**; follow the stream to the payload delivery.
3. (Advanced) Ingest a real phishing dataset into **Splunk** — the Boss of the SOC
   BOTSv1/v3 data includes email/web events you can pivot on.
