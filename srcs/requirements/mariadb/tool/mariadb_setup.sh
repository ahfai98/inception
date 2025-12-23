#!/bin/bash

#Initialize MariaDB
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB ..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

#Setup Mariadb
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

#Wait for MariaDB to be ready
until [ -S /run/mysqld/mysqld.sock ]; do
	echo "Waiting for MariaDB to be ready..."
	sleep 1
done

#Initialise custom database
# If the database is not initialized, set it up
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "Initializing database..."
    mariadb -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;
        CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;
        CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
        FLUSH PRIVILEGES;
EOSQL
    #Shutdown Mariadb
    echo "Shutting down temporary MariaDB instance..."
    mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait "$pid"
else
    echo "Database already exists, skipping initialization..."
    # Kill the background process
    kill "$pid"
    wait "$pid"
fi

#Start Mariadb in foreground
echo "Starting MariaDB server..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --console