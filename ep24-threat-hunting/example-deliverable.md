# Threat-Hunt Report — Episode 24 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Hypothesis
- ATT&CK: T1053 (Scheduled Task/Job) / Run-key persistence (T1547).
- "If Sable Finch kept persistence, I'd expect an unusual autorun/scheduled task created
  around the Ep13 compromise time in the registry/process data."

## 2. Hunt
| Query / data source | Result |
|---|---|
| registry/autoruns around compromise window (BOTS winregistry) | a suspicious Run-key value |
| process creation referencing that path | matching execution at reboot |

## 3. Conclusion
**Confirmed** a persistence mechanism the alerts missed. Bias check: I looked for the
*absence* too (normal autoruns baseline) and corroborated across registry + process data,
not a single hit.

## 4. New detection (from the hunt)
- Logic: alert on new/modified Run-key or scheduled task writing to user-writable paths.
- Automatable → handed to Ep20 as a scheduled detection (+ Sigma version).

## 5. Reflection (own words)
Hunting flips the mindset: start from "how would they persist?" not "what alerted?". The
win is turning the finding into an automated detection so it's never a manual hunt again.
