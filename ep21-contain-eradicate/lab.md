# Episode 21 — Contain & Eradicate the Breach

## Cold open
> **From:** Amara Okafor (SOC Lead)
> **Subject:** Confirmed compromise — contain it, then clean it
>
> Ep13 is confirmed: the wallet host is compromised and an admin account is cracked. I need
> a containment plan that doesn't needlessly kill the business, then a clean eradication —
> every foothold, account, and persistence mechanism gone. Write it as a runbook and show me
> the steps run on the lab host. — Amara

## Your role & mission objectives
- **Role:** incident responder executing containment and eradication.
- **Objectives:**
  1. **Contain** — isolate affected systems while preserving evidence and critical ops.
  2. **Eradicate** — remove malware, web shells, attacker accounts, and persistence.
  3. Decide **rebuild vs clean** and justify.
  4. Capture it all as a reusable **runbook** with the steps actually run.

## Scope & rules of engagement
- **In scope:** your lab's compromised host/containers. Preserve evidence *before* you wipe (ties to Ep23).

## Environment setup
Your lab wallet host/containers (the Ep13 target). Tools: `docker network disconnect` / `ufw`
/ NIC down for isolation; `ps`, `ss`, `systemctl`, crontab/registry review; account tools.
See `environment/README.md`.

## Guided investigation
1. **Contain.** Isolate the host (pull it off the network / ACL it) while keeping it powered (RAM evidence).
   - **Decision:** Isolate vs power-off — why keep it running for now? What's the business trade-off?
2. **Preserve.** Snapshot/triage-collect before changes (hand-off to forensics, Ep23).
   - **Decision:** What do you capture before you start deleting?
3. **Eradicate.** Remove the malicious file (`3791.exe`-equivalent), kill its process, delete persistence (cron/Run key/service), and disable/reset the cracked admin account and sessions.
   - **Decision:** How do you know you got *all* of it (not just the obvious file)?
4. **Rebuild vs clean.** Decide whether to clean in place or rebuild from a known-good image.
   - **Decision:** For a payments host, which is safer and why?

### Evidence checkpoints
- [ ] isolation action + proof  - [ ] evidence preserved before changes  - [ ] eradication steps (process killed, file + persistence removed, account reset)  - [ ] the runbook

## Deliverable
Fill `deliverable-template.md` → the **containment & eradication runbook** (+ executed steps).

## Framework mapping
- **MITRE ATT&CK (undone):** T1505.003 web shell, T1547 persistence, T1078 valid accounts
- **NIST CSF:** RESPOND — RS.MI (mitigation), RS.AN
- **Security+ SY0-701:** 4.1 incident response (containment, eradication, recovery)

## Stretch goals
1. Script the eradication checklist (idempotent) for reuse.
2. Add IOC-sweep steps to find the same foothold on *other* hosts.

## Verification questions
1. Why isolate but not immediately power off a suspected host?
2. What persistence mechanisms did you check for and remove?
3. Clean-in-place vs rebuild for the wallet host — what did you choose and why?
