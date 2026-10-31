# Instructor Answer Key — Episode 8
- 3-2-1: 3 copies, on 2 different media/locations, 1 off-site (ideally offline/immutable).
- Proof of restore = checksum verification (`sha256sum -c`) matching, not merely files reappearing.
- RPO = max tolerable data loss (drives backup frequency); RTO = max tolerable downtime (drives restore speed).
- Offline/immutable copy is the ransomware control — online backups can be encrypted too.
- Verification: (1) 3-2-1 + how met; (2) hash-verified restore; (3) RPO vs RTO.
