#!/bin/sh
set -e

mkdir -p /var/www/html
cd /var/www/html

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

echo "Waiting for MariaDB..."
until mariadb-admin --silent -h mariadb -u "$DB_USER" -p"$DB_USER_PASSWORD" ping; do
    sleep 1
done

if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."

    # Download only if core files are missing
    if [ ! -f wp-load.php ]; then
        wp core download --allow-root
    fi

    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbhost=mariadb

    wp core install --allow-root \
        --url="$WP_DOMAIN" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --allow-root \
        "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

    echo "WordPress installation completed."
else
    echo "WordPress already installed. Skipping setup."
fi

echo "Starting PHP-FPM 8.3..."
exec php-fpm83 -F
