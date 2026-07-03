# FreeRADIUS Configuration

This directory contains the FreeRADIUS configuration used to integrate MikroTik RouterOS with PrivacyIDEA.

## Purpose

FreeRADIUS acts as the authentication broker between:

- MikroTik RouterOS
- PrivacyIDEA
- MariaDB

It receives RADIUS authentication requests from MikroTik and forwards them to PrivacyIDEA for validation.

---

## Directory Structure

```
freeradius/
├── clients.conf
├── sites-enabled/
├── mods-enabled/
└── README.md
```

---

## Authentication Flow

```
VPN Client
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

---

## Configuration Files

| File | Description |
|------|-------------|
| clients.conf | Defines trusted RADIUS clients |
| sites-enabled/default | Authentication workflow |
| mods-enabled | Authentication modules |

---

## Security Notes

- Never expose UDP/1812 directly to the Internet.
- Use strong shared secrets.
- Restrict RADIUS clients by IP address.
- Enable logging.
- Monitor authentication attempts.
- Backup configuration files regularly.
