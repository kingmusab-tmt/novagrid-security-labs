# Episode 25 — Network Segmentation & Zero Trust

## Cold open

*Story so far — The Ep13 breach spread because the network is flat. Redesign it so one foothold isn't game over.*

> **From:** Tunde Bello (Sysadmin)
> **Subject:** Our network is flat and it scares me
>
> Once they were on the web server they could reach the wallet and the database with nothing
> in the way. Redesign our network so a foothold in one place doesn't mean game over — and
> explain the zero-trust bits to me plainly, with a diagram and the controls at each boundary. — Tunde

## Your role & mission objectives
- **Role:** security architect redesigning the network.
- **Objectives:**
  1. Define **segments/zones** (public/DMZ, app, data/PII, management, user) and what may talk to what.
  2. Apply **zero-trust** principles (verify explicitly, least-privilege access, assume breach, microsegmentation).
  3. Produce an **architecture diagram** (text/ASCII/Mermaid is fine) with trust boundaries.
  4. **Map the controls** at each boundary (firewall/ACL, NAC/802.1X, identity, inspection, logging).

## Concept Explanation — network segmentation & zero trust

A flat network means one foothold reaches everything — exactly how the Ep13 attacker went from the
web server to the wallet. **Segmentation** breaks the network into zones with controlled flows so a
breach is contained; **zero trust** goes further, removing *implicit* trust based on network location
and authenticating/authorising every request.

## Scope & rules of engagement
- **In scope:** a design deliverable (diagram + control mapping). No infrastructure changes required.

## Environment setup
No build required — this is architecture. Draw the diagram in Markdown/Mermaid or a tool of
choice.

No lab build. Produce a diagram (Mermaid/ASCII/draw.io) and a control mapping. Base the
design on the NovaGrid assets from earlier episodes (public site, wallet API, wallet DB/PII,
logging/SIEM, admin/management, user LAN). Reference NIST SP 800-207 for zero trust.

## Guided investigation
1. **Zone the network.** Group assets by sensitivity; the wallet DB (PII/cardholder) is the most protected zone.
   - **Decision:** What are your zones, and which flows are allowed between them (default deny)?
2. **Apply zero trust.** No implicit trust by network location; authenticate+authorise every request; microsegment east-west traffic.
   - **Decision:** How would zero trust have stopped the Ep13 lateral move from web → wallet?
3. **Diagram it.** Show zones, trust boundaries, and allowed flows.
4. **Map controls to boundaries.** Firewalls/ACLs, NAC/802.1X, identity-aware proxy/MFA, IDS/IPS, segmentation, logging.
   - **Decision:** Which control enforces each boundary, and where do you inspect/log?

### Evidence checkpoints
- [ ] zone definitions + allowed-flows matrix  - [ ] the architecture diagram  - [ ] the control-to-boundary mapping  - [ ] the "how it stops Ep13" note

## Key terms & frameworks

**Core terms**
- **Segmentation** — dividing the network into zones (by sensitivity) so traffic between them can be controlled, not assumed.
- **Default deny** — nothing is allowed between zones unless explicitly permitted — the opposite of a flat network.
- **East-west vs north-south traffic** — movement *between internal systems* vs *in/out of the network*; lateral movement is east-west, and flat networks don't inspect it.
- **Microsegmentation** — fine-grained segmentation down to individual workloads, limiting east-west movement.
- **DMZ** — a buffer zone for internet-facing services, isolated from the internal network.

**Zero trust (NIST SP 800-207)**
- **"Never trust, always verify"** — no request is trusted because of where it came from; identity, device posture and context are checked every time.
- **Per-request authentication/authorisation** — access is granted to a *resource*, not to the *network*.
- **Enforcement points** — identity-aware proxy / MFA at the application edge, NAC/802.1X at the network edge, segmentation gateways between zones.

**How it would have stopped Ep13:** with the wallet DB in its own default-deny zone and east-west
traffic authenticated, a foothold on the web server could not have simply reached the database —
the lateral move would have been denied and logged.

**Controls to map to each boundary:** firewalls/ACLs, NAC/802.1X, identity-aware proxy + MFA,
IDS/IPS inspection, and logging at every crossing.

## Deliverable
Fill `deliverable-template.md` → the **architecture diagram + control mapping**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1030 Network Segmentation, M1035 Limit Access to Resource Over Network (zero trust)
- **NIST CSF:** PROTECT — PR.AC/PR.PT; architecture per NIST SP 800-207 (Zero Trust)
- **Security+ SY0-701:** 3.1 architecture concepts (segmentation, zero trust, microsegmentation, DMZ)

## Stretch goals
1. Add a **data-flow** for a customer transaction across the zones.
2. Define **policy-enforcement/decision points** (PEP/PDP) per NIST 800-207.

## Verification questions
1. What are your zones and the default inter-zone policy?
2. Name three zero-trust principles and how each applies here.
3. How does your design stop the Ep13 web→wallet lateral movement?
