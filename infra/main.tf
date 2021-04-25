//#for creating infra :
//1. get the provider 
//2. create resource resourc group 
//3. create a VN where the resources will be located 
//4. Create subnets as needed 

provider "azurerm" {
            version = "2.56.0"
            features{}
        }
resource "azurerm_resource_group" "techchallenge-aks-rg"{
 name                         = "techchallenge-aks-rg"
 location                     = "australiaeast" 
}

resource "azurerm_virtual_network" "AKS-INFRA-VN"{ 
    name                      ="AKS-INFRA-VN"
    resource_group_name       = azurerm_resource_group.techchallenge-aks-rg.name
    location                  = azurerm_resource_group.techchallenge-aks-rg.location
    address_space             = ["10.0.0.0/16"]
    
}

resource "azurerm_subnet" "aks_subnet" {
    name = "AKS_SUBNET"
    virtual_network_name = azurerm_virtual_network.AKS-INFRA-VN.name
    resource_group_name = azurerm_virtual_network.AKS-INFRA-VN.resource_group_name
    address_prefixes     = ["10.0.1.0/24"]
  
}