# App Service Plan. Linux
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${azurerm_resource_group.rg.name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier     = "PremiumV2"
    size     = "P1v2"
    capacity = 1 # Ideally min 3 for HA
  }

}

resource "azurerm_app_service" "tca-docker-app" {
  name                = "${azurerm_resource_group.rg.name}-docker-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  site_config {
    always_on        = true
    app_command_line = "serve"
    linux_fx_version = "DOCKER|servian/techchallengeapp:latest"

    health_check_path = "/healthcheck/"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io",

    "VTT_DBHOST"     = "${azurerm_postgresql_server.postgressql_server.name}.postgres.database.azure.com"
    "VTT_DBPASSWORD" = var.dbPassword
    "VTT_DBUSER"     = "${var.dbUser}@${azurerm_postgresql_server.postgressql_server.name}"
    "VTT_LISTENHOST" = "0.0.0.0"
    "VTT_LISTENPORT" = 80
  }

  depends_on = [azurerm_postgresql_server.postgressql_server]

}
