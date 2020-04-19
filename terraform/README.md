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
