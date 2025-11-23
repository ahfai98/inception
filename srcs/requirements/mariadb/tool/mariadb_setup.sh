#!/bin/bash
DB_DATA_DIR="/var/lib/mysql"
DB_NAME="${DB_NAME:-default_wordpress}"
DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-default_rootpass}"
DB_USER="${DB_USER:-default_user}"
DB_USER_PASSWORD="${DB_USER_PASSWORD:-default_userpass}"

chown -R mysql:mysql "$DB_DATA_DIR"

cat > /setup.sql <<EOF
FLUSH PRIVILEGES;

-- Root user
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Application user
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;

-- Application database
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
FLUSH PRIVILEGES;
EOF

mysqld --bootstrap < /setup.sql

echo "[INFO] Starting MariaDB server..."
exec mysqld_safe --bind-address=0.0.0.0
