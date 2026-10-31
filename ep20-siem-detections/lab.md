# Episode 20 — Author SIEM Detections

## Cold open

*Story so far — You reconstructed the whole Ep13 intrusion. Season 2 closes by turning every stage of it into a detection so it never goes unseen again.*

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

## Concept Explanation — detection engineering

Catching an attack a day late is an autopsy; detection engineering turns each stage of a known
attack into an **alert that fires while it's happening**. A good detection balances **precision**
(few false positives) against **recall** (catches the real thing), has a sensible **threshold**, a
**severity**, and a defined response. You also choose between **signature** detection (fast, but only
catches *this* actor) and **behavioural** detection (robust, but noisier) — and usually keep both.

**Key terms**
- **Detection rule** — a saved query + threshold that raises an alert when matched.
- **True / false positive** — a real detection vs a benign event wrongly flagged.
- **Threshold & tuning** — the count/window and refinements that keep an alert useful instead of noisy.
- **Signature vs behavioural detection** — matching a known IOC vs matching suspicious behaviour.
- **Severity** — how urgent an alert is, driving the response.
- **Alert fatigue** — when too many false positives train analysts to ignore alerts — the thing tuning prevents.

## Scope & rules of engagement
- **In scope:** writing/validating SPL against BOTSv1, saving alerts, documenting the pack.
- **Out of scope:** acting on any live system.
- **Defensive framing:** this is detection engineering — you're building the blue-team tripwires.

## Environment setup
Reuse the **Ep13 Splunk + BOTSv1** instance. You will
validate searches against `index=botsv1` (Aug 2016 data → *All time*), then save the good
ones as **alerts** (Settings → Searches, reports, and alerts → New Alert).

No new environment. Use the Splunk + **BOTSv1** instance you built in Episode 13 (its setup is in `../ep13-host-compromise/lab.md`).

### Saving a detection as an alert
1. Run and validate your SPL (time picker on **All time** — BOTSv1 is Aug 2016).
2. **Save As → Alert**.
3. Set **trigger** (e.g. "Number of Results > 0"), **schedule** (cron or real-time),
   **severity**, and an **action** (log / email / webhook for the write-up).
4. Note: in a real SOC you'd schedule these; on the historical BOTSv1 data you're proving
   the *logic* fires on known-bad events, then documenting the schedule you'd use live.

### Field-name note
BOTSv1 parses web traffic under `sourcetype=stream:http` with fields like `src_ip`,
`dest_ip`, `http_method`, `uri_path`, `http_user_agent`, `status`. Exact field names can
vary by Splunk/app version — if a search returns nothing, run a bare
`index=botsv1 sourcetype=stream:http | head 1` and read the real field names, then adjust.
Validating and tuning your own SPL is part of the skill.

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

## Commands explained

Detections are SPL searches saved as alerts. `\|` is the SPL pipe.

| SPL pattern | What it detects | Tuning consideration |
|---|---|---|
| `... \| stats dc(uri) by src_ip` | one source hitting many unique URLs fast | scanning — set a sane unique-URL threshold; allowlist monitors/crawlers |
| `... \| stats count by src_ip` (admin login POSTs, short window) | admin brute force | pick count/window that isn't normal fat-fingering |
| failure→success transition by source | a *successful* brute force | higher severity; define success by status/size/redirect |
| search for a served executable (`*.exe`, e.g. `3791.exe`) | malicious file delivery | web-layer vs host-layer source; allowlist legit pushes |
| match on the defacement IOC **or** new outbound domain | attacker callout | keep both: IOC (fast) + behaviour (strategic) |
| save as *Settings → Searches, reports, and alerts → New Alert* | schedules the detection | set schedule, throttle, and the fire action |

## On Windows

**Splunk runs on Windows** and the SPL detections are identical. The natural extension on Windows is to
build the same detections over **Windows Security events and Sysmon** (logon 4624/4625, process-create
Sysmon ID 1, network ID 3, registry ID 13) forwarded via WEF — the detection-engineering method
(threshold, precision vs recall, signature vs behaviour, severity) is unchanged.

## Deliverable
Fill `deliverable-template.md` → a **Detection Pack**: one entry per detection with SPL,
logic, tuning, ATT&CK, severity, response. See `example-deliverable.md` for the target.

## Rubric
Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1047 Audit (detections here drive the follow-on mitigations M1032/M1026/M1030)
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
