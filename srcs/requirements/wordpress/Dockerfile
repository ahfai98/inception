FROM alpine:3.21

RUN apk add --no-cache ca-certificates

RUN cat <<EOF > /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/v3.21/main
https://dl-cdn.alpinelinux.org/alpine/v3.21/community
EOF

#Install PHP, MariaDB, WP-CLI dependencies
RUN apk add --no-cache \
    php php-fpm php-cli \
    php-mysqli php-mbstring php-zip php-ctype php-iconv php-phar \
    mariadb-client curl

#Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

#Copy custom PHP-FPM pool configuration
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

RUN sed -i 's/^memory_limit\s*=.*/memory_limit = 512M/g' /etc/php83/php.ini 

COPY ./tool/wp_setup.sh /wp_setup.sh
RUN chmod +x /wp_setup.sh

EXPOSE 9000

ENTRYPOINT ["/wp_setup.sh"]