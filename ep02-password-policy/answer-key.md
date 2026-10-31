# Instructor Answer Key — Episode 2
- **Rotation:** modern NIST 800-63B advises *against* mandatory periodic rotation; rotate on evidence of compromise. (SY0-701 still references complexity/age — students should name both and explain the shift.)
- **Length:** >= 12–14 or passphrases; screen against breached lists; allow long/space-containing secrets.
- **Lockout:** reasonable throttle (e.g. faillock deny=5, unlock 900s).
- **MFA:** admin + remote/SSH first.
- Verification: (1) no forced rotation + why; (2) minlen + faillock threshold they set; (3) MFA on admin/remote first.
