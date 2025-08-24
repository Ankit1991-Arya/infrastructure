resource "azurerm_lb" "this" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    subnet_id                     = var.subnet_id
    zones                         = var.zones
    private_ip_address_allocation = var.private_ip_address == "" ? "Dynamic" : "Static"
    private_ip_address            = var.private_ip_address == "" ? null : var.private_ip_address
    private_ip_address_version    = "IPv4"
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each = var.backend_address_pool_map

  name            = each.key
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each = local.backend_address_pool_nic_associations

  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = each.value.backend_address_pool_id
}

resource "azurerm_lb_probe" "this" {
  for_each = var.lb_probe_map

  name                = each.key
  loadbalancer_id     = azurerm_lb.this.id
  protocol            = each.value.protocol
  port                = each.value.port
  request_path        = contains(["Http", "Https"], each.value.protocol) ? each.value.request_path : null
  interval_in_seconds = lookup(each.value, "interval_in_seconds", 15)
  number_of_probes    = lookup(each.value, "number_of_probes", 2)
}

resource "azurerm_lb_rule" "this" {
  for_each = var.lb_rule_map

  name                           = each.key
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  protocol                       = lookup(each.value, "protocol", "Tcp")
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.this[lookup(each.value, "backend_address_pool_key", keys(var.backend_address_pool_map)[0])].id}"]
  probe_id                       = azurerm_lb_probe.this[lookup(each.value, "lb_probe_key", keys(var.lb_probe_map)[0])].id
  enable_floating_ip             = each.value.enable_floating_ip
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", 4)
  disable_outbound_snat          = lookup(each.value, "disable_outbound_snat", false)
  enable_tcp_reset               = lookup(each.value, "enable_tcp_reset", false)
}