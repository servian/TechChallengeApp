
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.64.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Establish the resource group 
resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
  tags = {
    Environment = "development"
  }
}
