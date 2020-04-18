#ECR

1)Retrieve an authentication token and authenticate your Docker client to your registry.
Use the AWS CLI:
C: aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com/wp-image

2) Build your Docker image using the following command. For information on building a Docker file from scratch:
C: docker build -t wp-image ./wordpress/.

3) After the build completes, tag your image so you can push the image to this repository:
C: docker tag wp-image:latest aws_account_id.dkr.ecr.region.amazonaws.com/wp-image:latest

4) Run the following command to push this image to your newly created AWS repository:
c: docker push aws_account_id.dkr.ecr.region.amazonaws.com/wp-image:latest

Amazon ECR - Pushing an Image:
https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html
ps.: Use the commands provided on ECR > Repositories > Image (in this case wp-image) > View push commands Button, because it provides the same information as above + the specific commands to our image.

Amazon ECR - Pulling an Image:
https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-pull-ecr-image.html
