<em><h1>Wordpress Project - Group 2</h1></em>
Here we will discuss how to run the Project solution

<em><h2>How to run</h2><p></em>
- Clone or Fork the repository from Git
<br>
- Navigate to the terraform folder (cd terraform)
<br>
- You'll need to initialize terraform to do this, please type ```terraform init```
<br>
- Once completed, type ```terraform plan``` This will plan out the way the Infrastructure is deployed, if you recieve any issues during this phase, please inform the team.
<br>
- Finally finish off with ```terraform apply``` and hit ```yes``` when prompoted. 
<br>
- Once review has been completed, please don't forget to type ```terraform destroy``` (Note there may be some issues regarding a DB Snapshot when destroying the code, if you do recieve this error navigate to your AWS RDS Console and select Snapshots from the left hand side, and delete the snapshot related to the created DB cluster.</p>
<br>

<h2>RDS</h2>
<em>Here will describe the parts of the RDS Code.</em>
- The RDS Code is made of 3 different resources.

- ```aws_rds_cluster```
- ```aws_rds_cluster_instance```
- ```aws_db_subnet_group```

Each resource has a part to create with the DB Cluster.

- Within the RDS code, we're defining what type of RDS Cluster to create, which Availability Zone it shall reside in, DB Username / Password, VPC Subnet Association, Instance Class.

Finally, there is a random resource that will generate a password using the arguments specified in the code, and display the out upon creation
You will use the output to fill the System Manager Parameter.

<h2> Security Groups </h2>
- Along side the RDS Code, there is also Security group code.
<br>
This is mandotray to have the security groups defined upon DB Cluster creation 

<h2> Variables </h2>
- There have been a few additions to the variable file, which contains DB username, RDS Security Group ID, Subnet ID's, Availability Zone.

<br>

###**ECR**


**#Pushing an image to the repository**

**1) Retrieve an authentication token and authenticate your Docker client to your registry.
Use the AWS CLI:**
  aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com/wp-image

**2) Build your Docker image using the following command. For information on building a Docker file from scratch:**
  docker build -t wp-image ./wordpress/.

**3) After the build completes, tag your image so you can push the image to this repository:**
  docker tag wp-image:latest aws_account_id.dkr.ecr.region.amazonaws.com/wp-image:latest

**4) Run the following command to push this image to your newly created AWS repository:**
  docker push aws_account_id.dkr.ecr.region.amazonaws.com/wp-image:latest


**#Pulling an image to the repository**

**1) Retrieve an authentication token and authenticate your Docker client to your registry.
Use the AWS CLI:**
  aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com/wp-image

**2)  Identify the image to pull:**
  aws ecr describe-repositories
  
**3) Pull the image using the docker pull command:**
  docker pull aws_account_id.dkr.ecr.region.amazonaws.com/wp-image:latest
