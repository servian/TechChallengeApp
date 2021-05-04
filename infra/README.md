# The Techchallange app deployment guide

### Introduction:
The TechChallange app is a go language single page app backed by Postgres SQL. The following document describes the updates and deployment of the app and db in a highly available environment.

### Assumptions: 
Cloud Provider: AWS 
VPC: The user must have VPC built for this. It can also be deployed in default VPC in the aws account. If not then there is VPC Stack available in the zip file. sample-vpc.yml
Security: The security aspects are not covered in details, given that the challenge should be simple to deploy with less dependencies. However the security improvements is suggested in the improvement area where user can improve the security architecture of the application 
Internet: The subnets should be having outbound to internet open to download the docker images

### Application Changes
   The application configuration has been changed to accomodate the autoscaling and dynamic pointers for the DB. Below are list of changes - 

**Conf.toml location**: The default location for conf.toml is changed to /opt/conf.toml in Dockerfile. The reason because in autoscalling,  the setup is creating conf.toml file local in host (/techchallenge/conf.toml)using dynamic parameters e.g. DB Host, and credentials using cloud init, and then mounting the /techchallenge with /opt directory of the container. Thus each new launch the image can remain same but DB can change dynamically without creating new image.

**DB Configuration**: Each time the new node launched in autoscaling group, there is cloud init command to dropping/creating table, and seeding data using updated -s option. This will reset DB every time new node launched. 
The code then updated to remove seeding and dropping table. Updating creating table with Create if not exist SQL Command. So it will only run first time and then retain the data for rest of DB usage. e.g. ASG new nodes, or upgrade in ASG won’t affect the DB data. 
 
Build the new Image: The docker image built with new code is praveenkpatidar/techchallangeapp:7. 

**NOTE**: If team need I can share the code update separately.  

### CloudFormation Template and Deployment Guide
There are 2 CloudFormation stacks template included. One optional networking and another one for application stack. 


**sample-vpc.yml**: **(Optional)** if the VPC is not exists in the AWS Account. Recommended is to have public and private VPC but the solution can be deployed in default VPC.

**00_cfn_app_infra.yml**: Provide the mandatory networking parameters, and leave the rest parameters to default settings unless required.

### Improvements can be done in future - 
Deployment Automation: 
	The deployment is not automated. However it can be wrapped into automation utilities e.g. CLIs, Jenkins to link the input from first stacks to down stream stacks. 
The output of Endpoints and ARNs can be published in SSM Parameters and then can be referred by downstream stacks. 
**Components:**
	In real time scenario the app stack will have separate stack for each components. e.g. IAM Roles, Security Groups, RDS and Autoscaling Groups can have separate interlinked stacks to better management.

**Parameters:**
	More parameterisation and should be done in template. For the purpose of simplicity additional values e.g. Max, min, desired capacity kept constant. 

**Encryption and SSL:** 
	Use encrypted Amis, RDS Encryption and ACM for HTTPS connection.

**SSH Connection to servers:**
	The keys are not used for the ssh and the KeyName is commented out in template. If one need to do ssh, then he need to open the port 22 and also relaunch stack by uncommenting the keyname parameter in the stack 05. 

**Password Maintenance:** 
	The passwords are kept open in CloudFormation. It can be driven via SSM Parameters Secure String or Secret Manager to rotate regularly. 

### Clean UP: 
Delete the infra stack and VPC stack (If deployed) 

---
If there is any issue in the deployment or configuration. Please contact
praveenpatidar007@gmail.com
0469977102
