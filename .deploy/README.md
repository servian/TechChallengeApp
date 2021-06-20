# Deployment

## Pre-requisites

- An Azure subscription
- Terraform
  - v1.0.0 at the time of writing
  - azurerm provider version 2.64.0
- (optional) Visual Studio Code

Azure cloud shell has terraform pre-installed, making it a great way to quickly launch this deployment from a cloned copy of this repository.
 
 # Architecture 

 See the [Architecture documentation](./ARCHITECTURE.md) for an overview of what will be deployed.


# Instructions

From a locally cloned repository

```
cd .deploy/.azure
terraform init
terraform apply -var 'resourceGroupName=rg-servian-tca' 