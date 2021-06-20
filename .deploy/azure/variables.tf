variable "location" {
  type        = string
  description = "azure region where the resource will be created"
  default     = "westus2"
}

variable "resourceGroupName" {
    type = string
    description = "Name of resource group"
}