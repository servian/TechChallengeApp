variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_vpc_id" {
  description = "Vpc id to create the ecs resources"
  type        = string
}

variable "aws_public_subnet_ids" {
  description = "A list of public subnet ids in the vpc"
  type        = list(string)
}

variable "aws_private_subnet_ids" {
  description = "A list of private subnet ids in the vpc"
  type        = list(string)
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "app_command" {
  description = "Command to be executed in the running container"
  type = list(string)
  default   = [ "serve" ]
}

variable "db_migration_command" {
  description = "Command to be executed in the running container"
  type = list(string)
  default   = [ "updatedb", "-s" ]
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "app_security_group_suffix" {
  description = "Suffix to append to application security group name"
  type        = string
  default     = "db"
}

variable "ecs_security_group_suffix" {
  description = "Suffix to append to ecs security group name"
  type        = string
  default     = "db"
}

variable "alb_suffix" {
  description = "Suffix to append to alb name"
  type        = string
  default     = "db"
}

variable "alb_target_group_suffix" {
  description = "Suffix to append to alb target group name"
  type        = string
  default     = "db"
}

variable "ecs_cluster_suffix" {
  description = "Suffix to append to ecs cluster name"
  type        = string
  default     = "db"
}

variable "ecs_service_suffix" {
  description = "Suffix to append to ecs service name"
  type        = string
  default     = "db"
}

variable "create_http_listener" {
  description = "Controls if HTTP listener is created for the alb"
  type        = bool
  default     = true
}

variable "create_ecs" {
  description = "Controls if ECS cluster is created (affects most of the resources)"
  type        = bool
  default     = true
}

variable "create_alb" {
  description = "Controls if alb is created (affects most of the resources)"
  type        = bool
  default     = true
}

variable "create_dns_subdomain" {
  description = "Controls if route53 subdomain and record is created"
  type        = bool
  default     = true
}

variable "create_dns_record" {
  description = "Controls if route53 subdomain and record is created"
  type        = bool
  default     = true
}

variable "domain" {
  description = "Domain name for the route53 entry"
  type        = string
  default     = ""
}

variable "create_autoscaling_app" {
  description = "Controls if autoscaling mechanism is created"
  type        = bool
  default     = true
}

variable "max_capacity" {
  description = "App autoscaling max capacity"
  default     = 10
}

variable "min_capacity" {
  description = "App autoscaling min capacity"
  default     = 1
}

variable "scale_cpu_target" {
  description = "Autoscaling CPU target"
  default     = 80
}

variable "scale_memory_target" {
  description = "Autoscaling memory target"
  default     = 60
}

// Application configuration

variable "container_environment" {
  description = "The container environmnent variables"
}

variable "container_secrets" {
  description = "The container secret environmnent variables"

}

variable "container_secrets_arns" {
  description = "ARN for secrets"
}

// db parameters

variable "db_port" {
  description = "Database port for the containers to connect"
  type = string
}

variable "db_security_groups" {
  description = "Database security group for the containers to connect"
  type = list(string)
}

variable "ec2_enabled_metrics" {
  type = list(string)

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

}

variable "ec2_desired_capacity" {
  default = "1"
}

variable "ec2_min_size" {
  default = "1"
}

variable "ec2_max_size" {
  default = "1"
}
//
//variable "db_name" {
//  description = "Database name for the containers to connect"
//  type = string
//}
//
//variable "db_port" {
//  description = "Database port for the containers to connect"
//  type = string
//}
//
//variable "db_host" {
//  description = "Database host name for the containers to connect"
//  type = string
//}
//
//variable "app_host_interface" {
//  description = "Interfaces the application listens"
//  type = string
//  default = "0.0.0.0"
//}
//
//// database secrets (arn of the secretsmanager resources)
//
//variable "db_username_arn" {
//  description = "Secrets manager arn for the database user"
//  type = string
//}
//
//variable "db_password_arn" {
//  description = "Secrets manager arn for the database password"
//  type = string
//}






