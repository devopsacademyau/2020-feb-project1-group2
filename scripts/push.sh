SHA=$(git rev-parse --short HEAD)

cd ../wordpress

eval $(aws ecr get-login --no-include-email --profile default --region ap-southeast-2 | sed 's|https://||')

docker build -t wpimage:$SHA .

docker tag wpimage:$SHA 595875296375.dkr.ecr.ap-southeast-2.amazonaws.com/wp-image:$SHA

docker push 595875296375.dkr.ecr.ap-southeast-2.amazonaws.com/wp-image:$SHA
