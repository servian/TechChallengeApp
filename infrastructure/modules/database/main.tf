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
  password                = var.db_password
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
