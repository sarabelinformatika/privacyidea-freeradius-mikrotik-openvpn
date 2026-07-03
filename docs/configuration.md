# Configuration Guide

> Complete configuration guide for integrating MikroTik RouterOS, FreeRADIUS and PrivacyIDEA to provide enterprise-grade Multi-Factor Authentication (MFA) for OpenVPN.

---

# Overview

After completing the installation, configure the following components in the recommended order:

1. MariaDB
2. PrivacyIDEA
3. FreeRADIUS
4. MikroTik RouterOS
5. OpenVPN
6. TOTP Token Enrollment
7. Authentication Testing

Following this sequence minimizes configuration issues and simplifies troubleshooting.

---

# Authentication Flow

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

Authentication sequence:

1. The VPN client connects to the MikroTik OpenVPN server.
2. MikroTik forwards the authentication request to FreeRADIUS.
3. FreeRADIUS passes the authentication request to PrivacyIDEA.
4. PrivacyIDEA validates:
   - Username
   - Password
   - TOTP Token
5. PrivacyIDEA returns Access-Accept or Access-Reject.
6. FreeRADIUS returns the response to MikroTik.
7. MikroTik establishes or rejects the VPN connection.

---

# Configuration Files

| Component | File |
|-----------|------|
| Docker Compose | docker-compose.yml |
| Environment Variables | .env |
| FreeRADIUS Clients | freeradius/clients.conf |
| MikroTik RADIUS | mikrotik/radius-client.rsc |
| MikroTik OpenVPN | mikrotik/openvpn-server.rsc |

---

# Configuration Order

| Step | Component |
|------|-----------|
| 1 | MariaDB |
| 2 | PrivacyIDEA |
| 3 | FreeRADIUS |
| 4 | MikroTik RouterOS |
| 5 | OpenVPN |
| 6 | Token Enrollment |
| 7 | Authentication Testing |

---

# Verify Docker Stack

Before configuring any component, verify that the complete Docker stack is running.

```bash
docker compose ps
```

Expected services:

- mariadb
- privacyidea
- freeradius

All services should report a running state.

---

# Configure MariaDB

MariaDB is used as the backend database for PrivacyIDEA.

Verify database connectivity.

```bash
docker exec -it mariadb mysql -u root -p
```

Verify that the PrivacyIDEA database exists.

```sql
SHOW DATABASES;
```

Expected:

```sql
privacyidea
```

Exit MariaDB.

```sql
exit
```

---

# Configure PrivacyIDEA

Open the PrivacyIDEA web interface.

Default Docker deployment:

```
http://SERVER-IP:8080
```

Reverse Proxy deployment:

```
https://your-domain.example
```

If you are deploying the solution in production, using a reverse proxy (for example Nginx Proxy Manager) with HTTPS is strongly recommended.

Complete the initial configuration.

Configure:

- Administrator account
- Realm
- Resolver
- User synchronization
- Policies
- TOTP support

Verify that users are successfully imported before continuing.

---

# Supported Authenticator Applications

PrivacyIDEA supports all RFC-compliant TOTP applications, including:

- Google Authenticator
- Microsoft Authenticator
- Aegis Authenticator
- FreeOTP
- Authy (where supported)

---

# Configure FreeRADIUS

FreeRADIUS forwards authentication requests from MikroTik RouterOS to PrivacyIDEA.

Configuration files included in this repository:

```
freeradius/
```

Important files:

- clients.conf
- README.md

Configuration details are documented in:

```
docs/freeradius-integration.md
```

Verify the container.

```bash
docker logs freeradius
```

The service should start without errors.

---

# Configure MikroTik RouterOS

Example MikroTik configuration files are included.

```
mikrotik/
```

Available examples:

- radius-client.rsc
- openvpn-server.rsc
- firewall.rsc
- ppp-profile.rsc

Import the configuration snippets and adjust:

- IP addresses
- Shared Secret
- Certificates
- DNS servers

to match your environment.

---

# Configure OpenVPN

Configure the MikroTik OpenVPN server.

Verify:

- Authentication
- Encryption
- Certificates
- PPP Profile
- RADIUS Authentication

Ensure that OpenVPN authentication uses the configured FreeRADIUS server.

---

# Token Enrollment

Enroll a TOTP token for each user.

PrivacyIDEA generates a QR code that can be scanned using any supported authenticator application.

Verify successful enrollment before testing VPN authentication.

---

# Password Format

Depending on the configured PrivacyIDEA policy, users may authenticate using:

```
Password + OTP
```

Example:

```
MyPassword123456
```

or

```
Password123456789
```

Refer to your PrivacyIDEA policy configuration.

---

# Authentication Test

Verify the complete authentication workflow.

```
VPN Client

↓

Username

↓

Password + OTP

↓

MikroTik

↓

FreeRADIUS

↓

PrivacyIDEA

↓

Access-Accept

↓

VPN Connected
```

A successful login confirms correct communication between:

- Docker
- MariaDB
- PrivacyIDEA
- FreeRADIUS
- MikroTik RouterOS
- OpenVPN

---

# Validation Checklist

Before moving to production verify:

- Docker containers are running.
- MariaDB is healthy.
- PrivacyIDEA is reachable.
- FreeRADIUS starts without errors.
- Perl authentication module is working.
- MikroTik communicates with the RADIUS server.
- Users are synchronized.
- TOTP authentication succeeds.
- VPN authentication succeeds.
- HTTPS is configured.
- Time synchronization is correct.
- Backups are configured.
- Monitoring is enabled.

---

# Production Checklist

Before allowing production users to connect:

- Administrator password changed
- Default credentials removed
- Shared Secret replaced
- HTTPS enabled
- Firewall verified
- Docker images updated
- Database backups configured
- OTP enrollment completed
- VPN authentication tested
- Disaster recovery tested
- Monitoring configured
- Authentication logs reviewed

---

# Next Step

Continue with:

```
docs/freeradius-integration.md
```

to understand how FreeRADIUS communicates with PrivacyIDEA and how the Perl authentication module is integrated into the authentication workflow.
