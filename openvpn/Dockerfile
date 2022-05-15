FROM mrnerd/baseimage:20.04

ENV KILL_SWITCH=on
ENV VPN_LOG_LEVEL=3

RUN apt-get install -y --no-install-recommends openvpn iptables dnsutils iputils-ping

COPY resources /app

RUN mkdir -p /var/log/openvpn && \
    rm /app/configs/.gitkeep

HEALTHCHECK CMD ping -c 3 1.1.1.1 || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
