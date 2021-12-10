resource "aws_db_instance" "servian_db" {
  identifier = "app"
  allocated_storage = 5
  backup_retention_period = 4
  engine = "postgres"
  engine_version = "9.6.20"
  instance_class = "db.t2.micro"
  storage_type = "gp2"
  name = "app"
  username = "postgres"
  password = "changeme"
  db_subnet_group_name = aws_db_subnet_group.persistent_data.id
  vpc_security_group_ids = [aws_security_group.postgres_security_group.id]
  #parameter_group_name = "postgres9"
}

# resource "aws_db_parameter_group" "postgres_dbparam" {
#   name        = "postgres9"
#   family      = "postgres9"
#   description = "Parameter group for postgres9"

# }


resource "aws_ecs_service" "pg_service" {
  name            = "pgservice"
  cluster         = aws_ecs_cluster.servian_ecs_cluster.id
  task_definition = aws_ecs_task_definition.servian_task.arn
  launch_type     = "FARGATE"
  desired_count   = 3
  depends_on      = [aws_ecs_service.servian_ecs_service]

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.servian_task.family
    container_port   = 5432
  }

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.postgres_security_group.id]
  }
}



