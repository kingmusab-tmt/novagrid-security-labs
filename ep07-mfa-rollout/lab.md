# Episode 7 — Roll Out MFA

## Cold open
> **From:** Amara Okafor (SOC Lead)
> **Subject:** MFA — admins and remote access first
>
> The phishing email in finance was a wake-up call. Plan an MFA rollout — who gets it
> first, which factors, how people enrol and recover — and actually demo it working on an
> account so I can see it, not just read about it. — Amara

## Your role & mission objectives
- **Role:** analyst planning and demonstrating an MFA rollout.
- **Objectives:**
  1. Explain the **authentication factors** and why MFA beats a password.
  2. Choose **methods** per audience (TOTP app, push, FIDO2 hardware), noting **phishing resistance**.
  3. **Demo** MFA by enabling **TOTP on SSH** on the lab VM.
  4. Write a **rollout plan**: scope/order, enrolment, recovery, exceptions.

## Concept Explanation — multi-factor authentication

MFA requires proof from two *different* categories — something you **know**, **have**, or **are** — so a
stolen password alone can't get in. Not all factors are equal: SMS codes can be intercepted or
SIM-swapped, TOTP apps are solid, and **FIDO2/WebAuthn** hardware keys are *phishing-resistant* because
they're cryptographically bound to the real site. Admins and remote access get the strongest factor.

**Key terms**
- **Factor categories** — *know* (password/PIN), *have* (phone, token, key), *are* (biometric). MFA mixes categories, not two of the same.
- **TOTP** — Time-based One-Time Password: a 6-digit code from an app (Google Authenticator, Aegis) that rotates every 30s.
- **FIDO2 / WebAuthn** — a hardware/platform authenticator bound to the site's origin, so a phishing page can't replay it; the gold standard.
- **Push / SMS OTP** — app-approval prompts / texted codes; SMS is the weakest factor (SIM-swap, interception).
- **PAM (Pluggable Authentication Modules)** — the Linux framework where you slot the TOTP check into the login flow.
- **Recovery / scratch codes** — one-time backup codes to get in if the second factor is lost; must be stored safely.

## Scope & rules of engagement
- **In scope:** configuring MFA on your lab VM; a written plan. Keep a second session open (lockout risk).

## Environment setup
Analyst VM. Demo uses `libpam-google-authenticator` (TOTP) + any authenticator app
(Google Authenticator/Aegis/FreeOTP).

Analyst VM. Install: `sudo apt-get install -y libpam-google-authenticator`. Run
`google-authenticator` as the user (save the scratch/recovery codes!). Add
`auth required pam_google_authenticator.so` to `/etc/pam.d/sshd` and set
`KbdInteractiveAuthentication yes` in `/etc/ssh/sshd_config`, then restart sshd.
**Keep a second SSH session open** while testing so a misconfig can't lock you out.
Any TOTP app works (Google Authenticator, Aegis, FreeOTP).

### Start the lab
- Start the lab from the repo root: `cd lab-env && docker compose up -d --build`, then `bash scripts/check-lab.sh`. Full guide: [lab-env/README.md](../../lab-env/README.md).
- Target: wallet-api SSH. The TOTP module is preinstalled. Edit `/etc/pam.d/sshd` and set `KbdInteractiveAuthentication yes` in the SSH drop-in, then `lab-restart ssh`.
- You can't lock yourself out: `docker compose exec wallet-api bash` always gets you back in as root.

## Guided investigation
1. **Factors.** Something you **know** / **have** / **are** (+ location/behaviour). MFA = two *different* categories.
   - **Decision:** Why isn't "password + security question" true MFA?
2. **Choose methods.** TOTP app vs push vs **FIDO2/WebAuthn** hardware keys; why SMS is the weakest; FIDO2 is phishing-resistant.
   - **Decision:** Which factor do admins get, and why the strongest for them?
3. **Demo (TOTP on SSH).** Install `libpam-google-authenticator`, run `google-authenticator`, add it to PAM + `sshd_config` (`KbdInteractiveAuthentication yes`), and log in with password + code.
   - **Decision:** What recovery option do you keep (scratch codes), and how do you store them safely?
4. **Plan the rollout.** Order (admins/remote → all), enrolment steps, recovery, and exceptions/break-glass.

### Evidence checkpoints
- [ ] factor explanation  - [ ] PAM/sshd config for TOTP  - [ ] a successful MFA SSH login (screenshot)  - [ ] the rollout plan

## Commands explained

| Command / file | What it does | Why you use it here |
|---|---|---|
| `sudo apt-get install -y libpam-google-authenticator` | installs the TOTP PAM module | enable TOTP for SSH |
| `google-authenticator` | generates a user's TOTP secret + QR + scratch codes | enrol an account |
| `/etc/pam.d/sshd` (`auth required pam_google_authenticator.so`) | inserts the TOTP check into SSH login | require the second factor |
| `/etc/ssh/sshd_config` (`KbdInteractiveAuthentication yes`) | lets SSH prompt for the code | allow password + TOTP |
| `lab-restart ssh` | reloads sshd safely | apply the MFA change without lockout |

## Deliverable
Fill `deliverable-template.md` → the **MFA deployment write-up** (plan + demo evidence).

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1032 Multi-factor Authentication
- **NIST:** SP 800-63B authenticator assurance levels (AAL); CSF PR.AA
- **Security+ SY0-701:** authentication, MFA factors, phishing-resistant authentication

## Stretch goals
1. Demo **FIDO2/WebAuthn** on a test web app (phishing-resistant).
2. Describe conditional access (require MFA from new devices/locations).

## Verification questions
1. Name the three main factor categories and give an example of each.
2. Why is SMS the weakest common factor, and what is phishing-resistant?
3. Which accounts get MFA first at NovaGrid, and why those?
