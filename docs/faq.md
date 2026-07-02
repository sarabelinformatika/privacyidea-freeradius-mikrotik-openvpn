# Frequently Asked Questions (FAQ)

> Frequently asked questions about deploying PrivacyIDEA, FreeRADIUS and MikroTik OpenVPN with Docker Compose.

---

# General Questions

## What is PrivacyIDEA?

PrivacyIDEA is an open-source Multi-Factor Authentication (MFA) server that supports a wide range of authentication methods including:

- TOTP
- HOTP
- WebAuthn
- FIDO2
- YubiKey
- SMS
- Email OTP

It provides centralized authentication management for enterprise environments.

---

## Why is FreeRADIUS required?

MikroTik RouterOS supports RADIUS authentication but cannot communicate directly with PrivacyIDEA.

FreeRADIUS acts as the authentication bridge between MikroTik RouterOS and PrivacyIDEA.

---

## Why not use MikroTik's native authentication?

RouterOS supports:

- Local users
- RADIUS
- Certificates

However, it does not natively support TOTP-based Multi-Factor Authentication for OpenVPN.

This repository addresses that limitation.

---

## Can this be deployed in production?

Yes.

The architecture is suitable for production environments provided that:

- HTTPS is enabled.
- Strong passwords are used.
- Backups are configured.
- Security recommendations are followed.
- Monitoring is implemented.

---

# Docker

## Why Docker?

Docker simplifies deployment by:

- Isolating services
- Simplifying updates
- Improving portability
- Reducing configuration errors
- Simplifying backups

---

## Can I deploy without Docker?

Yes.

However, Docker Compose is recommended because it provides:

- Consistent deployment
- Easier maintenance
- Simpler upgrades
- Better reproducibility

---

# MikroTik

## Which RouterOS versions are supported?

The project has been tested with RouterOS 7.x.

Always verify compatibility before deploying into production.

---

## Does this work with OpenVPN?

Yes.

The solution was specifically designed for MikroTik OpenVPN authentication.

---

## Can it be used with other VPN protocols?

Potentially yes.

Any VPN solution supporting RADIUS authentication may integrate with PrivacyIDEA through FreeRADIUS.

---

# PrivacyIDEA

## Which authenticators are supported?

PrivacyIDEA supports:

- Google Authenticator
- Microsoft Authenticator
- FreeOTP
- Aegis
- Authy
- Hardware tokens
- FIDO2
- WebAuthn

---

## Can Active Directory users be used?

Yes.

PrivacyIDEA supports multiple user sources including:

- LDAP
- Microsoft Active Directory
- SQL
- Local users

---

# FreeRADIUS

## Are user passwords stored inside FreeRADIUS?

No.

FreeRADIUS only forwards authentication requests.

PrivacyIDEA performs the actual authentication.

---

## Is RADIUS encrypted?

The communication relies on a shared secret.

When deployed across untrusted networks, additional protection such as VPN or network segmentation is recommended.

---

# Security

## Is TOTP secure?

Yes.

TOTP is an industry-standard authentication mechanism defined by RFC 6238.

It significantly improves security compared to password-only authentication.

---

## What happens if a user loses their phone?

An administrator can:

- Disable the token
- Revoke the token
- Enroll a new token

---

## Can multiple tokens be assigned?

Yes.

PrivacyIDEA supports assigning multiple tokens to a single user.

---

# Backup

## What should be backed up?

Recommended backups include:

- MariaDB
- Docker Compose files
- .env
- Certificates
- MikroTik configuration
- Reverse Proxy configuration

---

## Is database backup enough?

No.

A complete backup should include both:

- Configuration
- Database

---

# Troubleshooting

## Authentication always fails

Verify:

- Docker containers
- FreeRADIUS logs
- PrivacyIDEA logs
- MikroTik configuration
- Shared Secret
- System time

---

## OTP codes are rejected

Verify:

- NTP synchronization
- Time zone
- Token enrollment

---

## Containers restart continuously

Review:

```bash
docker logs privacyidea
docker logs freeradius
docker logs mariadb
```

---

# Updates

## How should Docker images be updated?

```bash
docker compose pull
docker compose up -d
```

Always backup the environment before updating.

---

## How often should updates be installed?

Recommendations:

- Security updates immediately.
- Feature updates after testing.
- Major upgrades only after validation.

---

# Support

This repository accompanies the technical documentation published by:

**SARABEL Informatika Kft.**

Website:

https://sarabelinformatika.hu

GitHub:

https://github.com/sarabelinformatika

---

# Final Notes

This project demonstrates one practical approach to implementing enterprise-grade Multi-Factor Authentication for MikroTik OpenVPN using PrivacyIDEA and FreeRADIUS.

Every production environment is different.

Always validate your deployment before going live.
