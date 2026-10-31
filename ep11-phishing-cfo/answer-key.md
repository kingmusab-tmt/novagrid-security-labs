# Instructor Answer Key — Episode 11

> Do not share with students until sign-off.

## Ground-truth facts in the sample
- **Originating IP:** 185.220.101.47 (host `mail.novag-rid-secure.com`) — not NovaGrid.
- **Authentication:** SPF = **fail**, DKIM = **none**, DMARC = **fail** (p=quarantine).
- **From:** `it-helpdesk@novagrid.com` — an **exact-domain spoof** (that's why DMARC fails).
- **Reply-To:** `helpdesk.novagrid@consultant-mail.com`; **Return-Path:** `bounce@novag-rid-secure.com`.
- **Link:** visible text `portal.novagrid.com/finance/approve`; real href `https://novagrid-m365-login.com/owa/`.
- **Attachment:** `NovaGrid_Payment_Advice.html`, real type **HTML document**,
  SHA-256 `c86ca00ccaff5c4661639b8fa6a277f342288a214116d0fde468cc3945784ecb`,
  form action `https://novagrid-m365-login.com/owa/collect.php`.

## Verification-question answers
1. **Origin IP 185.220.101.47**; **SPF and DMARC fail** (DKIM is absent/none).
2. Lookalike sign-in domain **`novagrid-m365-login.com`** — not `login.microsoftonline.com`
   and not a real NovaGrid domain; it only mimics the brand in the string.
3. SHA-256 **c86ca00ccaff5c4661639b8fa6a277f342288a214116d0fde468cc3945784ecb**; real type **HTML document** (despite the "payment advice" framing).

## Common student mistakes
- Trusting the From display name / domain without reading auth results.
- Reporting the visible link text instead of the real href.
- Calling the attachment a PDF/invoice because of its name — it's HTML.
- Listing IOCs without enriching any of them.

## Per-student variation (anti-copying)
Regenerate the sample with a unique IP, lookalike domain, subject and attachment per
student (the hash then differs). A small generator script can template these; wire it in
when we build the catalogue so no two reports match.
