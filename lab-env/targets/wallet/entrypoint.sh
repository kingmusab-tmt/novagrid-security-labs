#!/usr/bin/env bash
# Container entrypoint for wallet-api: start the services a VM would run under systemd.
# Your config changes survive `docker compose stop/start`; `docker compose down` resets the lab.
set -u
ssh-keygen -A >/dev/null 2>&1
mkdir -p /run/sshd
rm -f /run/rsyslogd.pid
rsyslogd
cron
/usr/sbin/sshd
nohup python3 /opt/wallet/wallet_api.py >/dev/null 2>&1 &
if [ -f /etc/novagrid/enable-debug-server ]; then
  nohup python3 -m http.server 8000 --directory /srv/wallet/exports >/dev/null 2>&1 &
fi
echo "[novagrid] wallet-api up: ssh:22  wallet API:8080  debug server:8000 (if enabled)"
exec sleep infinity
