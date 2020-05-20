SHA=$(git rev-parse --short HEAD)
REGION=$(aws configure get region)
ECR_REPO_NAME=$(aws ssm get-parameter --name "ECR_REPO_URL" --with-decryption --output text --query Parameter.Value)
ECR_REPO_PASSWORD=$(aws ecr get-login-password --region $REGION)
ECR_REPO_TAG=$ECR_REPO_NAME:$SHA

sed 's|{image}:|{image}:'"${SHA}"'|g' ../terraform/modules/application/td_template.json > ../terraform/modules/application/task_definition.json

cd ../wordpress

docker login --username AWS --password $ECR_REPO_PASSWORD $ECR_REPO_NAME
docker build -t $ECR_REPO_TAG .
docker push $ECR_REPO_TAG