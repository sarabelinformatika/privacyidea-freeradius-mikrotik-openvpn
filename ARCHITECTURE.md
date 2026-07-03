# Solution Architecture

> High-level architecture of the PrivacyIDEA + FreeRADIUS + MikroTik OpenVPN authentication platform.

---

# Purpose

The purpose of this project is to provide enterprise-grade Multi-Factor Authentication (MFA) for MikroTik OpenVPN deployments.

Although MikroTik RouterOS supports RADIUS authentication, it does not natively support Time-based One-Time Password (TOTP) authentication for OpenVPN.

This architecture bridges that limitation by integrating PrivacyIDEA and FreeRADIUS while preserving the existing VPN infrastructure.

---

# High-Level Architecture

```
                    Internet
                        │
                        ▼
               OpenVPN Client
                        │
                OpenVPN Tunnel
                        │
                        ▼
             MikroTik RouterOS
                        │
                  RADIUS (UDP)
                        │
                        ▼
                 FreeRADIUS
                        │
                 Perl Module
                        │
                   HTTP/HTTPS
                        │
                        ▼
                 PrivacyIDEA
                        │
                     SQL
                        │
                        ▼
                   MariaDB
```

---

# Authentication Workflow

1. The user starts an OpenVPN connection.
2. MikroTik forwards the authentication request to FreeRADIUS using RADIUS.
3. FreeRADIUS invokes the PrivacyIDEA Perl module.
4. PrivacyIDEA validates:
   - Username
   - Password
   - TOTP token
5. PrivacyIDEA returns the authentication result.
6. FreeRADIUS returns either **Access-Accept** or **Access-Reject**.
7. MikroTik allows or denies the VPN connection.

---

# Component Responsibilities

## MikroTik RouterOS

Responsible for:

- OpenVPN Server
- VPN Session Management
- RADIUS Client
- User Access Control

---

## FreeRADIUS

Responsible for:

- Receiving RADIUS requests
- Processing authentication
- Executing the PrivacyIDEA Perl module
- Returning authentication responses

---

## PrivacyIDEA

Responsible for:

- User authentication
- Token management
- TOTP validation
- Policy enforcement
- Audit logging

---

## MariaDB

Responsible for storing:

- Users
- Tokens
- Policies
- Audit information
- Authentication metadata

---

# Communication Matrix

| Source | Destination | Protocol |
|----------|-------------|----------|
| OpenVPN Client | MikroTik | OpenVPN |
| MikroTik | FreeRADIUS | RADIUS (UDP 1812/1813) |
| FreeRADIUS | PrivacyIDEA | HTTP / HTTPS |
| PrivacyIDEA | MariaDB | MySQL |

---

# Trust Boundaries

The solution consists of multiple trust zones.

```
Internet

↓

VPN Gateway

↓

Authentication Layer

↓

Authentication Server

↓

Database
```

Each layer should be protected independently.

---

# Security Layers

| Layer | Function |
|--------|----------|
| MikroTik | VPN Gateway |
| FreeRADIUS | Authentication Broker |
| PrivacyIDEA | MFA Server |
| MariaDB | Secure Data Storage |

The compromise of a single layer should not automatically compromise the entire authentication infrastructure.

---

# Why Docker?

Docker provides:

- Reproducible deployments
- Service isolation
- Simplified upgrades
- Portable infrastructure
- Easy backups
- Consistent environments

---

# Scalability

The architecture can be extended by:

- Multiple MikroTik routers
- Multiple VPN servers
- Reverse Proxy
- External LDAP or Active Directory
- MariaDB replication
- Centralized monitoring

---

# High Availability

Production environments should consider:

- Database replication
- Reverse Proxy
- Multiple FreeRADIUS servers
- Redundant VPN gateways
- Automated backups
- Monitoring and alerting

---

# Monitoring

Recommended monitoring targets:

- Docker Containers
- MariaDB
- PrivacyIDEA
- FreeRADIUS
- CPU
- Memory
- Disk Usage
- Authentication Failures
- Login Success Rate
- Network Availability

Zabbix is recommended for enterprise monitoring.

---

# Design Principles

This architecture follows several security and infrastructure design principles:

- Defense in Depth
- Least Privilege
- Separation of Duties
- Zero Trust Authentication
- Modular Design
- Secure Defaults

---

# Summary

This architecture provides a modular, scalable and secure Multi-Factor Authentication platform for MikroTik OpenVPN environments using PrivacyIDEA, FreeRADIUS and Docker.

By keeping each component focused on a single responsibility, the solution remains maintainable, extensible and suitable for enterprise production environments.
