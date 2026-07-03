# Installation Guide

> Enterprise deployment guide for implementing Multi-Factor Authentication (MFA) for MikroTik OpenVPN using PrivacyIDEA, FreeRADIUS and Docker Compose.

---

# Disclaimer

This project is intended for educational purposes, proof-of-concept environments and production reference implementations.

Although the configuration follows industry best practices, every production environment is unique. Always validate the complete solution in a non-production environment before deployment.

---

# Project Overview

MikroTik RouterOS supports username/password authentication and certificate-based authentication for OpenVPN.

However, RouterOS does **not** provide native support for modern Multi-Factor Authentication (MFA), such as Time-based One-Time Passwords (TOTP).

This project extends the authentication workflow by introducing a dedicated RADIUS authentication layer using FreeRADIUS and PrivacyIDEA, enabling enterprise-grade MFA while preserving the existing OpenVPN infrastructure.

---

# Architecture

```
                   +----------------------+
                   |    OpenVPN Client    |
                   +----------+-----------+
                              |
                              |
                              ▼
                   +----------------------+
                   |  MikroTik RouterOS   |
                   |    OpenVPN Server    |
                   +----------+-----------+
                              |
                    RADIUS Authentication
                              |
                              ▼
                   +----------------------+
                   |     FreeRADIUS       |
                   +----------+-----------+
                              |
                         Perl Module
                              |
                              ▼
                   +----------------------+
                   |    PrivacyIDEA       |
                   +----------+-----------+
                              |
                              ▼
                   +----------------------+
                   |      MariaDB         |
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
| 443 | TCP | PrivacyIDEA Web Interface (Reverse Proxy) |
| 8080 | TCP | PrivacyIDEA Container |
| 1812 | UDP | RADIUS Authentication |
| 1813 | UDP | RADIUS Accounting (optional) |
| 1194 | TCP or UDP | OpenVPN Server |

> **Note**
>
> RouterOS versions differ in supported OpenVPN transport protocols. Verify compatibility with your installed RouterOS version before deployment.

---

# Prerequisites

Before installing the solution, ensure that:

- Debian is fully updated.
- Docker Engine is installed.
- Docker Compose is available.
- The server has a static IP address.
- DNS resolution works correctly.
- Internet connectivity is available.
- NTP time synchronization is configured.
- Required firewall ports are opened.

---

# Network Requirements

Verify that:

- MikroTik can reach the FreeRADIUS server.
- FreeRADIUS can communicate with PrivacyIDEA.
- PrivacyIDEA can connect to MariaDB.
- Docker containers can communicate through the Docker bridge network.
- DNS resolution works correctly if hostnames are used.

---

# Update the Operating System

```bash
apt update
apt upgrade -y
reboot
```

---

# Install Docker

Install Docker Engine and Docker Compose using the official Docker installation guide for your Linux distribution.

Official documentation:

https://docs.docker.com/engine/install/

Verify the installation.

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

Create the production configuration file.

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
- PI_ADMIN_USER
- PI_ADMIN_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_ROOT_PASSWORD

Never commit the `.env` file to GitHub.

---

# Start the Environment

Launch the complete Docker stack.

```bash
docker compose up -d
```

The first startup may take several minutes while Docker downloads and initializes the required images.

---

# Verify Running Containers

```bash
docker compose ps
```

Expected services:

- mariadb
- privacyidea
- freeradius

All services should report a running state.

---

# Verify PrivacyIDEA

Open your browser.

If you are using the default Docker deployment:

```
http://SERVER-IP:8080
```

If you are using a reverse proxy:

```
https://your-domain.example
```

The PrivacyIDEA login page should be displayed.

---

# Initial Administrator

The first administrator account is created using the credentials defined in the `.env` file.

After the initial login:

- Verify administrator access.
- Change the administrator password if default credentials were used.
- Create additional administrative accounts if required.

---

# Verify FreeRADIUS

Check the container logs.

```bash
docker logs freeradius
```

The logs should indicate a successful startup without errors.

---

# Verify MariaDB

```bash
docker logs mariadb
```

Ensure the database initialized successfully and is accepting connections.

---

# Supported Authenticator Applications

PrivacyIDEA supports standard TOTP applications, including:

- Google Authenticator
- Microsoft Authenticator
- FreeOTP
- Aegis Authenticator
- Authy (where supported)

---

# Installation Complete

The infrastructure is now operational.

Continue with:

- PrivacyIDEA configuration
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
- Validate the `.env` configuration.
- Confirm firewall rules.
- Verify DNS resolution.
- Ensure system time is synchronized.

For additional troubleshooting guidance, see:

```
troubleshooting.md
```

---

# Security Recommendations

For production deployments, always:

- Replace all default passwords.
- Generate unique secret keys.
- Use strong RADIUS shared secrets.
- Restrict UDP ports 1812 and 1813.
- Enable HTTPS using a reverse proxy.
- Protect configuration backups.
- Backup the MariaDB database regularly.
- Monitor authentication logs.
- Keep Docker images updated.
- Apply operating system security updates.
- Test disaster recovery procedures.

---

# Next Steps

After the installation is complete:

1. Configure PrivacyIDEA.
2. Configure FreeRADIUS.
3. Configure MikroTik RouterOS.
4. Enroll TOTP tokens.
5. Test OpenVPN authentication.
6. Enable HTTPS.
7. Configure monitoring and backups.

Continue with:

```
configuration.md
```
