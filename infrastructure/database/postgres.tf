

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
  db_subnet_group_name    = var.TF_DBSUBNETGROUP
  tags = {
    Name = "${var.tag_prefix}-postgres"
  }
}

variable "TF_DBUSER" {
}


output "db_instance" {
  value = aws_db_instance.postgres_instance.address
}

variable "TF_DBPASSWORD" {
}

variable "TF_DBSUBNETGROUP" {
}

variable "tag_prefix" {
}

