#!/bin/bash

WP_PATH="/var/www/html/wordpress"
DB_HOST="${DB_HOST:-mariadb}"
WAIT_TIMEOUT="${WAIT_TIMEOUT:-60}"  # max wait time in seconds

echo "[INFO] Waiting for MariaDB at $DB_HOST to be ready..."

SECONDS_WAITED=0
until mysqladmin ping -h "$DB_HOST" --silent; do
    if [ $SECONDS_WAITED -ge $WAIT_TIMEOUT ]; then
        echo "[ERROR] MariaDB did not become ready after $WAIT_TIMEOUT seconds."
        exit 1
    fi
    echo "[INFO] MariaDB not ready yet, sleeping 2 seconds..."
    sleep 2
    SECONDS_WAITED=$((SECONDS_WAITED + 2))
done

echo "[INFO] MariaDB is up. Continuing WordPress setup..."

# Ensure WordPress directory exists
mkdir -p "$WP_PATH"

if [ -z "$(ls -A $WP_PATH)" ]; then
    echo "[INFO] WordPress directory is empty. Performing first-time setup..."
    cd "$WP_PATH"

    echo "[INFO] Downloading WordPress core..."
    wp core download --allow-root

    echo "[INFO] Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbhost="$DB_HOST" \
        --skip-check \
        --allow-root

    echo "[INFO] Installing WordPress..."
    wp core install \
        --url="$WP_DOMAIN" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "[INFO] Creating regular WordPress user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root

    echo "[INFO] WordPress bootstrap complete."
else
    echo "[INFO] WordPress directory already contains files. Skipping installation."
fi

echo "[INFO] Starting PHP-FPM 8.2..."
exec php-fpm8.2 -F -R
