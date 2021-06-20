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

# App Service Plan. Linux
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${azurerm_resource_group.rg.name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier     = "Standard"
    size     = "S1"
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
    app_command_line = ""
    # linux_fx_version = "DOCKER|servian/techchallengeapp:latest"
    linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"

    health_check_path = "/" #"/api/healthy?"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
  }
}

