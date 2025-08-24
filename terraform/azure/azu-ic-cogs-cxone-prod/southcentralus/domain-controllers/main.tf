provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}

module "domain-controllers" {
  source = "../../../../../modules/azure-domain-controllers"

  ic-region-id                  = "at"
  instance_list                 = ["atb-indco01", "ata-indco01"]
  virtual_machine_size          = "Standard_D2as_v4"
  enable_accelerated_networking = true # Surfaced here as it is dependent on VM size
  tags                          = {}   # Any tags provided here will override tags defined by module
}
#Triggering
