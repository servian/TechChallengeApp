resource "aws_ecs_task_definition" "ecstask_definition_techchallenge" {
  family                   = var.tag_prefix
  container_definitions    = <<DEFINITION
   [
    {
      "name": "${var.tag_prefix}",
      "image": "${aws_ecr_repository.ecr_repo.repository_url}:latest",
      "essential": true,
      "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
                    "awslogs-region": "ap-southeast-2",
                    "awslogs-create-group": "true",
                    "awslogs-stream-prefix": "techchallenge"
                }
            },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecstask_executionrole.arn
  depends_on = [
    aws_cloudwatch_log_group.cloudwatch_log_group
  ]
}

