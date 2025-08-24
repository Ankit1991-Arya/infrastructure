output "azurerm_lb_backend_address_pool_lb_id" {
  value = azurerm_lb_backend_address_pool.lb-pool.id
}

output "azurerm_lb_ip" {
  value = azurerm_lb.la-ha-palo-alto.private_ip_address
}