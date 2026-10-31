#!/usr/bin/env bash
# NovaGrid lab health check — confirms every service answers.
# Run from anywhere:  bash lab-env/scripts/check-lab.sh
# Probes from INSIDE the lab network (via the analyst container), so it works on a Linux
# VM and on Docker Desktop alike.
cd "$(dirname "$0")/.." || exit 1
fail=0
probe() {  # ip port label
  if docker compose exec -T analyst bash -c "timeout 3 bash -c 'echo > /dev/tcp/$1/$2'" >/dev/null 2>&1; then
    printf '  OK    %-24s %s:%s\n' "$3" "$1" "$2"
  else
    printf '  FAIL  %-24s %s:%s\n' "$3" "$1" "$2"; fail=1
  fi
}
echo "NovaGrid lab health check"
probe 172.28.0.10 22   "wallet-api ssh"
probe 172.28.0.10 8080 "wallet-api API"
probe 172.28.0.20 514  "logging collector"
probe 172.28.0.30 22   "legacy-billing ssh"
probe 172.28.0.30 8081 "legacy-billing admin"
if docker compose exec -T analyst bash -c "timeout 3 bash -c 'echo > /dev/tcp/172.28.0.10/8000'" >/dev/null 2>&1; then
  echo "  NOTE  debug server 172.28.0.10:8000 is OPEN (a Season 1 finding — expected until you fix it)"
else
  echo "  NOTE  debug server 172.28.0.10:8000 is closed (fixed)"
fi
[ "$fail" = 0 ] && echo "All core services up." || echo "Some services are down — try: docker compose up -d"
exit "$fail"
