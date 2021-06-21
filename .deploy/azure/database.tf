resource "azurerm_postgresql_server" "postgressql_server" {

  name                = var.sqlServerName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  # Move this to fetch outputs from azure vault
  # Add a `depends on` block to reference Keyvault
  administrator_login          = var.dbUser
  administrator_login_password = var.dbPassword
  version                      = "9.6"
  ssl_enforcement_enabled      = true

  //Network config
  # public_network_access_enabled = false

}

resource "azurerm_postgresql_database" "postgressql_db" {
  name                = var.databaseName
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgressql_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

}

resource "azurerm_postgresql_firewall_rule" "firewall_allow_all" {
  name                = "all_ips"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgressql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
