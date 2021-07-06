variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS"
  type        = string
}

variable "asg_subnet_ids" {
  description = "Private subnet ids for the ASG"
  type        = list(string)
}

variable "alb_subnets_ids" {
  description = "Subnets to deploy ALB"
  type        = list(string)
}

variable "db_user" {
  description = "Username for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "DB port for Postgres"
  type        = number
}

variable "db_name" {
  description = "Master database of Postgres"
  type        = string
}

variable "db_host" {
  description = "DB host address"
  type        = string
}

variable "aws_key_name" {
  description = "AWS Key name to SSH into EC2"
  type        = string
}

variable "listen_host" {
  description = "Servian Tech Challenge App listen host"
  type        = string
  default     = "0.0.0.0"
}

variable "listen_port" {
  description = "Servian Tech Challenge App listen port"
  type        = number
}

variable "latest_app_package_path" {
  description = "App latest package link"
  type        = string
}

variable "app_ami" {
  description = "AMI for the Launch Configuration"
  type        = string
}

variable "app_instance_type" {
  description = "Amazon Linux 2 AMI in ap-southeast-2 region"
  type        = string
  default     = "t2.micro"
}

variable "asg_health_check_type" {
  description = "ASG health check type"
  type        = string
  default     = "ELB"
}

variable "asg_min_size" {
  description = "Minimum number of instances running in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances running in ASG"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Desired number of instances running in ASG"
  type        = number
  default     = 2
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection or not"
  type        = bool
  default     = false
}

variable "stickiness_enabled" {
  description = "Whether ALB stickiness enabled"
  type        = bool
  default     = true
}

variable "health_check_protocol" {
  description = "Helath Check protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Helath Check path"
  type        = string
  default     = "/healthcheck/"
}

variable "healthy_threshold" {
  description = "Helath Check healthy threshold"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Helath Check unhealthy threshold"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Helath Check timeout"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Helath Check interval"
  type        = number
  default     = 10
}
