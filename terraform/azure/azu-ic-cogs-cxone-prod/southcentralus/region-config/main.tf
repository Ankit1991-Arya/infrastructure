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

module "region-config" {
  source = "../../../../../modules/azure-region-config"

  ad-domain-joiner-username             = "_aws@inucn.com"
  ad-base-ou-name                       = "azure-prod-texas"
  chef-environment-name                 = "production-texas"
  chef-server-name                      = "aoa-inchf01"
  deployment-files-bucket               = "ic-deployment-files-ao"
  domain-name                           = "inucn.com"
  external-domain-name                  = "nice-incontact.com"
  external-domain-name-for-new-services = "test.niceincontact.com"
  ic-region-id                          = "at"
  cxone-system-id                       = "prod"
  cxone-area-id                         = "na1"
}
#triggering
