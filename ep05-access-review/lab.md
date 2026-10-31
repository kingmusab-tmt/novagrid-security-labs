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

## Concept Explanation — least privilege & access reviews

An access review (or recertification) periodically checks that every account still has a legitimate
owner and only the rights its role needs. Over time, access *accretes* — people change roles, leavers
linger, service accounts get broad grants "just to make it work". The review reconciles actual
entitlements against roles and the staff roster, then strips anything that fails the "needs it for the
job" test.

**Key terms**
- **Entitlement** — a specific right an account holds (group membership, a sudo rule, file access).
- **Access matrix** — a table of who has which entitlements, used to spot excess.
- **Least privilege** — grant only the access a role requires, nothing more.
- **Segregation of duties (SoD)** — splitting sensitive tasks so no single account can do everything (e.g. request *and* approve).
- **Orphaned / stale / shared account** — no current owner / no recent use / used by several people — all review red flags.
- **Recertification** — the periodic sign-off that each access grant is still justified.

## Scope & rules of engagement
- **In scope:** your lab hosts. Apply changes reversibly on the VM, not production.

## Environment setup
Analyst VM + hosts from the shared stack. Tools: `getent passwd`, `getent group`,
`/etc/sudoers*`, `groups`, `lastlog`, `id`.

Work on the **wallet-api** target (or your own VM if not using `lab-env`). Read entitlements
with `getent passwd`, `getent group`, `sudo cat /etc/sudoers.d/*`, `id <user>`, and
`chage -l <user>` for password age. Reconcile every account against the staff roster — that,
not `lastlog` (which reads "Never logged in" on a freshly built lab), is how you spot
orphaned/stale access. Make reversible changes (e.g. `gpasswd -d user sudo`) and record
before/after. No production systems.

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api. Reconcile accounts and sudo rights against `/srv/hr/staff-roster.csv` — the roster is the source of truth for who should have access.

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

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `getent passwd` | lists accounts, UIDs and login shells | enumerate who can log in |
| `getent group sudo` (and `adm`, `wheel`) | shows members of privileged groups | find who holds admin rights |
| `id <user>` | shows a user's UID and all group memberships | see a single account's full entitlements |
| `sudo cat /etc/sudoers.d/*` | shows granular sudo rules | spot over-broad grants (e.g. `NOPASSWD: ALL`) |
| `chage -l <user>` | password-ageing status | identify stale accounts |
| `sudo gpasswd -d <user> sudo` | removes a user from the sudo group | apply least privilege (reversible) |

## Deliverable
Fill `deliverable-template.md` → the **access-review report**.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1018 User Account Management, M1026 Privileged Account Management (least privilege)
- **NIST CSF:** PROTECT — PR.AC/PR.AA (access control, least privilege)
- **Security+ SY0-701:** 4.x IAM; least privilege; account/identity lifecycle

## Stretch goals
1. Define **RBAC** groups (roles → rights) and move people into roles.
2. Schedule a **recurring recertification** (quarterly access review).

## Verification questions
1. Which accounts were over-privileged, and how did you decide?
2. Define least privilege in one sentence.
3. How did you handle an orphaned account, and why?
