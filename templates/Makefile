#.SHELLFLAGS := -eu -o pipefail -c
.PHONY: build lint push release install clean

AWS_REGION?=ap-southeast-1
AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --query "Account" --output text)

compose:
	@echo "Bootstrapping containers locally"
	pushd util/ && docker compose up -d

decompose:
	@echo "Shutting down containers"
	pushd util/ && docker compose down

utils:
	@echo "Deploying the utils..."
	rain deploy infra-utility.template infra-utility -r ${AWS_REGION} --yes

build-push:
	@echo "Preparing docker images..."
	pushd ../ && docker build . -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:app -t servian:app &&  popd
	pushd tasks/dbmgmt && docker build . -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:db -t servian:db
	make  ecr-login
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:app 
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:db 


sync-templates:
	@echo "Syncing local templates with S3..."
	aws s3 sync --exclude "*" --include "*.template" . s3://$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-utility-cloud-formation-repository\`].Value" --output text)

network:
	@echo "Deploying networking stack..."
	rain deploy infra-network.template infra-network -r ${AWS_REGION} --yes
db:
	@echo "Deploying data management layer..."
	rain deploy infra-db.template infra-db -r ${AWS_REGION} --yes

app:
	@echo "Rolling out application..."
	rain deploy infra-app.template infra-app -r ${AWS_REGION} --yes

ecr-login: 
	@echo "Authenticating to repository"
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com	

build:
	@echo "Building docker image for ${prog}"
	docker build --build-arg release=${release} -t ${prog}:latest -t ${prog}:${release} .

lint:
	@echo "Running the linter on Dockerfile..."
	docker pull hadolint/hadolint
	docker run --rm -i hadolint/hadolint < Dockerfile
