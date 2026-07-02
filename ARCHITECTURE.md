# Solution Architecture

> High-level architecture of the PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN authentication platform.

---

# Purpose

The purpose of this project is to provide enterprise-grade Multi-Factor Authentication (MFA) for MikroTik OpenVPN deployments.

MikroTik RouterOS supports RADIUS authentication but does not natively support TOTP-based Multi-Factor Authentication for OpenVPN.

This architecture bridges that limitation using PrivacyIDEA and FreeRADIUS.

---

# Logical Architecture

```
                    Internet
                        │
                        ▼
             OpenVPN Client
                        │
                        ▼
             MikroTik RouterOS
                        │
                 RADIUS Request
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

---

# Authentication Workflow

1. User initiates an OpenVPN connection.
2. MikroTik forwards the authentication request to FreeRADIUS.
3. FreeRADIUS forwards the request to PrivacyIDEA.
4. PrivacyIDEA validates:
   - Username
   - Password
   - TOTP token
5. PrivacyIDEA returns the authentication result.
6. FreeRADIUS returns Access-Accept or Access-Reject.
7. MikroTik allows or denies the VPN connection.

---

# Components

## MikroTik RouterOS

Responsible for:

- OpenVPN Server
- RADIUS Client
- VPN Session Management

---

## FreeRADIUS

Responsible for:

- Receiving authentication requests
- Communicating with PrivacyIDEA
- Returning RADIUS responses

---

## PrivacyIDEA

Responsible for:

- User authentication
- Token management
- TOTP validation
- Audit logging

---

## MariaDB

Responsible for storing:

- Users
- Tokens
- Policies
- Audit information

---

# Security Layers

The solution consists of multiple security layers.

| Layer | Function |
|--------|----------|
| MikroTik | VPN Gateway |
| FreeRADIUS | Authentication Broker |
| PrivacyIDEA | MFA Server |
| MariaDB | Secure Data Storage |

---

# Why Docker?

Docker provides:

- Reproducible deployments
- Simple upgrades
- Service isolation
- Easy backups
- Portable infrastructure

---

# High Availability

For production deployments consider:

- Database replication
- Reverse proxy
- Regular backups
- Monitoring
- Automated updates
- Redundant VPN gateways

---

# Monitoring

Recommended monitoring:

- Docker Containers
- MariaDB
- FreeRADIUS
- PrivacyIDEA
- Disk Usage
- CPU
- Memory
- Authentication Failures

Zabbix is recommended for enterprise monitoring.

---

# Summary

This architecture provides a secure, modular and scalable Multi-Factor Authentication platform for MikroTik OpenVPN environments using open-source technologies.
