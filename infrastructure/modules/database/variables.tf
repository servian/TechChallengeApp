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

variable "allocated_storage" {
  description = "Storage space for the DB"
  type        = number
}

variable "storage_type" {
  description = "Storage type for the RDS"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
}

variable "engine_version" {
  description = "Engine version the DB"
  type        = string
}

variable "multi_az" {
  description = "Whether Multi AZ should be enabled for DB?"
  type        = bool
}

variable "instance_class" {
  description = "Instance class for the RDS"
  type        = string
}

variable "name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35"
  type        = number
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
}

variable "allowed_security_groups" {
  description = "ID of the allowed Security Groups for Security Group"
  type        = list(string)
}

variable "subnet_group" {
  description = "Subnet group for the RDS"
  type        = list(string)
}
