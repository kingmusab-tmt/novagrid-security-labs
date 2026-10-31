# Episode 24 — Threat Hunting

## Cold open

*Story so far — The loud attack is handled. Now assume Sable Finch left something quiet behind and go looking.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Assume they're still here — go hunt
>
> The alerts fired on the loud stuff, but I want to know what we *didn't* get an alert for.
> Assume Sable Finch is still around and go hunting — form a hypothesis, prove or disprove it
> in the data, and if you find something, turn it into a detection so it's not a hunt next
> time. — Amara

## Your role & mission objectives
- **Role:** threat hunter running a hypothesis-driven hunt.
- **Objectives:**
  1. Form a **hypothesis** grounded in MITRE ATT&CK and the known campaign.
  2. **Hunt** the data (SIEM/EDR) for evidence, iterating the hypothesis.
  3. Document findings (confirmed activity, or a defensible "not found").
  4. Convert a finding into a **new detection** (hand to Ep20).

## Concept Explanation — threat hunting

Threat hunting is the proactive search for an attacker your *alerts didn't catch*. It's
**hypothesis-driven**: you pick a technique (ideally from MITRE ATT&CK) you have no detection for,
state exactly what evidence it would leave, then go looking in the data — proving or disproving it,
and turning any find into a new detection so you don't have to hunt it by hand again.

**Key terms**
- **Threat hunting** — proactively searching telemetry for undetected malicious activity.
- **Hypothesis** — a specific, testable claim ("if persistence via scheduled task, I'd see X in Y data").
- **MITRE ATT&CK** — a catalogue of adversary techniques used to structure hunts.
- **TTPs vs IOCs** — durable attacker *behaviours* vs brittle specific *indicators*; hunts target TTPs.
- **Pivoting** — following a lead across data sources (web → auth → process → registry) to confirm or clear it.
- **Confirmation bias** — the trap of seeing only evidence that supports your hypothesis; absence of evidence is also a result.

## Scope & rules of engagement
- **In scope:** querying your lab data (Splunk/BOTS from Ep13, Wazuh, host logs).

## Environment setup
Reuse the Ep13 **Splunk/BOTS** instance and/or **Wazuh**/host logs. Use **MITRE ATT&CK** to
pick techniques to hunt.

Reuse the Ep13 Splunk + BOTSv1 data and/or Wazuh/host logs. Browse MITRE ATT&CK
(attack.mitre.org) to choose techniques to hunt. Hunting is read-only analysis — you're
searching existing data for things no alert flagged. Save your queries + results to evidence.

## Guided investigation
1. **Hypothesis.** Pick an ATT&CK technique the campaign might use that you have *no* alert for
   (e.g. persistence via scheduled task/Run key, lateral movement, or data staging).
   - **Decision:** What exact, testable hypothesis are you hunting ("if X, I'd expect to see Y in Z data")?
2. **Hunt.** Query for the expected artifacts; follow leads; refine.
   - **Decision:** What does presence *or* absence of evidence tell you (and how do you avoid confirmation bias)?
3. **Pivot.** Correlate across data sources (web, auth, process, registry) to confirm or clear.
4. **Operationalise.** If you find something, write the detection logic for it (Ep20 format).
   - **Decision:** Can this be an automated detection, or is it inherently a periodic hunt?

### Evidence checkpoints
- [ ] the written hypothesis (+ ATT&CK technique)  - [ ] the hunt queries + results  - [ ] confirm/clear conclusion with reasoning  - [ ] the new detection

## Commands explained

The hunt runs as SPL searches (Ep13/20 Splunk). `\|` is the SPL pipe.

| SPL / action | What it does | Why you use it here |
|---|---|---|
| `index=botsv1 <technique artefacts>` | searches for the expected evidence of your hypothesis | test whether the technique was used |
| `... \| stats count by host, process` | aggregates to surface anomalies | spot the odd process/host |
| pivot on a found value (IP, user, hash) | follows the lead into other sourcetypes | corroborate across data sources |
| `... \| table _time, ...` | orders confirming events | document the finding |
| save the query as an alert | operationalises the hunt | turn a one-off hunt into a standing detection |

## On Windows

Hunt in Windows telemetry (or the same Splunk, over Windows logs).

**a.** Logons and failures (cf. auth.log):
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624,4625} -MaxEvents 50
```
**b.** With **Sysmon** installed, the high-value IDs are 1 (process create), 3 (network), 11 (file
create), 13 (registry). Hunt a hypothesis, e.g. odd persistence:
```powershell
Get-ScheduledTask | Where-Object {$_.Author -notlike 'Microsoft*'}
Get-CimInstance Win32_StartupCommand
```
**c.** Operationalise a find as a detection — a `Get-WinEvent` filter, a Sysmon rule, or an SPL
alert (Ep20 format) over the forwarded Windows logs.

## Deliverable
Fill `deliverable-template.md` → the **threat-hunt report**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** hunter's choice (e.g. T1053 scheduled task, T1021 lateral movement, T1074 data staged)
- **MITRE ATT&CK Mitigations:** M1047 Audit (hunts drive new detections and the control gaps to close)
- **NIST CSF:** DETECT — DE.CM, DE.AE
- **Security+ SY0-701:** 4.x threat hunting; using data sources; intelligence-driven defence

## Stretch goals
1. Run the hunt against **two** data sources and show how correlation strengthens the conclusion.
2. Add the new detection as a **Sigma** rule.

## Verification questions
1. State your hypothesis and the ATT&CK technique behind it.
2. What did the data show, and how did you guard against confirmation bias?
3. What detection did you create from the hunt (or why is it a recurring hunt, not an alert)?
