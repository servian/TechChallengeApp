resource "aws_ecs_task_definition" "techchallenge_taskdefinition" {
  family                   = "app-techchallenge-family"
  container_definitions    = <<DEFINITION
   [
    {
      "name": "app-techchallenge-family",
      "image": "${aws_ecr_repository.ecr_repo.repository_url}:latest",
      "essential": true,
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
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecstaskexecution_role.arn
}
