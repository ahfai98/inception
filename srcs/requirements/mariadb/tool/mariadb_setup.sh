#!/bin/sh
#exit if any command fails
set -e

#prepare runtime directory /run/mysqld for socket file
#get write permission for mysql user
#socket file allows local clients like mariadb CLI to connect without TCP
#pid file stores process ID of running MariaDB server, used to stop the server
#these two files are not permanent and are only valid while the server is running
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)

#check if database initialised
if [ ! -d /var/lib/mysql/mysql ]; then
    chown -R mysql:mysql /var/lib/mysql
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mariadbd --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    until mariadb-admin --silent -u root ping; do
        sleep 1
    done
    #In MariaDB/MySQL, anonymous users take precedence over wildcard users for a given host.
    #After deletion, authentication behaves as expected: named user + password is required.
    mariadb -e "DELETE FROM mysql.user WHERE User='';"
    mariadb -e "FLUSH PRIVILEGES;"
    mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
    mariadb -e "CREATE USER IF NOT EXISTS ${DB_USER} IDENTIFIED BY '${DB_USER_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_USER};"
    mariadb -e "FLUSH PRIVILEGES;"
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
    mariadb-admin -u root -p${DB_ROOT_PASSWORD} shutdown
    wait $pid
fi

#Start Mariadb in foreground
exec mariadbd --user=mysql --datadir=/var/lib/mysql