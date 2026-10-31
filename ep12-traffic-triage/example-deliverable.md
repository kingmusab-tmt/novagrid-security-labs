# Network-Analysis Report — Episode 12 (worked example — illustrative)

**Analyst:** A. Analyst  **Date:** 2026-10-30  **Capture:** <MTA exercise, e.g. 2025-xx-xx>

> Illustrative model showing the method and the shape of a good answer. Your real values
> come from the pcap you were assigned — do not copy these.

## 1. Verdict & summary
**Infected.** The finance workstation (10.x.x.x) received a malicious Office document via
a web download, which fetched a second-stage executable from a compromised site, then
established HTTP(S) command-and-control beaconing at regular intervals. Recommend blocking
the delivery and C2 infrastructure and reimaging the host.

## 2. Infected host
| Field | Value |
|-------|-------|
| IP | 10.x.x.x (the only internal host making the suspicious external requests) |
| MAC / hostname | from DHCP/NBNS/Kerberos in the pcap, if present |
| How identified | it initiates the odd DNS lookups and the payload download; peers don't |

## 3. Infection chain (timeline)
| Time (UTC) | Stage | Evidence (filter / stream) |
|------------|-------|----------------------------|
| t0 | User fetches a malicious doc/link | `http.request` — GET to the delivery host, unusual User-Agent |
| t0+s | Second-stage EXE downloaded | `http.request` returning `application/x-msdownload`; Export Objects → hash |
| t0+min | C2 beaconing begins | `Follow TCP/HTTP Stream` — regular POSTs / TLS to a suspicious SNI |

## 4. Indicators of Compromise
| Type | Indicator | How found | Enrichment |
|------|-----------|-----------|------------|
| Domain | delivery domain | `dns` / `http.host` | VT/URLhaus verdict |
| URL | payload URL | `http.request.full_uri` | " |
| IP | C2 IP | `ip.addr` of the beacon | AbuseIPDB |
| File | downloaded EXE name | Export Objects → HTTP | — |
| Hash | SHA-256 of the EXE | `sha256sum` of the exported object | VT/MalwareBazaar → family |
| C2 | domain/IP + protocol | Follow Stream; beacon interval | ThreatFox |

## 5. Recommended blocks / actions
1. Block the delivery domain/URL and the C2 domain/IP at proxy, DNS and firewall.
2. Isolate and reimage the infected workstation; reset that user's credentials.
3. Sweep other hosts for the same IOCs (hash, C2) via the SIEM.

## 6. Reflection (own words)
The tell for C2 was the *regularity* — evenly spaced POSTs of similar size, which normal
browsing doesn't do. With this captured once, I'd turn the beacon pattern into a detection
(Episode 20) so we catch the next one live.

## 7. Mapping
- **MITRE ATT&CK:** T1566 (delivery), T1105 (ingress tool transfer), T1071.001 (web C2)
- **NIST CSF:** DE.AE, DE.CM · RS.AN, RS.MI
- **Security+ SY0-701:** 4.4 (packet/flow investigation), 4.6 (monitoring), 2.4 (indicators)
