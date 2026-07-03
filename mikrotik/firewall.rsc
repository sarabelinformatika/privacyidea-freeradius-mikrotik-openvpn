# -----------------------------------------------------------------------------
# OpenVPN Firewall Rules
# -----------------------------------------------------------------------------

/ip firewall filter

add \
    chain=input \
    protocol=tcp \
    dst-port=1194 \
    action=accept \
    comment="Allow OpenVPN TCP"

add \
    chain=input \
    protocol=udp \
    dst-port=1195 \
    action=accept \
    comment="Allow OpenVPN UDP"

add \
    chain=forward \
    src-address=10.10.20.0/24 \
    dst-address=192.168.110.0/24 \
    action=accept \
    comment="Allow VPN clients to LAN"

add \
    chain=forward \
    src-address=192.168.110.0/24 \
    dst-address=10.10.20.0/24 \
    action=accept \
    comment="Allow LAN to VPN clients"

# MSS adjustment

/ip firewall mangle

add \
    chain=forward \
    protocol=tcp \
    tcp-flags=syn \
    src-address=10.10.20.0/24 \
    action=change-mss \
    new-mss=1360 \
    comment="OpenVPN MSS Fix"

add \
    chain=forward \
    protocol=tcp \
    tcp-flags=syn \
    dst-address=10.10.20.0/24 \
    action=change-mss \
    new-mss=1360 \
    comment="OpenVPN MSS Fix"
