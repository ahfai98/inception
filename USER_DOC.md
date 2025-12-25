Services Provided

MariaDB: Database backend for WordPress.

WordPress: Frontend website.

Nginx: Reverse proxy with HTTPS support.

Starting and Stopping the Project

Start all services:

make up

Stop all services:

make down

Start individual services:

make mariadb make wordpress make mginx

Stop individual services:

make stop-mariadb make stop-wordpress make stop-nginx

Accessing the Website

Website: https://\<VM_or_Host_IP\>

WordPress Admin Panel: https://\<VM_or_Host_IP\>/wp-admin

Credentials

Stored in ./secrets folder:

db_root_password.txt → MariaDB root

db_user_password.txt → MariaDB user

wp_admin_password.txt → WordPress admin

wp_user_password.txt → WordPress user

Environment variables (.env) also hold database and WordPress
configuration:

DB_USER=xxx DB_NAME=xxx WP_USER=xxx WP_ADMIN=xxx WP_DOMAIN="user.42.fr"

Checking Service Status

Follow logs:

make logs

Logs per service:

make logs-mariadb make logs-wordpress make logs-nginx

Enter container shell:

make exec-mariadb make exec-wordpress make exec-nginx
