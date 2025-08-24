

resource "azurerm_lb" "la-ha-palo-alto" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  frontend_ip_configuration {
    name      = var.frontend_ip_configuration_name
    subnet_id = var.subnet_id
    #      private_ip_address   = var.web_lb_private_IP
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "lb-pool" {
  name            = var.backend_address_pool_name
  loadbalancer_id = azurerm_lb.la-ha-palo-alto.id
}

resource "azurerm_lb_probe" "tcp_prob" {
  for_each = { for idx, record in var.prob_list : idx => record }
  #name         = each.value.name
  name                = each.value.probe_name
  loadbalancer_id     = azurerm_lb.la-ha-palo-alto.id
  protocol            = each.value.probe_protocol
  port                = each.value.probe_port
  interval_in_seconds = each.value.probe_interval_in_seconds
  number_of_probes    = 2
  request_path        = (each.value.probe_protocol == "Http" ? each.value.probe_request_path : null)
  #request_path        = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 2)
  #resource_group_name = var.resource_group
}

resource "azurerm_lb_rule" "lb_rule-ha" {
  for_each = { for idx, record in var.rule_list : idx => record }
  name     = each.value.rule_name
  # resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.la-ha-palo-alto.id
  protocol                       = each.value.rule_protocol
  frontend_port                  = each.value.rule_frontend_port
  backend_port                   = each.value.rule_backend_port
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb-pool.id]
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.tcp_prob[0].id
  load_distribution              = "SourceIP"
  #resource_group_name            = var.resource_group
}

