
resource "azurerm_public_ip" "cluster_agw_pip_1" {
  name                = var.pip_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "cluster_agw" {
  name                = var.app_gate_name
  resource_group_name = var.resource_group
  location            = var.location
  firewall_policy_id  = var.firewall_policy_id

  sku {
    name     = var.sku_name[0] #"Standard_v2"
    tier     = var.sku_name[1] #"Standard_v2"
    capacity = 2
  }

  #  autoscale_configuration {
  #    min_capacity = "1"
  #  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = format("port-%s", 80)
    port = 80
  }
  frontend_port {
    name = format("port-%s", 443)
    port = 443
  }
  frontend_port {
    name = format("port-%s", 3333)
    port = 3333
  }
  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.cluster_agw_pip_1.id
    #subnet_id            =  (var.private ? var.subnet_id : null)
  }

  #  dynamic frontend_ip_configuration {
  #    for_each = var.private_frontend
  #    content {
  #      name                          = "${var.frontend_ip_configuration_name}-private"
  #      subnet_id                     = var.subnet_id
  #      private_ip_address_allocation = "Static"
  #    }
  #  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool_name_list
    content {
      name = backend_address_pool.value["name"]
    }
  }

  dynamic "probe" {
    for_each = var.probe_name_list
    content {
      name                = probe.value["name"]
      host                = format("probe-%s", probe.value["name"])
      path                = probe.value["path"]
      protocol            = probe.value["protocol"]
      port                = probe.value["port"]
      interval            = 5
      timeout             = 4
      unhealthy_threshold = 2
      match {
        body        = "OK"
        status_code = ["200-399"]
      }
    }
  }

  #
  dynamic "backend_http_settings" {
    for_each = var.probe_name_list
    content {
      name                  = format("settings-%s", backend_http_settings.value["name"])
      cookie_based_affinity = backend_http_settings.value["cookie_based_affinity"]
      path                  = "/"
      port                  = backend_http_settings.value["backend_settings_port"]
      protocol              = backend_http_settings.value["protocol"]
      request_timeout       = 300
      probe_name            = backend_http_settings.value["name"]
      #      connection_draining = {
      #        enable_connection_draining = true
      #        drain_timeout_sec          = 300
      #      }
    }
  }
  dynamic "identity" {
    for_each = var.identity
    content {
      type         = "UserAssigned"
      identity_ids = [var.identity_ids]
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.identity
    content {
      name                = var.ssl_cert_key_name
      key_vault_secret_id = var.key_vault_secret_id
    }
  }
  dynamic "ssl_policy" {
    for_each = var.identity
    content {
      policy_name = "AppGwSslPolicy20170401S"
      policy_type = "Predefined"
    }
  }

  dynamic "http_listener" {
    for_each = var.listener_list
    content {
      host_name                      = http_listener.value["host_name"]
      name                           = http_listener.value["listener_name"]
      frontend_ip_configuration_name = var.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value["port_name"]
      protocol                       = http_listener.value["protocol"]
      ssl_certificate_name           = (http_listener.value["protocol"] == "Https" ? var.ssl_cert_key_name : null)
    }
  }
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule_set
    content {
      name                        = format("rule-%s", request_routing_rule.value["name"])
      rule_type                   = "Basic"
      http_listener_name          = request_routing_rule.value["listener_name"]
      backend_address_pool_name   = (request_routing_rule.value["redirect"] ? null : request_routing_rule.value["pool_name"])
      backend_http_settings_name  = (request_routing_rule.value["redirect"] ? null : format("settings-%s", request_routing_rule.value["backend_http_settings"]))
      redirect_configuration_name = (request_routing_rule.value["redirect"] ? request_routing_rule.value["redirect_conf_name"] : null)
      priority                    = (format("%g", request_routing_rule.key + 100))
    }
  }
  dynamic "redirect_configuration" {
    for_each = [for x in var.request_routing_rule_set : x if x.redirect]
    content {
      name                 = redirect_configuration.value["redirect_conf_name"]
      redirect_type        = "Permanent"
      target_listener_name = redirect_configuration.value["target_listener_name"]
      include_path         = true
      include_query_string = true
    }
  }
}
#"/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946/resourceGroups/networkinfra-tt/providers/Microsoft.Network/applicationGateways/reginal-service-app-agw/backendAddressPools/ng-globalweb-backend-pool"
resource "azurerm_key_vault_secret" "backend_address_pool" {
  for_each     = { for idx, record in var.backend_address_pool_name_list : idx => record }
  name         = each.value.name
  value        = format("%s/backendAddressPools/%s", azurerm_application_gateway.cluster_agw.id, each.value.name)
  key_vault_id = var.key_vault_id
}


