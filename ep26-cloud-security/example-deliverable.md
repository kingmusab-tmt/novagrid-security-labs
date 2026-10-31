# Cloud Security Design — Episode 26 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Shared responsibility
| Layer | Provider | NovaGrid |
|---|---|---|
| Physical/hypervisor | ✓ | |
| Managed service patching | ✓ (managed svcs) | OS patching (IaaS) |
| IAM, data, config, encryption keys | | ✓ |

## 2. IAM
Roles not users; least-privilege policies; MFA on all humans; **no root/long-lived access keys**;
scoped service roles per workload; just-in-time elevation for admins.

## 3. Network & encryption
Public subnet: load balancer/WAF only. Private subnets: app and DB. Security groups default-deny;
the wallet **DB has no public IP** and only accepts the app's security group. Encrypt at rest with
KMS-managed keys; TLS 1.2+ in transit.

## 4. Logging & secrets
Enable account-wide audit logging (CloudTrail-style) + VPC flow logs → central SIEM.
Secrets in a managed secrets store (rotated), never in code/images. Detection: alert on new IAM
users/keys, security-group opens to 0.0.0.0/0, and anomalous admin-console logins — the cloud
analogue of the Ep13 brute force + lateral move.

## 5. Reflection (own words)
Most cloud breaches are customer misconfig — public storage, over-broad IAM, exposed DBs. The
design leans on least-privilege IAM, a private data tier, and audit logging, which is exactly
where those failures happen.
