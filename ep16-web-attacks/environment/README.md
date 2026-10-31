# Environment — Episode 16
Run a deliberately vulnerable app **locally**:
- OWASP Juice Shop: `docker run --rm -p 3000:3000 bkimminich/juice-shop`
- or DVWA: `docker run --rm -it -p 8080:80 vulnerables/web-dvwa`
Optional: Burp Suite Community to intercept/modify requests. Only ever test these local
apps or targets you own/have written authorisation for. This is authorised testing in your
own lab — nothing else.
