# Episode 11 — Phishing to the CFO

## Cold open

> **From:** Amara Okafor (SOC Lead)
> **To:** You (Security Analyst)
> **Subject:** FWD: is this real? — Chidi forwarded this
>
> Morning. Chidi (our CFO) just forwarded an email he "almost clicked." He says the
> login page looked like our Microsoft 365 sign-in. I need you to work it as a proper
> phishing investigation — don't just eyeball it. Tell me: is it malicious, what are
> the indicators, has anyone else received it, and what do we do in the next hour?
> Put it in a short report I can hand to Zainab in compliance. — Amara

The forwarded message is saved for you at `environment/data/phishing-sample.eml`.

## Your role & mission objectives
- **Role:** Tier-1/2 security analyst at NovaGrid, triaging a reported phishing email.
- **Objectives:**
  1. Determine whether the email is malicious, with evidence (not a guess).
  2. Extract every indicator of compromise (IOC): sender infrastructure, URLs, domains, attachment hash.
  3. Enrich the IOCs against real threat-intelligence sources and record the verdicts.
  4. Recommend immediate containment and user-facing actions.
  5. Produce a phishing-analysis report an employer would accept.

## Scope & rules of engagement
- **In scope:** static analysis of the provided `.eml`, header analysis, URL/domain/hash enrichment via OSINT, and a written report.
- **Out of scope:** visiting the live phishing URL in a normal browser, entering any credentials, or downloading/running the payload outside an isolated sandbox.
- **Defensive framing:** this is detection and response. Treat every link and attachment as hostile; analyse, never interact.

## Environment setup
This episode is deliberately light — no heavy VM required.

On your analyst VM (or any Linux/WSL shell) you need:
- A text editor and a terminal with `python3`, `file`, `strings` (and optionally `oledump.py`).
- A browser for the OSINT sites below (free accounts help but aren't required):
  - VirusTotal — https://www.virustotal.com
  - URLhaus & ThreatFox (abuse.ch) — https://urlhaus.abuse.ch / https://threatfox.abuse.ch
  - AbuseIPDB — https://www.abuseipdb.com
- **Golden rule:** detonate nothing. If you want to see a URL's behaviour, submit it to **Any.Run** (free) or VirusTotal, not your own browser.

Start:
```bash
cd ep11-phishing-cfo/environment
ls data/                      # phishing-sample.eml
less data/phishing-sample.eml # read the raw message, headers and all
```

## Guided investigation

Work the email the way an analyst does — top of the headers down to the payload. At each
step there's a **decision** to make and justify in your notes.

1. **Read the raw headers.** Open the `.eml` as plain text so you see the real headers, not a client's rendering.
   - **Decision:** Does the `From:` display name match the actual `From:` address domain? Does `Reply-To:` differ from `From:`? What does the `Return-Path` say?

2. **Follow the Received chain & authentication.** Trace the `Received:` hops (bottom = origin) and read `Authentication-Results:`.
   - **Decision:** Do **SPF**, **DKIM** and **DMARC** pass or fail? What is the true originating IP, and does it belong to NovaGrid or Microsoft at all?

3. **Extract the URLs.** Pull every link from the body (and any `<a href>` that differs from its visible text).
   - **Decision:** Is the sign-in link really a Microsoft/NovaGrid domain, or a lookalike? Note the exact domain and any URL-shortener or redirect.

4. **Examine the attachment.** Identify its true type with `file`, compute its hash, and inspect it statically.
   ```bash
   # if the sample ships an attachment, extract and hash it (do NOT open it)
   sha256sum data/attachment.*        # record the hash
   file data/attachment.*             # real type vs. claimed extension
   ```
   - **Decision:** Does the file type match its extension? Macro-bearing document, script, or archive? What does it claim to be vs. what it is?

5. **Enrich the IOCs (real threat intel).** Take the sending IP, the sender/lookalike domains, the URL, and the attachment hash and check each against VirusTotal, URLhaus/ThreatFox and AbuseIPDB.
   - **Decision:** What's the community/vendor verdict on each indicator? Is this a known campaign or kit?

6. **Scope it.** Decide what you'd query in mail logs / the SIEM to find out who else got it.
   - **Decision:** What search would you run (sender, subject, URL, hash) to find other recipients, and who do you notify?

### 📸 Evidence checkpoints
Save each into `evidence/` with a clear filename:
- [ ] Screenshot/paste of the **header analysis** showing SPF/DKIM/DMARC results
- [ ] The **extracted IOC list** (IPs, domains, URLs, attachment hash)
- [ ] Screenshot of **at least one enrichment** result (VirusTotal / URLhaus / AbuseIPDB)
- [ ] The **`file` + `sha256sum`** output for the attachment
- [ ] Your proposed **mail-search / SIEM query** to scope other recipients

## Deliverable
Fill in `deliverable-template.md` to produce your **Phishing-Analysis Report**: verdict,
evidence, IOC table, scope, and recommended actions. This is the artifact that goes in
your portfolio. See `example-deliverable.md` for the standard to aim at.

## Rubric
Self-check against `rubric.md` before you call it done.

## Framework mapping
- **MITRE ATT&CK:** T1566.001/.002 (Phishing: attachment / link), T1598 (Phishing for Information), T1204 (User Execution)
- **NIST CSF:** DETECT (DE.CM, DE.AE) and RESPOND (RS.AN, RS.MI)
- **Security+ SY0-701:** 2.2/2.4 (social-engineering & attack indicators), 4.6 (alerting/monitoring), 5.6 (security awareness)

## Stretch goals (real data)
1. **Real malspam in Wireshark.** Download a current malspam exercise from
   https://www.malware-traffic-analysis.net (email + pcap). Open the pcap in Wireshark,
   follow the HTTP/TLS stream to the payload delivery, and add the real URLs/IPs to your
   IOC list. Compare the technique to NovaGrid's email.
2. **Enrich for real.** Submit the stretch sample's URL to Any.Run or VirusTotal and
   screenshot the behaviour.
3. **Write the user advisory.** Draft the 4-line warning Amara would send to all staff.

## Verification questions (instructor sign-off)
1. What is the true originating IP in `phishing-sample.eml`, and which authentication check(s) fail?
2. What is the exact lookalike sign-in domain, and how does it differ from the real one?
3. What is the SHA-256 of the attachment, and what is its real file type?
