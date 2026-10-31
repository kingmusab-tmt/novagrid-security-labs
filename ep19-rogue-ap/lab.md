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

## Scope & rules of engagement
- **In scope:** analysing a provided wireless survey and designing defences.
- **Out of scope / ethics:** do **not** deauth, jam, or attack any wireless network. This is
  assessment and defence only.

## Environment setup
Work from a **provided wireless survey** (an AP list with SSID/BSSID/channel/signal/auth) in
`environment/survey.csv`. If you have your *own* test AP and adapter you may capture a survey
with Kismet/airodump-ng — read-only, your own gear only. See `environment/README.md`.

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
