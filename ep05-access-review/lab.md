# Episode 5 — Access Review (Least Privilege)

## Cold open
> **From:** Zainab Idris (Compliance)
> **Subject:** Access review — who can do what, and should they?
>
> The audit flagged "excessive access." I need a review: list every account, what groups
> and sudo rights it has, map that to the person's actual role, and recommend what to strip.
> Flag any account nobody owns. — Zainab

## Your role & mission objectives
- **Role:** analyst performing an access (entitlement) review.
- **Objectives:**
  1. Enumerate users, groups, and sudo/privileged rights.
  2. Build an **access matrix**: account → rights → role → justified?
  3. Identify **over-privilege**, **shared** and **orphaned** accounts.
  4. Recommend and apply **least-privilege** changes; document.

## Scope & rules of engagement
- **In scope:** your lab hosts. Apply changes reversibly on the VM, not production.

## Environment setup
Analyst VM + hosts from the shared stack. Tools: `getent passwd`, `getent group`,
`/etc/sudoers*`, `groups`, `lastlog`, `id`.

## Guided investigation
1. **Enumerate entitlements.** Users with shells, membership of `sudo`/`adm`/`wheel`, and sudoers rules.
   - **Decision:** Who holds admin rights, and does their role need it?
2. **Map to role.** Build the access matrix and mark each right justified / not.
   - **Decision:** Which entitlements fail the "need it for the job" test?
3. **Find the strays.** Orphaned (no owner), shared, and stale (no recent login) accounts.
   - **Decision:** Disable, delete, or reassign — and why?
4. **Apply least privilege.** Remove unneeded group/sudo rights; document before/after.

### Evidence checkpoints
- [ ] users/groups/sudoers listing  - [ ] the access matrix  - [ ] stale/orphaned account list  - [ ] applied before/after

## Deliverable
Fill `deliverable-template.md` → the **access-review report**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** PROTECT — PR.AC/PR.AA (access control, least privilege)
- **Security+ SY0-701:** 4.x IAM; least privilege; account/identity lifecycle

## Stretch goals
1. Define **RBAC** groups (roles → rights) and move people into roles.
2. Schedule a **recurring recertification** (quarterly access review).

## Verification questions
1. Which accounts were over-privileged, and how did you decide?
2. Define least privilege in one sentence.
3. How did you handle an orphaned account, and why?
