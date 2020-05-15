SHA=$(git rev-parse --short HEAD)
AID=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)

cd ../wordpress

eval $(aws ecr get-login --no-include-email --profile default --region $REGION | sed 's|https://||')

docker build -t wpimage:$SHA .

docker tag wpimage:$SHA $AID.dkr.ecr.$REGION.amazonaws.com/wp-image:$SHA

docker push $AID.dkr.ecr.$REGION.amazonaws.com/wp-image:$SHA
