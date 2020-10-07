terraform {
  backend "s3" {
    // replace the bucket name/dynamodb with whats been created in the local account.
    // terraform apply to create the state bucket and dynamodb available at location iac/terraform/aws-modules/services/state
    // please not this is a one time task
    bucket = "terraform-state-20201004050231181200000001"
    dynamodb_table = "terraform-state-lock"
    key    = "dev-env-sydney-1.tfstate"
    region = "ap-southeast-2"
  }
}



provider "aws" {
  region = "ap-southeast-2"
}

# VPC and network creation

module "vpc" {
  source = "../../aws-modules/services/network"

  name = "servian-tech-challenge"

  cidr = "20.10.0.0/16"

  azs                 = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets     = ["20.10.1.0/24", "20.10.2.0/24"]
  public_subnets      = ["20.10.11.0/24", "20.10.12.0/24"]
  database_subnets    = ["20.10.21.0/24", "20.10.22.0/24"]

  # No default NACL - each subnet groups have one each
  manage_default_network_acl = false


  # public subnet NACL
  public_inbound_acl_rules = [
    # Public NACL - allows port 80 from anywhere
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Public NACL - allows ephemeral ports traffic from anywhere
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  public_outbound_acl_rules = [
    # Public NACL - open up ephemeral ports
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  # private subnet NACL
  private_inbound_acl_rules = [
//      # Private NACL - allows traffic from VPC CIDR, its not internet connected
//        {
//          rule_number = 100
//          rule_action = "allow"
//          from_port   = 0
//          to_port     = 0
//          protocol    = "-1"
//          cidr_block  = "0.0.0.0/0"
//        },
    # Private NACL - allows traffic from public subnets, its not internet connected
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 3000
      to_port     = 3000
      protocol    = "-1"
      cidr_block  = "20.10.11.0/24"
    },
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 3000
      to_port     = 3000
      protocol    = "-1"
      cidr_block  = "20.10.12.0/24"
    },
    //open up 443
    {
      rule_number = 400
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
    //open up VPC CIDR
    {
      rule_number = 600
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "20.10.0.0/16"
    },
  ]

  private_outbound_acl_rules = [
    # Private NACL - open up all ports
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  # database subnet NACL
  database_inbound_acl_rules = [
    # Database NACL - allows traffic from private subnets, its not internet connected
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "-1"
      cidr_block  = "20.10.1.0/24"
    },
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "-1"
      cidr_block  = "20.10.2.0/24"
    },
  ]

  database_outbound_acl_rules = [
    # Database NACL - open up all ports
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  database_dedicated_network_acl = true
  private_dedicated_network_acl = true
  public_dedicated_network_acl = true

  tags = {
    Owner       = "user"
    Environment = "dev"
    Name        = "test1"
  }
}

# Database

module "db" {
  source = "../../aws-modules/services/database"

  identifier = "devdb-postgres"
  multi_az = false

  engine            = "postgres"
  engine_version    = "10.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  storage_encrypted = false

  name = "devdb"
  username = "devuser"

  // Any sensitive data in this file can be encypted using sops / AWS KMS keys
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "5432"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = module.vpc.database_subnets
  rds_vpc_id = module.vpc.vpc_id

  # DB parameter group
  family = "postgres10"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "devdb"

  # Database Deletion Protection
  deletion_protection = false
}

module "secrets" {
  source =  "../../aws-modules/services/secrets"

  name = "servian-tech-challenge"
  application_secrets =  {
    "VTT_DBUSER" = "devuser",
    "VTT_DBPASSWORD"  = "YourPwdShouldBeLongAndSecure!"
  }
}

locals {
  props =   {
    "VTT_DBNAME" = "devdb",
    "VTT_DBPORT" = tostring(module.db.this_db_instance_port),
    "VTT_DBHOST" =  module.db.this_db_instance_address,
    "VTT_LISTENHOST" = "localhost",
    "VTT_LISTENPORT" = "3000"
  }

  props_map = [for secretKey in keys(local.props) : {
    name      = secretKey
    value = lookup(local.props, secretKey)
  }
  ]
}

module "compute" {
  source  =  "../../aws-modules/services/compute"

  app_image = var.app_image
  aws_vpc_id = module.vpc.vpc_id

  aws_private_subnet_ids = module.vpc.private_subnets
  aws_public_subnet_ids = module.vpc.public_subnets

  container_secrets = module.secrets.secrets_map
  container_environment = local.props_map
  container_secrets_arns = module.secrets.application_secrets_arns

  create_dns_subdomain = false
  create_dns_record = false

  db_port = module.db.this_db_instance_port
  db_security_groups = module.db.this_db_security_group_ids

  app_command = var.app_command
  app_count = var.app_count

  name = "servian-tech-challenge"

}





