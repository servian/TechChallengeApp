variable "aws_region" {
  description = "AWS region where all the resources are created."
  type        = string
}

variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
}

variable "aws_key_name" {
  description = "This is the name of the key to login to bastion."
  type        = string
  default     = "servian_tc_admin_key"
}

variable "app_port" {
  description = "Application listening port"
  type        = number
  default     = 3000

}

variable "app_package_link" {
  description = "Link to the Servian Tech Challenge app package"
  type        = string
}

variable "db_name" {
  description = "Name of the master database"
  type        = string
}

variable "db_user" {
  description = "Username for the master DB user"
  type        = string
  sensitive   = true
}
