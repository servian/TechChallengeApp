terraform {
    backend "azurerm"{
        resource_group_name    = "bd-storage-rg"
        storage_account_name   = "terraformstatexdfes"
        container_name         = "terraformstatefiles"
        key                    = "terraform.tfstate"
    }

    required_providers{
        
        azuread = {
            source = "hashicorp/azuread"
            version = "1.4.0"
        }
        random = {
            source = "hashicorp/random"
            version = "3.1.0"
        }
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.56.0"
        }
        }
      
    }

