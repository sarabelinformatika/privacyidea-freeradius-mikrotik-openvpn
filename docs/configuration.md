# Configuration Guide

> Complete configuration guide for integrating MikroTik RouterOS, FreeRADIUS and PrivacyIDEA to provide enterprise-grade Multi-Factor Authentication (MFA) for OpenVPN.

---

# Overview

After completing the installation, the following components must be configured:

1. MariaDB
2. PrivacyIDEA
3. FreeRADIUS
4. MikroTik RouterOS
5. OpenVPN
6. MFA Token Enrollment
7. Authentication Testing

This guide follows the recommended deployment sequence.

---

# Authentication Flow

```
OpenVPN Client
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

Authentication process:

1. The user connects to the MikroTik OpenVPN server.
2. MikroTik forwards the authentication request to FreeRADIUS.
3. FreeRADIUS validates the request through PrivacyIDEA.
4. PrivacyIDEA verifies:
   - Username
   - Password
   - TOTP code
5. If all checks succeed, an Access-Accept response is returned.
6. MikroTik establishes the VPN connection.

---

# Configuration Order

Always configure the environment in the following order:

| Step | Component |
|------|-----------|
| 1 | MariaDB |
| 2 | PrivacyIDEA |
| 3 | FreeRADIUS |
| 4 | MikroTik RouterOS |
| 5 | OpenVPN |
| 6 | MFA Token Enrollment |
| 7 | Authentication Testing |

Changing this order may lead to authentication failures.

---

# Configure MariaDB

MariaDB is used as the backend database for PrivacyIDEA.

Verify that the container is running:

```bash
docker ps
```

Expected container:

```
mariadb
```

Check database connectivity:

```bash
docker exec -it mariadb mysql -u root -p
```

Verify that the PrivacyIDEA database exists:

```sql
SHOW DATABASES;
```

Expected output:

```sql
privacyidea
```

Exit the MariaDB shell:

```sql
exit
```

---

# Configure PrivacyIDEA

Open the PrivacyIDEA web interface:

```
https://YOUR-SERVER-IP
```

or

```
https://YOUR-DOMAIN
```

Complete the initial setup wizard.

Create the administrator account.

After logging in:

- Configure the Realm
- Create the Resolver
- Synchronize users
- Enable TOTP support

At this stage, do **not** enroll tokens yet.

Token enrollment is covered later in this guide.

---

# Best Practices

During configuration:

- Use HTTPS only.
- Enable automatic backups.
- Use strong administrator passwords.
- Synchronize system time using NTP.
- Restrict administrative access.
- Store secret keys securely.

---

# Configure FreeRADIUS

FreeRADIUS acts as the authentication gateway between MikroTik RouterOS and PrivacyIDEA.

All authentication requests received from MikroTik are forwarded to PrivacyIDEA for verification.

The authentication workflow is:

```
MikroTik
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

## Verify the FreeRADIUS Container

Ensure the container is running.

```bash
docker ps
```

Expected output:

```
freeradius
```

Review the container logs.

```bash
docker logs freeradius
```

The service should start without errors.

---

## Configure RADIUS Clients

Each MikroTik router must be defined as a trusted RADIUS client.

Typical parameters include:

- Client IP Address
- Shared Secret
- Authentication Port
- Accounting Port

Only trusted network devices should be allowed to communicate with the RADIUS server.

---

## Configure PrivacyIDEA Authentication

FreeRADIUS authenticates users through PrivacyIDEA.

The authentication module should:

- Validate username
- Validate password
- Validate TOTP token
- Return Access-Accept or Access-Reject

No user credentials should be stored inside FreeRADIUS.

PrivacyIDEA remains the authoritative authentication source.

---

## Authentication Flow

```
VPN User

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
```

---

# Configure MikroTik RouterOS

Open WinBox or connect using SSH.

Navigate to:

```
Radius
```

Create a new RADIUS client.

Typical parameters include:

- Service: PPP
- Address: FreeRADIUS Server
- Authentication Port: 1812
- Accounting Port: 1813
- Shared Secret: Strong Password

Verify that the router can communicate with the FreeRADIUS server before continuing.

---

# Configure OpenVPN

Enable OpenVPN Server.

Configure:

- Authentication
- Encryption
- Certificates
- User Profiles

Ensure OpenVPN authentication uses the configured RADIUS server.

---

# Configure PrivacyIDEA

Log in as Administrator.

Complete the following tasks:

- Create Realm
- Configure Resolver
- Import Users
- Create Policies
- Enable TOTP Authentication

Verify that users are visible before continuing.

---

# Token Enrollment

Enroll a TOTP token for each user.

Supported applications include:

- Google Authenticator
- Microsoft Authenticator
- Authy
- FreeOTP
- Aegis

Scan the generated QR code.

Verify successful token enrollment.

---

# Authentication Test

Test the complete authentication chain.

```
VPN Client

↓

Username

↓

Password

↓

OTP

↓

VPN Connected
```

Successful authentication confirms:

- Docker environment
- MariaDB
- PrivacyIDEA
- FreeRADIUS
- MikroTik
- OpenVPN

are correctly configured.

---

# Validation Checklist

Before deploying into production verify:

- Docker containers are running.
- PrivacyIDEA is reachable.
- MariaDB is healthy.
- FreeRADIUS starts without errors.
- MikroTik reaches the RADIUS server.
- Users are synchronized.
- TOTP authentication succeeds.
- VPN connection is established.

All items should be successfully completed before allowing production users to connect.
