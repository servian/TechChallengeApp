resource "aws_ecs_service" "techchallenge_svc" {
  name            = "${var.tag_prefix}-svc"
  task_definition = aws_ecs_task_definition.ecstask_definition_techchallenge.arn
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = var.loadbalancer_tg_arn
    container_name   = aws_ecs_task_definition.ecstask_definition_techchallenge.family
    container_port   = 3000
  }

  network_configuration {
    subnets          = [var.private_subnet_a_id, var.private_subnet_b_id]
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_security_group.id]
  }

}
