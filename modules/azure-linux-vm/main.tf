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

resource "tls_private_key" "this" {
  count = var.admin_ssh_key == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "this" {
  name                         = var.virtual_machine_resource_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  size                         = var.virtual_machine_size
  admin_username               = var.admin_username
  network_interface_ids        = [azurerm_network_interface.this.id]
  zone                         = var.availability_zone != "" ? var.availability_zone : null
  availability_set_id          = var.availability_zone == "" && var.availability_set_id != "" ? var.availability_set_id : null
  computer_name                = coalesce(var.virtual_machine_computer_name, local.composed_vm_computer_name)
  patch_mode                   = var.patch_mode
  proximity_placement_group_id = try(var.proximity_placement_group_id, null)
  source_image_id              = var.source_image_id == "" ? null : var.source_image_id
  custom_data                  = var.custom_data == "" ? null : var.custom_data
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

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key == "" ? trimspace(tls_private_key.this[0].public_key_openssh) : var.admin_ssh_key
  }

  dynamic "gallery_application" {
    for_each = var.gallery_applications_map

    content {
      version_id             = each.value.version_id
      order                  = lookup(each.value, "order", null)
      configuration_blob_uri = lookup(each.value, "configuration_blob_uri", null)
      tag                    = lookup(each.value, "tag", null)
    }
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

  name                 = "${azurerm_linux_virtual_machine.this.name}-${lower(each.key)}disk"
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
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.disk_size_gb > 4095 ? "None" : lookup(each.value, "caching", "None")
}

resource "azurerm_virtual_machine_extension" "chef_bootstrap" {
  count = var.chef_bootstrap ? 1 : 0

  name                 = "chef-bootstrap"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Chef.Bootstrap.WindowsAzure"
  type                 = "ChefClient"
  type_handler_version = "1210.12"
  settings             = local.chef_bootstrap_extension_settings
  protected_settings   = local.chef_bootstrap_extension_protected_settings
  tags                 = local.tags

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
}