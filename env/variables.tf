# Common

variable "environment" {}

variable "location" {
  type        = map(string)
  description = "Location for resources"
    default = {
      aue = "australiaeast"
      aus = "australiasoutheast"
    }
}

variable "resource_group" {
  description = "Resource Group resource settings"
  type = map(string)
}

variable "keyvault" {
  description = "Keyvault resource settings"
  type = map(string)
}

variable "application" {
  description = "Web Application resource settings"
  type = map(string)
}

variable "database_server" {
  description = "Database server resource settings"
  type = map(string)
}

variable "database" {
  description = "Database resource settings"
  type = map(string)
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      environment = "dev"
   }
}