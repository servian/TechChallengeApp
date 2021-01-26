variable "app-name" {
  type = string
  default = "to-do-app"
}

variable "app-location" {
  type = string
  default = "australiaeast"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.12"
    }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "venura9"

    workspaces {
      prefix = "app-"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.app-name}-rg"
  location = var.app-location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.app-name}-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vnet-intgr-subnet" {
  name                 = "integration"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${var.app-name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "${var.app-name}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet-intgr" {
  app_service_id = azurerm_app_service.webapp.id
  subnet_id      = azurerm_subnet.vnet-intgr-subnet.id
}