*This project has been created as part of the 42 curriculum by jyap.*

# 42 Inception User Documentation

This project sets up a fully functional WordPress website using a Docker stack composed of three main services:

- **MariaDB** — the database storing all WordPress content.  
- **WordPress (PHP-FPM)** — the web application backend.  
- **NGINX** — the HTTPS web server and reverse proxy.  

The stack ensures secure communication using self-signed SSL certificates and separates data storage using Docker volumes.

---

## Services Provided

- **MariaDB**: Stores all website content, users, posts, and configuration.  
- **WordPress**: Handles website content, themes, plugins, and user management.  
- **NGINX**: Serves the website over HTTPS and forwards PHP requests to WordPress.  
- **Credentials management**: Sensitive passwords (database and WordPress) are stored as Docker secrets.

---

## Starting and Stopping the Project

### Start the Stack

From the root of the repository, run:

```sh
make up
```
or
```sh
docker compose up -d --build
```

- `-d` runs containers in detached mode.  
- `--build` ensures images are rebuilt if Dockerfiles were modified.

### Stop the Stack

```sh
make down
```
or
```sh
docker compose down
```

This stops all containers, but named volumes persist data, so your website content is retained.

---

## Accessing the Website

Open a web browser and go to:  
```
https://<HOST_IP>
```

Since a self-signed certificate is used, your browser may show a security warning. You can safely proceed.

---

## Accessing the WordPress Admin Panel

Admin URL:  
```
https://<HOST_IP>/wp-admin
```

Credentials are defined in `.env`:

```
WP_ADMIN=admin
WP_ADMIN_PASSWORD=<your admin password secret>
WP_ADMIN_EMAIL=<admin email>
```

---

## Locating and Managing Credentials

All sensitive passwords are stored as Docker secrets:

| Secret              | Location                           | Purpose                   |
|-------------------- |-----------------------------------|---------------------------|
| db_root_password    | ./secrets/db_root_password.txt     | Root MariaDB account      |
| db_user_password    | ./secrets/db_user_password.txt     | MariaDB user             |
| wp_user_password    | ./secrets/wp_user_password.txt     | WordPress user           |
| wp_admin_password   | ./secrets/wp_admin_password.txt    | WordPress admin          |

These secrets are automatically mounted inside the container at runtime and used by setup scripts. **Do not commit them to Git.**

---

## Checking Service Status

To verify that all services are running:

```sh
docker compose ps
```

Expected output shows three containers: `mariadb`, `wordpress`, `nginx` as `Up`.

You can also check logs:

```sh
make logs
```
or
```sh
docker compose logs -f
```

Look for:

- `mariadb`: ready for connections  
- `wordpress`: WordPress installed successfully / Starting PHP-FPM  
- `nginx`: All services ready. Starting NGINX...

---

## Notes

- **SSL**: Self-signed certificates are automatically generated in `/etc/ssl/self.crt` and `/etc/ssl/self.key`.  

---

## Exposed Ports

| Port | Service | Notes                      |
|------|---------|----------------------------|
| 443  | NGINX   | HTTPS (external access)    |
| 9000 | WordPress PHP-FPM | Internal, not exposed to host |
| 3306 | MariaDB | Internal, not exposed to host |

---

## Persistent Storage

The stack uses Docker volumes to store persistent data for the services. In this project, the volumes are **named but bind-mounted to specific directories on the host**, allowing easy access and backup outside Docker.

### MariaDB

- **Container path:** `/var/lib/mysql`  
- **Host path:** `${DATA_DIR}/mariadb`  
- **Purpose:** Stores all database files, including tables, users, and configuration.

### WordPress

- **Container path:** `/var/www/html`  
- **Host path:** `${DATA_DIR}/wordpress`  
- **Purpose:** Stores WordPress files, themes, plugins, and media uploads.

**Notes:**

- These volumes are named (`mariadb` and `wordpress`) from Docker’s perspective.  
- Bind-mounting ensures your data persists even if containers are removed, and makes migration or restoration easier.

---

This user documentation allows a new administrator to understand the stack, start/stop services, access the website, and manage credentials safely.