# Devops Academy - Project 01 – Group 02

Application migration from on-premise to the Cloud

## Solution Diagram
<!-- Image of design will go here -->
![AWSproject_wp_no53](https://user-images.githubusercontent.com/45111486/82754368-d09efd80-9e0f-11ea-9787-1e73773c1e11.png)



## Description

The objective for this team project is to create and run a pilot migration of a company’s web application to AWS.

Our project follows the assumption that this application is currently being used by hundreds of customers every day and it is based on WordPress - LAMP stack (Linux, Apache, MySQL and PHP). The company’s CEO is worried that a traffic peak may bring down the website and decided to migrate to the cloud.

## Technologies used:

* VCS → Github
* Infra as Code → Terraform
* Containerization → Docker / Docker-compose
* Build-automation utility  → Make
* Relational Database → Amazon Aurora (MySQL)
* Container orchestrator → ECS
* Host and images manager → ECR
* Cloud file storage → EFS

## Prerequisites to run this repository

* Git
* Docker Compose
* Make
* CLI

## Run instructions

Firstly, clone or download this Repository: 

[GitHub - devopsacademyau/2020-feb-project1-group2](https://github.com/devopsacademyau/2020-feb-project1-group2)

After cloning it, please ensure you are in the terraform directory:

`cd terraform`

Execute the command:

 `make all`

(Make utility will use the Makefile, which contains the targets and instructions on how to run a series of commands) 

Initialize the AWS Component, that is to pass your credentials to terraform.
You will be asked for your Secret key via the AWSCLI Container:


AWS Access Key ID [None]:\
AWS Secret Access Key [None]:\
Default region name [None]:\
Default output format [None]—-\

Then finally,

`make destroy`

To destroy or permanently delete the resources. The destroy action cannot be reversed.

Alternatively, if you prefer to see the execution of each step separately, you can do so by typing each of these commands followed by Enter.

`make init`\
`make _awsinit`\
`make build`\
`make plan`\
`make apply`

## Authors:

* Matt Garces
* Denise Horstmann
* Adriana Cavalcanti
* Marcio de Faria

## Road blocks:

- Finding time to work on this project and continue with our daily routines and jobs was a major road block. 
- The majority of our resources were built and we were able to run Wordpress app as expected. However, there were a few issues regarding CI/CD Workflow. After moving the tfstate file to S3 and testing, it was working fine on Matt's side. CI/CD Workflow from GH Action was deploying the solution upon new merges to master.But when other members of the team tried to test "make all" the issues started to appear: invalid AWS Credentials, tfstate being locked to certain users. We need to revist how to pass credentials.

## Improvements:

- Apply Blue-Green deployment to reduce downtime. This seems the safest strategy and popular for production workloads.
- Complete the CI/CD requirement part of the project. 
