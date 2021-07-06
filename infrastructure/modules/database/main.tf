locals {
  prefix = "${var.project}_${var.environment}"
}

# Create backend RDS Security Group

resource "aws_security_group" "servian_tc_backend_sg" {
  name   = "${local.prefix}_Backend_SG"
  vpc_id = var.vpc_id

  tags = {
    Name        = "${local.prefix}_Backend_SG"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create Security Group rules associate to the Security Group

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.servian_tc_backend_sg.id
}

# Create Servian TC Database Subnet Group

resource "aws_db_subnet_group" "servian_tc_db_subnet_group" {
  name       = "${local.prefix}_db_subnet_group"
  subnet_ids = var.subnet_group

  tags = {
    Name        = "${local.prefix}_DB_SG"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Generate a random string for DB master password
resource "random_password" "servian_tc_db_master_pass" {
  length           = 15
  special          = true
  min_special      = 1
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  override_special = "%^&*()-_=+[]{}<>:?"
  keepers = {
    pass_version = 1
  }
}

# Create Postgres database RDS instance 

resource "aws_db_instance" "servian_tc_db" {
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  multi_az                = var.multi_az
  instance_class          = var.instance_class
  name                    = var.name
  username                = var.db_user
  password                = random_password.servian_tc_db_master_pass.result
  identifier              = var.identifier
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  port                    = var.db_port
  storage_encrypted       = var.storage_encrypted
  db_subnet_group_name    = aws_db_subnet_group.servian_tc_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.servian_tc_backend_sg.id]
  tags = {
    Name        = "${local.prefix}_Database"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Store the DB credentials in AWS SSM Parameter Store for future references

# This secret parameter is not secured with a KMS key to reduce complexity of implementation.
# To secure it, add a key_id argument and pass the KMS key 
resource "aws_ssm_parameter" "servian_tc_db_password" {
  name        = "/${var.environment}/postgres/master/password"
  description = "The password for the DB master user"
  type        = "SecureString"
  value       = random_password.servian_tc_db_master_pass.result

  tags = {
    Name        = "${local.prefix}_SSM"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Store the DB master user
resource "aws_ssm_parameter" "servian_tc_db_user" {
  name  = "/${var.environment}/postgres/master/user"
  type  = "String"
  value = var.db_user
}

# Store the master DB name
resource "aws_ssm_parameter" "servian_tc_db_name" {
  name  = "/${var.environment}/postgres/master/db_name"
  type  = "String"
  value = var.name
}
