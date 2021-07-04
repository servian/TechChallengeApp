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

variable "bastion_ami" {
  description = "AMI for the bastion"
  type        = string
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
}

variable "db_user" {
  description = "Username for the master DB user"
  type        = string
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

variable "aws_key_pair" {
  description = "name AWS key to login to instance"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate public IP address to the instance"
  type        = bool
}

variable "public_subnet_ids" {
  description = "Public subnet IDS to host bastion host."
  type        = list(string)
}
