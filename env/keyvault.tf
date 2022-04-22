# Key Vault - https://www.terraform.io/docs/providers/azurerm/r/key_vault.html

resource "azurerm_key_vault" "kv" {
  name                        = "${var.keyvault.name}-${var.environment.name}-kv"
  location                    = var.location.aue
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = merge(var.tags, {
    layer = "secrets"
  })
}

# Web Application access policy
resource "azurerm_key_vault_access_policy" "webid" {
  key_vault_id       = azurerm_key_vault.kv.id
  object_id          = azurerm_app_service.web.identity.0.principal_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  secret_permissions = [
    "Get"
  ]

  depends_on = [
    azurerm_key_vault.kv,
    azurerm_app_service.web
  ]  
}

# For simplicity, machine generated password

resource "random_password" "db_adminpass" {
  length           = 6
  special          = true
  override_special = "!#"
}

# Admin password accessible to administrators at any time in the keyvault

resource "azurerm_key_vault_secret" "db_admin_password" {
  name         = "dbpsql-admin-password"
  value        = random_password.db_adminpass.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = merge(var.tags, {
    layer = "secrets"
  })

  depends_on = [
    azurerm_key_vault.kv,
    azurerm_key_vault_access_policy.currentspn
    ]
}

data "azurerm_key_vault_secret" "dbpass_datasource" {
  name="${azurerm_key_vault_secret.db_admin_password.name}"
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_secret.db_admin_password
  ]
}

resource "azurerm_key_vault_access_policy" "currentspn" {  

  key_vault_id = azurerm_key_vault.kv.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

  depends_on = [
    azurerm_key_vault.kv
  ]
}