# FreeRADIUS Configuration

> FreeRADIUS configuration files used to integrate MikroTik RouterOS with PrivacyIDEA for enterprise-grade Multi-Factor Authentication (MFA).

---

# Purpose

This directory contains the FreeRADIUS configuration required to authenticate MikroTik OpenVPN users through PrivacyIDEA.

FreeRADIUS acts as the authentication broker between:

- MikroTik RouterOS
- PrivacyIDEA
- MariaDB

Instead of authenticating users locally, FreeRADIUS forwards authentication requests to PrivacyIDEA using the Perl authentication module.

---

# Directory Structure

```
freeradius/
├── clients.conf
└── README.md
```

The remaining FreeRADIUS configuration files are part of the standard FreeRADIUS installation and are intentionally **not** duplicated in this repository.

Only the files that require project-specific customization are included.

---

# Authentication Flow

```
VPN Client
      │
      ▼
MikroTik RouterOS
      │
   RADIUS (UDP)
      │
      ▼
FreeRADIUS
      │
 Perl Authentication
      │
      ▼
PrivacyIDEA
      │
      ▼
MariaDB
```

---

# Configuration Files

| File | Description |
|------|-------------|
| clients.conf | Defines trusted MikroTik RADIUS clients |
| README.md | Documentation for the FreeRADIUS configuration |

Complete integration details are documented in:

```
docs/freeradius-integration.md
```

---

# Deployment Notes

Before using this configuration:

- Replace the example IP addresses.
- Generate a new RADIUS shared secret.
- Verify Docker networking.
- Confirm that PrivacyIDEA is reachable.
- Restrict access to trusted MikroTik routers only.

---

# Verification

Verify that FreeRADIUS starts correctly.

```bash
docker compose logs freeradius
```

For detailed debugging:

```bash
freeradius -X
```

Successful authentication should show:

- Perl module loaded
- Request received from MikroTik
- Request forwarded to PrivacyIDEA
- Access-Accept or Access-Reject returned

---

# Security Recommendations

For production deployments:

- Never expose UDP ports 1812 and 1813 directly to the Internet.
- Use a strong RADIUS shared secret.
- Restrict trusted clients by IP address.
- Enable authentication logging.
- Monitor failed authentication attempts.
- Protect configuration backups.
- Keep the Docker image updated.

---

# Additional Documentation

For complete deployment instructions, see:

- docs/installation.md
- docs/configuration.md
- docs/freeradius-integration.md
- docs/security.md
- docs/troubleshooting.md
