# Environment — Episode 17
Tools (install on the analyst VM): `testssl.sh` (clone from github.com/drwetter/testssl.sh),
`sslscan`, `nmap`, `openssl`. Targets: your own wallet host's 443, and **badssl.com**
subdomains (e.g. `expired.badssl.com`, `rc4.badssl.com`, `tls-v1-0.badssl.com`) which exist
specifically for safe TLS testing. All checks are read-only.
