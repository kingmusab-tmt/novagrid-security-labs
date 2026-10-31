#!/usr/bin/env python3
"""NovaGrid wallet API — a tiny LAB service (stdlib only). Not real, not secure, not for production.
Writes an Apache-style access log to /var/log/wallet/access.log for the logging episodes."""
import json, os, time
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

LOG = "/var/log/wallet/access.log"
BALANCES = {"chidi": 1250000, "amara": 84000, "cust_8842": 52000}

class Handler(BaseHTTPRequestHandler):
    server_version = "NovaGridWallet/0.9"

    def _send(self, code, body):
        data = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        line = '%s - - [%s] "%s" %s %s "-" "%s"\n' % (
            self.client_address[0], time.strftime("%d/%b/%Y:%H:%M:%S %z"),
            self.requestline, getattr(self, "_code", "-"), "-",
            self.headers.get("User-Agent", "-"))
        os.makedirs(os.path.dirname(LOG), exist_ok=True)
        with open(LOG, "a") as f:
            f.write(line)

    def send_response(self, code, message=None):
        self._code = code
        super().send_response(code, message)

    def do_GET(self):
        u = urlparse(self.path)
        if u.path == "/health":
            return self._send(200, {"status": "ok", "service": "novagrid-wallet"})
        if u.path == "/api/balance":
            user = parse_qs(u.query).get("user", [""])[0]
            if user in BALANCES:
                return self._send(200, {"user": user, "balance_ngn": BALANCES[user]})
            return self._send(404, {"error": "unknown user"})
        return self._send(404, {"error": "not found"})

    def do_POST(self):
        if urlparse(self.path).path == "/api/login":
            length = int(self.headers.get("Content-Length", 0) or 0)
            raw = self.rfile.read(length).decode(errors="replace")
            try:
                body = json.loads(raw or "{}")
            except ValueError:
                body = {}
            ok = body.get("username") in BALANCES and body.get("password") == "lab-only"
            return self._send(200 if ok else 401, {"login": "ok" if ok else "failed"})
        return self._send(404, {"error": "not found"})

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
