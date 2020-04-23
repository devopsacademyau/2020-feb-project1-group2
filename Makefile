BUILD_DOCKER = docker-compose build
RUN_DOCKER = docker-compose run --name wpimage-$(SHA) -d wp
SHA = $(shell git rev-parse --short HEAD)

plan:
	bash -x scripts/plan.sh

apply:
	bash -x scripts/apply.sh

destroy:
	bash -x scripts/destroy.sh

build:
	echo ID=$(SHA) > .env
	$(BUILD_DOCKER)
run:
	$(RUN_DOCKER) 
