FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && chmod 755 /run/mysqld

EXPOSE 3306

COPY ./tool/mariadb_setup.sh .

RUN chmod +x mariadb_setup.sh

CMD ["bash", "mariadb_setup.sh"]
