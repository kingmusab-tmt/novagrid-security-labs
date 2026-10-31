# Tabletop Injects — "Sable Finch Returns" (NovaGrid)

Facilitator: read each inject aloud, then drive the decision. Capture decision · owner ·
time target · gap before moving on. Scenario is fictional; it mirrors Episodes 11–24.

**Scenario frame:** Six weeks after the first breach, suspicious activity reappears on
NovaGrid's network during business hours. The wallet handles customer funds and PII.

---
**Inject 1 — Detection (09:02).** The SIEM fires the "admin brute force" alert (from your
Ep20 detection) against the finance portal, from a new IP.
*Decide:* Is this an event or an incident? Who triages, and who do they tell first?

**Inject 2 — Escalation (09:20).** Triage confirms a successful admin login and an
unfamiliar process on the finance workstation.
*Decide:* Who formally **declares an incident**? Who is on the response bridge?

**Inject 3 — Containment (09:35).** Containing means possibly taking the **wallet service
offline** during business hours — customers can't transact.
*Decide:* **Who authorises** taking the service down? What's the trigger/threshold? What's
the business trade-off and who owns it?

**Inject 4 — Internal comms (09:50).** Staff are noticing and asking in chat. Rumours start.
*Decide:* Who informs senior management? What do staff get told, by whom, and what are they
told **not** to do (e.g. talk to media)?

**Inject 5 — Legal / regulator / customer (10:30).** Evidence suggests customer PII may be
exposed. Nigerian data-protection rules (NDPR) and the card schemes (PCI DSS) may require
notification on a clock.
*Decide:* Who assesses the notification obligation? **Who authorises** notifying the
regulator and customers, and within what timeframe?

**Inject 6 — Recovery (12:15).** Eradication is done; the business wants the wallet back up.
*Decide:* Who signs off that it's safe to restore? What must be true before go-live
(patched, re-scanned, monitored)?

**Inject 7 — Public / PR (14:00).** A journalist emails asking about "an outage at NovaGrid."
*Decide:* Who speaks to the press? What is the holding statement, and who approves it?

**Inject 8 — After (next day).** The board calls an emergency review.
*Decide:* What are the top 3 things you report, and the single ask you make of the board?
