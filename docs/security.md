# Security Guide

> Security best practices and hardening recommendations for deploying PrivacyIDEA, FreeRADIUS and MikroTik OpenVPN in production environments.

---

# Purpose

This document provides security recommendations for deploying the solution in production environments.

The repository is designed to demonstrate a secure Multi-Factor Authentication (MFA) architecture, but every production deployment should be reviewed according to the organization's own security policies and compliance requirements.

---

# Security Architecture

```
                Internet
                    │
                    ▼
         OpenVPN Client
                    │
                    ▼
         MikroTik RouterOS
                    │
             RADIUS (UDP)
                    │
                    ▼
            FreeRADIUS Server
                    │
            Perl Authentication
                    │
                    ▼
             PrivacyIDEA
                    │
                    ▼
                MariaDB
```

Each component should expose only the services that are strictly required.

---

# Security Principles

This project follows several widely accepted security principles:

- Least Privilege
- Defense in Depth
- Separation of Duties
- Zero Trust Authentication
- Secure Defaults
- Principle of Minimal Exposure

---

# Secrets Management

Never store production secrets inside the repository.

The following values must always remain private:

- PI_SECRET_KEY
- PI_PEPPER
- MYSQL_ROOT_PASSWORD
- MYSQL_PASSWORD
- RADIUS Shared Secret
- Administrator Passwords

Use the provided `.env.example` file only as a template.

Never commit the `.env` file.

---

# Environment Variables

Sensitive configuration should always be stored in environment variables.

Example:

```
PI_SECRET_KEY
PI_PEPPER
MYSQL_PASSWORD
```

Never hardcode credentials inside:

- Dockerfile
- docker-compose.yml
- FreeRADIUS configuration
- MikroTik exports

---

# Docker Security

For production deployments:

- Use official Docker images whenever possible.
- Keep images updated.
- Remove unused images.
- Remove unused containers.
- Remove unused networks.
- Remove unused volumes.

Verify regularly:

```bash
docker image ls
docker ps
docker network ls
docker volume ls
```

---

# Container Isolation

All containers communicate through the dedicated Docker bridge network.

```
mfa
```

Avoid connecting unrelated containers to this network.

---

# MariaDB Security

Recommendations:

- Use strong database passwords.
- Restrict database access to Docker only.
- Do not expose MariaDB directly to the Internet.
- Backup the database regularly.
- Monitor database logs.

---

# PrivacyIDEA Security

Protect the administrative interface.

Recommendations:

- HTTPS only
- Strong administrator passwords
- Separate administrator accounts
- Least privilege
- Restrict administrative access by IP if possible
- Enable audit logging

---

# FreeRADIUS Security

Recommendations:

- Use long random shared secrets.
- Allow only trusted MikroTik routers.
- Restrict UDP ports 1812 and 1813.
- Never expose the RADIUS service directly to the Internet.
- Monitor authentication logs.

Example shared secret length:

```
32–64 random characters
```

---

# MikroTik Security

Recommendations:

- Keep RouterOS updated.
- Disable unused services.
- Restrict WinBox access.
- Restrict SSH access.
- Use firewall rules.
- Use strong administrator passwords.
- Backup configuration regularly.

---

# HTTPS

Always protect PrivacyIDEA using HTTPS.

Recommended:

```
Internet

↓

Reverse Proxy

↓

PrivacyIDEA
```

Supported reverse proxies include:

- Nginx Proxy Manager
- Nginx
- Traefik
- HAProxy

---

# Time Synchronization

TOTP authentication depends on accurate time.

Configure NTP on:

- Docker host
- MikroTik RouterOS

Time drift may result in authentication failures.

---

# Backup Strategy

Regularly back up:

- MariaDB
- Docker Compose configuration
- `.env`
- FreeRADIUS configuration
- MikroTik configuration
- PrivacyIDEA configuration

Store backups securely.

Test restoration procedures periodically.

---

# Logging

Monitor:

- Docker logs
- FreeRADIUS logs
- PrivacyIDEA audit logs
- MikroTik logs

Review authentication failures regularly.

---

# Firewall Recommendations

Allow only required ports.

| Port | Protocol | Purpose |
|------|----------|---------|
| 443 | TCP | HTTPS |
| 1812 | UDP | RADIUS Authentication |
| 1813 | UDP | RADIUS Accounting |
| 1194 | TCP/UDP | OpenVPN |

Block everything else unless explicitly required.

---

# Security Checklist

Before production deployment verify:

- HTTPS enabled
- Strong passwords
- Strong RADIUS shared secret
- `.env` protected
- Docker updated
- RouterOS updated
- NTP configured
- Database backups configured
- Authentication logs monitored
- Disaster recovery tested

---

# Disaster Recovery

Prepare documented recovery procedures for:

- Docker host failure
- MariaDB corruption
- PrivacyIDEA configuration loss
- MikroTik replacement
- Secret key rotation

Recovery procedures should be tested periodically.

---

# Recommended Maintenance

Weekly:

- Review authentication logs.
- Verify backups.
- Check Docker container status.

Monthly:

- Update Docker images.
- Update RouterOS.
- Rotate administrator passwords if required.
- Review firewall rules.

Quarterly:

- Test disaster recovery.
- Review user accounts.
- Remove unused users.
- Review security policies.

---

# Security Summary

The security of this solution depends on several independent layers:

- Docker isolation
- MikroTik firewall
- RADIUS authentication
- PrivacyIDEA MFA
- Strong secrets
- HTTPS
- Regular backups
- Continuous monitoring

When these recommendations are followed, the solution provides a secure and maintainable enterprise-grade Multi-Factor Authentication platform suitable for production deployments.
