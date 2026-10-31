# Instructor Answer Key — Episode 26
- Shared responsibility: provider secures physical/hypervisor (and more for managed services); customer owns IAM, data, configuration, and encryption-key management. Most breaches = customer misconfiguration.
- IAM: roles > users, least privilege, MFA, NO root/long-lived keys, scoped service identities.
- Network/encryption: private data tier (DB not public), default-deny security groups, KMS at rest + TLS in transit.
- Logging: account audit log (CloudTrail-style) + flow logs to SIEM; secrets in a manager, rotated.
- Verification: (1) two provider + two customer responsibilities; (2) private+encrypted DB; (3) logging that detects the cloud Ep13 analogue.
