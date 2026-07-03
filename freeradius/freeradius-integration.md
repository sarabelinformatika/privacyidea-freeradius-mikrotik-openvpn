# FreeRADIUS Integration

> This document explains how FreeRADIUS integrates with PrivacyIDEA to provide Multi-Factor Authentication (MFA) for MikroTik OpenVPN.

---

# Overview

FreeRADIUS acts as the authentication gateway between MikroTik RouterOS and PrivacyIDEA.

Instead of authenticating users locally, FreeRADIUS forwards authentication requests to PrivacyIDEA using the Perl authentication module.

This approach keeps the standard FreeRADIUS configuration largely unchanged while providing enterprise-grade MFA capabilities.

---

# Authentication Architecture

```
OpenVPN Client
        │
        ▼
MikroTik RouterOS
        │
     RADIUS
        │
        ▼
FreeRADIUS
        │
    Perl Module
        │
        ▼
PrivacyIDEA
        │
        ▼
MariaDB
```

---

# Modified Files

Only a small number of files are modified.

| File | Purpose |
|------|---------|
| Dockerfile | Install required Perl dependencies |
| freeradius/clients.conf | Configure trusted RADIUS clients |
| sites-enabled/default | Enable Perl authentication |
| Perl module | Communicate with PrivacyIDEA |

The remaining FreeRADIUS configuration remains unchanged.

---

# Step 1 – Install Perl Dependencies

The Docker image installs the required Perl modules.

Dockerfile:

```Dockerfile
libwww-perl
libconfig-inifiles-perl
libjson-perl
URI::Encode
```

These libraries allow the Perl module to communicate with PrivacyIDEA over HTTP/HTTPS.

---

# Step 2 – Configure Trusted Clients

Each MikroTik router must be configured as a trusted RADIUS client.

Example:

```text
client mikrotik {

    ipaddr = 192.168.110.1

    secret = CHANGE_ME_TO_A_STRONG_RADIUS_SECRET

    shortname = mikrotik-router

    nas_type = other
}
```

The complete example is available in:

```
freeradius/clients.conf
```

---

# Step 3 – Enable Perl Authentication

Inside the **authorize** section add:

```text
perl

if (ok) {
    update control {
        Auth-Type := Perl
    }
}
```

### Why?

If the Perl module validates the request successfully, FreeRADIUS changes the authentication method to **Perl**.

Without this step, PrivacyIDEA would never receive authentication requests.

---

# Step 4 – Register the Authentication Handler

Inside the **authenticate** section add:

```text
Auth-Type Perl {
    perl
}
```

### Why?

This tells FreeRADIUS which module is responsible for processing requests where:

```
Auth-Type := Perl
```

---

# Authentication Workflow

```
User

↓

MikroTik RouterOS

↓

FreeRADIUS

↓

Perl Module

↓

PrivacyIDEA

↓

MariaDB

↓

Access-Accept / Access-Reject
```

---

# Verification

Run FreeRADIUS in debug mode.

```bash
freeradius -X
```

A successful authentication should show:

- Perl module loaded
- Request forwarded to PrivacyIDEA
- Access-Accept returned
- No configuration errors

---

# Troubleshooting

Verify:

- Docker containers are running.
- Perl dependencies are installed.
- PrivacyIDEA is reachable.
- clients.conf contains the MikroTik router.
- Shared Secret matches on both sides.
- System time is synchronized.
- Docker networking is functioning correctly.

---

# Security Recommendations

For production deployments:

- Use strong RADIUS shared secrets.
- Restrict UDP ports 1812 and 1813.
- Never expose the RADIUS service directly to the Internet.
- Protect the PrivacyIDEA administration interface with HTTPS.
- Monitor authentication logs.
- Backup configuration files regularly.

---

# Summary

Only two functional changes are required inside the standard FreeRADIUS configuration:

1. Enable the Perl module during authorization.
2. Register the Perl authentication handler.

Everything else remains part of the standard FreeRADIUS installation, making future upgrades significantly easier while keeping the configuration clean and maintainable.

