# -----------------------------------------------------------------------------
# MikroTik RouterOS
# FreeRADIUS Client Configuration
#
# Example configuration for:
# PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN
#
# SARABEL Informatika Kft.
# https://sarabelinformatika.hu
# -----------------------------------------------------------------------------

# Configure the external RADIUS server

/radius
add \
    address=192.168.110.10 \
    service=ppp \
    authentication-port=1812 \
    accounting-port=1813 \
    secret=CHANGE_ME

# Enable RADIUS authentication for PPP services

/ppp aaa
set \
    use-radius=yes \
    accounting=yes
