# Web-Vuln Findings & Fixes — Episode 16 (worked example)
**Analyst:** A. Analyst  **Date:** 2026-10-31  **Target:** OWASP Juice Shop (local)

## Finding 1 — SQL Injection (login)
- Input: email field on login.
- PoC: email `' OR 1=1--` logged in as the first user without a password.
- Root cause: the login query concatenates user input directly into SQL.
- Fix: use **parameterised/prepared statements** so input is data, never code; least-privilege DB account; generic error messages.

## Finding 2 — Cross-Site Scripting (stored)
- Type/location: stored XSS via a product/search field reflected to other users.
- PoC: `<script>alert(document.domain)</script>` executed in the browser.
- Root cause: user input rendered into HTML without output encoding.
- Fix: **context-aware output encoding**, input validation, and a **Content-Security-Policy** header; use a framework's auto-escaping.

## Summary & priority
SQLi first (auth bypass / data exposure), then stored XSS (hits every viewer). Both stem
from trusting user input.

## Reflection (own words)
The `' OR 1=1--` login was a one-line proof that the query was built by string-concatenation.
Filtering "bad characters" is whack-a-mole; parameterised queries fix the class of bug.
