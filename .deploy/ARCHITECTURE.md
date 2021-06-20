# Architecture Overview

<!-- - Must document any pre-requisites clearly.
- Must be contained within a GitHub repository.
- Must deploy via an automated process.
- Must deploy infrastructure using code. -->

## Environment
In response to the assesment this application is deployed to a an Azure subscription with the following services:

- App Service 
  - Linux Container
- Azure PostreSQL DB
- Azure Monitor
  - Implements up\down scaling rules based
- Github Action for automated deployment

## Pre-requisites

- A Microsoft Azure subscription
- Terraform
  - v1.0.0 at the time of writing
  - azurerm provider version 2.64.0
  

## Infrastructure
Terraform is the chosen IAC provider to deploy the required infrastructure.


## Deployment
Assesment criteria:

     - Must be able to start from a cloned git repo.
     - Must deploy via an automated process.



