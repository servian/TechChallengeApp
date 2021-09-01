provider "aws" {
  region      = "us-east-1"
}
terraform {
  required_providers {
    aws       = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }
  }
  backend "s3" {
    bucket    = "app-project-tf-state"
    key       = "techchallenge.tfstate"
    region    = "us-east-1"
  }
}

#userdata script 
locals {
  user_data = <<-EOT
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install apache2 -y
  sudo apt-get install docker.io -y
  sudo service apache2 start
  sudo service docker start
  sudo chkconfig apache2 on
  sudo chkconfig docker on
  EOT
}

#VPC module
module "techchallenge-vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "3.6.0"
  name                         = "techchallenge-vpc"
  cidr                         = "10.0.0.0/16"
  azs                          = ["us-east-1a", "us-east-1b"]
  public_subnets               = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets             = ["10.0.10.0/24", "10.0.20.0/24"]
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  tags                         = {  
    Terraform                  = "true"
    Function                   = "VPC"
  }
}