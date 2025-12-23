
USER_HOME      := $(HOME)
DATA_DIR       := $(USER_HOME)/data
MARIADB_DIR    := $(DATA_DIR)/mariadb
WORDPRESS_DIR  := $(DATA_DIR)/wordpress

#Docker only looks for this particular env variable
#os.LookupEnv("COMPOSE_FILE")
COMPOSE_FILE   := srcs/docker-compose.yml

#makes srcs/docker-compose.yml available to the environment
export COMPOSE_FILE

#build images and containers
up: create_dirs
	docker compose up --build -d

#stops containers, removes containers, volumes and networks
down:
	docker compose down -v

#builds images only
build:
	docker compose build

restart:
	docker compose restart

#stops containers, deletes images and volumes, and removes orphan containers
#deletes bind-mounted folders
clean:
	docker compose down --rmi all --volumes --remove-orphans
	sudo rm -rf $(DATA_DIR)

#after clean, wipes out all unused images, networks, containers, build cache, volumes
fclean: clean
	docker system prune -af --volumes

re: fclean up

create_dirs:
	mkdir -p $(MARIADB_DIR) $(WORDPRESS_DIR)

mariadb:
	docker compose up -d --build mariadb

wordpress:
	docker compose up -d --build wordpress

stop-mariadb:
	docker compose stop mariadb

stop-wordpress:
	docker compose stop wordpress

rebuild-mariadb:
	docker compose build mariadb
	docker compose up -d mariadb

rebuild-wordpress:
	docker compose build wordpress
	docker compose up -d wordpress

logs:
	docker compose logs -f

logs-mariadb:
	docker compose logs -f mariadb

logs-wordpress:
	docker compose logs -f wordpress

exec-mariadb:
	docker compose exec mariadb bash

exec-wordpress:
	docker compose exec wordpress bash

.PHONY: up down build clean fclean re create_dirs
