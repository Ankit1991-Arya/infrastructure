resource "azurerm_network_interface" "this" {
  name                          = "${var.virtual_machine_resource_name}-nic"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  dns_servers                   = try(var.network_interface_dns_servers, null)
  enable_accelerated_networking = var.enable_accelerated_networking
  tags                          = local.tags

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_address : null
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_network_interface_application_security_group_association" "this" {
  count = var.associate_application_security_group ? 1 : 0

  network_interface_id          = azurerm_network_interface.this.id
  application_security_group_id = var.application_security_group_id
}

resource "random_password" "admin_password" {
  length  = 32
  special = true
}

resource "azurerm_windows_virtual_machine" "this" {
  name                         = var.virtual_machine_resource_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  size                         = var.virtual_machine_size
  admin_username               = var.admin_username
  admin_password               = random_password.admin_password.result
  network_interface_ids        = [azurerm_network_interface.this.id]
  zone                         = var.availability_zone != "" ? var.availability_zone : null
  availability_set_id          = var.availability_zone == "" && var.availability_set_id != "" ? var.availability_set_id : null
  computer_name                = coalesce(var.virtual_machine_computer_name, local.composed_vm_computer_name)
  enable_automatic_updates     = var.enable_automatic_updates
  license_type                 = var.license_type
  patch_mode                   = var.patch_mode
  hotpatching_enabled          = var.patch_mode == "AutomaticByPlatform" ? var.hotpatching_enabled : false
  proximity_placement_group_id = try(var.proximity_placement_group_id, null)
  source_image_id              = var.source_image_id == "" ? null : var.source_image_id
  timezone                     = var.timezone
  tags                         = local.tags

  os_disk {
    name                 = "${var.virtual_machine_resource_name}-osdisk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id == "" ? [1] : []

    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = lookup(var.source_image_reference, "version", "latest")
    }
  }

  boot_diagnostics {
    storage_account_uri = try(var.diagnostics_storage_account_uri, null)
  }

  dynamic "identity" {
    for_each = var.system_assigned_identity || length(var.user_assigned_identity_ids) > 0 ? [1] : []

    content {
      type         = local.virtual_machine_identity_type
      identity_ids = var.user_assigned_identity_ids
    }
  }

  lifecycle {
    ignore_changes = [
      identity["principal_id"],
      identity["tenant_id"],
      identity["identity_ids"]
    ]
  }
}

resource "azurerm_managed_disk" "this" {
  for_each = var.data_disk_map

  name                 = "${azurerm_windows_virtual_machine.this.name}-${lower(each.key)}disk"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = lookup(each.value, "storage_account_type", "Premium_LRS")
  create_option        = lookup(each.value, "create_option", "Empty")
  disk_size_gb         = each.value.disk_size_gb
  zone                 = var.availability_zone != "" ? var.availability_zone : null
  tags                 = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.data_disk_map

  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.disk_size_gb > 4095 ? "None" : lookup(each.value, "caching", "None")
}

resource "azurerm_virtual_machine_extension" "ad_domain_join" {
  name                       = "ad-domain-join"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = local.ad_domain_join_extension_settings
  protected_settings         = local.ad_domain_join_extension_protected_settings
  tags                       = local.tags

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_network_interface_security_group_association.this]
}

resource "azurerm_virtual_machine_extension" "chef_bootstrap" {
  count = var.chef_bootstrap ? 1 : 0

  name                 = "chef-bootstrap"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Chef.Bootstrap.WindowsAzure"
  type                 = "ChefClient"
  type_handler_version = "1210.12"
  settings             = local.chef_bootstrap_extension_settings
  protected_settings   = local.chef_bootstrap_extension_protected_settings
  tags                 = local.tags

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_virtual_machine_extension.disk_initialization[0]]
}

data "azurerm_key_vault" "Systems" {
  name                = "ic-systems-${regex("^(..).*$", var.virtual_machine_resource_name)[0]}"
  resource_group_name = "regionconfig-${regex("^(..).*$", var.virtual_machine_resource_name)[0]}"
}
data "azurerm_key_vault_secret" "dsc-disk-init-url" {
  name         = "dsc-disk-init-url"
  key_vault_id = data.azurerm_key_vault.Systems.id
}
data "azurerm_key_vault_secret" "dsc-disk-init-sas" {
  name         = "dsc-disk-init-sas"
  key_vault_id = data.azurerm_key_vault.Systems.id
}

resource "azurerm_virtual_machine_extension" "disk_initialization" {
  count = var.disk_initialization_dsc_extension ? 1 : 0

  name                       = "disk-initialization"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true
  settings                   = local.disk_initialization_extension_settings
  protected_settings         = local.disk_initialization_extension_protected_settings
  tags                       = local.tags

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.this,
    azurerm_virtual_machine_extension.ad_domain_join
  ]

  lifecycle {
    ignore_changes = [protected_settings]
  }
}
