# Rubric — Episode 11 (100 pts)

| Area | What "good" looks like | Pts |
|------|------------------------|-----|
| Verdict & summary | Correct verdict; management summary is clear and actionable | 15 |
| Header analysis | SPF/DKIM/DMARC read correctly; true origin IP identified | 20 |
| Content analysis | Lookalike URL spotted (visible vs. href); attachment typed & hashed | 20 |
| IOC extraction | Complete, correctly typed IOC table | 15 |
| Enrichment | At least 2 indicators checked against real OSINT, verdicts recorded | 10 |
| Scoping & actions | Sensible mail/SIEM search + realistic containment/user actions | 15 |
| Reflection | Honest, specific, in own words | 5 |

**Evidence required in `evidence/`:** header analysis, IOC list, ≥1 enrichment screenshot,
`file`+`sha256sum` output, proposed scoping query. Missing evidence caps the related area.
