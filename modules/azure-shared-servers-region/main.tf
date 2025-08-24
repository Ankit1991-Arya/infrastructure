resource "azurerm_resource_group" "this" {
  name     = "shared-servers-region-${var.ic_region_id}"
  location = var.location
  tags     = local.tags
}

data "azurerm_key_vault" "EnvVar" {
  name                = "ic-envvar-${var.ic_region_id}"
  resource_group_name = "regionconfig-${var.ic_region_id}"
}
data "azurerm_key_vault_secret" "EnvVar" {
  for_each     = local.EnvVar_secrets_list
  name         = each.value
  key_vault_id = data.azurerm_key_vault.EnvVar.id
}

data "azurerm_key_vault" "Systems" {
  name                = "ic-systems-${var.ic_region_id}"
  resource_group_name = "regionconfig-${var.ic_region_id}"
}
data "azurerm_key_vault_secret" "Systems" {
  for_each     = local.Systems_secrets_list
  name         = each.value
  key_vault_id = data.azurerm_key_vault.Systems.id
}

module "BIDatamart" {
  source   = "../azure-windows-vm"
  for_each = var.bidatamart_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["BIDatamart"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["BIDatamart"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["ng-bidatamart-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["ng-bidatamart-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_bidatamart"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_bidatamart]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["BIDatamart"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "NG BI Datamart Server"
      Cluster    = "Global"
      Product    = "NG"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

module "BMCMonitoring" {
  source   = "../azure-windows-vm"
  for_each = var.bmcmonitoring_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["BMCMonitoring"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["BMCMonitoring"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-management-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["tools-bmcmonitoring-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["tools-bmcmonitoring-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"tools_bmcmonitoring"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[tools_bmcmonitoring]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["BMCMonitoring"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "Tools BMC Monitoring Server"
      Cluster    = "Global"
      Product    = "Tools"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

module "DatabaseMonitor" {
  source   = "../azure-windows-vm"
  for_each = var.databasemonitor_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["DatabaseMonitor"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["DatabaseMonitor"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["tools-databasemonitor-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["tools-databasemonitor-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"tools_databasemonitor"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[tools_databasemonitor]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["DatabaseMonitor"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "Tools Database Monitor"
      Cluster    = "Global"
      Product    = "Tools"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

module "GlobalWeb" {
  source   = "../azure-windows-vm"
  for_each = var.globalweb_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["GlobalWeb"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["GlobalWeb"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["dmz-network-dmz-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["ng-globalweb-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["ng-globalweb-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_globalweb"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_globalweb]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["GlobalWeb"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "NG Global Web Server"
      Cluster    = "Global"
      Product    = "NG"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "globalweb" {
  for_each = var.globalweb_instance_map

  network_interface_id    = module.GlobalWeb[each.key].network_interface_id
  ip_configuration_name   = module.GlobalWeb[each.key].ip_configuration_name
  backend_address_pool_id = data.azurerm_key_vault_secret.EnvVar["ng-globalweb-backend-pool"].value
}

module "LogicMonitor" {
  source   = "../azure-windows-vm"
  for_each = var.logicmonitor_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["LogicMonitor"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["LogicMonitor"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["network-logicmonitor-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["network-logicmonitor-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"network_logicmonitor"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[network_logicmonitor]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["LogicMonitor"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "Network LogicMonitor Server"
      Cluster    = "Global"
      Product    = "Network"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

module "ThousandEyesAgentDMZ" {
  source   = "../azure-linux-vm"
  for_each = var.thousandeyesagentdmz_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["ThousandEyesAgentDMZ"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["ThousandEyesAgentDMZ"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["dmz-network-dmz-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["network-thousandeyesagentdmz-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["network-thousandeyesagentdmz-nsg"].value
  admin_username                       = "inlocadmin"
  admin_ssh_key                        = data.azurerm_key_vault_secret.Systems["SystemsKeyPairPublicKeyOpenSSH"].value
  chef_bootstrap                       = false
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[tools_thousandeyesagentdmz]"

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["ThousandEyesAgentDMZ"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "Thousand Eyes Agent DMZ"
      Cluster    = "Region"
      Product    = "Tools"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

module "ThousandEyesAgentInternal" {
  source   = "../azure-linux-vm"
  for_each = var.thousandeyesagentinternal_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["ThousandEyesAgentInternal"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", local.vm_image_map["ThousandEyesAgentInternal"])
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["network-thousandeyesagentinternal-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["network-thousandeyesagentinternal-nsg"].value
  admin_username                       = "inlocadmin"
  admin_ssh_key                        = data.azurerm_key_vault_secret.Systems["SystemsKeyPairPublicKeyOpenSSH"].value
  chef_bootstrap                       = false
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[tools_thousandeyesagentinternal]"

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["ThousandEyesAgentInternal"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    {
      DeviceType = "Thousand Eyes Agent Internal"
      Cluster    = "Region"
      Product    = "Tools"
    },
    local.tags # Merges local.tags last in order to capture var.tags passed from root configuration
  )
}

