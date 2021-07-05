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

variable "aws_key_name" {
  description = "name AWS key to login to instance"
  type        = string
}

variable "bastion_ami" {
  description = "AMI for the bastion"
  type        = string
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


