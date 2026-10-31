# Segmentation & Zero-Trust Design — Episode 25 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Zones
| Zone | Contents | Sensitivity |
|---|---|---|
| DMZ/Public | marketing site, WAF, reverse proxy | low |
| App | wallet API | high |
| Data | wallet DB (PII/cardholder) | **critical** |
| Management | admin/jump host, SIEM | high |
| User | staff LAN | medium |

## 2. Allowed flows (default deny)
| From | To | Allowed? | Control |
|---|---|---|---|
| Public | App (443 only) | yes | WAF + firewall |
| App | Data (DB port, app identity) | yes, restricted | microsegmentation + mTLS |
| Public | Data | **no** | firewall deny |
| User | Management | via jump host + MFA only | identity-aware proxy |

## 3. Architecture diagram
```
[Internet] -> [DMZ: WAF/reverse proxy] -> [App: wallet API] -> [Data: wallet DB (PII)]
                                             ^ mgmt via jump host + MFA (Management zone)
                       (SIEM/logging taps each boundary)   default-deny between all zones
```

## 4. Zero-trust principles applied
- Verify explicitly: every request authenticated + authorised (identity, device, MFA) regardless of network location.
- Least privilege: the app identity can reach only the DB port it needs; no broad subnet trust.
- Assume breach / microsegmentation: east-west traffic restricted, so a DMZ foothold can't reach Data directly.

## 5. How it stops the Ep13 lateral move
The web host sits in the DMZ with no route to the Data zone; reaching the wallet DB requires
the app identity over a restricted, inspected path — a defaced web box can't pivot to PII.

## 6. Reflection (own words)
Flat networks turn one foothold into full compromise. Default-deny between zones plus
identity-based access (not "you're on the LAN, you're trusted") is what breaks the kill chain.
