# Episode 12 — Triage Suspicious Traffic (Wireshark)

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** Weird traffic from a finance workstation — pcap attached
>
> Our NDR flagged odd outbound traffic from a workstation in finance and we grabbed a
> capture. I don't want "looks suspicious" — open the pcap and tell me: which host is
> infected, how it got infected, what it downloaded, and what it's calling home to. Give
> me the IOCs so I can block them, and a short report for the record. — Amara

## Your role & mission objectives
- **Role:** analyst doing packet-level triage of a suspected infection.
- **Objectives:**
  1. Identify the **infected host** (IP, and MAC/hostname if present).
  2. Reconstruct the **infection chain**: initial delivery → payload download → C2.
  3. Extract the **IOCs**: domains, URLs, IPs, the downloaded file and its hash, C2 channel.
  4. **Enrich** the IOCs against real threat intel.
  5. Produce a **network-analysis report** with a timeline and block-list.

## Scope & rules of engagement
- **In scope:** offline analysis of the provided pcap in Wireshark; OSINT enrichment; a report.
- **Out of scope:** visiting the malicious domains in a normal browser, or running any
  extracted file outside an isolated sandbox.
- **Defensive framing:** you are reading recorded traffic. Export files to hash them;
  never execute them.

## Environment setup
See `environment/README.md`. In short: install **Wireshark**, then download a real
infection pcap from **malware-traffic-analysis.net** (zips are password `infected`).
Work offline once you have the pcap.

## Guided investigation
Work it the way a network analyst does. For each step, note your **filter**, the
**finding**, and the **decision**.

1. **Get the lay of the land.** *Statistics → Protocol Hierarchy* and *Statistics →
   Conversations*. Set the time column to UTC.
   - **Decision:** Which internal IP is doing the suspicious talking (the infected host)? What protocols dominate?

2. **DNS first.** Filter `dns`. Look for odd lookups — random-looking names, rare TLDs, many failed resolutions.
   - **Decision:** Which domain(s) look malicious, and which resolved to what IP?

3. **The delivery.** Filter `http.request` (and check `tls.handshake.extensions_server_name` for HTTPS). Look for the first odd request — an unusual `User-Agent`, a download of an `.exe`/`.dll`/macro doc, a Content-Type that doesn't match the extension.
   - **Decision:** What was downloaded, from where, and does the file type match its name?

4. **Extract and hash the payload.** *File → Export Objects → HTTP*, save the suspicious object, then hash it (`sha256sum`). **Do not run it.**
   - **Decision:** What is the SHA-256, and what does enrichment (VirusTotal / MalwareBazaar) say it is?

5. **Find the C2.** *Follow → HTTP/TCP Stream* on the post-infection traffic; look for beaconing (regular intervals), odd POSTs, or TLS to a suspicious SNI/JA3.
   - **Decision:** What is the command-and-control channel (domain/IP, protocol), and how often does it beacon?

6. **Assemble & recommend.** Build the timeline and the block-list.
   - **Decision:** What do you block first, and what do you tell the endpoint team to do with the host?

### Evidence checkpoints
Save to `evidence/`:
- [ ] Protocol Hierarchy / Conversations screenshot (showing the infected host)
- [ ] The malicious DNS or HTTP request
- [ ] The exported payload's `sha256sum` output
- [ ] One enrichment result (VirusTotal / MalwareBazaar / URLhaus)
- [ ] Your IOC list and timeline

## Deliverable
Fill `deliverable-template.md` → a **Network-Analysis Report**: infected host, infection
chain, IOC table, C2, timeline, and recommended blocks. See `example-deliverable.md`.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** T1566 (phishing delivery), T1105 (ingress tool transfer), T1071.001 (web C2), T1568 (dynamic resolution / DGA, if present)
- **NIST CSF:** DETECT (DE.AE, DE.CM) · RESPOND (RS.AN, RS.MI)
- **Security+ SY0-701:** 4.4 (investigate using data sources — packet captures, flow), 4.6 (monitoring), 2.4 (malware/attack indicators)

## Stretch goals (more real tooling)
1. **CLI analysis.** Re-extract the IOCs with `tshark` (e.g. `tshark -r capture.pcap -Y http.request -T fields -e http.host -e http.request.uri`).
2. **Security Onion / Zeek.** Replay the same pcap through Security Onion and compare what Suricata/Zeek surface vs. your manual read.
3. **JA3.** If C2 is over TLS, compute the JA3 hash and check it against threat intel.

## Verification questions (instructor sign-off)
1. What is the infected host's IP, and how did you conclude it was the victim (not a peer)?
2. What domain/URL delivered the payload, and what is the SHA-256 of the extracted file?
3. What is the C2 channel, and what in the traffic tells you it's C2 rather than normal browsing?
