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
  ad-base-ou-name                       = "azure-test-texas"
  chef-environment-name                 = "test-texas"
  chef-server-name                      = "ena-inchf01"
  deployment-files-bucket               = "ic-deployment-files-ao"
  domain-name                           = "in.lab"
  external-domain-name                  = "test.nice-incontact.com"
  external-domain-name-for-new-services = "test.niceincontact.com"
  ic-region-id                          = "tt"
  cxone-system-id                       = "test"
  cxone-area-id                         = "na1"
}
