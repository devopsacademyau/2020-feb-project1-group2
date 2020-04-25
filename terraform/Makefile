SHA = $(shell git rev-parse --short HEAD)

##Tasks

init:
        echo ID=$(SHA) > .env
        docker-compose run --rm \
        terraform init
.PHONY: init


_awsinit:
        mkdir -p creds
        docker-compose run --rm aws \
        configure

.PHONY: _awsinit


plan:
        docker-compose run  \
        --rm terraform plan -out=.terraform-plan


.PHONY: plan


apply:
        docker-compose run --rm \
        terraform apply .terraform-plan

.PHONY: apply

destroy:
        docker-compose run --rm \
        terraform destroy -auto-approve
.PHONY: destroy
