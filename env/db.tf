# Posgres Flexi DB Server

resource "azurerm_postgresql_flexible_server" "posdb" {
  name                   = "chsql-${var.environment.name}-psqlflex"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.db-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.dns-db.id
  administrator_login    = var.database_server.admin_username
  administrator_password = data.azurerm_key_vault_secret.dbpass_datasource.value #azurerm_key_vault_secret.db_admin_password.value
  zone                   = "1"
  storage_mb             = var.database_server.storage_mb
  sku_name               = var.database_server.sku_name
  
  high_availability {
    mode = "ZoneRedundant"
  }
  
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.dns-app-vnet,
    data.azurerm_key_vault_secret.dbpass_datasource,
    azurerm_private_dns_zone.dns-db    
    ]
}

# The TechChallenge:latest docker image from the servian repository has SSL transport disabled for DB.
# This switches the postgress flexi server configuration to disable ssl transport requirements. 
# This is NOT recommended, but to make the app work as is. 
# If you want to test this infra with that particular image, uncomment this block.

# resource "azurerm_postgresql_flexible_server_configuration" "db-ssl-off" {
#   name      = "require_secure_transport"
#   server_id = azurerm_postgresql_flexible_server.posdb.id
#   value     = "off"
# }

resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = var.database.name
  server_id = azurerm_postgresql_flexible_server.posdb.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}