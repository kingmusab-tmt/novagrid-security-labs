#!/usr/bin/env bash
# Put the NovaGrid lab back to its original (intentionally weak) state.
# Removes the lab containers and its backup volumes, then rebuilds and starts it fresh.
#   bash lab-env/scripts/reset-lab.sh
cd "$(dirname "$0")/.." || exit 1
docker compose down -v
docker compose up -d --build
bash scripts/check-lab.sh
