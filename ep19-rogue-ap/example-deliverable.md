# Wireless Assessment — Episode 19 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Site:** Osogbo branch

## 1. Concepts
A **rogue AP** is any unauthorised AP attached to the network; an **evil twin** is an
impostor that copies a legitimate SSID to lure clients. "Fake NovaGrid-WiFi" is an **evil twin**.

## 2. Identified impostor
| SSID | BSSID | Channel | Encryption | Why it's the rogue |
|---|---|---|---|---|
| NovaGrid-WiFi | 62:1A:9F:D4:7E:33 | 6 | **Open** | duplicate SSID but unknown/locally-administered MAC (not Cisco like the real APs), **open** auth vs WPA2-Enterprise, and a suspiciously strong signal |

## 3. Risk assessment
Clients that associate route traffic through the attacker (adversary-in-the-middle): they can
run a captive portal to harvest credentials, strip/downgrade TLS, and steal session cookies.
Open/spoofed Wi-Fi made it trivial because clients didn't authenticate the *network*.

## 4. Detection & prevention controls
| Control | What it does |
|---|---|
| WPA3 / 802.1X (EAP-TLS) | clients verify the network via certificate → evil twin can't impersonate |
| Wireless IDS (WIDS) | alerts on duplicate SSID / unexpected BSSID |
| Client policy | don't auto-join open SSIDs; validate server cert |
| Rogue-AP scans + staff awareness | find planted APs; teach staff the real SSID behaviour |

## 5. The single best preventive control (and why)
**802.1X with EAP-TLS (mutual auth):** the client authenticates the network, so an open
impostor with the same SSID can't complete the handshake — the evil twin stops working.

## 6. Reflection (own words)
The tell was the mismatched BSSID vendor and open auth under a name that should be
WPA2-Enterprise. The fix isn't a bigger password — it's making clients verify the network.
