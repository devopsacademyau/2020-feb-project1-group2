#!/bin/bash
cd terraform
terraform apply -auto-approve
terraform output > db.txt 
