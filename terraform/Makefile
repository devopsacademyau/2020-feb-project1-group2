SHA = $(shell git rev-parse --short HEAD)
RUN = docker-compose run --rm

##TASKS
init:
	echo ID=$(SHA) > .env
	$(RUN) terraform init
.PHONY: init

_awsinit:
	mkdir -p creds
	$(RUN) aws configure
.PHONY: _awsinit

build:
	$(RUN) terraform apply -target module.ecr -var-file="dev.tfvars" -auto-approve
	bash -x ../scripts/push.sh
.PHONY: build

plan:
	$(RUN) terraform plan -var-file="dev.tfvars" -out=.terraform-plan 
.PHONY: plan

apply:
	$(RUN) terraform apply .terraform-plan 
.PHONY: apply

destroy:
	$(RUN) terraform destroy -var-file="dev.tfvars" -auto-approve
.PHONY: destroy

all:
	make _awsinit
	make init
	make build
	make plan
	make apply
.PHONY: all