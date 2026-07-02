<p align="center">
  <img src="images/banner.png" alt="SARABEL Informatika - PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN" width="100%">
</p>

# PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN

> Enterprise Multi-Factor Authentication (MFA) for MikroTik OpenVPN using PrivacyIDEA, FreeRADIUS and Docker.

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![MikroTik](https://img.shields.io/badge/MikroTik-E3000F?style=for-the-badge)
![PrivacyIDEA](https://img.shields.io/badge/PrivacyIDEA-009688?style=for-the-badge)
![FreeRADIUS](https://img.shields.io/badge/FreeRADIUS-005A9C?style=for-the-badge)
![OpenVPN](https://img.shields.io/badge/OpenVPN-EA7E20?style=for-the-badge)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge)

---

# Project Overview

This repository demonstrates how to implement **true Two-Factor Authentication (2FA)** for **MikroTik OpenVPN**, despite RouterOS not providing native TOTP or MFA support.

By integrating:

- PrivacyIDEA
- FreeRADIUS
- Docker Compose
- MikroTik RouterOS
- OpenVPN

it is possible to provide secure enterprise authentication without purchasing additional proprietary solutions.

---

# Why this project?

RouterOS currently supports:

- Username
- Password
- Certificate authentication

However, it **does not provide native Time-based One-Time Password (TOTP) authentication** for OpenVPN users.

This project bridges that gap by using:

```
OpenVPN Client
        │
        ▼
MikroTik RouterOS
        │
        ▼
FreeRADIUS
        │
        ▼
PrivacyIDEA
        │
        ▼
MariaDB
```

The result is enterprise-grade MFA while keeping the existing OpenVPN infrastructure.

---

# Features

- Docker Compose deployment
- PrivacyIDEA Authentication Server
- FreeRADIUS integration
- MikroTik RouterOS configuration
- TOTP Authentication
- Centralized user management
- Secure RADIUS communication
- OpenVPN compatibility
- Production-ready architecture

---

# Repository Structure

```
.
├── docs/
│   ├── installation.md
│   ├── configuration.md
│   ├── troubleshooting.md
│   ├── security.md
│   └── faq.md
│
├── mikrotik/
│   ├── radius-client.rsc
│   ├── firewall.rsc
│   └── openvpn-server.rsc
│
├── images/
│
├── screenshots/
│
├── docker-compose.yml
├── .env.example
├── CHANGELOG.md
└── README.md
```

---

# Documentation

| Document | Description |
|----------|-------------|
| installation.md | Complete installation guide |
| configuration.md | Configuration walkthrough |
| troubleshooting.md | Common issues and solutions |
| security.md | Security recommendations |
| faq.md | Frequently Asked Questions |

---

# Security

This repository is intended for educational and production reference purposes.

Before deploying into production:

- Change all default passwords.
- Generate new secret keys.
- Restrict RADIUS access.
- Enable HTTPS.
- Keep Docker images updated.
- Protect backups.
- Monitor authentication logs.

---

# Related Blog Article

A complete implementation guide is available on the SARABEL Informatika blog.

https://sarabelinformatika.hu

---

# Technologies

- MikroTik RouterOS
- OpenVPN
- Docker
- Docker Compose
- PrivacyIDEA
- FreeRADIUS
- MariaDB
- Linux
- Enterprise Authentication
- Multi-Factor Authentication (MFA)

---

# License

This project is released under the MIT License.

---

# Author

**SARABEL Informatika Kft.**

Enterprise IT Infrastructure • Virtualization • Backup • Monitoring • Microsoft 365 • Linux

🌐 https://sarabelinformatika.hu

LinkedIn:

https://www.linkedin.com/in/sarabel-informatika-kft-8041003a1/

GitHub:

https://github.com/sarabelinformatika
