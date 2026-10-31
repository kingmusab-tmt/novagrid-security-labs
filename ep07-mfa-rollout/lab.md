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

## Scope & rules of engagement
- **In scope:** configuring MFA on your lab VM; a written plan. Keep a second session open (lockout risk).

## Environment setup
Analyst VM. Demo uses `libpam-google-authenticator` (TOTP) + any authenticator app
(Google Authenticator/Aegis/FreeOTP). See `environment/README.md`.

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

## Deliverable
Fill `deliverable-template.md` → the **MFA deployment write-up** (plan + demo evidence).

## Framework mapping
- **NIST:** SP 800-63B authenticator assurance levels (AAL); CSF PR.AA
- **Security+ SY0-701:** authentication, MFA factors, phishing-resistant authentication

## Stretch goals
1. Demo **FIDO2/WebAuthn** on a test web app (phishing-resistant).
2. Describe conditional access (require MFA from new devices/locations).

## Verification questions
1. Name the three main factor categories and give an example of each.
2. Why is SMS the weakest common factor, and what is phishing-resistant?
3. Which accounts get MFA first at NovaGrid, and why those?
