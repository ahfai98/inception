FROM alpine:3.21

#--no-cache avoids caching to keep image small
#CA Certificates needed to use HTTPS connection
RUN apk add --no-cache ca-certificates

#Configure APK repositories
RUN cat <<EOF > /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/v3.21/main
https://dl-cdn.alpinelinux.org/alpine/v3.21/community
EOF

#Install MariaDB
#update package index
#mariadb server daemon, mariadb-client is command line client to interact with Mariadb
RUN apk update && \
    apk add --no-cache mariadb mariadb-client

# Copy custom config for MariaDB
COPY ./conf/custom.cnf /etc/my.cnf.d/custom.cnf

COPY ./tool/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh

EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]