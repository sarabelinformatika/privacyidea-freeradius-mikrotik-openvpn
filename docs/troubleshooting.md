# Troubleshooting Guide

> Common issues, diagnostics and solutions for deploying PrivacyIDEA, FreeRADIUS and MikroTik OpenVPN using Docker Compose.

---

# Introduction

Even a correctly deployed environment may experience configuration issues.

This guide describes the most common problems encountered during deployment and explains how to diagnose and resolve them.

---

# Verify Container Status

Always begin by checking whether all containers are running.

```bash
docker ps
```

Expected containers:

- mariadb
- privacyidea
- freeradius

If any container is missing, inspect the logs.

---

# View Container Logs

PrivacyIDEA

```bash
docker logs privacyidea
```

FreeRADIUS

```bash
docker logs freeradius
```

MariaDB

```bash
docker logs mariadb
```

---

# PrivacyIDEA Container Does Not Start

## Symptoms

Container exits immediately after startup.

## Possible Causes

- Missing environment variables
- Invalid configuration
- Missing database connection
- Invalid secret keys

## Solution

Verify the environment configuration.

```bash
cat .env
```

Confirm that the following variables exist:

```
PI_SECRET_KEY
PI_PEPPER
```

Both values must be unique and sufficiently long.

---

# Error: PI_SECRET_KEY is not set

## Cause

PrivacyIDEA requires a SECRET_KEY for session encryption.

Without it, the application cannot start.

## Solution

Generate a random value.

Example:

```
PI_SECRET_KEY=<YOUR_SECRET_KEY>
```

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

Generate a strong random value.

Example:

```
PI_PEPPER=<YOUR_PEPPER>
```

Restart Docker.

---

# MariaDB Connection Failed

## Symptoms

PrivacyIDEA reports database connection errors.

## Verify

```bash
docker logs mariadb
```

Check:

- Database name
- Username
- Password
- Hostname

Ensure that the values match the `.env` configuration.

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
docker network inspect bridge
```

If custom networks are used, verify that every service is connected correctly.

---

# FreeRADIUS Access-Reject

## Symptoms

Authentication always fails.

## Possible Causes

- Incorrect shared secret
- Client IP mismatch
- PrivacyIDEA unavailable
- Invalid credentials

## Verify

```bash
docker logs freeradius
```

Review authentication requests and rejection reasons.

---

# MikroTik Cannot Reach FreeRADIUS

## Verify Connectivity

Ping the RADIUS server.

Check:

- IP address
- Firewall
- UDP Port 1812
- UDP Port 1813

Verify the shared secret on both systems.

---

# OpenVPN Authentication Failed

## Possible Causes

- Incorrect username
- Incorrect password
- Invalid OTP
- RADIUS communication failure
- PrivacyIDEA unavailable

Review:

- MikroTik logs
- FreeRADIUS logs
- PrivacyIDEA logs

Always identify which component rejected the authentication.

---

# Invalid TOTP

## Symptoms

Authentication fails despite the correct password.

## Verify

Check:

- System time
- NTP synchronization
- Token enrollment
- Time zone configuration

TOTP requires accurate time synchronization.

---

# QR Code Cannot Be Scanned

Possible causes:

- Browser cache
- Incorrect hostname
- Invalid HTTPS configuration

Generate a new token and verify the QR code again.

---

# HTTPS Certificate Issues

Verify:

- Certificate validity
- Hostname
- Reverse Proxy
- DNS records

Modern browsers reject invalid certificates.

---

# Docker Compose Validation

Validate the configuration.

```bash
docker compose config
```

Correct any reported errors before restarting the environment.

---

# Restart All Services

```bash
docker compose down
docker compose up -d
```

---

# Verify Authentication Flow

Successful authentication follows this sequence:

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

If authentication stops at any stage, inspect the logs of the failing component.

---

# Best Practices

- Keep Docker images updated.
- Synchronize system time using NTP.
- Backup MariaDB regularly.
- Use strong shared secrets.
- Protect the `.env` file.
- Monitor authentication logs.
- Test configuration changes before production deployment.

---

# Additional Documentation

For installation instructions see:

```
installation.md
```

For configuration details see:

```
configuration.md
```

For security recommendations see:

```
security.md
```
