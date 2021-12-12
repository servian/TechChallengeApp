resource "aws_db_instance" "servian_db" {
  identifier = "app"
  allocated_storage = 5
  backup_retention_period = 4
  engine = "postgres"
  engine_version = "9.6.20"
  instance_class = "db.t2.micro"
  storage_type = "gp2"
  name = "app"
  username= var.VTT_DBUSER
  password= var.VTT_DBPASSWORD
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.id
  vpc_security_group_ids = [aws_security_group.postgres_security_group.id]
}

data "aws_db_instance" "servian_db" {
  db_instance_identifier = "app"
  depends_on = [
    aws_db_instance.servian_db
  ]
}



