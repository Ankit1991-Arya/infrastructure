terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ictfstate"
    storage_account_name = "ictfstate"
    container_name       = "ic-tfstate"
    key                  = "tf-terraform-backend"
  }
}

provider "azurerm" {
  client_id       = var.AZURE_CLIENT_ID_TEST
  client_secret   = var.AZURE_CLIENT_SECRET_TEST
  subscription_id = var.AZURE_SUBSCRIPTION_ID_TEST
  tenant_id       = var.AZURE_TENANT_ID
  features {}
}
