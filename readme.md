# Servian DevOps Tech Challenge - Tech Challenge App

## Deployment

I have chosen to use an AWS Fargate ECS instance for hosting the dockerized application, and an AWS RDS instance for the postgres. There is an AWS Elastic Load Balancer in front.

### Reasons
- AWS Fargate is highly available, and serverless so there is little managing of the containers.
- RDS is a managed database, which is highly available by utilising multiple availability zones, and is easy to scale if required.
- Elastic load balancer allows us to have a single point of entry into the application from the internet. 

## How to Deploy
### Locally
I have created a docker-compose which should allow you to easily run the application locally. The config file for the database is `database.env`. The application config is set in the `conf.toml`.

1. Clone repo
2. `docker-compose up` 

### Deploying to AWS
1. Clone repo
2. Set environment variable for AWS: 

    `export AWS_ACCESS_KEY_ID = <value>`

    `export AWS_SECRET_ACCESS_KEY= <value>`

3. Run terraform code: 

    `terraform init`

    `terraform apply --auto-approve`

3. Push docker image into the newly provisioned AWS ECR instance

    `docker build -t servian/techchallengeapp .`

    `docker tag servian/techchallengeapp <path to ECR repo>`

    `docker push <path to ECR repo>`

4. Ensure fargate tasks are running successfully.

5. Find load balncer DNS name and navigate to site. 


## Architecture Diagram

## TODO

There are a lot of things I would implement/change given more time and if this was a real production system.

- Secret Management - using Terraform and AWS Secret Manager to automatically generate and store secret for database. 
- Better hardening of networking - ensuring private subnets for the fargate application and only have the load balancer public facing. 
- Makefile for easy tag/push of docker image for local dev.
- CI/CD pipeline to automate the entire deployment. 
- Better logging and observability.

