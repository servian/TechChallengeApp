resource "azurerm_app_service_plan" "webplan" {
  name                = "${var.application.name}-${var.environment.name}-asp"
  location            = var.location.aue
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true
  zone_redundant      = var.application.zone_redundant

  sku {
    tier = "${var.application.service_plan_skus_tier}"
    size = "${var.application.service_plan_skus_size}"
  }
}

resource "azurerm_app_service" "web" {
  name                = "${var.application.name}-${var.environment.name}-app"
  location            = var.location.aue
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.webplan.id
  https_only          = true

  site_config {
    app_command_line  = "serve" # By defaults on first install, it runs the migration on the entry point.
    linux_fx_version  = "DOCKER|${var.application.default_image}"
    always_on         = "true"
    health_check_path = "${var.application.health_check_path}"
  }

  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version, # Tells the app to ignore changes because our deployments are made outside of Terraform by the CI/CD pipeline
      site_config.0.app_command_line  # The entry point is changed outside of terraform after initial deployment, so subsequently changes to this are ignored.
    ]
  }

  identity {
    type = "SystemAssigned"
  }  

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE": "false"
    "WEBSITES_CONTAINER_START_TIME_LIMIT": "600" # Delays app service killing the container too early during if warmup takes too long. i.e seeding.
    "WEBSITE_VNET_ROUTE_ALL": "1"
    "WEBSITES_PORT": "${var.application.app_listening_port}"
    "PORT": "${var.application.app_listening_port}"
    "VTT_DBNAME": "${var.database.name}"
    "VTT_DBUSER": "${var.database_server.admin_username}"
    "VTT_DBPASSWORD": "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.dbpass_datasource.versionless_id})"
    "VTT_DBPORT": "5432"
    "VTT_DBHOST": "${azurerm_postgresql_flexible_server.posdb.name}.postgres.database.azure.com"
    "VTT_LISTENHOST": "0.0.0.0"
    "VTT_LISTENPORT": "${var.application.app_listening_port}"
    #DOCKER_CUSTOM_IMAGE_NAME
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL            = "https://index.docker.io"
    # DOCKER_REGISTRY_SERVER_USERNAME       = ""
    # DOCKER_REGISTRY_SERVER_PASSWORD       = ""        
  }

  logs {
    application_logs {
      file_system_level = "${var.application.app_logs_level}"
    }
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb = 35
      }
    }     
  }

  depends_on = [
    azurerm_app_service_plan.webplan,
    azurerm_postgresql_flexible_server_database.appdb,
    data.azurerm_key_vault_secret.dbpass_datasource
  ]
}

# Create the App Service Autoscale settings

resource "azurerm_monitor_autoscale_setting" "webplan_autoscale" {
  name                     = "webplan_scale-${var.environment.name}-as"
  location                 = var.location.aue
  resource_group_name      = azurerm_resource_group.rg.name
  target_resource_id       = azurerm_app_service_plan.webplan.id

  profile {
              name = "defaultProfile"
              capacity {
                          default = 2
                          minimum = 2
                          maximum = 4
                      }      
              # Increase the Instance count by 1 when CPU usage is 85% consitanty for  5 mins
              rule {
                      metric_trigger {
                                          metric_name        = "CpuPercentage"
                                          metric_resource_id = azurerm_app_service_plan.webplan.id
                                          time_grain         = "PT1M"
                                          statistic          = "Average"
                                          time_window        = "PT5M"
                                          time_aggregation   = "Average"
                                          operator           = "GreaterThan"
                                          threshold          = 85
                                      }
                      scale_action {
                                          direction = "Increase"
                                          type      = "ChangeCount"
                                          value     = "1"
                                          cooldown  = "PT1M"
                                      }
                  }

              # Decrease the Instance count by 1 when CPU usage is 40% or less consitanty for  5 mins
              rule {
                      metric_trigger {
                                          metric_name        = "CpuPercentage"
                                          metric_resource_id = azurerm_app_service_plan.webplan.id
                                          time_grain         = "PT1M"
                                          statistic          = "Average"
                                          time_window        = "PT5M"
                                          time_aggregation   = "Average"
                                          operator           = "LessThan"
                                          threshold          = 40
                                      }

                      scale_action {
                                          direction = "Decrease"
                                          type      = "ChangeCount"
                                          value     = "1"
                                          cooldown  = "PT1M"
                                      }
                  }

              # Increase the Instance count by 1 when Memory usage is 85% consitanty for  5 mins
              rule {
                      metric_trigger {
                                          metric_name        = "MemoryPercentage"
                                          metric_resource_id = azurerm_app_service_plan.webplan.id
                                          time_grain         = "PT1M"
                                          statistic          = "Average"
                                          time_window        = "PT5M"
                                          time_aggregation   = "Average"
                                          operator           = "GreaterThan"
                                          threshold          = 85
                                      }
                      scale_action {
                                          direction = "Increase"
                                          type      = "ChangeCount"
                                          value     = "1"
                                          cooldown  = "PT1M"
                                      }
                  }

              # Decrease the Instance count by 1 when Memory usage is 40% or less consitanty for  5 mins
              rule {
                      metric_trigger {
                                          metric_name        = "MemoryPercentage"
                                          metric_resource_id = azurerm_app_service_plan.webplan.id
                                          time_grain         = "PT1M"
                                          statistic          = "Average"
                                          time_window        = "PT5M"
                                          time_aggregation   = "Average"
                                          operator           = "LessThan"
                                          threshold          = 40
                                      }
                      scale_action {
                                          direction = "Decrease"
                                          type      = "ChangeCount"
                                          value     = "1"
                                          cooldown  = "PT1M"
                                      }
                  }

  }
}