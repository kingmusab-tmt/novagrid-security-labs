# Episode 20 — Author SIEM Detections

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** Never again — I want alerts, not autopsies
>
> We caught the defacement a day late. I want detections in Splunk so that if Sable Finch
> (or anyone) tries that playbook again, we get paged while it's happening. Build me a
> detection for each stage of the Episode 13 attack: the scan, the admin brute force, a
> *successful* brute force, the malware drop, and the defacement callout. For each one I
> want the search, why it works, how you keep it from crying wolf, and what we do when it
> fires. — Amara

## Your role & mission objectives
- **Role:** detection engineer building and tuning SIEM alerts.
- **Objectives:**
  1. Write a working Splunk detection for **each** stage of the Ep13 kill chain.
  2. For every detection, document: data source, logic, threshold/schedule, **false-positive tuning**, severity, and response.
  3. Map each detection to **MITRE ATT&CK**.
  4. Prove each one fires on the known BOTSv1 events.
  5. Save them as Splunk alerts and export the pack as your portfolio artifact.

## Scope & rules of engagement
- **In scope:** writing/validating SPL against BOTSv1, saving alerts, documenting the pack.
- **Out of scope:** acting on any live system.
- **Defensive framing:** this is detection engineering — you're building the blue-team tripwires.

## Environment setup
Reuse the **Ep13 Splunk + BOTSv1** instance (see `environment/README.md`). You will
validate searches against `index=botsv1` (Aug 2016 data → *All time*), then save the good
ones as **alerts** (Settings → Searches, reports, and alerts → New Alert).

## Guided build
Build five detections. For **each**, write the SPL, confirm it returns the known malicious
activity, then answer the decision questions before you save it.

1. **Web vulnerability scanning.**
   - *Idea:* a scanner hits many unique URLs fast and/or carries a tell-tale `User-Agent`.
   - **Decisions:** Which field and threshold? Do you key on the Acunetix `User-Agent` (precise but evadable) or on request-volume per source (robust but noisier)? How do you avoid flagging legitimate crawlers/monitoring?

2. **Admin brute force.**
   - *Idea:* many POSTs to the CMS admin login from one source in a short window.
   - **Decisions:** What count over what time window is "brute force" vs normal fat-fingering? Per-source or per-account? What's the severity?

3. **Successful brute force / anomalous admin login.**
   - *Idea:* a successful admin authentication from a source that was just failing repeatedly (a failure→success transition).
   - **Decisions:** How do you distinguish success from failure in the data (status code / response size / redirect)? This one is higher severity — why, and what's the auto-response?

4. **Malicious file delivery / execution.**
   - *Idea:* an executable served to or written on the web server (`.exe`, e.g. `3791.exe`).
   - **Decisions:** Web-layer (`stream:http`) or host-layer (`wineventlog`/registry) detection — which is more reliable and why? How do you allowlist legitimate software pushes?

5. **Defacement / attacker-infrastructure callout.**
   - *Idea:* requests for the defacement image, or traffic to the attacker domain/IP.
   - **Decisions:** Detect on the known IOC (fast, but only catches *this* actor) or on a behaviour (web content changing / new outbound domain)? Keep both and say which is strategic.

### Evidence checkpoints
Save to `evidence/`:
- [ ] The **SPL** for each of the five detections
- [ ] A screenshot of **each detection returning the known malicious events** (e.g. the scan source, 40.80.148.42)
- [ ] The **saved-alert configuration** for at least two (schedule, trigger, severity)
- [ ] Your **false-positive notes** per detection

## Deliverable
Fill `deliverable-template.md` → a **Detection Pack**: one entry per detection with SPL,
logic, tuning, ATT&CK, severity, response. See `example-deliverable.md` for the target.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK (detections for):** T1595.002, T1110, T1190, T1105, T1491.001
- **NIST CSF:** DETECT — DE.CM (continuous monitoring), DE.AE (anomalies & events)
- **Security+ SY0-701:** 4.6 (alerting & monitoring, SIEM), 4.5 (automation/orchestration), 4.1 (IR support)

## Stretch goals
1. **Write them as Sigma rules** too (`sigma` is tool-agnostic and very employable); keep the `.yml` in your artifact.
2. **Risk-based alerting:** combine scan + brute force + login success from one source into a single higher-confidence alert.
3. **Tune for FPs:** add an allowlist (known scanners/admin IPs) and show the before/after result counts.

## Verification questions (instructor sign-off)
1. Show your brute-force detection returning the attacker source IP from Ep13.
2. How does your "successful brute force" detection tell success from failure in the data?
3. Which of your detections survive if the attacker changes their User-Agent, and which don't — and why does that matter?
