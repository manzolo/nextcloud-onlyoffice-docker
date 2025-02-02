# Nextcloud with OnlyOffice Integration (Docker Compose)

**Note:** This setup is primarily intended for local development and testing purposes. It uses self-signed certificates, which are not suitable for production environments due to security concerns. For production deployments, consider using a trusted Certificate Authority (CA) to obtain a valid SSL certificate.
This repository provides a streamlined setup for deploying Nextcloud with integrated OnlyOffice document editing capabilities using Docker Compose.

## Features

- **Seamless Integration:** Leverage OnlyOffice within Nextcloud for collaborative editing of documents, spreadsheets, and presentations directly from the web interface.
- **Dockerized Deployment:** Benefit from a containerized approach for simplified setup, management, and scalability.
- **Pre-configured Environment:** Enjoy a ready-to-use environment with essential configurations for Nextcloud and OnlyOffice.

## Prerequisites

To successfully run this setup, ensure you have the following installed on your system:

- **Linux-based Operating System:** This project is designed for Linux environments (e.g., Ubuntu, Debian, CentOS).
- **Docker Engine:** Docker is required to manage the containerized applications. You can download and install Docker from the official website (https://www.docker.com/get-started).
- **Docker Compose:** Docker Compose simplifies multi-container applications. Install it using your system's package manager (e.g., `sudo apt install docker-compose` on Ubuntu/Debian).
- **OpenSSL:** OpenSSL is used for secure communication. It's typically pre-installed on most Linux distributions.
- **GNU Make (Optional):** While not strictly necessary, `make` can automate certain tasks (explained in the Usage section).

## Usage

### Clone the Repository

Begin by cloning this repository to your local machine:

```bash
git clone https://github.com/manzolo/nextcloud-onlyoffice-docker.git
cd nextcloud-onlyoffice-docker
make prepare   # Creates the necessary volume folders to store persistent data for Nextcloud and OnlyOffice
make start     # Starts Nextcloud and OnlyOffice containers
make logs      # Displays logs from the containers

```

### Add entry to /etc/hosts
```
<your-IP> nextcloud.lan
<your-IP> onlyoffice.lan
```

### Verify configuration (*accept self-signed certificate*)
- Navigato to [https://nextcloud.lan](https://nextcloud.lan)
- Navigato to [https://onlyoffice.lan](https://onlyoffice.lan)

### Onlyoffice configuration

- Navigato to [https://nextcloud.lan](https://nextcloud.lan)

- Install OnlyOffice app:

    Log in to Nextcloud.
    Go to "Apps" -> "Discover".
    Search for and install the "OnlyOffice" app.

- Configure OnlyOffice:

    Go to "Admin" -> "OnlyOffice".
    In the "OnlyOffice Server URL" field, enter: https://onlyoffice.lan.
    In the "Secret Key" field, enter the value of the JWT_SECRET environment variable. You can find this value in the .env file.

### Test onlyoffice
Run this command:
```bash
make onlyoffice-enable-test
```
Navigato to [https://onlyoffice.lan/example/](https://onlyoffice.lan/example/)
    
## Important Considerations

- **Self-Signed Certificates:** This setup uses self-signed certificates for convenience during development and testing. Self-signed certificates are not trusted by browsers and may trigger security warnings. For production environments, obtain a valid SSL certificate from a trusted Certificate Authority.
- **Security:** Always follow best practices for securing your Nextcloud instance, including strong passwords, regular updates, and appropriate firewall configurations.
- **Persistent Storage:** For long-term data persistence, configure persistent storage volumes for Nextcloud. Refer to the official Nextcloud documentation for details.
- **Customization:** You can customize this setup by modifying the `docker-compose.yml` file and exploring the configuration options for Nextcloud and OnlyOffice.

