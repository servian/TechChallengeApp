# Architecture Overview

## Environment

In response to the assesment this application is deployed to a an Azure subscription with the following services:

- App Service
  - Linux Container
- Azure PostreSQL DB
- Azure Monitor
  - Implements up\down scaling rules based on Host CPU or Memory usage, to a Max of 4 instances

## Infrastructure

Terraform is the chosen IAC provider to deploy the required infrastructure.
