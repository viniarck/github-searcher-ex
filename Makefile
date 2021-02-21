build:
	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build

test:
	docker exec api bash -c "mix test --trace"

mix-deps:
	docker exec api bash -c "mix deps.get"

test-local:
	cd github && mix test --trace

compose-up:
	docker-compose up -d

compose-down:
	docker-compose down

.PHONY: all test clean
