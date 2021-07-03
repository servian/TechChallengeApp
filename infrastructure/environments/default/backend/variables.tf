variable "environment" {
  description = "Environment for the application such as prod, staging, dev etc."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the backend"
  type        = string
}

variable "db_user" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
  default     = "postgres"
}

variable "db_port" {
  description = "DB port for Postgres"
  type        = number
  default     = 5432
}

variable "allocated_storage" {
  description = "Storage space for the DB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for the RDS"
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version the DB"
  type        = string
  default     = "12.5"
}

# To be enabled
variable "multi_az" {
  description = "Whether Multi AZ should be enabled for DB?"
  type        = bool
  default     = false
}

variable "instance_class" {
  description = "Instance class for the RDS"
  type        = string
  default     = "db.t2.micro"
}

variable "name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "postgres"
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "servian-tc-db"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true

}

variable "backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35"
  type        = number
  default     = 7
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "allowed_security_groups" {
  description = "ID of the allowed Security Groups for Security Group"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# TODO: To be replaced by subnets
variable "private_subnet_ids" {
  description = "Private Subnet IDs for RDS"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

