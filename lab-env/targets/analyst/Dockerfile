# Analyst toolbox — a shell INSIDE the lab network (handy on Docker Desktop, where you
# can't reach container IPs directly). Use:  docker compose exec analyst bash
FROM ubuntu:22.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nmap openssh-client curl iproute2 iputils-ping dnsutils netcat-openbsd python3 ca-certificates less \
 && rm -rf /var/lib/apt/lists/*
CMD ["sleep", "infinity"]
