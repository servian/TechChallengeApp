variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS Deployment Region"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
  description = "AZs to deploy subnets to"
}