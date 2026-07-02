# privacyidea-freeradius-mikrotik-openvpn
Enterprise-ready Multi-Factor Authentication (MFA) for MikroTik OpenVPN using PrivacyIDEA, FreeRADIUS and Docker Compose.

# MikroTik OpenVPN MFA with PrivacyIDEA + FreeRADIUS

Enterprise-ready Multi-Factor Authentication (MFA) for MikroTik OpenVPN using **PrivacyIDEA** and **FreeRADIUS**.

> **Official companion repository of the SARABEL Informatika technical article.**

---

## Overview

MikroTik RouterOS provides a stable and reliable OpenVPN server implementation, but **it does not natively support modern Multi-Factor Authentication (MFA)** methods such as TOTP (Google Authenticator, Microsoft Authenticator, Authy, etc.).

This repository demonstrates how to extend MikroTik OpenVPN authentication by integrating:

- PrivacyIDEA
- FreeRADIUS
- Docker Compose
- MariaDB
- TOTP Authentication

The result is a secure and centrally managed MFA solution suitable for business environments.

---

## Why This Solution?

Native MikroTik authentication supports:

- Local users
- RADIUS
- Active Directory (via RADIUS)

However, it **cannot validate Time-based One-Time Passwords (TOTP)** on its own.

By introducing **PrivacyIDEA** and **FreeRADIUS**, MikroTik delegates authentication to a RADIUS server, which validates both:

- Username & Password
- One-Time Password (OTP)

This enables enterprise-grade two-factor authentication without replacing the existing VPN infrastructure.

---

## Architecture

```text
                +------------------+
                | MikroTik Router  |
                | OpenVPN Server   |
                +---------+--------+
                          |
                     RADIUS Request
                          |
                +---------v--------+
                |   FreeRADIUS     |
                +---------+--------+
                          |
                Authentication
                          |
                +---------v--------+
                |   PrivacyIDEA    |
                +---------+--------+
                          |
                     MariaDB
```

---

## Features

- Docker-based deployment
- PrivacyIDEA 3.x
- FreeRADIUS integration
- TOTP Authentication
- Google Authenticator compatible
- Microsoft Authenticator compatible
- Authy compatible
- Enterprise-ready architecture
- Easy backup and migration
- Secure authentication workflow

---

## Repository Contents

```
docker-compose.yml
.env.example
README.md

privacyidea/
freeradius/
mariadb/

examples/

mikrotik/

screenshots/

docs/
```

---

## Technologies

- MikroTik RouterOS
- OpenVPN
- PrivacyIDEA
- FreeRADIUS
- Docker
- Docker Compose
- MariaDB
- Linux

---

## Requirements

- MikroTik RouterOS
- Docker Engine
- Docker Compose
- Linux Server (Debian recommended)
- Public DNS (optional)
- SMTP server (recommended)

---

## Security

This repository **does not include production secrets**.

Sensitive information such as:

- API keys
- Database passwords
- Secret keys
- Encryption keys

must be configured through the `.env` file.

---

## Related Article

A complete deployment guide is available on the SARABEL Informatika blog:

➡️ https://sarabelinformatika.hu/blog/

---

## Disclaimer

This repository is intended for educational and production deployment reference purposes.

Always review and adapt the configuration before deploying it into a production environment.

---

## Author

**SARABEL Informatika Kft.**

Enterprise IT Infrastructure  
Virtualization • Backup • Monitoring • Microsoft 365

🌐 https://sarabelinformatika.hu

---

If this repository helped you, consider giving it a ⭐.
