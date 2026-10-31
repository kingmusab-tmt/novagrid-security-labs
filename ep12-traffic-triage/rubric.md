# Rubric — Episode 12 (100 pts)

| Area | What "good" looks like | Pts |
|------|------------------------|-----|
| Infected host ID | Correct host + sound reasoning (initiator, not peer) | 15 |
| Infection chain | Correct, ordered delivery → download → C2 with evidence | 25 |
| Payload handling | Object exported, hashed, enriched — never executed | 15 |
| IOC extraction | Complete, correctly typed IOC table | 15 |
| C2 analysis | C2 channel identified with *why* (beaconing/SNI/odd POSTs) | 15 |
| Blocks & actions | Realistic, specific block-list + host action | 10 |
| Reflection | Specific and honest | 5 |

**Evidence required in `evidence/`:** protocol-hierarchy/conversations, the malicious
request, the exported-object hash, one enrichment, the IOC list/timeline. Verify findings
against malware-traffic-analysis.net's published answers for the assigned pcap.
