

resource "azurerm_route_table" "rt" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = var.route_list
    content {
      name                   = route.value["name"]
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = route.value["next_hop_in_ip_address"]

    }
  }
}
resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each       = { for idx, record in var.subnet_id : idx => record }
  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.rt.id
}
