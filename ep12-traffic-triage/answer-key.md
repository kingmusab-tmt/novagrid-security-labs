# Instructor Answer Key — Episode 12

> Private. This lab uses a **real, assignable** pcap, so there is no single fixed answer —
> use malware-traffic-analysis.net's **published answers** for whichever exercise the
> student was assigned, and grade the method.

## What a correct analysis always does (regardless of the pcap)
- Identifies the infected host as the **initiator** of the suspicious DNS/HTTP, not a peer.
- Separates **delivery** (first malicious request/doc) from **payload download** (the EXE/DLL) from **C2** (post-infection beaconing).
- **Exports and hashes** the payload and enriches the hash (never executes it).
- Recognises C2 by **behaviour** — regular beacon intervals, repetitive similar-sized POSTs, or TLS to a suspicious SNI/JA3 — not just by the destination.
- Produces a block-list of domains/URLs/IPs and a host action (isolate/reimage).

## Verification-question guidance
1. Infected host = the internal IP initiating the malicious traffic; students should cite the DNS/HTTP it starts.
2. Delivery domain/URL + payload SHA-256 must match MTA's answer for that exercise (student shows the exported-object hash).
3. C2 identified by beaconing regularity / anomalous POSTs / suspicious TLS SNI — the *reasoning* is the point.

## Anti-copying
Assign a **different MTA exercise per student** (by date). Different pcap → different
infected host, domains, and hashes, so no two reports match; copied work is obvious
because its IOCs won't match the assigned capture.
