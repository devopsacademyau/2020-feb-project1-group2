# Devops Academy - Project 01 – Group 02

Application migration from on-premise to the Cloud

## Solution Diagram
![AWSproject01](https://user-images.githubusercontent.com/45111486/80457800-3fa14780-8973-11ea-9982-a1e28bafa713.png)<!-- Image of design will go here -->

## Description

The objective for this team project is to create and run a pilot migration of a company’s web application to AWS.

Our project follows the assumption that this application is currently being used by hundreds of customers every day and it is based on WordPress - LAMP stack (Linux, Apache, MySQL and PHP). The company’s CEO is worried that a traffic peak may bring down the website and decided to migrate to the cloud.

## Technologies used:

• VCS → Github
• Infra as Code → Terraform
• Containerization → Docker / Docker-compose
• Relational Database → Amazon Aurora (MySQL)
• Container orchestrator → ECS
• Host and images manager → ECR
• Cloud file storage → EFS

## Prerequisites to run this repository

• Git
• Docker Compose
• Make
• CLI

## Run instructions

Firstly, you must initialize the AWS Component, that is to pass your credentials to terraform.
To do this type.

`make _awsinit`

You'll then be asked for your Secret key via the AWSCLI Container

AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]:
Default output format [None]

After completing these,
It will store the credentials within the terraform folder in a folder titled "Creds"

Then run

`make init`

To start the terraform init

`make plan`

To start terraform plan

`make apply`

To apply

After running `make apply`, in order to include the right values in the parameters store keys or change the values manually:

1. Log in to AWS console then go to Systems Manager service, which is located under Management & Governance.
2. Navigate to Parameter Store, under Application Management.
3. Select the parameter and click “Edit” to change/add the new value. Save changes.
   Remember to select “SecureString” to encrypt sensitive data using the KMS keys for your account.

Then finally,

`make destroy`

To destroy or permanently delete the resources. The destroy action cannot be reversed.

## Authors:

• Matt Garces
• Denise Horstmann
• Adriana Cavalcanti
• Marcio de Faria

## Road blocks:

- Finding time to work on this project and continue with our daily routines and jobs was the first road block. 
The majority of our resources were built, but we were unable to run Wordpress as expected. Some of the issues we had includes finishing the tasks definitions, not having EC2 instances registered so ASG was not able to launch any new instance inside the cluster. We also just have a single NAT Gateway in our solution for decreasing costs, two would be ideal. 

## Improvements:

- Prioritisation of tasks. Not knowing where to start and not having experience working on a similar project caused a few delays in the initial two weeks.  
- Terraform plan and apply nuances such as naming resources, for example, duplicated names resources issues. 
