# Instructor Answer Key — Episode 10
- AUP elements: purpose/scope, acceptable + unacceptable use, monitoring/privacy notice, consequences, acknowledgement/signature.
- Offboarding: disable before delete (reversible, preserves evidence); rotate shared secrets the person knew (service passwords, API tokens, shared keys); collect assets/badge; retain per policy then delete after a hold.
- Onboarding key step: least privilege (plus MFA enrolment, AUP signature).
- Execution must show the lab account actually disabled + sudo removed + key revoked.
- Verification: (1) three AUP elements; (2) disable-before-delete + what to rotate; (3) least privilege as the key onboarding step.

## Ground truth in the reference lab (lab-env)
- Expected on `contractor`: `usermod -L`, shell set to nologin, `gpasswd -d contractor sudo`, `authorized_keys` emptied/removed, `chage -E 0`; rotate shared secrets they knew (e.g. the wallet DB password).
- Verify: SSH as `contractor` is refused and `groups contractor` no longer shows sudo.
