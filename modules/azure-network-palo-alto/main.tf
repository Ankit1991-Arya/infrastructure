


resource "azurerm_marketplace_agreement" "palo" {
  publisher = "paloaltonetworks"
  offer     = "vmseries-flex"
  plan      = "byol"
}

data "azurerm_key_vault_secret" "kvsecret-a" {
  name         = local.key-name-site-a
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "kvsecret-b" {
  name         = local.key-name-site-b
  key_vault_id = var.key_vault_id
}
locals {
  naming-list = [data.azurerm_key_vault_secret.kvsecret-a.value, data.azurerm_key_vault_secret.kvsecret-b.value]

}

#(length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])

module "vmseries-modules_vmseries" {
  count = 2
  #source                     = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vmseries"
  #source                     =  "github.com/PaloAltoNetworks/terraform-azurerm-vmseries-modules//modules/vmseries?ref=develop"
  source = "github.com/PaloAltoNetworks/terraform-azurerm-vmseries-modules//modules/vmseries?ref=e22e513ecadb796a16e5887fae84a14df950d412"
  # version                    = "0.4.0"
  location            = var.location
  resource_group_name = var.resource_group
  name                = format("%s-tvn-fw0%s", local.naming-list[count.index], var.number[count.index])
  username            = "panadmin"
  password            = "Change-Me-007"
  vm_size             = var.vm_size
  img_version         = var.image-version
  enable_zones        = true
  avzone              = var.zones[count.index]
  img_sku             = azurerm_marketplace_agreement.palo.plan
  interfaces = [
    {
      name                 = format("%s-%s-%s", local.naming-list[count.index], var.mgmnt-int-name, count.index)
      subnet_id            = var.security-palo-mgmnt-subnet
      enable_ip_forwarding = true
      #        public_ip_address_id = azurerm_public_ip.my_mgmt_ip.id
    },
    {
      name                 = format("%s-%s-%s", local.naming-list[count.index], var.trust-int-name, count.index)
      subnet_id            = var.security-palo-trust-subnet
      enable_ip_forwarding = true
      enable_backend_pool  = true
      lb_backend_pool_id   = var.backend_address_pool_id_for_lb
    },
    {
      name                 = format("%s-%s-%s", local.naming-list[count.index], var.untrust-int-name, count.index)
      subnet_id            = var.security-palo-untrust-subnet
      enable_ip_forwarding = true
    },
  ]
}

#(region)(environment)(az)-tvn-fw##

data "azurerm_subscription" "this" {}

resource "azurerm_network_interface_security_group_association" "group_association_palo_mgmnt-int-name" {
  depends_on                = [module.vmseries-modules_vmseries]
  count                     = 2
  network_interface_id      = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/networkInterfaces/${format("%s-%s-%s", local.naming-list[count.index], var.mgmnt-int-name, count.index)}"
  network_security_group_id = var.ng_network_paloalto_mgmnt_nsg_id
}
resource "azurerm_network_interface_security_group_association" "group_association_palo_trust-int-name" {
  depends_on                = [module.vmseries-modules_vmseries]
  count                     = 2
  network_interface_id      = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/networkInterfaces/${format("%s-%s-%s", local.naming-list[count.index], var.trust-int-name, count.index)}"
  network_security_group_id = var.ng_network_paloalto_int_nsg_id
}
resource "azurerm_network_interface_security_group_association" "group_association_palo_untrust-int-name" {
  depends_on                = [module.vmseries-modules_vmseries]
  count                     = 2
  network_interface_id      = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/networkInterfaces/${format("%s-%s-%s", local.naming-list[count.index], var.untrust-int-name, count.index)}"
  network_security_group_id = var.ng_network_paloalto_int_nsg_id
}

#resource "azurerm_network_interface_backend_address_pool_association" "net_association" {
#  count                   = 2
#  network_interface_id    =  "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/networkInterfaces/${format("%s-%s-%s",local.naming-list[count.index],var.trust-int-name,count.index)}"
#  ip_configuration_name   = "ip-configuration-fw"
#  backend_address_pool_id =
#}