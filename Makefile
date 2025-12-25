
DATA_DIR       := $(HOME)/data

#Docker only looks for this particular env variable
#os.LookupEnv("COMPOSE_FILE")
COMPOSE_FILE   := srcs/docker-compose.yml

#makes srcs/docker-compose.yml available to the environment
export COMPOSE_FILE

#build images and containers, --build rebuilds image
#-d detached, --wait waits for all services to become healthy
up: create_dirs
	docker compose up --build -d --wait

#stops containers, removes containers, volumes and networks
down:
	docker compose down -v

#builds images only, does not start containers
build:
	docker compose build

#stops containers, removes containers, images and volumes, orphan containers
#deletes host bind-mounted folders
clean:
	docker compose down --rmi all --volumes --remove-orphans
	doas rm -rf $(DATA_DIR)

#deletes all unused images, networks, containers, build cache, volumes
#-a removes everything not in use, -f no confirmation
fclean: clean
	docker system prune -af --volumes

re: fclean up

create_dirs:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

mariadb: create_dirs
	docker compose up -d --build mariadb --wait

wordpress: create_dirs
	docker compose up -d --build wordpress --wait

mginx: create_dirs
	docker compose up -d --build nginx --wait

stop-mariadb:
	docker compose stop mariadb

stop-wordpress:
	docker compose stop wordpress

stop-nginx:
	docker compose stop nginx

rebuild-mariadb: create_dirs
	docker compose build mariadb
	docker compose up -d mariadb

rebuild-wordpress: create_dirs
	docker compose build wordpress
	docker compose up -d wordpress

rebuild-nginx: create_dirs
	docker compose build nginx
	docker compose up -d nginx

#-f follow logs
logs:
	docker compose logs -f

logs-mariadb:
	docker compose logs -f mariadb

logs-wordpress:
	docker compose logs -f wordpress

logs-nginx:
	docker compose logs -f nginx

exec-mariadb:
	docker compose exec mariadb sh

exec-wordpress:
	docker compose exec wordpress sh

exec-nginx:
	docker compose exec nginx sh

.PHONY: up down build clean fclean re create_dirs \
        mariadb wordpress nginx stop-mariadb stop-wordpress stop-nginx \
        rebuild-mariadb rebuild-wordpress rebuild-nginx \
        logs logs-mariadb logs-wordpress logs-nginx \
        exec-mariadb exec-wordpress exec-nginx
