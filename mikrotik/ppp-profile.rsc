# -----------------------------------------------------------------------------
# PPP Profile
# -----------------------------------------------------------------------------

/ip pool
add \
    name=openvpn_pool \
    ranges=10.10.20.2-10.10.20.250

/ppp profile
add \
    name=ovpn_profile \
    local-address=10.10.20.1 \
    remote-address=openvpn_pool \
    dns-server=192.168.110.20,192.168.110.21
