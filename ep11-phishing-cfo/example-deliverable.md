# Phishing-Analysis Report — Episode 11 (worked example)

**Analyst:** A. Analyst  **Date:** 2026-10-28  **Ticket:** Chidi Nwosu (CFO) — reported email

> Model answer — the standard to aim at. Enrichment verdicts here are for the fictional
> training sample; in the real malware-traffic-analysis.net stretch they resolve to live results.

## 1. Verdict
**Malicious — credential-phishing.** The email spoofs NovaGrid's own domain, fails all
sender-authentication checks, and carries an HTML attachment that renders a fake
Microsoft 365 / NovaGrid sign-in page posting credentials to an attacker domain.

## 2. Summary (for management)
An email claiming to be from NovaGrid IT Helpdesk urged the CFO to approve an "unpaid
payment advice" within 12 hours. It did not come from our systems — it was sent from an
unrelated IP and fails SPF, DKIM and DMARC. Both the link and the attached HTML file lead
to a look-alike login page (`novagrid-m365-login.com`) built to steal credentials. No
credentials were entered. Recommend blocking the sender infrastructure, purging the
message from all mailboxes, and warning staff.

## 3. Evidence
### 3.1 Header & authentication analysis
| Check | Result | Notes |
|-------|--------|-------|
| From vs. envelope / Reply-To | Mismatch | From `it-helpdesk@novagrid.com` (spoofed) but Return-Path `bounce@novag-rid-secure.com` and Reply-To `helpdesk.novagrid@consultant-mail.com` |
| Originating IP | 185.220.101.47 | Host `mail.novag-rid-secure.com` — not NovaGrid infrastructure |
| SPF | **fail** | Sending IP not authorised for novagrid.com |
| DKIM | **none** | Message not signed |
| DMARC | **fail** (p=quarantine) | header.from novagrid.com, with SPF/DKIM failing |

### 3.2 Content
- **Lure / pretext:** urgency + authority — a NGN 4,250,000 payment "reversed in 12 hours" unless approved.
- **Links:** visible text reads `https://portal.novagrid.com/finance/approve` but the real href is `https://novagrid-m365-login.com/owa/` (classic display-vs-href mismatch).
- **Attachment:** `NovaGrid_Payment_Advice.html` — real type **HTML document** (not an invoice/PDF); SHA-256 `c86ca00ccaff5c4661639b8fa6a277f342288a214116d0fde468cc3945784ecb`. It contains a fake sign-in form posting to `https://novagrid-m365-login.com/owa/collect.php`.

## 4. Indicators of Compromise (IOCs)
| Type | Indicator | Enrichment / verdict |
|------|-----------|----------------------|
| IP | 185.220.101.47 | Check AbuseIPDB / GreyNoise (training sample: treat as attacker-controlled) |
| Domain | novag-rid-secure.com | Sender infrastructure; look-alike of novagrid |
| Domain | novagrid-m365-login.com | Credential-harvest landing + form action |
| URL | https://novagrid-m365-login.com/owa/ | Phishing landing page |
| URL | https://novagrid-m365-login.com/owa/collect.php | Credential POST endpoint |
| Hash (SHA-256) | c86ca00ccaff5c4661639b8fa6a277f342288a214116d0fde468cc3945784ecb | HTML attachment |
| Email | it-helpdesk@novagrid.com (spoofed) / helpdesk.novagrid@consultant-mail.com (reply-to) | |

## 5. Scope
- **Mail/SIEM search:** by subject `"Unpaid payment advice pending your approval"`, sender IP `185.220.101.47`, and the URL/domain `novagrid-m365-login.com` to find other recipients and any clicks.
- **Notify:** SOC Lead (Amara), Compliance (Zainab); if anyone entered credentials, Identity team for forced reset.

## 6. Recommended actions (next hour)
1. Block `novagrid-m365-login.com`, `novag-rid-secure.com` and IP `185.220.101.47` at mail gateway and web proxy/DNS.
2. Purge the message from all mailboxes (tenant-wide search-and-delete); quarantine any copies.
3. Confirm the CFO entered no credentials; if unsure, force password reset + revoke sessions + verify MFA.
4. Send a short staff advisory describing the lure and the look-alike domain.

## 7. Reflection (in your own words)
The urgency and the 12-hour deadline were the first tell, but the header read is what
confirmed it — an exact-domain spoof that fails DMARC can't be explained away. The
display-vs-href trick on the link is the detail a busy executive misses. With a real mail
gateway and SIEM I'd pivot on the hash and domain immediately to see blast radius; here I
reasoned it from the single sample.

## 8. Mapping
- **MITRE ATT&CK:** T1566.001 (attachment), T1566.002 (link), T1598 (phishing for information), T1204 (user execution)
- **NIST CSF:** DE.CM, DE.AE (detect) · RS.AN, RS.MI (respond)
- **Security+ SY0-701:** 2.2/2.4 (social engineering & indicators), 4.6 (monitoring/alerting), 5.6 (awareness)
