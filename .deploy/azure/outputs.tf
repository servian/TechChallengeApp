output "app_service_name" {
  value = "${azurerm_app_service.tca-docker-app.name}"
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.tca-docker-app.default_site_hostname}"
}