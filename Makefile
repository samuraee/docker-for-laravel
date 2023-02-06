COMPOSE_FILES=docker-compose.yml
COMPOSE_PROFILES=

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

help:
	@echo "env"
	@echo "==> Create .env file"
	@echo ""
	@echo "up"
	@echo "==> Create and start containers"
	@echo ""
	@echo "provision-all"
	@echo "==> Provision dependencies for database, PHP & JS"
	@echo ""
	@echo "provision-project"
	@echo "==> Provision dependencies for both PHP & JS"
	@echo ""
	@echo "provision-db"
	@echo "==> Provision database (Migrate & Seed)"
	@echo ""
	@echo "build-up"
	@echo "==> Create and build all containers"
	@echo ""
	@echo "watch-assets"
	@echo "==> Compile assets and watch all changes"
	@echo ""
	@echo "status"
	@echo "==> Show currently running containers"
	@echo ""
	@echo "destroy"
	@echo "==> Down all the containers, keeping their data"
	@echo ""
	@echo "shell"
	@echo "==> Create an interactive shell for FPM user"
	@echo ""
	@echo "shell-as-root"
	@echo "==> Create an interactive shell for root user"
	@echo ""
	@echo "mysql-shell"
	@echo "==> Create an interactive shell for MySQL"
	@echo ""
	@echo "redis-shell"
	@echo "==> Create an interactive shell for Redis"
	@echo ""
	@echo "precommit-hook"
	@echo "==> Setup precommit hook for git"
env:
	@[ -e ./.env ] || cp -v ./.env.example ./.env

up:
	docker-compose -f $(COMPOSE_FILES) up -d

build-up:
	docker-compose -f $(COMPOSE_FILES) up -d --build --force-recreate

build-no-cache:
	docker-compose -f $(COMPOSE_FILES) build --no-cache

status:
	docker-compose -f $(COMPOSE_FILES) ps

destroy:
	docker-compose -f $(COMPOSE_FILES) down --remove-orphans

shell:
	docker-compose -f $(COMPOSE_FILES) exec web bash

shell-as-root:
	docker-compose -f $(COMPOSE_FILES) exec -u 0 web bash

mysql-shell:
	docker-compose -f $(COMPOSE_FILES) exec -u 0 mysql mysql -u$(DB_USERNAME) -p$(DB_PASSWORD)

redis-shell:
	docker-compose -f $(COMPOSE_FILES) exec -u 0 redis redis-cli

provision-project:
	docker-compose -f $(COMPOSE_FILES) exec web /app/deploy/docker/development/provision_project.sh

provision-db:
	docker-compose -f $(COMPOSE_FILES) exec web /app/deploy/docker/development/provision_database.sh

provision-all: provision-project provision-db

watch-assets:
	docker-compose -f $(COMPOSE_FILES) exec web npm run watch

precommit-hook:
	@[ -f ./precommit-hook.sh ] && cp -v ./precommit-hook.sh ./.git/hooks/pre-commit || echo "error: could not find precommit-hook.sh"

style-check:
	docker-compose -f $(COMPOSE_FILES) exec web /app/vendor/bin/pint --test /app/