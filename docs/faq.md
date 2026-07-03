# Frequently Asked Questions (FAQ)

> Frequently asked questions about deploying PrivacyIDEA, FreeRADIUS and MikroTik OpenVPN using Docker Compose.

---

# General

## What problem does this project solve?

MikroTik RouterOS supports RADIUS authentication for OpenVPN but does not provide native support for Time-based One-Time Password (TOTP) authentication.

This project bridges that limitation by integrating:

- PrivacyIDEA
- FreeRADIUS
- Docker Compose
- MikroTik RouterOS

to provide enterprise-grade Multi-Factor Authentication (MFA).

---

## Is this a production-ready solution?

Yes.

The architecture is suitable for production deployments when:

- HTTPS is enabled.
- Strong secrets are used.
- Security recommendations are followed.
- Monitoring is configured.
- Regular backups are performed.

---

## Is this an official MikroTik solution?

No.

This is an independent open-source implementation demonstrating how MikroTik RouterOS can be integrated with PrivacyIDEA through FreeRADIUS.

---

# MikroTik

## Does MikroTik support TOTP natively?

No.

RouterOS currently supports:

- Local authentication
- RADIUS
- Certificates

Native TOTP authentication for OpenVPN is not available.

---

## Why is FreeRADIUS required?

PrivacyIDEA is not a RADIUS server.

FreeRADIUS receives authentication requests from MikroTik and forwards them to PrivacyIDEA.

---

## Which RouterOS versions are supported?

The project has been tested with RouterOS 7.x.

Earlier versions may work but have not been validated.

---

## Can multiple MikroTik routers use the same PrivacyIDEA server?

Yes.

Multiple routers can authenticate against a single FreeRADIUS and PrivacyIDEA instance.

Each router must be configured as a trusted RADIUS client.

---

# PrivacyIDEA

## What is PrivacyIDEA?

PrivacyIDEA is an open-source Multi-Factor Authentication platform supporting:

- TOTP
- HOTP
- FIDO2
- WebAuthn
- YubiKey
- SMS
- Email OTP

---

## Can I use Active Directory?

Yes.

PrivacyIDEA supports:

- Microsoft Active Directory
- LDAP
- SQL
- Local Users

---

## Which authenticator applications are supported?

Any RFC-compliant TOTP application.

Examples:

- Google Authenticator
- Microsoft Authenticator
- Aegis Authenticator
- FreeOTP
- Authy

---

## Can users have multiple tokens?

Yes.

PrivacyIDEA supports assigning multiple authentication tokens to a single user.

---

# FreeRADIUS

## Does FreeRADIUS store user passwords?

No.

FreeRADIUS acts only as an authentication gateway.

User authentication is performed entirely by PrivacyIDEA.

---

## Is RADIUS traffic encrypted?

RADIUS authentication uses a shared secret for request validation.

If authentication traffic traverses untrusted networks, additional protection such as VPN tunnels or dedicated management networks is recommended.

---

# Docker

## Why use Docker Compose?

Docker Compose provides:

- Repeatable deployments
- Service isolation
- Easy upgrades
- Simplified backups
- Portable infrastructure

---

## Can this project be installed without Docker?

Yes.

However, Docker Compose is recommended because all configuration examples and documentation are based on containerized deployment.

---

# Security

## Is TOTP secure?

Yes.

TOTP is defined by RFC 6238 and is one of the most widely adopted Multi-Factor Authentication mechanisms.

---

## What happens if a user loses their authenticator device?

An administrator can:

- Revoke the existing token.
- Disable the token.
- Enroll a replacement token.

---

## What should be backed up?

Regular backups should include:

- MariaDB
- Docker Compose files
- `.env`
- FreeRADIUS configuration
- PrivacyIDEA configuration
- MikroTik configuration
- Reverse Proxy configuration

---

# Troubleshooting

## Authentication always fails

Verify:

- Docker containers
- MikroTik RADIUS configuration
- FreeRADIUS logs
- PrivacyIDEA logs
- Shared Secret
- System time

---

## OTP codes are rejected

Check:

- NTP synchronization
- Token enrollment
- System time
- PrivacyIDEA policy

---

## Containers continuously restart

Review:

```bash
docker compose logs privacyidea
docker compose logs freeradius
docker compose logs mariadb
```

---

# Updates

## How should Docker images be updated?

```bash
docker compose pull
docker compose up -d
```

Always create a backup before updating.

---

## How often should updates be installed?

Recommended schedule:

- Security updates: immediately.
- Feature updates: after testing.
- Major upgrades: only after validation.

---

# Documentation

Additional documentation is available in this repository:

- installation.md
- configuration.md
- freeradius-integration.md
- troubleshooting.md
- security.md

---

# Support

Project maintained by:

**SARABEL Informatika Kft.**

Website

https://sarabelinformatika.hu

GitHub

https://github.com/sarabelinformatika

---

# Final Notes

This project demonstrates a practical and reproducible approach to implementing enterprise-grade Multi-Factor Authentication for MikroTik OpenVPN using PrivacyIDEA, FreeRADIUS and Docker Compose.

Although the solution has been designed using industry best practices, every production environment is different. Always validate your deployment before allowing production users to authenticate.
