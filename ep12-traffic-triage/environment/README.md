# Environment — Episode 12 (Wireshark + real pcap)

Light setup. No VM required beyond your analyst machine.

## 1. Install Wireshark
- https://www.wireshark.org/download.html (Windows/macOS/Linux). `tshark` (CLI) comes with it.

## 2. Get a real infection pcap
- Source: **https://www.malware-traffic-analysis.net** — Brad Duncan's archive of real
  malware traffic, with pcaps, the associated emails, and published answers.
- Use either the **"traffic analysis exercises"** page or a recent **blog entry** that
  includes a pcap.
- Downloads are **zip files, password: `infected`**. Unzip in a folder you control.
- **Per student:** assign each student a *different* exercise/date — their analysis (and
  IOCs) will differ, so reports can't be copied.

## 3. Safety
- The pcap only *describes* traffic — opening it in Wireshark is safe.
- Any file you **export** (File → Export Objects) is potentially live malware: hash it,
  submit the hash to VirusTotal, and **never execute it** outside an isolated sandbox.
- Don't browse to the extracted domains/URLs in a normal browser.

## 4. Enrichment sites
VirusTotal (https://virustotal.com), MalwareBazaar & URLhaus (abuse.ch), AbuseIPDB.

## Note on self-checking
malware-traffic-analysis.net publishes answers for its exercises — the instructor uses
those to verify the student's findings for whichever pcap was assigned.
