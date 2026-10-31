# Episode 26 — Secure Cloud Architecture

## Cold open

*Story so far — NovaGrid is moving services to the cloud — the same defence principles, a new shared-responsibility model.*

> **From:** Amara Okafor (SOC Lead)
> **Subject:** Wallet is moving to the cloud — design it right
>
> Leadership wants the wallet in the cloud. I don't want to lift-and-shift our mistakes.
> Design the secure version: who can do what, how it's segmented, how data is encrypted,
> how we'd see an incident, and be crystal clear about what the cloud provider secures vs
> what's on us. — Amara

## Your role & mission objectives
- **Role:** cloud security architect.
- **Objectives:**
  1. Apply the **shared responsibility model** (provider vs customer).
  2. Design **IAM** (least privilege, roles, MFA, no long-lived root keys).
  3. Design **network** (VPC/subnets, security groups, private data tier) and **encryption** (at rest/in transit, KMS).
  4. Design **logging/monitoring** (CloudTrail-style audit, flow logs) and **secrets management**.

## Concept Explanation — cloud security

The cloud changes *who* secures *what*, not whether security matters. Under the **shared
responsibility model** the provider secures the underlying infrastructure and the customer secures
their identities, data and configuration — and it's almost always the *customer's* side
(misconfigured storage, over-broad IAM, exposed databases) that causes cloud breaches. The same
principles you applied on-prem (least privilege, encryption, network isolation, logging) carry over,
expressed in cloud primitives.

## Scope & rules of engagement
- **In scope:** a design deliverable (provider-agnostic, examples welcome). No live cloud account needed.

## Environment setup
No build required. Design provider-agnostically (AWS/Azure/GCP examples fine). Optionally
relate to **BOTSv3** (cloud/AWS data) you may have from Episode 13's stretch. See
the setup below.

No cloud account needed — this is a design. Keep it provider-agnostic with concrete examples
(AWS IAM roles/Security Groups/KMS/CloudTrail, or Azure/GCP equivalents). If you did the
Episode 13 BOTSv3 stretch, reuse that cloud context. Deliver a short design + a diagram.

## Guided investigation
1. **Shared responsibility.** Split what the provider secures (hardware, hypervisor) vs NovaGrid (IAM, data, config).
   - **Decision:** Which recent breaches are usually the *customer's* fault (misconfig, exposed storage, over-broad IAM)?
2. **IAM.** Roles over users, least privilege, MFA, no root/long-lived keys, scoped service identities.
   - **Decision:** How do you avoid the "god-mode key" problem?
3. **Network + encryption.** Public/private subnets, security groups (default deny), the DB in a private tier; encrypt at rest (KMS-managed keys) and in transit (TLS).
   - **Decision:** How do you keep the wallet DB off the public internet?
4. **Logging + secrets.** Enable audit logging (CloudTrail-style) + flow logs; use a secrets manager, not hard-coded creds.
   - **Decision:** How would you detect the cloud version of the Ep13 incident?

### Evidence checkpoints
- [ ] shared-responsibility split  - [ ] IAM design  - [ ] network+encryption design (diagram)  - [ ] logging+secrets design

## Key terms & frameworks

**Core terms**
- **Shared responsibility model** — the split between what the cloud provider secures (hardware, hypervisor) and what the customer secures (IAM, data, config).
- **IAM roles & least privilege** — grant scoped, assumable roles rather than long-lived "god-mode" keys; enforce MFA; avoid using the root account.
- **Security groups / NACLs** — cloud firewalls; keep them default-deny and keep the database in a private subnet, off the public internet.
- **Public vs private subnet** — internet-reachable vs internal-only network tiers; sensitive data belongs in private tiers.
- **Encryption at rest & in transit** — KMS-managed keys for stored data, TLS for data on the wire.
- **Secrets manager** — a managed store for credentials, so secrets aren't hard-coded in code or images.
- **Audit logging (e.g. CloudTrail) + flow logs** — recording API calls and network flows so you can detect and investigate.

**How you'd catch the cloud version of Ep13:** API audit logs + flow logs would show the anomalous
access and data movement; detections mirror the Ep20 ones, just over cloud telemetry.

**The recurring lesson:** most cloud incidents trace to **misconfiguration** on the customer side —
an exposed bucket, an over-broad role — not a provider failure.

## Deliverable
Fill `deliverable-template.md` → the **cloud security design**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1032 Multi-factor Authentication, M1041 Encrypt Sensitive Information, M1018 User Account Management, M1047 Audit (cloud logging)
- **NIST CSF:** PROTECT (PR.AC/PR.DS) · DETECT (DE.CM); cloud per CSA / provider well-architected security pillars
- **Security+ SY0-701:** 3.1 cloud concepts; shared responsibility; IAM; encryption; 4.x cloud logging

## Stretch goals
1. Add **infrastructure-as-code** guardrails / policy-as-code (deny public buckets, enforce encryption).
2. Map the design to the provider's **well-architected** security pillar.

## Verification questions
1. Give two things the provider secures and two the customer must secure.
2. How do you keep the wallet database private and encrypted?
3. What logging would detect the cloud equivalent of the Ep13 attack?
