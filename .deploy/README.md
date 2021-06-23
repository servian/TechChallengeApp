# Deployment

The following is a guide on deploying this application from the repository that has been cloned to your device.

## Pre-requisites

The following are requried to be install on the device to which you are deploying.

- Git
- An Azure Subscription
- Azure Cli
- Terraform
- Docker

Azure cloud shell has terraform and git pre-installed as well as authenticated to azure, making it a great way to quickly launch this deployment from a cloned copy of this repository. However to seed the database we will run a quick docker command which will launch a container, connect to PostreSQL and seed the database then will close.  
This task requires the docker engine is installed.

# Architecture

See the [Architecture documentation](./ARCHITECTURE.md) for an overview of what will be deployed.

# Instructions

Launch [Azure cloud shell](https://shell.azure.com)

> ...and ensure the desired subscription is selected!

Clone the repository

`git clone <repo-url>`

Next run through the [terraform variables file](./azure/variables.tf). There are some `sensible` defaults that you are welcome to override.

Change into the terrform deployment directory of **.deploy/azure**

```bash
terraform init

terraform plan -out tfplan

terraform apply tfplan
```

If the terraform output is Ok, proceed with the deployment.

\***\* Perform the following on the device where you have docker installed. \*\***

After the infrastructure is setup, create a file that will house some environment variables. An example of the key=value pairs are in **deploy/env.conf.example**. Fill with the values that are being used for the database user, password and host.

```bash
#pop out of the current 'azure' folder

cd ..

code env.conf
```

We will pass these values as environmental variables into our docker image, to seed the database. This is a once off task, and could be automated as a Stage in a pipeline but for now it would be quicker to perform this action.

!! _This is not a production methodology of deploying schema changes to a database. This is a development scenario_ !!

_Source_ the file into your bash environment to create Environmental variables. This is so that you don't have to type the variables inline.

```bash
# Add some environmental variables into our current shell environment
source env.conf

# echo out a variable to test
echo $VTT_DBHOST
```

As is the beauty of Docker, run this shortlived task to connect and seed the Database.

```bash

docker pull servian/techchallengeapp

docker run \
    -e VTT_DBUSER=$VTT_DBUSER \
    -e VTT_DBHOST=$VTT_DBHOST \
    -e VTT_DBNAME=$VTT_DBNAME \
    -e VTT_DBPASSWORD=$VTT_DBPASSWORD \
     servian/techchallengeapp \
     updatedb -s
```

You should expect to see positive logging from the application advising that the seed operation completed.

Visit the Application URL (terraform would have output this) and start GTD!

## Moving Forward

- Implementing Continous Deployment via Azure DevOps
- Authentication to Azure with a service principal
- Secrets via Key Vault, pulled into the pipelines as a variable group
- Connect the Web App to Azure database for PostreSQL with Private Link and remove the insecure firewall rule of allowing 0.0.0.0
- Terraform remote state
