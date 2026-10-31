# Episode 21 — Contain & Eradicate the Breach

## Cold open

*Story so far — Season 2 proved NovaGrid can be breached — phishing to compromise to defacement. Season 3 is the response, and it starts with containment.*

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

## Concept Explanation — incident response: containment & eradication

Once a compromise is confirmed, the incident-response lifecycle moves from detection into
**containment** (stop the bleeding), **eradication** (remove the attacker and every foothold), and
then recovery (Ep22). Order matters: you isolate the host *without* destroying the volatile evidence
forensics will need, then you hunt down *all* of the attacker's persistence — not just the obvious
file — before you trust the box again.

**Key terms**
- **Containment** — limiting the damage and spread (isolating the host, blocking the C2) while you respond.
- **Eradication** — removing the malware, accounts, and persistence so the attacker can't simply return.
- **Isolation** — cutting the host's network access while keeping it powered, so RAM evidence survives.
- **Persistence** — the mechanisms (cron jobs, services, Run keys, rogue accounts, SSH keys) an attacker plants to regain access.
- **Rebuild vs clean** — restoring from a known-good image vs attempting to disinfect in place; for a payments host, rebuild is safer.
- **Blast radius** — how far the compromise could have spread, which sets the scope of eradication.

## Scope & rules of engagement
- **In scope:** your lab's compromised host/containers. Preserve evidence *before* you wipe (ties to Ep23).

## Environment setup
Your lab wallet host/containers (the Ep13 target). Tools: `docker network disconnect` / `ufw`
/ NIC down for isolation; `ps`, `ss`, `crontab -l`, and account tools (`getent`, `chage`, `usermod`).
On the containers there's no `systemctl`, so stop a rogue service by killing its process (`pkill`)
and removing its persistence; `systemctl` applies only on a non-container system (a normal VM/server).

Use the Ep13 compromised lab host/containers. Isolation options: `docker network disconnect
<net> <container>`, `ufw deny`/NIC down, or ACL. Review persistence: `crontab -l`, systemd
units/timers, `~/.ssh/authorized_keys`, (Windows) Run keys/services. Preserve first
(snapshot / triage copy) so Ep23 forensics still has evidence. Reversible on the lab.

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

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `docker network disconnect <net> <container>` | cuts the host off the lab network | contain without powering off (preserve RAM) |
| `ps -ef` / `pkill -f <name>` | finds and kills the malicious process | stop the running malware |
| `crontab -l` / check `~/.ssh/authorized_keys` / services | surface persistence mechanisms | ensure you removed *all* footholds, not just the file |
| `sudo usermod -L <user>` / `passwd <user>` | locks/rotates the cracked admin account | deny the attacker the credential they stole |
| `find / -newermt <time> -type f` | lists files changed since the intrusion | discover dropped/modified files |

## On Windows

Contain and eradicate on the **Windows target**, removing the planted persistence.

**a.** Contain — cut the network but keep it powered (RAM evidence):
```powershell
Disable-NetAdapter -Name 'Ethernet' -Confirm:$false
```
**b.** Eradicate the two inert persistence mechanisms the lab planted:
```powershell
Unregister-ScheduledTask -TaskName NovaGridUpdater -Confirm:$false
Remove-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name NovaGridSync
```
**c.** Confirm you got *all* of it — hunt the other autorun locations:
```powershell
Get-CimInstance Win32_StartupCommand          # or Sysinternals Autoruns.exe
Get-ScheduledTask | Where-Object {$_.Author -notlike 'Microsoft*'}
```
Then disable/reset the cracked admin account. Windows persistence lives in Run keys, Services,
Scheduled Tasks and WMI subscriptions — **Autoruns** surfaces them all.

## Deliverable
Fill `deliverable-template.md` → the **containment & eradication runbook** (+ executed steps).

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1018 User Account Management, M1042 Disable/Remove Feature, M1026 Privileged Account Management (eradication)
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
