# IAM

resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_ecs ? 1 : 0

  name = format("%s-ecsTaskExecutionRole", var.name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = merge(
  {
    "Name" = format("%s-ecsTaskExecutionRole", var.name)
  },
  var.tags,
  )
}

resource "aws_iam_role" "ecs_task_role" {
  count = var.create_ecs ? 1 : 0

  name = format("%s-ecsTaskRole", var.name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = merge(
  {
    "Name" = format("%s-ecsTaskRole", var.name)
  },
  var.tags,
  )
}

resource "aws_iam_policy" "secrets" {
  count = var.create_ecs ? 1 : 0

  name        = format("%s-task-policy-secrets", var.name)
  description = "Policy that allows access to the secrets we created"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AccessSecrets",
            "Effect": "Allow",
            "Action": [
              "secretsmanager:GetSecretValue"
            ],
            "Resource": ${jsonencode(var.container_secrets_arns)}
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  count = var.create_ecs ? 1 : 0

  role       = element(aws_iam_role.ecs_task_execution_role.*.name,0)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment-for-secrets" {
  count = var.create_ecs ? 1 : 0

  role       = element(aws_iam_role.ecs_task_execution_role.*.name,0)
  policy_arn = element(aws_iam_policy.secrets.*.arn,0)
}

resource "aws_cloudwatch_log_group" "main" {
  count = var.create_ecs ? 1 : 0

  name = "/ecs/${var.name}-task"

  tags = merge(
  {
    "Name" = format("%s-task", var.name)
  },
  var.tags,
  )
}

# ALB Security group
# This is the group you need to edit if you want to restrict access to the application
resource "aws_security_group" "lb" {
  count = var.create_ecs && var.create_alb  ? 1 : 0

  description = "controls access to the ALB"
  vpc_id      =  var.aws_vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  {
    "Name" = format("%s-${var.app_security_group_suffix}", var.name)
  },
  var.tags,
  )
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  count = var.create_ecs  && var.create_alb ? 1 : 0

  description = "allow inbound access from the ALB only"
  vpc_id      = var.aws_vpc_id

  ingress {
    protocol        = "tcp"
    from_port       =  var.app_port
    to_port         =  var.app_port
    //security_groups = [element(aws_security_group.lb.*.id,0)]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  {
    "Name" = format("%s-${var.ecs_security_group_suffix}", var.name)
  },
  var.tags,
  )

}

//Add a rule to allow traffic to the database from the containers

resource "aws_security_group_rule" "this" {
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  source_security_group_id = element(aws_security_group.ecs_tasks.*.id,0)
  // TO DO added to any of the database security groups currently, this behaviour can be changed if any issues
  security_group_id = element(var.db_security_groups,0)
}

### ALB

resource "aws_alb" "this" {
  count = var.create_ecs  && var.create_alb ? 1 : 0

  subnets         = var.aws_public_subnet_ids
  security_groups = [element(aws_security_group.lb.*.id,0)]

  tags = merge(
  {
    "Name" = format("%s-${var.alb_suffix}", var.name)
  },
  var.tags,
  )
}

resource "aws_alb_target_group" "app" {
  count = var.create_ecs  && var.create_alb ? 1 : 0

  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_id
  target_type = "ip"

  health_check {
    enabled = true
    path = "/healthcheck/"
  }

  tags = merge(
  {
    "Name" = format("%s-${var.alb_target_group_suffix}", var.name)
  },
  var.tags,
  )

}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  count = var.create_http_listener && var.create_ecs  && var.create_alb ? 1 : 0

  load_balancer_arn = element(aws_alb.this.*.id,0)
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = element(aws_alb_target_group.app.*.id,0)
    type             = "forward"
  }

}

### ECS

// read the provider information from the aws provider
data "aws_region" "current" {}

resource "aws_ecs_cluster" "this" {
  count = var.create_ecs ? 1 : 0

  name =  format("%s-ecs", var.name)

  tags =  var.tags

}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = format("%s-agent", var.name)
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = format("%s-agent-profile", var.name)
  role = aws_iam_role.ecs_agent.name
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-040bd2e2325535b3d"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = aws_security_group.ecs_tasks.*.id
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${format("%s-ecs", var.name)} >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
}

resource "aws_ecs_task_definition" "this" {
  count = var.create_ecs ? 1 : 0

  family                   =  format("%s-task", var.name)
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = element(aws_iam_role.ecs_task_execution_role.*.arn,0)
  task_role_arn            = element(aws_iam_role.ecs_task_role.*.arn,0)

  container_definitions = jsonencode([{

    name        =  format("%s-container", var.name)
    image       = var.app_image
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.app_port
      hostPort      = var.app_port
    }]

    command = var.app_command

    logConfiguration = {
      logDriver="awslogs",
      "options": {
        "awslogs-group": element(aws_cloudwatch_log_group.main.*.name,0),
        "awslogs-stream-prefix": "ecs",
        "awslogs-region": data.aws_region.current.name
      }
    }

    environment = var.container_environment
    secrets = var.container_secrets
  }
  ])

  tags = merge(
  {
    "Name" = format("%s-${var.ecs_cluster_suffix}", var.name)
  },
  var.tags,
  )

}

resource "aws_ecs_service" "this" {
  count = var.create_ecs ? 1 : 0

  name            = "tf-ecs-service"
  cluster         = element(aws_ecs_cluster.this.*.id,0)
  task_definition = element(aws_ecs_task_definition.this.*.arn,0)
  desired_count   = var.app_count
  launch_type     = "EC2"
  scheduling_strategy = "REPLICA"

//  placement_strategy {
//    type = "spread"
//    field = "attribute:ecs.availability-zone"
//  }

  network_configuration {
    security_groups = aws_security_group.ecs_tasks.*.id
    subnets         = var.aws_private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = element(aws_alb_target_group.app.*.id,0)
    container_name   = format("%s-container", var.name)
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.front_end
  ]

//  tags = merge(
//  {
//    "Name" = format("%s-${var.ecs_service_suffix}", var.name)
//  },
//  var.tags,
//  )

}

// Setup Autoscaling

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = format("%s-asg", var.name)
  vpc_zone_identifier       = var.aws_private_subnet_ids
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = var.ec2_desired_capacity
  termination_policies      = ["OldestLaunchConfiguration", "Default"]
  min_size                  = var.ec2_min_size
  max_size                  = var.ec2_max_size
  enabled_metrics           = var.ec2_enabled_metrics

  health_check_type         = "EC2"
}

resource "aws_appautoscaling_target" "ecs_target" {
  count = var.create_ecs && var.create_autoscaling_app ? 1 : 0

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${element(aws_ecs_cluster.this.*.name,0)}/${element(aws_ecs_service.this.*.name,0)}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count = var.create_ecs && var.create_autoscaling_app ? 1 : 0

  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = element(aws_appautoscaling_target.ecs_target.*.resource_id,0)
  scalable_dimension = element(aws_appautoscaling_target.ecs_target.*.scalable_dimension,0)
  service_namespace  = element(aws_appautoscaling_target.ecs_target.*.service_namespace,0)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.scale_memory_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count = var.create_ecs && var.create_autoscaling_app ? 1 : 0

  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = element(aws_appautoscaling_target.ecs_target.*.resource_id,0)
  scalable_dimension = element(aws_appautoscaling_target.ecs_target.*.scalable_dimension,0)
  service_namespace  = element(aws_appautoscaling_target.ecs_target.*.service_namespace,0)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.scale_cpu_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

// Create the new zone

resource "aws_route53_zone" "subdomain" {
  count = var.create_dns_subdomain ? 1 : 0

  name = var.domain

  tags = merge(
  {
    "Name" = format("%s-${var.ecs_service_suffix}", var.name)
  },
  var.tags,
  )
}

resource "aws_route53_record" "record" {
  count = var.create_dns_record && var.create_dns_subdomain ? 1 : 0

  name = format("${var.name}.%s", var.domain)
  type = "A"
  zone_id = element(aws_route53_zone.subdomain.*.zone_id,0)
  alias {
    evaluate_target_health = false
    name = element(aws_alb.this.*.dns_name,0)
    zone_id = element(aws_alb.this.*.zone_id,0)
  }
}
