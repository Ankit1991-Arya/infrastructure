terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.22.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=1.2.0"
    }
  }
}

data "azurerm_client_config" "current" {}
