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
RUN apk add --no-cache mariadb mariadb-client

#replace all matching bind-address to 0.0.0.0, allows connection from any IP
#comment out all skip-networking to enable TCP connection
RUN sed -i "s/.*bind-address\s*=.*/bind-address=0.0.0.0/g" /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i "s/.*skip-networking.*/#skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf

#COPY ./tool/my_custom.cnf /etc/my.cnf.d/my_custom.cnf

COPY ./tool/mariadb_setup.sh /mariadb_setup.sh
RUN chmod +x /mariadb_setup.sh

EXPOSE 3306
ENTRYPOINT ["/mariadb_setup.sh"]