# Logging Baseline — Episode 4 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31

## 1. Log sources & events
| Source | Events captured | Why it matters |
|---|---|---|
| auth/SSH | logins, failures | detect brute force / unauthorised access |
| sudo | privilege use | track admin actions |
| web (access) | requests, 4xx/5xx | spot scanning/exploitation |
| ufw/auditd | blocked traffic, file changes | surface tampering |

## 2. Central collection
- Forwarded over **TCP/514** (reliable delivery) via rsyslog `*.* @@logging:514`.
- Collector: rsyslog `imtcp` on 514, writing per-host files under `/var/log/remote/`.
- Proof: a failed SSH login on wallet-api appears on the collector within seconds.

## 3. Time sync & retention
- `timedatectl` shows NTP synchronized on both hosts.
- Retention: 90 days via logrotate (balance of investigation need vs disk).

## 4. Dashboard queries
| Question | Query | Sample result |
|---|---|---|
| Failed SSH logins | `journalctl _SYSTEMD_UNIT=ssh.service | grep "Failed password"` | 12 from one IP |
| Sudo usage | `grep sudo /var/log/remote/*/auth.log` | tunde x4 |
| Top source IPs | `awk '{print $1}' access.log | sort | uniq -c | sort -rn | head` | one noisy IP |
| Web 4xx/5xx | `awk '$9 ~ /^[45]/' access.log | wc -l` | spike at 09:00 |

## 5. Reflection (own words)
Time sync sounds boring until you try to line up events across two hosts — without it the
timeline is guesswork. TCP forwarding was the right call; I didn't want to lose events.
