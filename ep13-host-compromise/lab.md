# Episode 13 — Host Compromise: Investigate in Splunk

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** Marketing site defaced — need the full story
>
> Our marketing site is showing a defacement image and Tunde says the box "felt slow"
> for a day before. Everything's in Splunk. I don't want a guess — I want the timeline:
> how they found us, how they got in, what they ran, and what they left behind. Give me
> an incident report with an ATT&CK mapping and what we do to eradicate and recover.
> — Amara

## Your role & mission objectives
- **Role:** Tier-2 analyst running a SIEM-based investigation.
- **Objectives:**
  1. Reconstruct the attack **timeline** across recon → brute force → exploitation → defacement/malware.
  2. Extract the **IOCs** (attacker IPs, domains, tools, files/hashes).
  3. Map the activity to **MITRE ATT&CK**.
  4. Recommend **containment, eradication and recovery**.
  5. Produce an **incident report** fit for the portfolio.

## Scope & rules of engagement
- **In scope:** searching and pivoting within the BOTSv1 data in your Splunk instance; a written report.
- **Out of scope:** interacting with any live host or the real defacement infrastructure.
- **Defensive framing:** you are the responder reconstructing events from logs — analysis only.

## Environment setup
Follow `environment/README.md` to install Splunk and load **BOTSv1**. Key points:
- The data is from **August 2016** — set your time picker to *All time* (or Aug 2016) or you'll see nothing.
- Everything lives in one index (e.g. `index=botsv1`). Start broad, then narrow by `sourcetype`.
- Useful sourcetypes in BOTSv1 include `stream:http`, `suricata`, `fgt_utm` (FortiGate),
  `iis`, `wineventlog`, `winregistry`, `xmlwineventlog`. Explore what's there:
  ```
  index=botsv1 | stats count by sourcetype
  ```

## Guided investigation
Work the kill chain. At each stage, write the **SPL you ran**, the **answer**, and the
**decision** it drives. Don't just collect facts — explain what each means for the response.

1. **Scope & reconnaissance.** NovaGrid's web server is `imreallynotbatman.com`
   (`192.168.250.70`). Find the earliest hostile activity against it.
   - *Hint:* look at web traffic and IDS for a scanner's `User-Agent` / alert signatures.
   - **Decision:** What scanning tool was used, and from which attacker IP? Is this targeted or spray?

2. **Brute force.** The site runs a CMS (Joomla) with an `/administrator` login.
   - *Hint:* count POSTs to the admin login by source and by submitted username; look for many attempts then a change in response size/behaviour.
   - **Decision:** Which account was targeted, roughly how many attempts, and did a login finally **succeed** (and with what password)?

3. **Exploitation / code execution.** After access, the attacker put code on the server.
   - *Hint:* look for an uploaded executable or web content being written/served.
   - **Decision:** What is the name of the malicious file the attacker ran/uploaded?

4. **Defacement & attacker infrastructure.** A defacement image was planted.
   - *Hint:* find the image request and the external host/domain serving attacker content.
   - **Decision:** What is the defacement image, and what domain/IP hosted the attacker's content?

5. **Malware & enrichment.** Pull any malware hash you can from the data and enrich it.
   - *Hint:* registry/sysmon/stream may surface a hash; check it on VirusTotal / MalwareBazaar.
   - **Decision:** What family/actor does the enrichment point to?

6. **Timeline & response.** Assemble the ordered timeline, then recommend actions.
   - **Decision:** What do you contain first, what must be eradicated, and how do you recover the site safely?

### Evidence checkpoints
Save to `evidence/` (name clearly, e.g. `02-bruteforce.png`):
- [ ] The `stats count by sourcetype` result (your map of the data)
- [ ] A screenshot for **each** kill-chain stage showing the SPL + result
- [ ] Your **IOC list** (IPs, domains, tool, file name, hash)
- [ ] One **enrichment** result (VirusTotal / MalwareBazaar)
- [ ] Your assembled **timeline**

## Deliverable
Fill `deliverable-template.md` → an **Incident Report** with timeline, IOCs, ATT&CK
mapping, and containment/eradication/recovery. See `example-deliverable.md` for the target.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** T1595.002 (active scanning: vuln scanning), T1190 (exploit public-facing app),
  T1110 (brute force), T1505.003 (web shell), T1105 (ingress tool transfer), T1491.001 (internal/external defacement)
- **NIST CSF:** DETECT (DE.AE) · RESPOND (RS.AN, RS.MI, RS.RP) · RECOVER (RC.RP)
- **Security+ SY0-701:** 4.1 (IR process & activities), 4.4/4.6 (investigation using data sources, SIEM), 4.3 (vulnerability/attack response)

## Stretch goals (real data)
1. **Persistence hunt.** Pivot on `winregistry`/`wineventlog` to find any persistence the attacker set.
2. **Build a detection.** Write a Splunk search that would have **alerted** on the brute force in real time, and save it as the detection artifact for Episode 20.
3. **Go to the cloud.** Repeat a comparable investigation in **BOTSv3** (AWS CloudTrail/endpoint data) for a cloud-incident angle.

## Verification questions (instructor sign-off)
1. What scanning tool and attacker IP appear first against `192.168.250.70`?
2. What password eventually worked against the Joomla `admin` account, and how did you confirm success?
3. What is the name of the malicious executable the attacker placed on the server?
