#!/bin/sh
set -e

#Ensure wordpress path exists
mkdir -p /var/www/html

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

echo "Waiting for mariadb..."
until mariadb-admin --silent -h mariadb -u ${DB_USER} -p${DB_USER_PASSWORD} ping; do
    sleep 1
done

#if wp-config does not exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading Wordpress core..."
    wp core download --path=/var/www/html --allow-root

    echo "Creating wp-config.php..."
    wp config create --path=/var/www/html --allow-root \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_USER_PASSWORD} \
        --dbhost=mariadb

    echo "Installing Wordpress..."
    wp core install --path=/var/www/html --allow-root \
        --url=${WP_DOMAIN} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    echo "Creating Wordpress User..."
    wp user create --path=/var/www/html --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author

    echo "Wordpress Installation Done."
fi

echo "Starting PHP-FPM 8.3..."
exec php-fpm83 -F