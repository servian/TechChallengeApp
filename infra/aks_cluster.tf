
resource "azurerm_kubernetes_cluster" "techchallenge_aks_cluster" {
  name                = "${azurerm_resource_group.techchallenge-aks-rg.name}-cluster"
  location            = azurerm_resource_group.techchallenge-aks-rg.location
  resource_group_name = azurerm_resource_group.techchallenge-aks-rg.name
  dns_prefix          = "${azurerm_resource_group.techchallenge-aks-rg.name}-cluster"
  node_resource_group  = "${azurerm_resource_group.techchallenge-aks-rg.name}-nrg"

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D2_v2"
    availability_zones =[1,2,3]
    enable_auto_scaling  = true 
    min_count = 1
    max_count  = 2
    os_disk_size_gb  = 30
    type = "VirtualMachineScaleSets"

  }

  identity {
    type = "SystemAssigned"
  }

  #Add on Profiles

  addon_profile {
      azure_policy{enabled = true }
      # oms_agent{
      #     enabled = true
      # }
  }

}