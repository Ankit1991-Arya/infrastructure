locals {
  # We can potentially use locals to transform resource name to meet computer name requirements
  composed_vm_computer_name = var.virtual_machine_computer_name

  virtual_machine_identity_type = (length(var.user_assigned_identity_ids) > 0 ?
    var.system_assigned_identity ? "SystemAssigned, UserAssigned" : "UserAssigned"
    : var.system_assigned_identity ? "SystemAssigned" : ""
  )

  tags = merge(
    {
      CreatedBy       = "Terraform"
      TerraformModule = "azure-windows-vm"
      DeviceType      = "Systems Domain Controller"
      Cluster         = "Global"
      Product         = "Systems"
      Owner           = "Systems Teams"
    },
    var.tags
  )

  ad_domain_join_extension_settings = jsonencode({
    "Name"    = "${var.ad_domain_name}"
    "OUPath"  = "${var.ad_ou_path}"
    "User"    = "${var.ad_domain_join_username}"
    "Restart" = "true"
    "Options" = "3"
  })

  ad_domain_join_extension_protected_settings = jsonencode({
    "Password" = "${var.ad_domain_join_password}"
  })

  # Eliminate potential duplicate "https://" from chef_server_url variable
  chef_server_url = "https://${replace("${var.chef_server_url}", "/(http|https):///", "")}"

  chef_bootstrap_extension_settings = jsonencode({
    "bootstrap_options" = {
      "chef_node_name"         = "${azurerm_windows_virtual_machine.this.computer_name}"
      "chef_server_url"        = "${local.chef_server_url}"
      "environment"            = "${var.chef_environment}"
      "validation_client_name" = "incontact-validator"
    }
    "daemon"                = "none"
    "chef_daemon_interval"  = "0"
    "runlist"               = "${var.chef_runlist}"
    "validation_key_format" = "base64encoded"
  })

  chef_bootstrap_extension_protected_settings = <<-EOF
  {
    "validation_key": "${var.chef_validation_key}",
    "chef_server_crt": "${var.chef_server_crt}"
  }
  EOF

  # Refactor data_disk_map slightly for easier DSC consumption
  data_disk_list = [
    for disk_key, disk in var.data_disk_map : {
      label  = disk_key
      lun    = disk.lun
      letter = disk.drive_letter
      ausize = lookup(disk, "allocation_unit_size", "4096")
      size   = disk.disk_size_gb # Passing this value only to trigger DSC run following update to disk size
    }
  ]

  disk_initialization_extension_settings = <<-SETTINGS
    {
      "wmfVersion": "latest",
      "configuration": {
        "url": "${data.azurerm_key_vault_secret.dsc-disk-init-url.value}",
        "script": "DiskInitialization.ps1",
        "function": "DiskInitialization"
      },
      "configurationArguments": {
        "disk_list": "${base64encode(jsonencode(local.data_disk_list))}",
        "computer_name": "${azurerm_windows_virtual_machine.this.computer_name}"
      }
    }
  SETTINGS

  disk_initialization_extension_protected_settings = <<-PROTECTEDSETTINGS
    {
      "configurationUrlSasToken": "${data.azurerm_key_vault_secret.dsc-disk-init-sas.value}"
    }
  PROTECTEDSETTINGS

}
