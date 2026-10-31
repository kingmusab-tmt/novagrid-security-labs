# Instructor Answer Key — Episode 6
- Restricted/regulated = cardholder data (PCI DSS) and personal data (NDPR / PII).
- PCI DSS: avoid storing the PAN where possible; if stored it must be rendered unreadable (truncation/tokenisation/encryption). A stray plaintext card CSV is a finding.
- Students must actually run grep/regex scans and show (redacted) hits, not just theorise.
- Verification: (1) Restricted + the driving law; (2) where cardholder data was found + PCI stance; (3) a handling rule per class.
- Safety: synthetic/test data only; redact before committing.

## Ground truth in the reference lab (lab-env)
- PII: `/srv/wallet/data/customers.csv` (names, emails, phones, NIN field).
- Cardholder data: `/srv/wallet/exports/old_payments_backup.csv` (test PANs) — **and it's exposed on the network** via the debug server on port 8000. Restricted data, publicly readable: top finding.
- Secret: DB password in `/etc/wallet/wallet.conf` (world-readable).
