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

    container_definitions = <<EOT
[
    {
        "name": "servian_service_family",
        "image": "525864815479.dkr.ecr.ap-southeast-1.amazonaws.com/ecr_servian:latest",
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
                "value": "app.cur2pbgaqj0u.ap-southeast-1.rds.amazonaws.com" 
            },
            {
                "name": "VTT_DBPASSWORD",
                "value": "changeme" 
            },
            {
                "name": "VTT_DBNAME",
                "value": "app" 
            }
        ],
        
        "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "servian",
                    "awslogs-region": "ap-southeast-1",
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
    desired_count = 1

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

