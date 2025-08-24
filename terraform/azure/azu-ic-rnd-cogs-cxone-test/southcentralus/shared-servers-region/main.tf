provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}
module "region-shared-servers" {
  source          = "../../../../../modules/azure-shared-servers-region"
  ic_region_id    = "tt"
  location        = "southcentralus"
  vm_size_class   = "PreProd"
  disk_size_class = "PreProd"
  tags            = {} # Any tags provided here will override tags defined by module
  bidatamart_instance_map = {
    "tta-inbid01" = {
      virtual_machine_size = "Standard_D4ads_v5"
      data_disk_map = {
        "SQL_Backup" = {
          storage_account_type = "Premium_LRS"
          create_option        = "Empty"
          disk_size_gb         = "128"
          allocation_unit_size = 65536
          drive_letter         = "S"
          caching              = "ReadOnly"
          lun                  = 5
        }
      }
    }
    "ttb-inbid01" = {
      virtual_machine_size = "Standard_D4ads_v5"
      data_disk_map        = {}
    }
  }
  globalweb_instance_map = {
    "tta-ingws01" = { virtual_machine_size = "Standard_D2ads_v5" }
    "ttb-ingws01" = { virtual_machine_size = "Standard_D2ads_v5" }
  }
  logicmonitor_instance_map = {
    "tta-inlmo01" = { virtual_machine_size = "Standard_D2ads_v5" }
  }
}
#Triggering
