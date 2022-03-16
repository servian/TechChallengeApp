resource "aws_db_instance" "postgres_instance" {
  allocated_storage       = 5
  engine                  = "postgres"
  identifier              = "postgres-db"
  engine_version          = "13.4"
  instance_class          = "db.t3.micro"
  name                    = "techChallangedb"
  multi_az                = false
  storage_type            = "gp2"
  backup_retention_period = 1
  username                = var.TF_DBUSER
  availability_zone       = "ap-southeast-2a"
  deletion_protection     = false
  password                = var.TF_DBPASSWORD
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.postgres_securitygroup.id]
  db_subnet_group_name    = var.TF_DBSUBNETGROUP
  tags = {
    Name = "${var.tag_prefix}-postgres"
  }
}

resource "aws_security_group" "postgres_securitygroup" {
  name        = "securitygroup-postgres"
  description = "Allow database connections on port 5432" 
  vpc_id      = var.vpc_id  #Attached to Application VPC 

  ingress = [
    {
      description      = "port 5432 postgres"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      security_groups  = [var.securitygroup_id] #Application VPC SG communicate to database on port 5432
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }
  ]  

  egress = [
    {
      description      = "Allow All Outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  
  tags = {
    Name = "${var.tag_prefix}-postgres"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}