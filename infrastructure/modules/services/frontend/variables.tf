variable "project" {
  description = "This is a prefix given to all resources and tags to identify that they belong to Servian Tech Challenge project"
  type        = string
  default     = "servian_tc"
}
variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS"
  type        = string
}

variable "app_ami" {
  description = "AMI for the Launch Configuration"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for app"
  type        = string
}

variable "db_user" {
  description = "Username for the master DB user"
  type        = string
  sensitive = true
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

variable "listen_host" {
  description = "App listen host"
  type        = string
}

variable "listen_port" {
  description = "App listen port"
  type        = number
}

variable "latest_app_package_path" {
  description = "App latest package link"
  type        = string
}

variable "asg_health_check_type" {
  description = "ASG health check type"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances running in ASG"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances running in ASG"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances running in ASG"
  type        = number
}

variable "asg_subnet_ids" {
  description = "Private subnet ids for the ASG"
  type        = list(string)
}

variable "alb_subnets_ids" {
  description = "Subnets to deploy ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection or not"
  type        = bool
}

variable "stickiness_enabled" {
  description = "Whether ALB stickiness enabled"
  type        = bool
}

variable "health_check_protocol" {
  description = "Helath Check protocol"
  type        = string
}

variable "health_check_path" {
  description = "Helath Check path"
  type        = string
}

variable "healthy_threshold" {
  description = "Helath Check healthy threshold"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Helath Check unhealthy threshold"
  type        = number
}

variable "health_check_timeout" {
  description = "Helath Check timeout"
  type        = number
}

variable "health_check_interval" {
  description = "Helath Check interval"
  type        = number
}

variable "aws_key_name" {
  description = "name AWS key to login to instance"
  type        = string
}
