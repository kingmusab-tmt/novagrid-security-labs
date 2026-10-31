# NovaGrid wallet-api lab target (INTENTIONALLY weak — lab use only)
FROM ubuntu:22.04
COPY . /opt/novagrid-setup
# strip Windows CRLF line endings in case the repo was checked out on Windows
RUN sed -i 's/\r$//' /opt/novagrid-setup/*.sh /opt/novagrid-setup/app/*.py /opt/novagrid-setup/seed/* \
 && bash /opt/novagrid-setup/setup.sh /opt/novagrid-setup \
 && rm -rf /var/lib/apt/lists/*
EXPOSE 22 8000 8080
CMD ["bash", "/opt/novagrid-setup/entrypoint.sh"]
