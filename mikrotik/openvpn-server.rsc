# -----------------------------------------------------------------------------
# MikroTik RouterOS
# OpenVPN Server Configuration
#
# Example configuration
# -----------------------------------------------------------------------------

/interface ovpn-server server

add \
    name=openvpn_tcp \
    disabled=no \
    protocol=tcp \
    port=1194 \
    certificate=server \
    auth=sha256,sha512 \
    cipher=aes256-cbc \
    default-profile=ovpn_profile

add \
    name=openvpn_udp \
    disabled=no \
    protocol=udp \
    port=1195 \
    certificate=server \
    auth=sha256,sha512 \
    cipher=aes256-cbc \
    default-profile=ovpn_profile
