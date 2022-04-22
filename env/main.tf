terraform {
  backend "azurerm" {    
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.2"            
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group.name}-${var.environment.name}-aue-rg"
  location = var.location.aue
}