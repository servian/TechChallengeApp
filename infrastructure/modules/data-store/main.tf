# CREATE backend RDS SECURITY GROUP

resource "aws_security_group" "servian_tc_backend_sg" {
  name = "Servian TC backend Security Group"
  vpc_id = aws_vpc.servian_tc_vpc.id
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      aws_security_group.servian_tc_asg_sg.id
    ]
  }

  # Bastion host will perform the DB import
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      aws_security_group.servian_tc_bastion_sg.id
    ]
  }
  tags = {
    Name        = "Servian TC Backend Security Group"
    Terraform   = "True"
  }
}

# Create Servian TC Database Subnet Group

resource "aws_db_subnet_group" "servian_tc_db_subnet_group" {
  name = "servian_tc_db_subnet_group"
  subnet_ids = [
    aws_subnet.servian_tc_private_2a.id,
    aws_subnet.servian_tc_private_2b.id
    ]

  tags = {
    Name        = "Sevian TC DB Subnet Group"
    Terraform   = "True"
  }
}

# Create DFSC Database Instance 

resource "aws_db_instance" "servian_tc_db" {
  allocated_storage       = "20"
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "12.5"
  multi_az                = "false"
  # multi_az                = "true"
  instance_class          = "db.t2.micro"
  name                    = "postgres"
  username                = "postgres"
  password                = var.db_master_password
  identifier              = "servian-tc-db"
  skip_final_snapshot     = "true"
  backup_retention_period = "7"
  port                    = "5432"
  storage_encrypted       = "false"
  db_subnet_group_name    = aws_db_subnet_group.servian_tc_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.servian_tc_backend_sg.id]
   tags = {
    Name        = "Servian TC Database"
    Terraform   = "True"
  }
}