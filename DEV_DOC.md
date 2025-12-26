# Developer Documentation

## 1. Environment Setup

### Prerequisites

Before setting up the project, ensure you have the following installed on your system:
- Docker (latest stable version)
- Docker Compose (v2+)
- Make (for Makefile commands)
- Git (for cloning the repository)
- Alpine Linux or compatible Linux environment recommended (though Docker works on other OS)

### Configuration Files

- `.env` — contains environment variables for the stack such as `DB_NAME`, `DB_USER`, `WP_DOMAIN`, etc.
- `conf/` — configuration files for Nginx (`nginx.conf`) and PHP-FPM (`www.conf`).
- `tool/` — shell scripts for initializing MariaDB (`mariadb_setup.sh`), WordPress (`wp_setup.sh`), and Nginx (`nginx_setup.sh`).
- `requirements/` — Dockerfiles and related setup for each service:
  - `requirements/mariadb/`
  - `requirements/wordpress/`
  - `requirements/nginx/`

### Secrets

Stored in `secrets/` folder:
- `db_root_password.txt`
- `db_user_password.txt`
- `wp_user_password.txt`
- `wp_admin_password.txt`

Secrets are mounted into containers at runtime for security.

## 2. Building and Launching the Project

Clone the repository:
```bash
git clone <repo_url>
cd <repo_name>
```

Set up `.env` and `secrets/` files with appropriate values.

Start the stack using Makefile:
```bash
make up
```
This builds all images and launches containers.

Docker Compose automatically handles dependencies: `mariadb → wordpress → nginx`.

Stopping the stack:
```bash
make down
```
Stops all containers. Named volumes persist unless explicitly removed.

## 3. Managing Containers and Volumes

### Docker Compose Commands

View running containers:
```bash
docker compose ps
```

Tail logs of all services:
```bash
docker compose logs -f
```

Rebuild a specific service (e.g., WordPress):
```bash
docker compose build wordpress
docker compose up -d wordpress
```

### Makefile Commands (examples)
- `make build` — Build all images.
- `make up` — Launch all containers.
- `make down` — Stop containers.
- `make logs` — Follow logs of all containers.

### Volumes

Named volumes store persistent data:
- `mariadb` → `/var/lib/mysql`
- `wordpress` → `/var/www/html`

Inspect volumes:
```bash
docker volume ls
docker volume inspect <volume_name>
```

Clean up unused volumes:
```bash
docker volume prune
```

## 4. Project Data and Persistence

- **MariaDB:** All database data is stored in the named volume `mariadb`. Data persists even if containers are removed.
- **WordPress:** All site files, themes, plugins, and uploads are stored in `wordpress` named volume. Changes persist between container restarts.

### Backup / Restore

Named volumes can be backed up:
```bash
docker run --rm -v mariadb:/data -v $(pwd):/backup alpine tar czf /backup/mariadb.tar.gz -C /data .
```
Similar approach applies for the WordPress volume.

## 5. Notes for Developers

- Containers may take time to be fully ready after `docker compose up` due to service initialization (MariaDB setup, WordPress install).
- Nginx waits for WordPress and MariaDB before starting to serve HTTPS