# TLS / Crypto-Config Assessment — Episode 17 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Target:** wallet-api:443

## 1. Protocols offered
| Protocol | Offered? | Keep/Disable |
|---|---|---|
| TLS 1.3 | no | enable |
| TLS 1.2 | yes | keep |
| TLS 1.1 / 1.0 | **yes** | **disable** |
| SSLv3 | no | — |

## 2. Ciphers & forward secrecy
- Weak: 3DES and a CBC suite offered; one RC4 on the legacy vhost.
- Forward secrecy: only some ECDHE suites — should be preferred/only.

## 3. Certificate
| Check | Result |
|---|---|
| Validity | valid, 40 days left — renew process unclear |
| Chain | intermediate missing (some clients fail) |
| Key size/type | RSA 2048 (ok) |
| Signature | SHA-256 (ok) |
| CN/SAN | matches |

## 4. Weaknesses & remediation
| Weakness | Risk | Fix |
|---|---|---|
| TLS 1.0/1.1 enabled | downgrade/known attacks | disable; TLS 1.2+ only |
| 3DES/RC4/CBC ciphers | weak crypto | remove; use modern AEAD (AES-GCM, ChaCha20) |
| Missing intermediate | client trust failures | install full chain |
| No forward secrecy preference | past traffic exposure if key leaks | prefer ECDHE |

## 5. Target "good" configuration
TLS 1.2 + 1.3 only; ECDHE + AES-GCM/ChaCha20; full chain installed; HSTS enabled; automated renewal.

## 6. Reflection (own words)
The scanner just said "weak TLS"; the value was translating that into *disable 1.0/1.1,
drop 3DES/RC4, fix the chain, prefer ECDHE* — specific changes Tunde can actually make.
