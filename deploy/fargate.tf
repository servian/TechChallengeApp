resource "aws_ecs_task_definition" "servian_task" {
    family = "servian_service_family"

    // Fargate is a type of ECS that requires awsvpc network_mode
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"

    // Valid sizes are shown here: https://aws.amazon.com/fargate/pricing/
    memory = "512"
    cpu = "256"

    // Fargate requires task definitions to have an execution role ARN to support ECR images
    execution_role_arn = "${aws_iam_role.ecs_role.arn}"

    depends_on = [aws_db_instance.servian_db, aws_ecr_repository.ecr_repo]

    container_definitions = <<EOT
[
    {
        "name": "servian_service_family",
        "image": "${data.aws_ecr_repository.ecr_repo.repository_url}",
        "memory": 512,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000
            },
            {
                "containerPort": 5432,
                "hostPort": 5432

            }
        ],
        "environment": [
            {
                "name": "VTT_DBHOST",
                "value": "${data.aws_db_instance.servian_db.address}"
            },
            {
                "name": "VTT_DBNAME",
                "value": "${var.VTT_DBNAME}"
            },
            {   
                "name": "VTT_DBPASSWORD",
                "value": "${var.VTT_DBPASSWORD}"
            }
        ],       
        
        "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "servian",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-create-group": "true",
                    "awslogs-stream-prefix": "servian"
            }
        }
    }
]
EOT
}

resource "aws_ecs_cluster" "servian_ecs_cluster" {
    name = "servian_ecs_cluster"
}

resource "aws_ecs_service" "servian_ecs_service" {
    name = "servian_ecs_service"

    cluster = "${aws_ecs_cluster.servian_ecs_cluster.id}"
    task_definition = "${aws_ecs_task_definition.servian_task.arn}"

    launch_type = "FARGATE"
    desired_count = 2

    network_configuration {
        subnets = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}"]
        security_groups = ["${aws_security_group.servian_security_group.id}"]
        assign_public_ip = true
    }

    load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.servian_task.family
    container_port   = 3000
  }

}

