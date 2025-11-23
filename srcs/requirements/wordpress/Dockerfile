# Base image
FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP 8.2, necessary extensions, WP-CLI dependencies
RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysql php8.2-curl php8.2-zip php8.2-xml \
    php8.2-gd php8.2-mbstring php8.2-intl php8.2-bcmath \
    curl wget less mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Copy custom PHP-FPM pool configuration
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
# Ensure the PHP runtime socket directory exists
RUN mkdir -p /run/php

# Copy WordPress setup script
COPY ./tool/wp_setup.sh /wp_setup.sh
RUN chmod +x /wp_setup.sh

# Set working directory (optional)
WORKDIR /var/www/html

# Start the WordPress setup script
CMD ["/bin/bash", "/wp_setup.sh"]
