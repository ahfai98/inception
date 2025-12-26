*This project has been created as part of the 42 curriculum by jyap.*

==============
1. Description
===============

The 42 Inception project is designed to deploy a fully functional WordPress website
using Docker containers, orchestrated with Docker Compose. The project demonstrates
containerization, service orchestration, networking, and secrets management.

The deployed stack consists of three main services:

- **MariaDB**: Provides the database backend for WordPress. The container initializes
  the database, creates the required user and database, and ensures secure passwords
  via Docker secrets.

- **WordPress**: The PHP-based web application. This container installs WordPress
  automatically using WP-CLI, sets up the wp-config.php file, creates the admin user,
  and optionally creates additional users.

- **NGINX**: Acts as a reverse proxy with SSL support. The container waits for MariaDB and WordPress to be ready before starting, ensuring no connection errors occur.

Persistent storage is implemented using Docker volumes for both MariaDB and WordPress
to preserve data across container restarts.

=========================================
2. Project Structure and Included Sources
==========================================

- **requirements/mariadb/**: Dockerfile and `mariadb_setup.sh` script for initializing
  the MariaDB database and managing the root and user credentials.

- **requirements/wordpress/**: Dockerfile and `wp_setup.sh` script for downloading,
  configuring, and installing WordPress with WP-CLI.

- **requirements/nginx/**: Dockerfile and `default.conf` for SSL-enabled NGINX
  configuration, including FastCGI integration with PHP-FPM.

- **docker-compose.yml**: Orchestrates all services, networks, volumes, and secrets.

- **secrets/**: Contains password files for MariaDB and WordPress users. These are
  mounted as Docker secrets to avoid exposing sensitive information in environment variables.

- **volumes**: Defined for persistent data storage for WordPress and MariaDB.

================
3. Instructions
================

Prerequisites:
- Docker 20+ and Docker Compose installed.
- Unix-like environment recommended (Linux/macOS).

Steps to run the project:

1. Clone the repository:
git clone <repo_url>
cd <repo_name>

2. Ensure secrets are created:
./secrets/db_root_password.txt
./secrets/db_user_password.txt
./secrets/wp_user_password.txt
./secrets/wp_admin_password.txt

3. Build and start containers using Makefile or Docker Compose:
make
or
docker compose up --build -d

4. Access the website:
https://<host-ip>
- WordPress installation and user creation will be completed automatically.
- Self-signed SSL certificate is used for development purposes.

5. View logs:
make logs
- Useful for monitoring MariaDB, WordPress, and NGINX startup progress.

6. Stop and remove containers:
make down
- Preserves volumes to maintain data.

============================
4. Technical Design Choices
=============================

**Docker vs Virtual Machines**
- Docker containers are lightweight, start quickly, and share the host OS kernel.
- Virtual machines provide full OS isolation but consume more resources and are slower to boot.
- Docker was chosen for faster deployment, simplified orchestration, and efficient resource usage.

**Secrets vs Environment Variables**
- Docker Secrets are used for sensitive data (database passwords, WP passwords)
to prevent exposing them in `docker inspect`.
- Environment variables are used for non-sensitive configuration (DB_NAME, WP_TITLE, etc.).

**Docker Network vs Host Network**
- A custom bridge network (`inception`) is used to isolate containers.
- Inter-container communication occurs over the bridge network using container names as DNS.
- Host networking was avoided to improve security and service isolation.

**Docker Volumes vs Bind Mounts**
- Volumes provide persistent, managed storage for WordPress and MariaDB data.
- Bind mounts map host directories directly and are used here with `driver_opts` for easier data persistence.
- Volumes allow better portability and backup compared to bind mounts alone.

**Health Checks and Wait-for Scripts**
- NGINX waits for MariaDB and WordPress to be fully initialized before starting to prevent connection errors.
- WordPress container waits for MariaDB to be ready before running installation scripts.
- MariaDB container initializes system tables and users only if the database is not already set up.

============
5. Resources
============

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- MariaDB documentation: https://mariadb.com/kb/en/
- WordPress documentation: https://wordpress.org/support/
- NGINX documentation: https://nginx.org/en/docs/
- WP-CLI documentation: https://wp-cli.org/
- Tutorials on LEMP stack with Docker: https://www.digitalocean.com/community/tutorials
- AI usage: AI was used to assist in writing documentation, explaining scripts,
and providing technical recommendations. No AI-generated code was used in production.

====================
6. Additional Notes
====================

- First-time startup may take longer due to MariaDB system table initialization
and WordPress installation.
- Self-signed SSL certificates are included for HTTPS development testing.
- Ports exposed: 443 (NGINX HTTPS).
- Docker Compose ensures proper dependency order with `depends_on` and
wait-for scripts to prevent premature service startup.
