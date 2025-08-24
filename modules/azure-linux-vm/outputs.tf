output "network_interface_id" {
  value = azurerm_network_interface.this.id
}
output "ip_configuration_name" {
  value = azurerm_network_interface.this.ip_configuration[0].name
}