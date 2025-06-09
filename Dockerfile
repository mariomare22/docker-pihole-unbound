# Use the new Alpine-based Pi-hole image
FROM pihole/pihole:2025.06.1

# Update package list and install unbound and wget
RUN apk update && apk add unbound wget

# Copy configuration files
COPY pihole-unbound/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY pihole-unbound/unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY pihole-unbound/99-edns.conf /etc/dnsmasq.d/99-edns.conf

# Create the services directory and copy the run script
RUN mkdir -p /etc/services.d/unbound
COPY pihole-unbound/unbound-run /etc/services.d/unbound/run

# Create the unbound directory and set permissions
RUN mkdir -p /var/lib/unbound && \
    chown pihole:pihole /var/lib/unbound

# Download the root hints file for unbound
RUN wget https://www.internic.net/domain/named.root -qO /var/lib/unbound/root.hints

ENTRYPOINT ["start.sh"]
