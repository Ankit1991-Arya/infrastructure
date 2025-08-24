output "agw_public_ip" {
  value = azurerm_public_ip.cluster_agw_pip_1.ip_address
  #value = var.private ? null : azurerm_public_ip.cluster_agw_pip_1.ip_address
}
#
#

