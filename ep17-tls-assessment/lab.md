# Episode 17 — Weak TLS / Certificate Assessment

## Cold open

*Story so far — Same scan (Ep15), different weakness: the payments site is offering weak TLS. On a wallet, that has to be right.*

> **From:** Tunde Bello (Sysadmin)
> **Subject:** Is our HTTPS actually secure?
>
> A scan flagged "weak TLS" on the wallet site. I don't fully get the output — can you
> assess what protocols and ciphers we're offering, check the certificate, and tell me
> exactly what to change? It's a payments site; it has to be right. — Tunde

## Your role & mission objectives
- **Role:** analyst assessing TLS/certificate configuration.
- **Objectives:**
  1. Enumerate offered **protocols** and **cipher suites**.
  2. Check the **certificate**: validity, chain, key size, signature algorithm, name match.
  3. Identify weaknesses (old TLS/SSL, weak ciphers, no forward secrecy, cert issues).
  4. Write the **remediation** (what to disable/enable and why).

## Concept Explanation — TLS & certificate assessment

TLS protects data in transit — but only if it's configured well. A weak setup offers obsolete
protocols or ciphers, lacks **forward secrecy**, or presents a broken certificate, any of which a
browser (or an attacker) can exploit. Assessing it means enumerating what the server offers, judging
it against modern baselines (TLS 1.2+ with AEAD ciphers and ECDHE), and checking the certificate is
valid, trusted and correctly named.

**Key terms**
- **TLS version** — SSLv3/TLS 1.0/1.1 are obsolete and must be disabled; TLS 1.2+ only.
- **Cipher suite** — the agreed algorithms for key exchange, encryption and integrity; weak ones (RC4, 3DES, export) must go.
- **Forward secrecy (ECDHE)** — session keys that aren't recoverable even if the server's private key later leaks.
- **Certificate chain** — the server cert plus intermediates linking to a trusted root; an incomplete chain breaks trust.
- **CN / SAN** — the names a certificate is valid for; must match the hostname.
- **HSTS** — a header forcing HTTPS, preventing downgrade/stripping.

## Scope & rules of engagement
- **In scope:** your own TLS endpoint (wallet host) and public teaching endpoints like
  badssl.com (designed for this). Testing is read-only.

## Environment setup
Tools: **testssl.sh**, **sslscan**, and `nmap --script ssl-enum-ciphers`, plus `openssl
s_client`. Target your wallet host; use **badssl.com** subdomains for known-bad examples.

Tools (install on the analyst VM): `testssl.sh` (clone from github.com/drwetter/testssl.sh),
`sslscan`, `nmap`, `openssl`. Targets: your own wallet host's 443, and **badssl.com**
subdomains (e.g. `expired.badssl.com`, `rc4.badssl.com`, `tls-v1-0.badssl.com`) which exist
specifically for safe TLS testing. All checks are read-only.

## Guided investigation
1. **Enumerate.** `nmap --script ssl-enum-ciphers -p 443 <host>` and/or `testssl.sh <host>`.
   - **Decision:** Which protocols are offered? Are SSLv3/TLS 1.0/1.1 present (they shouldn't be)?
2. **Ciphers & PFS.** Review cipher suites and key exchange.
   - **Decision:** Which ciphers are weak (RC4, 3DES, export, CBC issues)? Is forward secrecy (ECDHE) offered?
3. **Certificate.** `openssl s_client -connect <host>:443` → check expiry, chain completeness, key size (>=2048 RSA / ECC), signature (no SHA-1), and CN/SAN match.
   - **Decision:** Any cert problems a browser would warn on? Why does each matter?
4. **Remediate.** Specify the target config (e.g. TLS 1.2+ only, modern AEAD ciphers, ECDHE, HSTS).

### Evidence checkpoints
- [ ] protocol/cipher enumeration output  - [ ] certificate details  - [ ] the weakness list  - [ ] the target "good" config

## Commands explained

| Command | What it does | Why you use it here |
|---|---|---|
| `nmap --script ssl-enum-ciphers -p 443 <host>` | lists offered protocols and cipher suites with grades | find obsolete protocols / weak ciphers |
| `testssl.sh <host>` | a thorough TLS/cert audit in one run | cross-check and catch cert issues, HSTS, etc. |
| `openssl s_client -connect <host>:443` | opens a raw TLS session and prints the cert chain | inspect expiry, chain, key size, CN/SAN |
| check signature algorithm / key size | confirm no SHA-1, RSA ≥ 2048 / ECC | judge the certificate's strength |

## On Windows

The cross-platform checks work on Windows: `nmap --script ssl-enum-ciphers -p 443 <host>` and **sslscan**
(Windows build). `testssl.sh` itself needs WSL or Git-Bash. PowerShell can do quick checks:
```powershell
Test-NetConnection <host> -Port 443              # reachability
# inspect the certificate:
$c = Get-PfxCertificate -FilePath (some)   # or use openssl via Git for Windows:
#   openssl s_client -connect <host>:443
```
The findings (obsolete protocols, weak ciphers, missing forward secrecy, cert problems) and the
remediation (TLS 1.2+ only, modern AEAD + ECDHE, HSTS) are identical.

## Deliverable
Fill `deliverable-template.md` → the **crypto-config assessment** + remediation.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **MITRE ATT&CK Mitigations:** M1041 Encrypt Sensitive Information (strong TLS), M1035 Limit Access to Resource Over Network (disable weak protocols/ciphers)
- **NIST CSF:** PROTECT — PR.DS (data-in-transit)
- **Security+ SY0-701:** 1.4 cryptographic solutions (protocols, ciphers, certificates, PFS); 3.x secure protocols

## Stretch goals
1. Add **HSTS** and explain what it prevents.
2. Compare two **badssl.com** endpoints (e.g. expired vs. modern) and document the differences.

## Verification questions
1. Which TLS protocol versions should be disabled, and which kept?
2. What is forward secrecy, and how do you tell from the cipher list if it's offered?
3. Name two certificate problems a client would reject, and why.
