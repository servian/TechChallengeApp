## What is it
Set of CloudFormation template and shell scripts and Dockerfiles to orchestrate provisioning of the environment

### infra-utility.template
Resources, shared between templates or ones that provide infrastructure for infrastructure. For example, and S3 bucket where we sync all templates so we can reuse these templates
in higher order templates (as nested).

### infra-network.template
Responsible for managing shared network resources, VPC, DMZ networks, Internet and NAT Gateway. 

### infra-private-network.template
Low level module to create private subnets and is intended to be used as a nested stack. Better approach would be to create a [CloudFormation module](https://aws.amazon.com/blogs/mt/introducing-aws-cloudformation-modules/). 
Using module would result in less orchestration of our own and cleaner templates. And of course, no nasty nestedness.

### infra-db.template
Creates and manages database cluster

### infra-app.template
Creates and manages task definitions and serivces for Fargate cluster.

## Tools (and installation instruction for Mac)
### cfn-lint
Official linter for templates, very reasonable set of default rules
```
brew install cfn-lint
```
### rain
development workflow tool for CloudFormation [https://github.com/aws-cloudformation/rain]
```
brew install rain
```

## Assumptions
AWS CLI is installed and configured with the `default` profile in ap-southeast-1 (Singapore region). `default` profile has `AdministratorAccess` AWS Managed Policy attached to it. That deserves its own prolonged conversation, but for the sake of exercise I think this is reasonable assumption.


## Deployment
Controlled via Makefile, worth noting, the order of operations matter (and that is something to think about going forward - how to make deployment declarative rather then imperative).
Here is the sequence of make invocations:
```
make utils
make sync-templates
make all-images
make network
make db
make run-dbinit
make run-dbseed
```

## Utilities
I've used `docker compose` to make sure application actually runs as expected before shaping the Fargate, task definitions and service. Run it with
```
docker compose up
```
as compose now is part of docker!

## Impprovements
Well, lots of them actually! 
1. RDS is encrypted at rest with custom KMS key
2. Secrets are encrypted using custom KMS
3. Better composition of templates (more nestedness!)
4. Better exported names (stronger naming convention)
5. Incorporate linting for Dockerfiles and CloudFormation templates. I actually did it while developing but didn't make it a part of build system
6. I did not figure out better way to execute dbinit and dbseed
7. May be look at copilot to manage application environment
8. Get better structure for tempates. As application template looks bloated now.
