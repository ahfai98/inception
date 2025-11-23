FROM debian:bookworm

COPY ./tool/mariadb_setup.sh .

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server

EXPOSE 3306

CMD ["bash", "mariadb_setup.sh"]
