# Episode 17 — Weak TLS / Certificate Assessment

## Cold open
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

## Scope & rules of engagement
- **In scope:** your own TLS endpoint (wallet host) and public teaching endpoints like
  badssl.com (designed for this). Testing is read-only.

## Environment setup
Tools: **testssl.sh**, **sslscan**, and `nmap --script ssl-enum-ciphers`, plus `openssl
s_client`. Target your wallet host; use **badssl.com** subdomains for known-bad examples.
See `environment/README.md`.

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

## Deliverable
Fill `deliverable-template.md` → the **crypto-config assessment** + remediation.

## Rubric

Self-check against `rubric.md`.

## Framework mapping
- **NIST CSF:** PROTECT — PR.DS (data-in-transit)
- **Security+ SY0-701:** 1.4 cryptographic solutions (protocols, ciphers, certificates, PFS); 3.x secure protocols

## Stretch goals
1. Add **HSTS** and explain what it prevents.
2. Compare two **badssl.com** endpoints (e.g. expired vs. modern) and document the differences.

## Verification questions
1. Which TLS protocol versions should be disabled, and which kept?
2. What is forward secrecy, and how do you tell from the cipher list if it's offered?
3. Name two certificate problems a client would reject, and why.
