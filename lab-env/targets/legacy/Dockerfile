# "legacy-billing" — a forgotten, unmanaged host nobody put in the asset register (Ep1)
FROM ubuntu:22.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssh-server python3 \
 && rm -rf /var/lib/apt/lists/* \
 && echo 'root:admin' | chpasswd \
 && mkdir -p /run/sshd /srv/admin /etc/ssh/sshd_config.d \
 && printf 'PermitRootLogin yes\nPasswordAuthentication yes\n' > /etc/ssh/sshd_config.d/00-legacy.conf
COPY index.html /srv/admin/index.html
EXPOSE 22 8081
CMD ["bash", "-c", "ssh-keygen -A >/dev/null 2>&1; /usr/sbin/sshd; exec python3 -m http.server 8081 --directory /srv/admin"]
