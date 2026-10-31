# Episode 18 — Credential Stuffing on Customer Accounts

## Cold open

*Story so far — Unable to break the portal head-on (Ep16), the attackers switch to replaying stolen passwords against the login.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Customers locked out — are we being stuffed?
>
> Support is flooded with "I'm locked out" and we're seeing logins from odd places. I think
> it's credential stuffing — reused passwords from other breaches being replayed against our
> login. Prove it from the logs, then tell me how we stop it without locking out real
> customers. — Amara

## Your role & mission objectives
- **Role:** analyst detecting an account-takeover campaign and designing mitigations.
- **Objectives:**
  1. Distinguish **credential stuffing** from brute force and password spraying.
  2. **Detect** the pattern in auth/web logs (many accounts, few IPs, high failure rate, some successes).
  3. Identify **compromised accounts** (failure→success, new geo/device).
  4. Design **mitigations** that stop it without harming legitimate users.

## Concept Explanation — credential stuffing & account takeover

Credential stuffing replays *username:password pairs leaked from other breaches* against your login,
betting that people reuse passwords. Its fingerprint in the logs is distinctive — one source hitting
**many different accounts** with a **high failure rate** and a **small but real success rate**. You
confirm it, scope which accounts were taken over, and choose layered mitigations that stop the bots
without punishing real customers.

**Key terms**
- **Credential stuffing** — automated login attempts using breach-sourced credential pairs across many accounts.
- **Brute force vs spraying** — many passwords against one account vs a few common passwords across many accounts.
- **Credential reuse** — the user habit that makes stuffing work.
- **Account takeover (ATO)** — successful unauthorised access to a user's account.
- **Rate limiting / lockout** — throttling attempts per source/account to blunt automation.
- **Impossible travel / velocity** — logins too far apart in distance/time to be one person — a detection signal.

## Scope & rules of engagement
- **In scope:** analysing provided/lab auth logs and writing the detection + mitigation plan.
- **Out of scope:** actually running any credential attack.

## Environment setup
Use auth/web logs from your lab (the wallet portal access log / auth log), or a sample auth
log. Optionally query them in **Splunk** (reuse the Ep13 instance).

Use auth/web logs: the wallet portal access log and auth log from your lab, or a sample auth
log you create (many accounts from a couple of IPs, mostly failures, a few successes).
Optionally load them into the Ep13 Splunk instance and pivot there. No attack tooling is
run — this is detection + planning on recorded data.

## Guided investigation
1. **Define the attack.** Credential stuffing (known user:pass pairs, many accounts) vs brute
   force (many passwords, one account) vs spraying (few common passwords, many accounts).
   - **Decision:** Which signature distinguishes stuffing in the logs?
2. **Detect.** Find sources attempting logins across **many distinct accounts** with a **high
   failure rate** and a **low but non-zero success rate**; note velocity and geo spread.
   - **Decision:** What thresholds/queries flag stuffing but not a busy normal day?
3. **Scope compromise.** Identify accounts with a failure→**success** from a stuffing source, or logins from a new country/device.
   - **Decision:** Which accounts are likely taken over, and what's the immediate action?
4. **Mitigate.** Design layered controls and weigh user friction.
   - **Decision:** Which controls stop stuffing with least impact on real customers?

### Evidence checkpoints
- [ ] the detection query/logic + result  - [ ] list of suspected compromised accounts  - [ ] the attack-type justification  - [ ] the mitigation plan

## Commands explained

The "commands" here are **log queries / signals** (SIEM or `grep`/`awk` over auth logs).

| Query / signal | What it shows | Why you use it here |
|---|---|---|
| failures grouped **by source IP** | which sources are hammering logins | find the attacking infrastructure |
| **distinct accounts** attempted per source | breadth of targeting | stuffing hits many accounts (brute force hits one) |
| failure-rate per source + **velocity** | speed and success ratio | distinguish stuffing from a busy normal day |
| a **failure→success** transition from a stuffing source | likely account takeover | scope which accounts to reset |
| new-country / new-device logins | anomalous access | corroborate takeover |

## Deliverable
Fill `deliverable-template.md` → the **detection + mitigation write-up**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** T1110.004 (credential stuffing), T1078 (valid accounts)
- **MITRE ATT&CK Mitigations:** M1032 Multi-factor Authentication, M1036 Account Use Policies (lockout/throttle), M1027 Password Policies
- **NIST CSF:** DETECT (DE.CM, DE.AE) · PROTECT (PR.AA)
- **Security+ SY0-701:** 2.4 password attacks (stuffing/spraying/brute force); 4.6 detection; MFA & mitigations

## Stretch goals
1. Write the detection as a **Splunk/Sigma** rule (feeds Episode 20).
2. Model **impossible-travel** detection (two logins too far apart in time/space).

## Verification questions
1. How does credential stuffing differ from brute force and from spraying?
2. What log pattern did you use to detect it, and how did you avoid false positives?
3. Which single mitigation helps most, and what's its user-experience cost?

## Time-boxed variant (optional — "the portal's under attack right now")
Credential stuffing is a live, time-critical event. Run a **25-minute** drill:

- **00:00–08:00** — confirm it: the login pattern that proves stuffing (many users, few attempts each, one source / botnet, high failure rate).
- **08:00–16:00** — scope it: how many accounts tried, how many succeeded, from where.
- **16:00–22:00** — the mitigation decision: rate-limit / MFA challenge / IP block / forced reset — pick and justify under the clock.
- **22:00–25:00** — the 3-line incident note + the one detection you'd keep running.

Record your start/stop. Note the trade-off you accepted (e.g. blocking the source IP may hit
real users behind a NAT) — naming the trade-off under pressure is the senior skill.
