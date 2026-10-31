#!/usr/bin/env bash
# NovaGrid "wallet-api" target — plants the INTENTIONAL weaknesses that Season 1 finds and fixes.
# LAB USE ONLY. Never run this on a real or shared machine.
# Used by BOTH the Docker image and the Vagrant VM, so the two targets are identical.
#
#   bash setup.sh [SRC_DIR]     (SRC_DIR holds app/ and seed/; default: this script's folder)
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
SRC="${1:-$(cd "$(dirname "$0")" && pwd)}"
# A booted VM runs systemd; a docker build/container does not.
IN_CONTAINER=1; [ -d /run/systemd/system ] && IN_CONTAINER=0

# ---------------------------------------------------------------- packages
apt-get update
apt-get install -y --no-install-recommends \
  openssh-server openssh-client sudo rsyslog cron logrotate python3 lynis \
  libpam-pwquality cracklib-runtime libpam-google-authenticator ufw iptables iproute2 procps \
  net-tools vim-tiny nano less tar ca-certificates bsdutils
if [ "$IN_CONTAINER" = 0 ]; then
  apt-get install -y --no-install-recommends auditd   # auditd only works on a real VM
fi

# ---------------------------------------------------------------- accounts (Eps 1, 2, 5, 10)
mkuser() { id "$1" >/dev/null 2>&1 || useradd -m -s /bin/bash -c "$2" "$1"; }
mkuser amara      "Amara Okafor - SOC Lead"
mkuser tunde      "Tunde Bello - Sysadmin"
mkuser chidi      "Chidi Nwosu - CFO"
mkuser svc-backup "Backup service account - owner tunde"
mkuser webadmin   "Web admin (2025 contractor)"
mkuser contractor "PayBridge integration contractor"

echo 'root:toor' | chpasswd                              # weak root password (Ep3)
for u in amara chidi svc-backup webadmin contractor; do echo "$u:NovaGrid!2026" | chpasswd; done
echo 'tunde:Tunde@2024' | chpasswd                       # the reused/breached password (Ep2 story)

for u in amara tunde webadmin contractor; do usermod -aG sudo "$u"; done
echo 'svc-backup ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/svc-backup   # over-privileged service acct (Ep5)
chmod 440 /etc/sudoers.d/svc-backup
chage -d 2026-01-10 webadmin                             # stale: password untouched since January

# leaver still holds an SSH key (Ep10 offboarding)
install -d -m 700 -o contractor -g contractor /home/contractor/.ssh
rm -f /tmp/ck /tmp/ck.pub
ssh-keygen -q -t ed25519 -N '' -C 'contractor@paybridge-laptop' -f /tmp/ck
install -m 600 -o contractor -g contractor /tmp/ck.pub /home/contractor/.ssh/authorized_keys
rm -f /tmp/ck /tmp/ck.pub

# ---------------------------------------------------------------- SSH: weak, set via a drop-in (Ep3)
# Ubuntu reads sshd_config.d/*.conf first and the FIRST value wins — so this overrides the main file.
mkdir -p /etc/ssh/sshd_config.d /run/sshd
cat > /etc/ssh/sshd_config.d/00-novagrid-lab.conf <<'EOF'
# NovaGrid legacy settings (left by the previous admin)
PermitRootLogin yes
PasswordAuthentication yes
EOF

# ---------------------------------------------------------------- password policy: weak (Ep2)
# pam_pwquality is present but configured weakly; faillock is not configured at all.
sed -i -E 's/^#?\s*minlen\s*=.*/minlen = 6/' /etc/security/pwquality.conf
grep -q '^minlen' /etc/security/pwquality.conf || echo 'minlen = 6' >> /etc/security/pwquality.conf

# ---------------------------------------------------------------- data (Eps 6, 8)
install -d /srv/wallet/data /srv/wallet/exports /srv/hr /etc/wallet /var/log/wallet
cp "$SRC/seed/customers.csv"           /srv/wallet/data/customers.csv
cp "$SRC/seed/old_payments_backup.csv" /srv/wallet/exports/old_payments_backup.csv
cp "$SRC/seed/staff-roster.csv"        /srv/hr/staff-roster.csv
cp "$SRC/seed/asset-register.csv"      /srv/hr/asset-register.csv
cp "$SRC/seed/wallet.conf"             /etc/wallet/wallet.conf
chmod 644 /etc/wallet/wallet.conf                        # secret readable by everyone (finding)
install -d /opt/wallet
cp "$SRC/app/wallet_api.py" /opt/wallet/wallet_api.py

# ---------------------------------------------------------------- logging: local only, no forwarding (Ep4)
sed -i -E 's/^(module\(load="imklog".*)$/# \1/' /etc/rsyslog.conf   # no kernel log in containers/VM-safe

# ---------------------------------------------------------------- services
# The leftover debug server runs while this flag file exists (delete it to "remove" the service).
install -d /etc/novagrid
touch /etc/novagrid/enable-debug-server

# Containers have no systemctl — give students a safe restart helper.
cat > /usr/local/bin/lab-restart <<'EOF'
#!/usr/bin/env bash
# Restart a NovaGrid lab service inside the container (no systemctl here).
#   lab-restart ssh | rsyslog | cron | wallet-api | debug-server
set -u
stop() { pkill -x "$1" 2>/dev/null; for _ in $(seq 1 25); do pgrep -x "$1" >/dev/null || return 0; sleep 0.2; done; }
case "${1:-}" in
  ssh|sshd)
    /usr/sbin/sshd -t || { echo "sshd config has an ERROR — not restarting (you would be locked out). Fix it and retry."; exit 1; }
    stop sshd; mkdir -p /run/sshd; /usr/sbin/sshd && echo "sshd restarted" ;;
  rsyslog|rsyslogd)
    stop rsyslogd; rm -f /run/rsyslogd.pid; rsyslogd && echo "rsyslog restarted" ;;
  cron)
    stop cron; cron && echo "cron restarted" ;;
  wallet-api)
    pkill -f wallet_api.py; sleep 0.5; nohup python3 /opt/wallet/wallet_api.py >/dev/null 2>&1 & echo "wallet-api restarted" ;;
  debug-server)
    pkill -f "http.server 8000"; sleep 0.5
    if [ -f /etc/novagrid/enable-debug-server ]; then
      nohup python3 -m http.server 8000 --directory /srv/wallet/exports >/dev/null 2>&1 & echo "debug server restarted"
    else echo "debug server stopped and disabled (flag file removed)"; fi ;;
  *) echo "usage: lab-restart ssh|rsyslog|cron|wallet-api|debug-server"; exit 2 ;;
esac
EOF
chmod 755 /usr/local/bin/lab-restart

if [ "$IN_CONTAINER" = 0 ]; then
  cat > /etc/systemd/system/wallet-api.service <<'EOF'
[Unit]
Description=NovaGrid wallet API (lab)
After=network.target
[Service]
ExecStart=/usr/bin/python3 /opt/wallet/wallet_api.py
Restart=always
[Install]
WantedBy=multi-user.target
EOF
  cat > /etc/systemd/system/wallet-debug.service <<'EOF'
[Unit]
Description=Leftover debug file server (should not exist)
After=network.target
[Service]
ExecStart=/usr/bin/python3 -m http.server 8000 --directory /srv/wallet/exports
Restart=always
[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable --now ssh rsyslog cron wallet-api wallet-debug auditd || true
  systemctl restart ssh || true
fi
echo "[novagrid] wallet-api target provisioned (container=$IN_CONTAINER)"
