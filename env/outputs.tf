output "todo_app_url" {
  value = "${azurerm_app_service.web.name}.azurewebsites.net"
}
