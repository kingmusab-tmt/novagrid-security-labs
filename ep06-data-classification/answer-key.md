# Instructor Answer Key — Episode 6
- Restricted/regulated = cardholder data (PCI DSS) and personal data (NDPR / PII).
- PCI DSS: avoid storing the PAN where possible; if stored it must be rendered unreadable (truncation/tokenisation/encryption). A stray plaintext card CSV is a finding.
- Students must actually run grep/regex scans and show (redacted) hits, not just theorise.
- Verification: (1) Restricted + the driving law; (2) where cardholder data was found + PCI stance; (3) a handling rule per class.
- Safety: synthetic/test data only; redact before committing.
