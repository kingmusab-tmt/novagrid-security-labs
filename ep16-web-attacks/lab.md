# Episode 16 — Web Attacks on the Wallet Portal (SQLi & XSS)

## Cold open

*Story so far — The Ep15 scan flagged the wallet portal — NovaGrid's biggest input surface. Now test it for injection properly.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Can our portal be injected?
>
> The wallet portal is our biggest input surface. Before an attacker does, test a copy for
> injection and scripting flaws, show me a working proof-of-concept, and — most important —
> write the fix our developers should apply. Lab copy only. — Amara

## Your role & mission objectives
- **Role:** analyst doing authorised application security testing on a lab target.
- **Objectives:**
  1. Find and **demonstrate SQL injection** (e.g. auth bypass / data extraction).
  2. Find and **demonstrate XSS** (reflected and/or stored).
  3. Explain the **root cause** of each.
  4. Write the **developer remediation** (parameterised queries, output encoding, validation, headers).

## Scope & rules of engagement
- **In scope:** a **deliberately vulnerable app you run locally** (OWASP Juice Shop or DVWA).
- **Out of scope / ethics:** never test a site you don't own or have written permission for.
  Everything here stays in your lab.

## Environment setup
Run **OWASP Juice Shop** or **DVWA** in Docker on your analyst VM; optionally **Burp Suite
Community** to intercept requests.

Run a deliberately vulnerable app **locally**:
- OWASP Juice Shop: `docker run --rm -p 3000:3000 bkimminich/juice-shop`
- or DVWA: `docker run --rm -it -p 8080:80 vulnerables/web-dvwa`
Optional: Burp Suite Community to intercept/modify requests. Only ever test these local
apps or targets you own/have written authorisation for. This is authorised testing in your
own lab — nothing else.

## Guided investigation
1. **Map inputs.** Find forms/parameters (login, search, feedback).
   - **Decision:** Which inputs reach a database or get reflected back to users?
2. **SQL injection.** Try classic payloads (e.g. `' OR '1'='1`), then extraction via UNION/error.
   - **Decision:** What does a successful injection prove about how the query is built?
3. **XSS.** Inject a harmless script (`<script>alert(1)</script>`) in a reflected field, then a stored field if present.
   - **Decision:** Reflected vs stored — which is worse here and why?
4. **Root cause + fix.** For each: why it worked, and the correct fix.
   - **Decision:** Why do parameterised queries beat "blocking bad characters"?

### Evidence checkpoints
- [ ] the vulnerable input identified  - [ ] SQLi PoC (request + result)  - [ ] XSS PoC (payload + result)  - [ ] the fix write-up

## Deliverable
Fill `deliverable-template.md` → **web-vuln findings + developer fixes**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK:** T1190 (exploit public-facing app)
- **MITRE ATT&CK Mitigations:** M1050 Exploit Protection (WAF), M1013 Application Developer Guidance (input validation, parameterised queries), M1026 Privileged Account Management
- **NIST CSF:** PROTECT — PR.PS (secure development); IDENTIFY — ID.RA
- **Security+ SY0-701:** 2.3/2.4 application attacks (injection, XSS) & mitigations; input validation; secure coding

## Stretch goals
1. Demonstrate a **parameterised-query** fix in code and show the payload now fails.
2. Add security headers (CSP) and show the XSS blocked.

## Verification questions
1. What payload achieved SQL injection, and what does that reveal about the query?
2. Difference between reflected and stored XSS — which did you find?
3. Why is parameterised/prepared querying the correct fix (not just input filtering)?
