variable "aws_region" {
  default     = "ap-southeast-1"
  description = "Which region should the resources be deployed into?"
}

variable "VTT_DBNAME" {
  description = "The name of the postgres db"
  type        = string
  default     = "postgres"
}

variable "VTT_DBUSER" {
  description = "The username for the DB master user"
  type        = string
  default     = "postgres"
}
variable "VTT_DBPASSWORD" {
  description = "The password for the DB master user"
  type        = string
  sensitive   = true

}
