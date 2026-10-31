# The Sable Finch Campaign — storyline brief

> This is the **narrative spine** of the whole series, so you know what you're reconstructing.
> Everything here is fictional and defensive. You don't attack anything in this episode — you
> **assemble the story** from evidence you already produced in Episodes 11–31.

Sable Finch is the recurring adversary across NovaGrid's year. Reconstructed, their campaign
ran the classic kill chain — and each stage maps to an episode you've already worked:

| Kill-chain stage | What Sable Finch did (story) | You investigated it in |
|---|---|---|
| Reconnaissance | Mapped NovaGrid's public surface; found the forgotten `legacy-billing` box | Ep 1 (asset audit), Ep 15 (vuln scan) |
| Initial access | Phishing the CFO; credential stuffing the portal | Ep 11 (phishing), Ep 18 (credential stuffing) |
| Execution / foothold | Landed on a host, dropped tooling | Ep 13 (host compromise), Ep 14 (malware triage) |
| Persistence / privilege | Rogue sudo account, reused SSH key, weak SSH | Ep 2, Ep 3, Ep 5, Ep 31 (rogue account) |
| Lateral movement / C2 | Beaconing from wallet-api to an unknown host | Ep 12 (traffic triage), Ep 31 (beacon alert) |
| Collection / staging | Customer PII copied into a public web dir | Ep 6 (data classification), Ep 31 (data staged) |
| Exfiltration | Pulled the staged data over HTTP | Ep 12, Ep 16 (web), Ep 23 (forensics) |
| Impact | Attempted to disrupt the wallet service | Ep 21 (contain), Ep 22 (recover) |

Your job in the capstone: turn these scattered episode findings into **one coherent incident
story** an employer (or a board) can follow end to end.
