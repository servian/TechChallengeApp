# Deploying the environment using teraform

## Prerequisites
- Terraform
- Azure CLI
- Account in Github
- Container Registry
- Azure storage account to store terraform state file
- Azure Service Principal

NOTE: This was tested using Ubuntu. If you wish to use powershell you may need to change the `.env` in point 3 to SET instead of export.

### 1- Install Azure CLI
Follow the instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

On Debian \ Ubuntu:

As described [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest): 
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 2 - Login to azure to provision prerequisites 

2.1 Log in with your azure admin account:

```bash
$ az login
```

2.2 Select your subscription
```bash
$ az account list
```

2.3 Set your subscription id 
```bash
$ az account set --subscription="SUBSCRIPTION_ID"
```

2.4 Create application service principal (for simplicity we could use a scope over the subscription, not recommended in a production environment)
```bash
az ad sp create-for-rbac --name "techapp" --role contributor \
                            --scopes /subscriptions/SUBSCRIPTION_ID \
                            --sdk-auth
``` 
Save the output as it will be required to configure the secrets in github.

More details can be found [here](https://github.com/Azure/login#configure-deployment-credentials)

2.5 Create a secret and record its value. You can also store these details locally in the environment file as described in the following step
https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#add-credentials

### 3 Create a storage account for the backend config
You can create a copy of the `.env.template` file called `.env` in the env folder of the project. This file extension is ignored by git. This will be useful if you wish to deploy the infrastructure manually later.

There is an `.env` file will set environment variables that determine the name of the resource group, the location, and the storage account used for saving Terraform state.

Note that storage account names need to be globally unique, so you will have to update the storage account name provided in the `.env.template` file. You can check whether a chosen name is available using the following command: 
```bash
az storage account check-name --name $TERRAFORM_SA
```

Create a resource group and storage account for storing the backend config using the following script:
```bash
az group create -n $RESOURCE_GROUP -l $LOCATION
az storage account create -n $TERRAFORM_SA -g $RESOURCE_GROUP --sku Standard_LRS
az storage container create --name $TERRAFORM_CONTAINER --account-name $TERRAFORM_SA
```

### 4 - Confiure Github Actions repository

4.1 Create a `ci` environment. go to >> settings> environments >> new environment
    add `ci` value and press ok.

    NOTE: You could set quality gates for certain users if you wish at this point.

In your applications repository go to >> settings >> secrets >> actions >> new repository secret and add the details for each of these:

4.1 Secrets required by Terraform CLI

    - Name: ARM_CLIENT_ID
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: ARM_CLIENT_SECRET
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: ARM_SUBSCRIPTION_ID
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: ARM_TENANT_ID 
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: TERRAFORM_CONTAINER
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: TERRAFORM_KEY
    Value: {as per output captured on step 2.4 or as per `.env` file}

    - Name: TERRAFORM_SA
    Value: {as per output captured on step 2.4 or as per `.env` file}
    
    - Name: RESOURCE_GROUP
    Value: {as per output captured on step 2.4 or as per `.env` file}

4.2 Secret required for the Azure/github action CLI

    - Name: AZURE_CREDENTIALS
    Value: 
        {
            "clientId": "{as per output captured on step 2.4}",
            "clientSecret": "{as per output captured on step 2.5}",
            "subscriptionId": "{as per output captured on step 2.4}",
            "tenantId": "{as per output captured on step 2.4}"
        }

4.3 Docker hub container registry secret    
        
    4.3.1 Create a new access token in you dockerhub account as described [here](https://docs.docker.com/docker-hub/access-tokens/#create-an-access-token)

    4.3.2 Create secret

        - Name: DOCKER_USERNAME
          Value: {the token created in 3.3.1}
        - Name: DOCKER_USERNAME
          Value: {Your github account username}


NOTE: The app is defaulted to the image eliasm50/techchallengeapp:latest that already exists, it can be changed by changing the file env.{env_name}.ftvars terraform file        

### 5 - Run the github actions in this order

1 - Infrastructure Deploy Workflow: This action will provision the infrastructure required to run the application. This is triggered manually

2 - SeedDB Workflow: This will seed the database. This is triggered manually

3 - CICD Workflow: This will build and deploy the latest version of the application using a semver tag. This is triggered manually or by a new commit.

4 - Infrastructure Destroy Workflow: This action will destroy the infrastructure created in point 1. This is manually triggered.


## Deploying the environment manually

### Install terraform 
Download the latest binary for your platform from [here](https://www.terraform.io/downloads.html)

On Debian \ Ubuntu:

```bash
sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_windows_amd64.zip
unzip terraform_1.1.9_windows_amd64.zip
sudo mv terraform /usr/local/bin/
```
### Install Azure CLI
Follow the instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

On Debian \ Ubuntu:

As described [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest): 
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Initialise terraform

### Authenticate using a service pricipal
Follow the instructions [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) to log in using the Azure CLI, create, and set the service prinicpal for Terraform to use.

### Set environment variables with your Service Principal's information
Create a copy of the `.env.template` file called `.env`. The `.env` file is ignored by git.

Follow the process described [here](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html#configuring-the-service-principal-in-terraform) to create your service principal, and get the required login values. 
Use those values to populate the following values used for authenticating the Service Principal in the `.env` file:

```bash
export ARM_CLIENT_ID="{appId}"
export ARM_CLIENT_SECRET="{password}"
export ARM_SUBSCRIPTION_ID="{subscriptionId}"
export ARM_TENANT_ID="{tenant}"
```

Load the values from the .env file using the command `source .env`. *This may not work in your setup, leading to issues applying the terraform template and logging in with the service principal. If so, you need to copy the contents of the .env file and execute it directly in your terminal.*

### Create a storage acount for the backend config if you have not done before
The `.env` file will set environment variables that determine the name of the resource group, the location, and the storage account used for saving Terraform state.
Note that storage account names need to be globally unique, so you will have to update the storage account name provided in the `.env.template` file. You can check whether a chosen name is available using the following command: 
```bash
az storage account check-name --name $TERRAFORM_SA
```

Create a resource group and storage account for storing the backend config using the following script:
```bash
az group create -n $RESOURCE_GROUP -l $LOCATION
az storage account create -n $TERRAFORM_SA -g $RESOURCE_GROUP --sku Standard_LRS
az storage container create --name $TERRAFORM_CONTAINER --account-name $TERRAFORM_SA
```

### Run Terraform
Download and configure the Terraform providers by running: 
```bash
terraform init -backend-config="storage_account_name=$TERRAFORM_SA" -backend-config="container_name=$TERRAFORM_CONTAINER" -backend-config="key=$ENVIRONMENT.terraform.tfstate" -backend-config="resource_group_name=$RESOURCE_GROUP"
```
These commands may take a while to respond - be patient.

Login so that external scripts can run using the Service Principal:
```bash
az login  --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```
Now deploy your environment by applying the terraform configuration. It will first generate an execution plan and ask for your approval to perform the actions.
```bash
terraform apply -var-file="vars/$ENVIRONMENT.tfvars" -var "project_name=$RESOURCE_GROUP"
```
After applying the terraform configuration successfully, you will see two outputs which will be used for testing.

You can get the application url by running following terraform command.
- `terraform output`

## To deploy the application refer to point 5 of the previous section