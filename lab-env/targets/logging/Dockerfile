# NovaGrid central log collector (rsyslog) — lab use
FROM ubuntu:22.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends rsyslog logrotate procps iproute2 less \
 && rm -rf /var/lib/apt/lists/* \
 && sed -i -E 's/^(module\(load="imklog".*)$/# \1/' /etc/rsyslog.conf
COPY 10-collector.conf /etc/rsyslog.d/10-collector.conf
# rsyslog drops privileges to the 'syslog' user, so it must own the folder it writes into
RUN sed -i 's/\r$//' /etc/rsyslog.d/10-collector.conf \
 && mkdir -p /var/log/remote && chown syslog:adm /var/log/remote
EXPOSE 514/tcp 514/udp
CMD ["rsyslogd", "-n"]
