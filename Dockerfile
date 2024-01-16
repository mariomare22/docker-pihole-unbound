#ARG PIHOLE_VERSION
FROM pihole/pihole:2024.01.0
RUN apt-get update && apt-get install -y unbound wget

COPY pihole-unbound/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY pihole-unbound/unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY pihole-unbound/99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
COPY pihole-unbound/unbound-run /etc/services.d/unbound/run
RUN wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints

EXPOSE 80/tcp
EXPOSE 80/udp
EXPOSE 53/tcp
EXPOSE 53/udp

ENTRYPOINT ./s6-init

#HEALTHCHECK CMD dig @127.0.0.1 pi.hole || exit 1
