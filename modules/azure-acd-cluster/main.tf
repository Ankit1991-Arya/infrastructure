resource "azurerm_resource_group" "acd_cluster" {
  name     = "acd-cluster-${var.ic_region_id}-${var.cluster_id}"
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

module "api" {
  source   = "../azure-windows-vm"
  for_each = var.api_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["API"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["dmz-network-dmz-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-dmz-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-dmz-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_api"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_api]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG API Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["API"],
    lookup(each.value, "data_disk_map", {})
  )
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "api" {
  for_each = var.api_instance_map

  network_interface_id    = module.api[each.key].network_interface_id
  ip_configuration_name   = module.api[each.key].ip_configuration_name
  backend_address_pool_id = data.azurerm_key_vault_secret.EnvVar["ng-api-backend-pool"].value
}

module "bitube" {
  source   = "../azure-windows-vm"
  for_each = var.bitube_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["BITube"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_bitube"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_bitube]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG BIT Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["BITube"],
    lookup(each.value, "data_disk_map", {})
  )
}

module "core" {
  source   = "../azure-windows-vm"
  for_each = var.core_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["Core"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_core"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_core]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG Core Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["Core"],
    lookup(each.value, "data_disk_map", {})
  )
}

module "datawarehouse" {
  source   = "../azure-windows-vm"
  for_each = var.datawarehouse_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["DataWarehouse"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_datawarehouse"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "role[ng_datawarehouse_a]" : "role[ng_datawarehouse_b]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG Data Warehouse Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["DataWarehouse"],
    lookup(each.value, "data_disk_map", {})
  )
}

module "datawarehouse_sqlaoag_ilb" {
  source = "../azure-internal-load-balancer"

  lb_name             = "${var.cluster_id}-dwa-sqlaoag-ilb"
  resource_group_name = azurerm_resource_group.acd_cluster.name
  location            = azurerm_resource_group.acd_cluster.location
  subnet_id           = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  tags                = merge(local.tags, { DeviceType = "NG Data Warehouse Server" })
  backend_address_pool_map = {
    "SQLAlwaysOnBackendPool" = {
      for instance_key, instance in var.datawarehouse_instance_map : instance_key => {
        network_interface_id  = module.datawarehouse[instance_key].network_interface_id
        ip_configuration_name = module.datawarehouse[instance_key].ip_configuration_name
      }
    }
  }
  lb_probe_map = {
    "SQLAlwaysOnEndPointProbe" = {
      protocol            = "Tcp"
      port                = 59999
      interval_in_seconds = 5
    }
  }
  lb_rule_map = {
    "SQLAlwaysOnEndPointListener" = {
      frontend_port      = 1433
      backend_port       = 1433
      enable_floating_ip = true
    }
  }
}

module "media" {
  source   = "../azure-windows-vm"
  for_each = var.media_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["Media"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_media"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_media]"
  disk_initialization_dsc_extension    = true

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["Media"],
    lookup(each.value, "data_disk_map", {})
  )

  tags = merge(
    local.tags,
    {
      DeviceType = "NG Media Server"
      Product    = "NG"
    }
  )
}

module "storagemigration" {
  source   = "../azure-windows-vm"
  for_each = var.storagemigration_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["StorageMigration"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["core-network-core-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-internal-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"storageservices_migration"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[storageservices_migration]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG Storage Migration Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["StorageMigration"],
    lookup(each.value, "data_disk_map", {})
  )
}

module "storagemigration_ilb" {
  source = "../azure-internal-load-balancer"
  count  = length(var.storagemigration_instance_map) < 1 ? 0 : 1

  lb_name             = "${var.cluster_id}-storagemigration-ilb"
  resource_group_name = azurerm_resource_group.acd_cluster.name
  location            = azurerm_resource_group.acd_cluster.location
  subnet_id           = data.azurerm_key_vault_secret.EnvVar["core-network-serverless-subnet"].value
  tags                = merge(local.tags, { DeviceType = "NG Storage Migration Server" })
  backend_address_pool_map = {
    "StorageMigrationBackendPool" = {
      for instance_key, instance in var.storagemigration_instance_map : instance_key => {
        network_interface_id  = module.storagemigration[instance_key].network_interface_id
        ip_configuration_name = module.storagemigration[instance_key].ip_configuration_name
      }
    }
  }
  lb_probe_map = {
    "StorageMigrationHttpProbe" = {
      protocol            = "Http"
      port                = 8888
      interval_in_seconds = 5
      request_path        = "/" # Default?
    }
  }
  lb_rule_map = {
    "StorageMigrationRule" = {
      frontend_port      = 3333
      backend_port       = 3333
      enable_floating_ip = false
    }
  }
}

#resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "storagemigration" {
#   for_each = var.storagemigration_instance_map
#   network_interface_id    = module.storagemigration[each.key].network_interface_id
#   ip_configuration_name   = module.storagemigration[each.key].ip_configuration_name
#   backend_address_pool_id = data.azurerm_key_vault_secret.EnvVar["storageservices-migration-backend-pool"].value
# }

module "web" {
  source   = "../azure-windows-vm"
  for_each = var.web_instance_map

  virtual_machine_resource_name        = each.key
  virtual_machine_computer_name        = each.key
  resource_group_name                  = azurerm_resource_group.acd_cluster.name
  location                             = azurerm_resource_group.acd_cluster.location
  virtual_machine_size                 = lookup(each.value, "virtual_machine_size", local.vm_size_map["Web"][var.vm_size_class])
  source_image_reference               = lookup(each.value, "source_image_reference", var.default_source_image_reference)
  os_disk_caching                      = lookup(each.value, "", "ReadWrite")
  availability_zone                    = regex("^..(?P<site_id>[ab])-.*$", each.key)["site_id"] == "a" ? "1" : "2"
  subnet_id                            = data.azurerm_key_vault_secret.EnvVar["dmz-network-dmz-subnet"].value
  enable_accelerated_networking        = lookup(each.value, "enable_accelerated_networking", true)
  associate_application_security_group = true
  application_security_group_id        = data.azurerm_key_vault_secret.EnvVar["cluster-dmz-servers-asg"].value
  network_security_group_id            = data.azurerm_key_vault_secret.EnvVar["cluster-dmz-servers-nsg"].value
  ad_domain_name                       = data.azurerm_key_vault_secret.EnvVar["domain-name"].value
  ad_ou_path                           = join(",", ["OU=${"ng_web"}", "OU=${regex("^(.{3})-.*$", each.key)[0]}", data.azurerm_key_vault_secret.EnvVar["ad-base-ou-distinguished-name"].value])
  ad_domain_join_username              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-username"].value
  ad_domain_join_password              = data.azurerm_key_vault_secret.Systems["ad-domain-joiner-password"].value
  chef_bootstrap                       = true
  chef_server_url                      = "${data.azurerm_key_vault_secret.EnvVar["chef-server-name"].value}.${data.azurerm_key_vault_secret.EnvVar["domain-name"].value}/organizations/incontact"
  chef_validation_key                  = data.azurerm_key_vault_secret.EnvVar["chef-validation-key"].value
  chef_server_crt                      = data.azurerm_key_vault_secret.EnvVar["chef-server-crt"].value
  chef_environment                     = data.azurerm_key_vault_secret.EnvVar["chef-environment-name"].value
  chef_runlist                         = "role[ng_web]"
  disk_initialization_dsc_extension    = true
  tags                                 = merge(local.tags, { DeviceType = "NG Web Server" })

  data_disk_map = merge(
    local.data_disk_maps[lookup(each.value, "disk_sizing", var.disk_size_class)]["Web"],
    lookup(each.value, "data_disk_map", {})
  )
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "web" {
  for_each = var.web_instance_map

  network_interface_id    = module.web[each.key].network_interface_id
  ip_configuration_name   = module.web[each.key].ip_configuration_name
  backend_address_pool_id = data.azurerm_key_vault_secret.EnvVar["ng-web-backend-pool"].value
}
