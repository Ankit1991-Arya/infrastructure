

resource "azurerm_virtual_network_peering" "peering_s_d" {
  name                         = join("-", tolist([var.src_vnet_name, var.remote_vnet_name]))
  resource_group_name          = var.resource_group
  virtual_network_name         = var.src_vnet_name
  remote_virtual_network_id    = var.remote_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "peering_d_s" {
  name                         = join("-", tolist([var.remote_vnet_name, var.src_vnet_name]))
  resource_group_name          = var.resource_group
  virtual_network_name         = var.remote_vnet_name
  remote_virtual_network_id    = var.src_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}