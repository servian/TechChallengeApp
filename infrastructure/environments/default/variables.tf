variable "aws_region" {
  description = "AWS region where all the resources are created."
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
  default     = "default"
}
