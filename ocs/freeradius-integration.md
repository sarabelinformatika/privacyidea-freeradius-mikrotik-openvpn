# FreeRADIUS Integration

> This document explains the minimal changes required to integrate FreeRADIUS with PrivacyIDEA.

---

# Overview

This project intentionally keeps the standard FreeRADIUS configuration as intact as possible.

Instead of replacing the complete `sites-enabled/default` configuration, only a few modifications are required to enable PrivacyIDEA authentication.

This approach provides several advantages:

- Easier upgrades
- Better compatibility with future FreeRADIUS releases
- Smaller maintenance effort
- Clear documentation of project-specific changes

---

# Files Modified

The following files were modified during the integration.

| File | Purpose |
|------|---------|
| clients.conf | Define trusted MikroTik clients |
| Dockerfile | Install required Perl dependencies |
| Perl module | Communicate with PrivacyIDEA |
| sites-enabled/default | Enable Perl authentication |

All other FreeRADIUS files remain unchanged.

---

# Step 1 – Enable the Perl Module

Locate the **authorize** section.

Add:

```text
perl

if (ok) {
    update control {
        Auth-Type := Perl
    }
}
```

## Why?

The PrivacyIDEA integration is implemented through the FreeRADIUS Perl module.

When the module successfully processes an authentication request, FreeRADIUS changes the authentication type to **Perl**.

Without this modification, FreeRADIUS would continue with its default authentication methods and PrivacyIDEA would never be called.

---

# Step 2 – Configure the Authentication Section

Locate:

```text
authenticate {
```

Add:

```text
Auth-Type Perl {
    perl
}
```

## Why?

This tells FreeRADIUS which authentication handler should process requests that have:

```
Auth-Type := Perl
```

Without this section, authentication requests would fail because FreeRADIUS would not know how to handle the new authentication type.

---

# Authentication Flow

```
VPN Client
      │
      ▼
MikroTik RouterOS
      │
      ▼
FreeRADIUS

authorize
      │
      ▼
Perl Module
      │
      ▼
PrivacyIDEA
      │
      ▼
MariaDB
      │
      ▼
Access-Accept
```

---

# Why Not Replace the Entire Configuration?

The original `sites-enabled/default` file contains nearly one thousand lines of standard FreeRADIUS configuration.

Only a few lines are actually required for PrivacyIDEA integration.

Keeping the original file unchanged provides several benefits:

- Easier upgrades
- Better maintainability
- Smaller Git repository
- Simpler troubleshooting
- Cleaner documentation

---

# Verification

Run FreeRADIUS in debug mode.

```bash
freeradius -X
```

Expected behavior:

- The Perl module loads successfully.
- Authentication requests reach PrivacyIDEA.
- Successful logins return **Access-Accept**.
- Invalid credentials return **Access-Reject**.

---

# Troubleshooting

If authentication fails, verify the following:

- The Perl module is installed.
- PrivacyIDEA is reachable.
- The Perl module is loaded.
- `Auth-Type := Perl` is assigned correctly.
- The `authenticate` section contains `Auth-Type Perl`.
- Docker networking is functioning correctly.
- FreeRADIUS logs do not report syntax errors.

---

# Summary

The integration requires only two functional modifications to the standard FreeRADIUS configuration:

1. Enable the Perl module during authorization.
2. Register the Perl authentication handler.

Everything else remains part of the standard FreeRADIUS installation.

This approach minimizes maintenance while preserving compatibility with future FreeRADIUS releases.
