# Instructor Answer Key — Episode 17
- Disable SSLv3/TLS 1.0/1.1; keep TLS 1.2 and 1.3.
- Weak ciphers: RC4, 3DES, export, static-RSA/CBC-only; prefer AEAD (AES-GCM, ChaCha20).
- Forward secrecy = ECDHE/DHE key exchange → compromise of the server key doesn't decrypt past sessions; visible as ECDHE in the cipher list.
- Cert rejects: expired, name mismatch, untrusted/incomplete chain, weak key (<2048 RSA), SHA-1 signature.
- Verification: (1) disable 1.0/1.1, keep 1.2/1.3; (2) forward secrecy via ECDHE; (3) two cert problems + why.
