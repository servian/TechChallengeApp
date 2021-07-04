variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDS to host bastion host."
  type        = list(string)
}

variable "key_name" {
  description = "name AWS key to login to instance"
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
  default     = "0.0.0.0"
}

variable "listen_port" {
  description = "App listen port"
  type        = number
  default     = 3000
}

variable "latest_app_package_path" {
  description = "App latest package link"
  type        = string
  default     = "https://github.com/servian/TechChallengeApp/releases/download/v.0.8.0/TechChallengeApp_v.0.8.0_linux64.zip"
}

variable "bastion_ami" {
  description = "AMI for the bastion"
  type        = string
  default     = "ami-05064bb33b40c33a2"
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "Whether to associate public IP address to the instance"
  type        = bool
  default     = true
}


