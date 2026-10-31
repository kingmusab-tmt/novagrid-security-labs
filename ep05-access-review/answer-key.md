# Instructor Answer Key — Episode 5
- Over-privilege usually surfaces on service accounts (full sudo) and ex-staff/contractors still enabled.
- Least privilege: grant only the access needed to do the job, nothing more.
- Orphaned account: disable first (reversible), hold, then delete per policy — don't delete blind.
- Reward scoping sudo to specific commands and defining RBAC roles.
- Verification: (1) which accounts + why; (2) least-privilege definition; (3) disable-then-delete handling.

## Ground truth in the reference lab (lab-env)
- `svc-backup`: full NOPASSWD sudo, but the roster says it needs only tar and rsync → scope sudo to those commands.
- `webadmin`: not on the roster (orphaned), stale password → disable, then delete after a hold.
- `contractor`: leaving today → offboard (Episode 10). `amara`/`tunde` sudo is justified; `chidi` correctly has none.
