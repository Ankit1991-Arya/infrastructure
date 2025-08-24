output "ng_network_f5_internal" {
  value = azurerm_network_security_group.ng_network_f5_internal_nsg.id
}
output "ng_network_f5_mgmnt" {
  value = azurerm_network_security_group.ng_network_f5_nsg.id
}
output "ng_network_f5_external" {
  value = azurerm_network_security_group.ng_network_f5_external_nsg.id
}
output "ng_network_paloalto_int_nsg" {
  value = azurerm_network_security_group.ng_network_paloalto_int_nsg.id
}
output "ng_network_paloalto_mgmnt_nsg" {
  value = azurerm_network_security_group.ng_network_paloalto_nsg.id
}