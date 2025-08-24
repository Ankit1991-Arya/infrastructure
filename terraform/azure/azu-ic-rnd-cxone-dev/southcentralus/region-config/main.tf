terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.79"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.2"
    }
  }
}

provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}
provider "azapi" {}

module "region-config" {
  source = "../../../../../modules/azure-region-config"

  ad-domain-joiner-username             = "aws@in.lab"
  ad-base-ou-name                       = "azure-dev-texas"
  chef-environment-name                 = "dev-texas"
  chef-server-name                      = "ena-inchf01"
  deployment-files-bucket               = "ic-deployment-files-do"
  domain-name                           = "in.lab"
  external-domain-name                  = "dev.nice-incontact.com"
  external-domain-name-for-new-services = "dev.niceincontact.com"
  ic-region-id                          = "dt"
  cxone-system-id                       = "dev"
  cxone-area-id                         = "na1"
}