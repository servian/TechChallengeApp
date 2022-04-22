resource "azurerm_virtual_network" "chappvnet" {
  name                = "chapp-${var.environment.name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Database integration subnet

resource "azurerm_subnet" "db-subnet" {
  name                 = "db-${var.environment.name}-sbnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.chappvnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "pfsdelegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  depends_on = [
    azurerm_virtual_network.chappvnet
  ]
}

# App Service integration subnet

resource "azurerm_subnet" "chapp-subnet" {
  name                 = "chapp-${var.environment.name}-sbnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.chappvnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Web"]
  delegation {
    name = "appdelegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }

  depends_on = [
    azurerm_virtual_network.chappvnet
  ] 
}

# Private DNS configuration

resource "azurerm_private_dns_zone" "dns-db" {
  name                = "chapp.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name   
}

# App service vnet integration
resource "azurerm_private_dns_zone_virtual_network_link" "dns-app-vnet" {
  name                  = "chapapp.com"
  private_dns_zone_name = azurerm_private_dns_zone.dns-db.name
  virtual_network_id    = azurerm_virtual_network.chappvnet.id
  resource_group_name   = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_virtual_network.chappvnet
  ]
}

# Allows integration of this app into the pre-allocated subnet
resource "azurerm_app_service_virtual_network_swift_connection" "appvnetint" {
  app_service_id     = azurerm_app_service.web.id
  subnet_id          = azurerm_subnet.chapp-subnet.id

  depends_on = [
    azurerm_subnet.chapp-subnet,
    azurerm_app_service.web
  ]  
}