variable "location" {
  type        = string
  description = "azure region where the resource will be created"
  default     = "westus2"
}

variable "resourceGroupName" {
  type        = string
  description = "Name of resource group"
}

variable "databaseName" {
  type        = string
  description = "Name of the PostreSQL database"
  default     = "tca_dev"
}

variable "dbUser" {
  type    = string
  default = "sparticus"
}
variable "dbPassword" {
  type    = string
  default = "S3curestring!"
}

variable "sqlServerName" {
  type    = string
  default = "tcasql202106"
}