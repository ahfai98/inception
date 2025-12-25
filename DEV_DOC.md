Developer Documentation (DEV_DOC.md) Prerequisites

Docker & Docker Compose

Make

Git

Environment Setup

Clone the repository:

git clone \<repo_url\> cd \<repo_name\>

Create required directories for persistent data:

mkdir -p \${HOME}/data/mariadb \${HOME}/data/wordpress

Copy and edit .env file with appropriate credentials.

Building and Launching

Build all images:

make build

Launch all services:

make up

Build and launch individual services:

make rebuild-mariadb make rebuild-wordpress make rebuild-nginx

Managing Containers and Volumes

Stop containers:

make down

Clean everything including images and volumes:

make fclean

Prune unused Docker objects:

docker system prune -af --volumes

Access container shell:

make exec-mariadb make exec-wordpress make exec-nginx

Data Storage

MariaDB: \${HOME}/data/mariadb (via Docker volume bind mount)

WordPress: \${HOME}/data/wordpress (via Docker volume bind mount)

Makefile Overview

up → Build and start all services

down → Stop and remove containers, volumes, networks

logs → Follow logs

exec-\* → Enter container shell

clean/fclean/re → Cleanup images, volumes, and directories

Docker Compose Notes

Uses custom bridge network inception

Secrets stored in ./secrets for sensitive credentials

Volumes bind-mounted to host DATA_DIR for persistence

Services dependency:

WordPress depends on MariaDB

Nginx depends on WordPress
