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

#ASG module
module "techchallenge-asg" {   
  source                       = "terraform-aws-modules/autoscaling/aws"
  version                      = "~> 4.0"
  name                         = "techchallenge-asg"
  min_size                     = 1
  max_size                     = 1
  desired_capacity             = 1
  wait_for_capacity_timeout    = 0
  health_check_type            = "EC2"
  vpc_zone_identifier          = module.techchallenge-vpc.public_subnets
  initial_lifecycle_hooks      = [
    {
      name                     = "StartupLifeCycleHook"
      default_result           = "CONTINUE"
      heartbeat_timeout        = 60
      lifecycle_transition     = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata    = jsonencode({ "hello" = "world" })
    },
    {
      name                     = "TerminationLifeCycleHook"
      default_result           = "CONTINUE"
      heartbeat_timeout        = 180
      lifecycle_transition     = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata    = jsonencode({ "goodbye" = "world" })
    }
  ]
  instance_refresh             = {
    strategy                   = "Rolling"
    preferences                = {
      min_healthy_percentage   = 50
    }
    triggers                   = ["tag"]
  }

  lt_name                      = "techchallenge-lt"
  description                  = "Launch template"
  update_default_version       = true
  use_lt                       = true
  create_lt                    = true
  image_id                     = "ami-09e67e426f25ce0d7"
  instance_type                = "t3.micro"
  key_name                     = "app-project-kp"
  user_data_base64             = base64encode(local.user_data)
  ebs_optimized                = true
  enable_monitoring            = true
  disable_api_termination      = true
  target_group_arns            = module.techchallenge-alb.target_group_arns

  network_interfaces           = [
    {
      delete_on_termination    = true
      description              = "eth0"
      device_index             = 0
      security_groups          = [module.techchallenge-ssh-sg.security_group_id, module.techchallenge-http-sg.security_group_id]
    }
  ]
  placement                    = {
    availability_zone          = "us-east-1a"
  }

  tags = [
    {
      key                      = "Terraform"
      value                    = "true"
      propagate_at_launch      = true
    },
    {
      key                      = "Function"
      value                    = "Web Server"
      propagate_at_launch      = true
    },
  ]
}


#RDS module
module "techchallenge-rds" {
  source                       = "terraform-aws-modules/rds/aws"
  version                      = "3.3.0"
  identifier                   = "techchallenge-rds"
  engine                       = "postgres"
  engine_version               = "10.15"
  family                       = "postgres10"
  major_engine_version         = "10"        
  instance_class               = "db.t2.micro"
  allocated_storage            = 10
  name                         = "app"
  username                     = "postgres"
  password                     = "changeme"
  port                         = 5432
  subnet_ids                   = module.techchallenge-vpc.database_subnets
  vpc_security_group_ids       = [module.techchallenge-db-sg.security_group_id]
  publicly_accessible          = false
}

module "techchallenge-http-sg" {
  source                       = "terraform-aws-modules/security-group/aws"
  version                      = "4.3.0"
  name                         = "techchallenge-http-sg"
  description                  = "HTTP access to EC2 instance."
  vpc_id                       = module.techchallenge-vpc.vpc_id
  ingress_cidr_blocks          = ["0.0.0.0/0"]
  ingress_rules                = ["http-80-tcp", "all-icmp"]
  egress_rules                 = ["all-all"]
}

module "techchallenge-ssh-sg" {
  source                       = "terraform-aws-modules/security-group/aws"
  version                      = "4.3.0"
  name                         = "techchallenge-ssh-sg"
  description                  = "SSH access to EC2 instance."
  vpc_id                       = module.techchallenge-vpc.vpc_id
  ingress_cidr_blocks          = ["121.7.236.104/32"]
  ingress_rules                = ["ssh-tcp"]
  egress_rules                 = ["all-all"]
}

module "techchallenge-db-sg" {
  source                       = "terraform-aws-modules/security-group/aws"
  version                      = "4.3.0"
  name                         = "techchallenge-db-sg"
  description                  = "Access to DB server."
  vpc_id                       = module.techchallenge-vpc.vpc_id
  ingress_cidr_blocks          = ["10.0.0.0/16"]
  ingress_rules                = ["postgresql-tcp"]
  egress_rules                 = ["all-all"]
}