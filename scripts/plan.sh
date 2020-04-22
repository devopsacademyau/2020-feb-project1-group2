#!/bin/bash
cd terraform
terraform init
terraform plan -out da-wp
