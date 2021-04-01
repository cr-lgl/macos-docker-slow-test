DOCKER_COMPOSE ?= cd docker && docker-compose -p macos_docker_slow_test

.PHONY: start
start: erase build up ## clean current environment, recreate dependencies and spin up again

.PHONY: rebuild
rebuild: start ## same as start

.PHONY: erase
erase: ## stop and delete containers, clean volumes.
		$(DOCKER_COMPOSE) stop
		$(DOCKER_COMPOSE) rm -v -f

.PHONY: build
build: ## build environment and initialize composer and project dependencies
		$(DOCKER_COMPOSE) build

.PHONY: up
up: ## spin up environment
		$(DOCKER_COMPOSE) up -d

.PHONY: backend-bash
backend-bash: ## gets inside a backend container
		$(DOCKER_COMPOSE) exec --user workspace backend bash -l

.PHONY: composer
composer: ## composer install
		$(DOCKER_COMPOSE) exec --user backend workspace composer install

.PHONY: keygen
keygen: ## generate keys
		$(DOCKER_COMPOSE) exec --user backend workspace php artisan key:generate

.PHONY: front-bash
front-bash: ## gets inside a frontend container
		$(DOCKER_COMPOSE) exec --user node frontend sh -l
