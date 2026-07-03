# Troubleshooting Guide

> Common issues, diagnostics and solutions for deploying PrivacyIDEA, FreeRADIUS and MikroTik OpenVPN using Docker Compose.

---

# Introduction

Even a correctly deployed environment may experience configuration issues.

This guide describes the most common deployment problems, explains how to diagnose them and provides recommended solutions.

---

# Quick Diagnostics

Most deployment issues can be identified using the following commands.

```bash
docker compose ps
docker compose logs privacyidea
docker compose logs freeradius
docker compose logs mariadb
docker compose config
```

If all containers are running without errors, continue with the component-specific troubleshooting sections below.

---

# Verify Docker Stack

Always begin by verifying that all services are running.

```bash
docker compose ps
```

Expected services:

- mariadb
- privacyidea
- freeradius

If any service is missing or exited unexpectedly, inspect its logs.

---

# View Container Logs

PrivacyIDEA

```bash
docker compose logs privacyidea
```

FreeRADIUS

```bash
docker compose logs freeradius
```

MariaDB

```bash
docker compose logs mariadb
```

---

# PrivacyIDEA Container Does Not Start

## Symptoms

The container exits immediately after startup.

## Possible Causes

- Missing environment variables
- Invalid database configuration
- Invalid secret keys
- Database unavailable

## Verify

```bash
docker compose logs privacyidea
```

Check that the following variables exist in the `.env` file:

```
PI_SECRET_KEY
PI_PEPPER
PI_DB_HOST
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
```

Restart the stack after making changes.

```bash
docker compose down
docker compose up -d
```

---

# Error: PI_SECRET_KEY is not set

## Cause

PrivacyIDEA requires a SECRET_KEY for session encryption.

Without it, the application cannot start.

## Solution

Generate a secure random value and update the `.env` file.

Restart the containers.

```bash
docker compose down
docker compose up -d
```

---

# Error: PI_PEPPER is not set

## Cause

The PEPPER value is required to securely hash sensitive information.

## Solution

Generate a secure random value.

Update the `.env` file and restart the containers.

---

# PrivacyIDEA Cannot Connect to MariaDB

## Symptoms

PrivacyIDEA starts but reports database connection errors.

## Verify

```bash
docker compose logs privacyidea
```

Confirm:

- PI_DB_HOST
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD

Verify MariaDB is running.

```bash
docker compose logs mariadb
```

Both containers must be connected to the same Docker network.

---

# MariaDB Connection Failed

## Verify

```bash
docker compose logs mariadb
```

Check:

- Database initialization
- User creation
- Database name
- Authentication errors

---

# Docker Network Issues

## Symptoms

Containers cannot communicate.

## Verify

```bash
docker network ls
```

Inspect the project network.

```bash
docker network inspect mfa
```

Confirm that all containers are attached to the same Docker network.

---

# FreeRADIUS Does Not Start

## Verify

```bash
docker compose logs freeradius
```

Check for:

- Syntax errors
- Missing Perl dependencies
- Missing configuration files
- Permission issues

---

# FreeRADIUS Cannot Reach PrivacyIDEA

## Symptoms

Authentication requests are received but always rejected.

## Verify

```bash
docker compose logs freeradius
```

Confirm:

- Perl module loaded
- PrivacyIDEA reachable
- HTTP communication successful

---

# FreeRADIUS Returns Access-Reject

## Possible Causes

- Incorrect RADIUS shared secret
- MikroTik client IP mismatch
- Invalid credentials
- PrivacyIDEA unavailable
- Invalid TOTP

Verify:

- Shared Secret
- Client IP
- PrivacyIDEA logs
- FreeRADIUS logs

---

# MikroTik Cannot Reach FreeRADIUS

Verify:

- FreeRADIUS IP address
- UDP Port 1812
- UDP Port 1813
- Shared Secret
- Service = PPP
- MikroTik Firewall
- Docker Firewall

Test basic connectivity using ping if ICMP is allowed.

---

# OpenVPN Authentication Failed

## Possible Causes

- Incorrect username
- Incorrect password
- Invalid OTP
- FreeRADIUS unavailable
- PrivacyIDEA unavailable
- Incorrect RADIUS configuration

Review logs from:

- MikroTik
- FreeRADIUS
- PrivacyIDEA

Identify which component rejected the authentication.

---

# Invalid Password Format

Some PrivacyIDEA policies require users to concatenate the password and OTP.

Example:

```
MyPassword123456
```

instead of:

```
Password
123456
```

Verify the configured authentication policy.

---

# Invalid TOTP

## Verify

Check:

- System time
- NTP synchronization
- Token enrollment
- Time zone configuration

TOTP authentication requires accurate time synchronization.

---

# QR Code Cannot Be Scanned

Possible causes:

- Browser cache
- Invalid hostname
- Incorrect HTTPS configuration
- Corrupted QR code

Generate a new token and try again.

---

# Reverse Proxy Issues

If PrivacyIDEA is published through Nginx Proxy Manager or another reverse proxy, verify:

- HTTPS enabled
- Correct backend target
- DNS records
- SSL certificate validity

---

# HTTPS Certificate Issues

Verify:

- Certificate validity
- Hostname
- Reverse Proxy configuration
- DNS records

Modern browsers reject invalid or expired certificates.

---

# Docker Compose Validation

Validate the complete Docker configuration.

```bash
docker compose config
```

Update Docker images if necessary.

```bash
docker compose pull
```

Correct all reported configuration errors before restarting the environment.

---

# Restart the Environment

```bash
docker compose down
docker compose up -d
```

---

# Verify Authentication Flow

Successful authentication follows this sequence.

```
VPN Client

↓

MikroTik RouterOS

↓

FreeRADIUS

↓

PrivacyIDEA

↓

MariaDB

↓

Access-Accept

↓

VPN Connected
```

If authentication stops at any stage, inspect the logs of the corresponding component.

---

# Environment Health Checklist

| Component | Verified |
|------------|----------|
| Docker Containers | ✅ |
| MariaDB | ✅ |
| PrivacyIDEA | ✅ |
| FreeRADIUS | ✅ |
| Perl Module | ✅ |
| MikroTik RouterOS | ✅ |
| OpenVPN | ✅ |
| HTTPS | ✅ |
| MFA | ✅ |
| TOTP | ✅ |
| NTP Synchronization | ✅ |
| Backups | ✅ |
| Monitoring | ✅ |

---

# Best Practices

- Keep Docker images updated.
- Synchronize system time using NTP.
- Backup MariaDB regularly.
- Protect the `.env` file.
- Use strong RADIUS shared secrets.
- Enable HTTPS.
- Monitor authentication logs.
- Test configuration changes before production deployment.

---

# Still Having Problems?

If all configuration files match this repository and authentication still fails:

- Enable FreeRADIUS debug logging.
- Review PrivacyIDEA logs.
- Verify Docker networking.
- Verify MikroTik RADIUS configuration.
- Check system time synchronization.
- Confirm the RADIUS shared secret matches on both systems.

Most deployment issues are caused by:

- Incorrect RADIUS shared secret
- Time synchronization problems
- Incorrect Docker environment variables
- Invalid PrivacyIDEA policies
- Firewall configuration

---

# Related Documentation

- installation.md
- configuration.md
- freeradius-integration.md
- security.md
- faq.md
