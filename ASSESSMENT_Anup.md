# Assessment
The application has been hosted successfully in AKS cluster. Please refer to the screenshot below,

![Application](/doc/images/application.JPG)

Due to unavailibity of any SSL certificate the application is serve over http protocol.

## Prerequisities:

 1. You should have an valid Azure Account
 2. You should have an Azure DevOps subscription to deploy the solution

 ## Details of Deployment

 I have used multistage azure devops yaml pipeline to deploy my solution into AKS. The pipeline looks like below,

 ![pipeline](/doc/images/pipeline.JPG)

 The architecture Diagram of Deployment looks like below,

![Deployment Architecture Diagram](/doc/images/PipelineArchitecture.JPG)

 Few Key points to be taken into consideration,

  * All the application secrets are maintainaed in Azure DevOps Librarry varibale group.
  * To run the deployment `Docker Registry Service Connection` and `Kubernetes service connection` has been used. 
  * Due to time constraints all the Azure Resources has been provisioned manually, but easily can be provisioned through ARM templated and outputs can be used in next deployment step.
  * The DB creation step has been executed in the Build phase once deployment is completed.
  * AKS RBAC has not been implemented due to evironment constraint at my end can be easily done to finegrain the security policy.

## Process instructions for provisioning solution.

 1. Provision Database and store the details as secrets in Azure DevOps Varibale group named as `TechChallengeApp`. 
 2. Provision Azure Infrastructure and create Azure DevOps Service connection.
 3. Modify `aksmanifest.yaml` to map to your ACR and AKS namespace.

## Resiliency of the application

- Auto scaling has been enabled by deploying into AKS and details has been provided in manifest file. The application has been deployed into 2 pods load balances through a internal load balancer.
- Highly available Database solution has been achieved through `Azure Database for PostgreSQL server` PAAS service with `Hyperscale (Citus) server group` plan using `Geo Redundant Feature` .

## CI/CD practice followed.

 * Branch restriction policy has been applied to prevent direct commits to `master` branch.
 * As part of the PR process github Checks has been enabled to check the build status. Please refer to the screen shot below,

![githubSecurity](/doc/images/githubSecurity.JPG)

