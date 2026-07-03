# -----------------------------------------------------------------------------
# FreeRADIUS Docker Image
#
# PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN
#
# This image extends the official FreeRADIUS image with the
# required Perl modules for PrivacyIDEA RADIUS authentication.
#
# Author:
# SARABEL Informatika Kft.
# https://sarabelinformatika.hu
# -----------------------------------------------------------------------------

FROM freeradius/freeradius-server:latest

LABEL maintainer="SARABEL Informatika Kft."
LABEL description="FreeRADIUS container for PrivacyIDEA integration"
LABEL version="1.0.0"

# -----------------------------------------------------------------------------
# Install required packages
# -----------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libwww-perl \
        libconfig-inifiles-perl \
        libjson-perl \
        cpanminus && \
    cpanm URI::Encode && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Expose RADIUS ports
# -----------------------------------------------------------------------------

EXPOSE 1812/udp
EXPOSE 1813/udp

# -----------------------------------------------------------------------------
# Start FreeRADIUS
# -----------------------------------------------------------------------------

CMD ["freeradius", "-f"]
