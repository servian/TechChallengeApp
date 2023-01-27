#!/bin/bash

# Start the container and set the environment variables to overwrite the existing config.toml
docker run -d --name TechChallengeApp -p 80:<SERVICE_PORT> \
-e VTT_DBUSER=$(aws ssm get-parameter --name <APP_NAME>_rds_kf_postgresql_master_user --region <AWS_DEFAULT_REGION> --with-decryption | jq -r '.Parameter.Value') \
-e VTT_DBPASSWORD=$(aws ssm get-parameter --name <APP_NAME>_rds_kf_postgresql_master_password --region <AWS_DEFAULT_REGION> --with-decryption | jq -r '.Parameter.Value') \
-e VTT_DBHOST='<DBHOST>' \
-e VTT_DBNAME='<DBNAME>' \
-e VTT_DBPORT='5432' \
-e VTT_DBTYPE='postgres' \
-e VTT_LISTENHOST='0.0.0.0' \
-e VTT_LISTENPORT='<SERVICE_PORT>' \
<AWS_ACCOUNT_ID>.dkr.ecr.<AWS_DEFAULT_REGION>.amazonaws.com/<IMAGE_REPO_NAME>:<IMAGE_TAG>
