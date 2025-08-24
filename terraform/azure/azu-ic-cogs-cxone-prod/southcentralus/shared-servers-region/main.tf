provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}

module "shared-servers-region" {
  source = "../../../../../modules/azure-shared-servers-region"

  ic_region_id    = "at"
  location        = "southcentralus"
  vm_size_class   = "Prod"
  disk_size_class = "Prod"
  tags            = {} # Any tags provided here will override tags defined by module

  bidatamart_instance_map = {
    "ata-inbid01" = { virtual_machine_size = "Standard_E4s_v5" }
    "atb-inbid01" = { virtual_machine_size = "Standard_E4s_v5" }
  }
  bmcmonitoring_instance_map = {
    "ata-bmmon01" = { virtual_machine_size = "Standard_D8s_v5" }
  }
  databasemonitor_instance_map = {
    "ata-indbm01" = { virtual_machine_size = "Standard_D4s_v5" }
  }
  globalweb_instance_map = {
    "ata-ingws01" = { virtual_machine_size = "Standard_D4s_v5" }
    "atb-ingws01" = { virtual_machine_size = "Standard_D4s_v5" }
  }
  logicmonitor_instance_map = {
    "ata-inlmo01" = { virtual_machine_size = "Standard_D2s_v5" }
  }
  thousandeyesagentdmz_instance_map = {
    "ata-inted01" = { virtual_machine_size = "Standard_D2s_v5" }
  }
  thousandeyesagentinternal_instance_map = {
    "ata-intei01" = { virtual_machine_size = "Standard_D2s_v5" }
  }
}
#Triggering 
