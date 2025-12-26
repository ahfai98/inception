#!/bin/sh
set -e

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)

echo "Waiting for MariaDB..."
until mariadb -h "mariadb" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" -e "SELECT 1"; do
  echo "MariaDB not ready yet..."
  sleep 3
done

echo "Waiting for WordPress..."
until nc -z wordpress 9000; do
  echo "WordPress not ready yet..."
  sleep 3
done

echo "All services ready. Starting NGINX..."
exec nginx -g "daemon off;"
