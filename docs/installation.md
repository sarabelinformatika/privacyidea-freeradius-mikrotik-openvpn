# Installation Guide

> Enterprise deployment guide for implementing Multi-Factor Authentication (MFA) on MikroTik OpenVPN using PrivacyIDEA, FreeRADIUS and Docker Compose.

---

# Disclaimer

This project is intended for educational purposes, proof-of-concept environments and production reference implementations.

Although the configuration has been designed following industry best practices, every production environment is unique. Always validate the complete solution in a non-production environment before deployment.

---

# Project Overview

MikroTik RouterOS currently supports username/password authentication and certificate-based authentication for OpenVPN.

Native support for Time-based One-Time Passwords (TOTP), HOTP or modern Multi-Factor Authentication is not available.

This project extends the authentication process by introducing a dedicated RADIUS authentication layer using FreeRADIUS and PrivacyIDEA.

The solution enables enterprise-grade MFA while preserving the existing OpenVPN infrastructure.

---

# Architecture

```
                   +----------------------+
                   | OpenVPN Client       |
                   +----------+-----------+
                              |
                              |
                              ▼
                   +----------------------+
                   | MikroTik RouterOS    |
                   | OpenVPN Server       |
                   +----------+-----------+
                              |
                    RADIUS Authentication
                              |
                              ▼
                   +----------------------+
                   | FreeRADIUS           |
                   +----------+-----------+
                              |
                              ▼
                   +----------------------+
                   | PrivacyIDEA          |
                   +----------+-----------+
                              |
                              ▼
                   +----------------------+
                   | MariaDB              |
                   +----------------------+
```

---

# Tested Environment

| Component | Version |
|-----------|---------|
| Debian | 13 (Trixie) |
| Docker Engine | Latest Stable |
| Docker Compose | v2 |
| PrivacyIDEA | 3.13 |
| FreeRADIUS | 3.x |
| MariaDB | 11.x |
| MikroTik RouterOS | 7.x |

---

# Minimum System Requirements

| Resource | Recommended |
|----------|-------------|
| CPU | 2 vCPU |
| Memory | 4 GB RAM |
| Storage | 30 GB SSD |
| Network | Static IP Address |
| DNS | Fully Qualified Domain Name (recommended) |

---

# Network Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 443 | TCP | PrivacyIDEA Web Interface |
| 1812 | UDP | RADIUS Authentication |
| 1813 | UDP | RADIUS Accounting (optional) |
| 1194 | TCP or UDP* | OpenVPN Server |

> **Note**
>
> RouterOS versions differ in supported OpenVPN transport protocols. Verify compatibility with your installed RouterOS version before deployment.

---

# Prerequisites

Before installing the solution ensure that:

- Debian is fully updated.
- Docker Engine is installed.
- Docker Compose is available.
- The server has a static IP address.
- DNS resolution works correctly.
- Internet connectivity is available.
- NTP time synchronization is configured.
- Required firewall ports are opened.

---

# Update the Operating System

```bash
apt update
apt upgrade -y
reboot
```

---

# Install Docker

Install Docker using the official Docker installation script.

```bash
curl -fsSL https://get.docker.com | sh
```

Verify installation.

```bash
docker version
```

Expected output:

```
Client:
 Version: xx.xx

Server:
 Version: xx.xx
```

---

# Verify Docker Compose

```bash
docker compose version
```

Example:

```
Docker Compose version v2.xx.x
```

---

# Clone the Repository

```bash
git clone https://github.com/sarabelinformatika/privacyidea-freeradius-mikrotik-openvpn.git
```

Enter the project directory.

```bash
cd privacyidea-freeradius-mikrotik-openvpn
```

---

# Configure Environment Variables

Create a production configuration file.

```bash
cp .env.example .env
```

Edit the configuration.

```bash
nano .env
```

At minimum configure:

- PI_SECRET_KEY
- PI_PEPPER
- Database username
- Database password
- Database name
- Time zone

Never commit the `.env` file to GitHub.

---

# Start the Environment

Launch all containers.

```bash
docker compose up -d
```

The first startup may take several minutes while Docker downloads the required images.

---

# Verify Running Containers

```bash
docker ps
```

Expected containers:

- mariadb
- privacyidea
- freeradius

All containers should report a healthy or running state.

---

# Verify PrivacyIDEA

Open your browser.

```
https://SERVER-IP
```

or

```
https://your-domain.example
```

The PrivacyIDEA login page should be displayed.

---

# Verify FreeRADIUS

View the logs.

```bash
docker logs freeradius
```

The log should indicate successful startup without errors.

---

# Verify MariaDB

```bash
docker logs mariadb
```

Ensure the database initialized successfully and is accepting connections.

---

# Installation Complete

The base infrastructure is now operational.

Continue with:

- Configuration of PrivacyIDEA
- FreeRADIUS integration
- MikroTik RADIUS client configuration
- OpenVPN server configuration
- TOTP token enrollment

See:

```
configuration.md
```

---

# Troubleshooting

If any service fails to start:

- Verify Docker is running.
- Check container logs.
- Validate `.env` configuration.
- Confirm firewall rules.
- Verify DNS resolution.
- Ensure server time is synchronized.

Additional troubleshooting documentation is available in:

```
troubleshooting.md
```

---

# Security Recommendations

For production environments always:

- Replace all default passwords.
- Generate unique secret keys.
- Restrict RADIUS access.
- Enable HTTPS certificates.
- Backup the database regularly.
- Monitor authentication logs.
- Keep Docker images updated.
- Apply operating system security updates.

---

# Next Step

Proceed to:

```
configuration.md
```

to configure the complete authentication workflow between MikroTik RouterOS, FreeRADIUS and PrivacyIDEA.
