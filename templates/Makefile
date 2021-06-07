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

db-image:
	@echo "[INFO] Building and pushing docker image for: [db]"
	pushd tasks/dbmgmt && docker build . -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:db -t servian:db
	make  ecr-login
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:db 

app-image:
	@echo "[INFO] Building and pushing docker image for: [application]"
	pushd ../ && docker build . -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:app -t servian:app &&  popd
	make  ecr-login
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian:app 

all-images: db-image app-image

sync-templates:
	@echo "Syncing local templates with S3..."
	aws s3 sync --exclude "*" --include "*.template" . s3://$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-utility-cloud-formation-repository\`].Value" --output text)

network:
	@echo "Deploying networking stack..."
	rain deploy infra-network.template infra-network -r ${AWS_REGION} --yes

db:
	@echo "Deploying data management layer..."
	rain deploy infra-db.template infra-db --params TemplateRepoURL=https://$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-utility-cloud-formation-repository\`].Value" --output text).s3-${AWS_REGION}.amazonaws.com  -r ${AWS_REGION} --yes

app:
	@echo "Rolling out application..."
	rain deploy infra-app.template infra-app \
		--params TemplateRepoURL=https://$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-utility-cloud-formation-repository\`].Value" --output text).s3-${AWS_REGION}.amazonaws.com,RegistryURL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/servian -r ${AWS_REGION} --yes

ecr-login: 
	@echo "Authenticating to repository"
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com	

run-dbinit:
	echo "[INFO] Presetting RDS cluster:"
	AWS_PAGER="" aws ecs run-task \
		--cluster $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-fargate-cluster\`].Value" --output text) \
		--task-definition $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-postgres-task\`].Value" --output text | cut -d "/" -f2) \
		--launch-type FARGATE --network-configuration \
		'{"awsvpcConfiguration":{"subnets": $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-private-subnets\`].Value" --output text), "securityGroups": ["$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-application-sec-group\`].Value" --output text)"],"assignPublicIp":"DISABLED"}}' \
		--region ${AWS_REGION}

run-dbseed:
	echo "[INFO] Seeding database with data:"
	AWS_PAGER="" aws ecs run-task \
		--cluster $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-fargate-cluster\`].Value" --output text) \
		--task-definition $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-seed-task\`].Value" --output text | cut -d "/" -f2) \
		--launch-type FARGATE --network-configuration \
		'{"awsvpcConfiguration":{"subnets": $(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-private-subnets\`].Value" --output text), "securityGroups": ["$(shell aws cloudformation list-exports --query "Exports[?Name==\`infra-app-application-sec-group\`].Value" --output text)"],"assignPublicIp":"DISABLED"}}' \
		--region ${AWS_REGION}

lint:
	@echo "Running the linter on Dockerfile..."
	docker pull hadolint/hadolint
	docker run --rm -i hadolint/hadolint < Dockerfile
