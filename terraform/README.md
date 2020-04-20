<em><h1>Wordpress Project - Group 2</h1></em>
Here we will discuss how to run the Project solution

<h2>How to run</h2>
- Take a clone or fork of the repoistry from Git
- Navgiate to the terraform folder (cd terraform)
- You'll need to initialize terraform to do this, please type ```terraform init```
- Once completed, type ```terraform plan``` This will plan out the way the Infrastructure is deployed, if you recieve any issues during this phase, please inform the team.
- Finally finish off with ```terraform apply``` and hit ```yes``` when prompoted. (You may recieve some issues regarding a lock file when applying, if this is the case please add the following parameter -lock=false)

- Once review has been completed, please don't forget to type ```terraform destroy -lock=false``` (Note there may be some issues regarding a DB Snapshot when destroying the code, if you do recieve this error navigate to your AWS RDS Console and select Snapshots from the left hand side, and delete the snapshot related to the created DB cluster.



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
