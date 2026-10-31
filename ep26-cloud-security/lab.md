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

## Scope & rules of engagement
- **In scope:** a design deliverable (provider-agnostic, examples welcome). No live cloud account needed.

## Environment setup
No build required. Design provider-agnostically (AWS/Azure/GCP examples fine). Optionally
relate to **BOTSv3** (cloud/AWS data) you may have from Episode 13's stretch. See
`environment/README.md`.

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
