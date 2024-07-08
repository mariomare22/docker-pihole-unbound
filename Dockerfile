#ARG PIHOLE_VERSION
FROM pihole/pihole:2024.07.0
RUN apt-get update && apt-get install -y unbound wget

COPY pihole-unbound/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY pihole-unbound/unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY pihole-unbound/99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
COPY pihole-unbound/unbound-run /etc/services.d/unbound/run
RUN wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints


ENTRYPOINT ./s6-init
