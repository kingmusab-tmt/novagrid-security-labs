# Episode 19 — Rogue Access Point at a Branch

## Cold open

*Story so far — The fight moves off the wire and into a branch office — staff connected to a fake 'NovaGrid-WiFi'.*

> **From:** Zainab Idris (Compliance)
> **Subject:** Staff joined a fake "NovaGrid-WiFi"
>
> At the Osogbo branch, people connected to what looked like our Wi-Fi and some had sessions
> hijacked. I think someone planted a rogue or "evil twin" access point. Here's the wireless
> survey — work out which AP is the rogue, how it fooled people, and how we stop this. — Zainab

## Your role & mission objectives
- **Role:** analyst doing a defensive wireless assessment.
- **Objectives:**
  1. Explain **rogue AP** vs **evil twin** and how each tricks users.
  2. From the survey, **identify the rogue/evil-twin** (SSID, BSSID/MAC, channel, signal, encryption).
  3. Explain the **risk** (MITM, credential/session theft on open or spoofed Wi-Fi).
  4. Design **detection and prevention** controls.

## Concept Explanation — rogue access points & evil twins

Wireless trust is fragile: a laptop can be tricked into joining an attacker's access point that
simply *looks* like the real one. A **rogue AP** is any unauthorised AP on your network; an **evil
twin** is an impostor that clones a legitimate SSID to lure clients, then sits in the middle of their
traffic. You identify it by comparing a site survey against the list of authorised APs — the SSID may
match, but the hardware address, vendor, channel or encryption won't.

## Scope & rules of engagement
- **In scope:** analysing a provided wireless survey and designing defences.
- **Out of scope / ethics:** do **not** deauth, jam, or attack any wireless network. This is
  assessment and defence only.

## Environment setup
Work from a **provided wireless survey** (an AP list with SSID/BSSID/channel/signal/auth) in
`environment/survey.csv`. If you have your *own* test AP and adapter you may capture a survey
with Kismet/airodump-ng — read-only, your own gear only.

Primary material: `survey.csv` (a wireless site survey) plus the authorised-AP list in the
lab. Compare the two to find the impostor. No wireless attacking of any kind — assessment
only. If you own a test AP + a monitor-mode adapter, you may capture your *own* survey with
Kismet/airodump-ng (read-only), but it is not required.

## Guided investigation
1. **Concepts.** Rogue AP (unauthorised AP on your network) vs evil twin (impostor copying a
   legit SSID to lure clients).
   - **Decision:** Which one matches "fake NovaGrid-WiFi"?
2. **Spot the rogue.** Compare the survey against the list of **authorised** APs. Look for a
   duplicate SSID with a different BSSID/vendor, odd channel, unexpected location/signal, or
   weaker/open encryption.
   - **Decision:** Which BSSID is the impostor, and what tells you?
3. **Assess risk.** What can the operator do to clients that associate (MITM, captive-portal credential harvest, session theft)?
   - **Decision:** Why did WPA2-Personal / open Wi-Fi make this easy?
4. **Defend.** Design controls: WPA3/802.1X (enterprise auth), wireless IDS / rogue-AP
   detection, client config (don't auto-join open SSIDs, validate server certs), and staff awareness.
   - **Decision:** Which single control would have prevented the evil twin working?

### Evidence checkpoints
- [ ] rogue vs evil-twin explanation  - [ ] the identified rogue BSSID + reasoning  - [ ] risk assessment  - [ ] the control set

## Key terms & frameworks

**Core terms**
- **SSID vs BSSID** — the network *name* (easily copied) vs the AP's *MAC address* (the hardware identity). A duplicate SSID with an unfamiliar BSSID is the tell.
- **Rogue AP** — an unauthorised access point attached to your network (even a well-meaning employee's).
- **Evil twin** — an impostor AP broadcasting a trusted SSID to harvest credentials or man-in-the-middle clients.
- **MITM (man-in-the-middle)** — the attacker relays and can read/alter traffic between client and the real service.
- **Captive-portal harvesting** — a fake "sign-in to Wi-Fi" page that steals credentials.

**How you spot the impostor in the survey** — against the authorised-AP list, look for: a duplicate
SSID with a **different BSSID/vendor**, an **unexpected channel**, an **odd location or signal
strength**, or **weaker/open encryption** than the real network uses.

**Defensive frameworks**
- **WPA2-Personal vs WPA3 / 802.1X (WPA-Enterprise)** — a shared Wi-Fi password lets anyone stand up a convincing twin; **802.1X/EAP** authenticates the *network to the client* (via a server certificate) and each user individually, which is what actually defeats an evil twin.
- **WIDS/WIPS** — Wireless Intrusion Detection/Prevention Systems that detect and can contain rogue APs.
- **Client hardening** — don't auto-join open SSIDs, validate the server certificate, forget networks after use.
- **The single most effective control:** enterprise authentication (802.1X with server-cert validation), because the fake AP can't present the real network's certificate.

## On Windows

Windows can run the wireless survey natively:
```powershell
netsh wlan show networks mode=bssid     # SSIDs with their BSSIDs, signal, channel, encryption
netsh wlan show interfaces              # what you're connected to
```
Compare the BSSIDs against the authorised-AP list exactly as in the lab — a duplicate SSID with an
unfamiliar BSSID/vendor, odd channel, or weaker encryption is your evil twin. The defences (WPA3 /
802.1X enterprise auth, WIDS/WIPS, validating the server certificate, not auto-joining open SSIDs) are
the same.

## Deliverable
Fill `deliverable-template.md` → the **wireless assessment report**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** T1557 (adversary-in-the-middle), T1200 (hardware additions)
- **MITRE ATT&CK Mitigations:** M1037 Filter Network Traffic, M1030 Network Segmentation, 802.1X/network access control
- **NIST CSF:** PROTECT — PR.AC/PR.PT; DETECT — DE.CM
- **Security+ SY0-701:** 2.x wireless attacks (rogue AP, evil twin); 3.x secure wireless (WPA3, 802.1X, EAP)

## Stretch goals
1. Specify an **802.1X/EAP-TLS** design so clients authenticate the network (stops evil twins).
2. Describe how a **WIDS** would alert on a duplicate-SSID/BSSID anomaly.

## Verification questions
1. Difference between a rogue AP and an evil twin?
2. Which survey attributes identified the impostor BSSID?
3. What single control best prevents an evil-twin attack, and why?
