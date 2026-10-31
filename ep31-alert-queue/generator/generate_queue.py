#!/usr/bin/env python3
"""
Episode 31 alert-queue generator — NovaGrid Security Labs.

Builds a realistic Tier-1 SOC shift: a queue of SIEM alerts that is mostly NOISE
(benign activity and false positives) with a handful of alerts that matter. The
student triages the queue under a clock — the skill is prioritisation and not
burning out on noise, exactly like a real console.

This produces DEFENSIVE training data only: alert records (timestamp, rule, host,
user, source, severity) in CSV + JSONL. It runs no attacks and touches no network.

Usage:
    python3 generate_queue.py [--alerts 120] [--seed NAME] [--out ./out]

The answer key (which alerts are true positives and why) is written to
_instructor_answers.csv and must NOT be given to students.
"""
import argparse, csv, json, os, random, datetime, hashlib

# verdict: "benign" (normal ops), "fp" (false positive), "tp" (true positive)
BENIGN = [
    ("Successful SSH login", "4.0 auth", "low", "{user} logged in from the office subnet 172.28.0.0/24"),
    ("Scheduled backup completed", "4.0 ops", "info", "svc-backup ran the nightly /srv/wallet backup"),
    ("Package update installed", "4.0 ops", "info", "unattended-upgrades patched {pkg} on {host}"),
    ("Firewall allowed known service", "4.0 ops", "low", "ufw allowed 8080/tcp to wallet-api (expected)"),
    ("Password changed", "4.0 auth", "low", "{user} changed their password at a console"),
    ("TLS handshake to payment partner", "4.0 ops", "info", "outbound TLS to the PayBridge sandbox (allow-listed)"),
]
FALSE_POS = [
    ("Multiple failed logins", "2.0/4.0 auth", "medium",
     "{n} failed logins for {user} then success — user fat-fingered the new password (confirmed with {user})"),
    ("Port scan detected", "2.0 recon", "medium",
     "sweep across 172.28.0.0/24 from the analyst box — it's the scheduled Nessus/Lynis scan window"),
    ("New admin account created", "4.0 auth", "high",
     "useradd for 'intern-aug' — matches the approved onboarding ticket CHG-2041"),
    ("Large outbound transfer", "4.0 ops", "medium",
     "2.1 GB to offsite — the approved weekly backup replication to /offsite"),
    ("Antivirus signature match", "2.0 malware", "medium",
     "EICAR test string in a user's Downloads — it's the monthly AV self-test"),
    ("Service restart", "4.0 ops", "low",
     "wallet-api restarted — matches the maintenance window in change calendar"),
]
TRUE_POS = [
    ("Successful admin login from new geo", "2.0/4.0 auth", "high",
     "root login to legacy-billing (172.28.0.30) from 203.0.113.66 — a host never seen before, outside the office subnet",
     "No change ticket; legacy-billing has no business being reached externally; source IP is unknown. Escalate: possible unauthorised access."),
    ("Brute force then success", "2.0/4.0 auth", "critical",
     "32 failed admin logins to the finance portal in 90s from 203.0.113.66, then one success",
     "Password-guessing that worked. Escalate immediately and check what the session did."),
    ("Rogue account with sudo", "4.0 auth", "critical",
     "new account 'support-svc' added to the sudo group with NO matching change ticket",
     "Unauthorised privileged account — a persistence foothold. Escalate and disable."),
    ("Data staged in web root", "2.0/4.0 ops", "high",
     "customers.csv copied into the public /srv/admin web directory on legacy-billing",
     "Sensitive data staged where it can be pulled over HTTP — likely exfil prep. Escalate."),
    ("Outbound to unknown host from server", "4.0 ops", "high",
     "wallet-api made repeated HTTP requests to 198.51.100.23 (not allow-listed) every 10 min",
     "Beacon-like pattern to an unknown host — possible C2 or exfil. Escalate and capture the traffic."),
]
USERS = ["amara","tunde","chidi","webadmin","contractor","svc-backup","intern-aug"]
HOSTS = ["wallet-api","logging","legacy-billing","analyst"]
PKGS  = ["openssl","curl","python3","rsyslog","openssh-server"]

def fill(text, rnd):
    return (text.replace("{user}", rnd.choice(USERS))
                .replace("{host}", rnd.choice(HOSTS))
                .replace("{pkg}",  rnd.choice(PKGS))
                .replace("{n}",    str(rnd.randint(3, 6))))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--alerts", type=int, default=120)
    ap.add_argument("--seed", default="novagrid")
    ap.add_argument("--out", default="./out")
    a = ap.parse_args()
    rnd = random.Random(int(hashlib.sha256(a.seed.encode()).hexdigest(), 16))
    os.makedirs(a.out, exist_ok=True)
    n_tp = min(len(TRUE_POS), max(4, a.alerts // 25))
    tps = rnd.sample(TRUE_POS, n_tp)
    n_noise = a.alerts - n_tp
    base = datetime.datetime(2026, 10, 30, 8, 0, 0)
    rows = []
    def add(kind, rule, dom, sev, desc, verdict, why=""):
        rows.append({"rule": rule, "domain": dom, "severity": sev, "description": desc,
                     "_verdict": verdict, "_why": why, "_kind": kind})
    for _ in range(n_noise):
        if rnd.random() < 0.55:
            r = rnd.choice(BENIGN); add("benign", r[0], r[1], r[2], fill(r[3], rnd), "benign")
        else:
            r = rnd.choice(FALSE_POS); add("fp", r[0], r[1], r[2], fill(r[3], rnd), "false-positive")
    for r in tps:
        add("tp", r[0], r[1], r[2], r[3], "true-positive", r[4])
    rnd.shuffle(rows)
    step = max(1, (8 * 60) // max(1, len(rows)))
    for i, row in enumerate(rows):
        ts = base + datetime.timedelta(minutes=i * step, seconds=rnd.randint(0, 59))
        row["id"] = f"ALRT-{1000+i}"; row["timestamp"] = ts.strftime("%Y-%m-%d %H:%M:%S")
    cols = ["id","timestamp","severity","rule","domain","description"]
    with open(os.path.join(a.out, "alert-queue.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
        for r in rows: w.writerow({c: r[c] for c in cols})
    with open(os.path.join(a.out, "alert-queue.jsonl"), "w") as f:
        for r in rows: f.write(json.dumps({c: r[c] for c in cols}) + "\n")
    with open(os.path.join(a.out, "_instructor_answers.csv"), "w", newline="") as f:
        w = csv.writer(f); w.writerow(["id","timestamp","severity","rule","verdict","why_it_matters","description"])
        for r in sorted(rows, key=lambda x: x["id"]):
            w.writerow([r["id"], r["timestamp"], r["severity"], r["rule"], r["_verdict"], r["_why"], r["description"]])
    tp_ids = sorted(r["id"] for r in rows if r["_kind"] == "tp")
    print(f"Wrote {len(rows)} alerts to {a.out}/alert-queue.csv")
    print(f"  true positives to find: {n_tp}  ->  {', '.join(tp_ids)}  (see _instructor_answers.csv)")

if __name__ == "__main__":
    main()
