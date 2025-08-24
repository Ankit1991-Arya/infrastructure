data "azurerm_resource_group" "domain-controllers" {
  name = "domaincontrollers-${var.ic-region-id}"
}

data "azurerm_key_vault" "EnvVar" {
  name                = "ic-envvar-${var.ic-region-id}"
  resource_group_name = "regionconfig-${var.ic-region-id}"
}
data "azurerm_key_vault_secret" "EnvVar" {
  for_each     = local.EnvVar_secrets_list
  name         = each.value
  key_vault_id = data.azurerm_key_vault.EnvVar.id
}

data "azurerm_key_vault" "Systems" {
  name                = "ic-systems-${var.ic-region-id}"
  resource_group_name = "regionconfig-${var.ic-region-id}"
}
data "azurerm_key_vault_secret" "Systems" {
  for_each     = local.Systems_secrets_list
  name         = each.value
  key_vault_id = data.azurerm_key_vault.Systems.id
}

module "domain_controller" {
  source   = "../azure-windows-vm"
  for_each = local.virtual_machines

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = data.azurerm_resource_group.domain-controllers.name
  location                             = data.azurerm_resource_group.domain-controllers.location
  virtual_machine_size                 = var.virtual_machine_size
  source_image_reference               = var.source_image_reference
  os_disk_caching                      = "None"
  availability_zone                    = each.value.availability_zone
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["systems-domaincontroller-nsg"].value
  enable_accelerated_networking        = var.enable_accelerated_networking
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["systems-domaincontroller-asg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = var.ad_ou_path # Defaults to "" as DC will be moved following promotion
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[systems_domaincontroller]"
  disk_initialization_dsc_extension    = true
  tags                                 = local.tags
  data_disk_map = {
    "Apps" = {
      disk_size_gb      = "128"
      lun               = 1
      availability_zone = each.value.availability_zone
      drive_letter      = "D"
    }
    "AddedLater" = {
      disk_size_gb      = "16"
      lun               = 2
      availability_zone = each.value.availability_zone
      drive_letter      = "L"
    }
  }
}
