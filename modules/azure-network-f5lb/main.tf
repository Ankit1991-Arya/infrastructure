data "azurerm_client_config" "current" {}


resource "azurerm_marketplace_agreement" "f5" {
  publisher = "f5-networks"
  offer     = "f5-big-ip-byol"
  plan      = "f5-big-all-2slot-byol"
}
module "bigip" {
  count                      = 2
  source                     = "F5Networks/bigip-module/azure"
  version                    = "1.2.0"
  prefix                     = format("%s%s-int-adc0%s", var.prefix_name, var.zoneid[count.index], var.number[count.index])
  f5_ssh_publickey           = file("${path.module}/pub.pub")
  resource_group_name        = var.resource_group
  mgmt_subnet_ids            = [{ "subnet_id" = var.mgmt-subnet, "public_ip" = false, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  mgmt_securitygroup_ids     = [var.mgmt-network-security-group]
  external_subnet_ids        = [{ "subnet_id" = var.vip-subnet, "public_ip" = false, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids = [var.external-network-security-group]
  internal_subnet_ids        = [{ "subnet_id" = var.core-subnet, "public_ip" = false, "private_ip_primary" = "" }]
  internal_securitygroup_ids = [var.internal-network-security-group]
  availability_zone          = (count.index == 0 ? 1 : 2)
  #availabilityZones           = var.availability_zone
  f5_image_name    = var.image_name[0]
  f5_product_name  = var.product[0]
  f5_version       = var.bigip_version[0]
  f5_instance_type = var.instance_type
  f5_username      = var.admin_username
  f5_password      = var.admin_pass
}

# Could use something like this to attach ip configuration to NIC created by module.bigip
#resource "null_resource" "test" {
#  provisioner "local-exec" {
#    command = "az network nic ip-config"
#  }
#  depends_on = [module.bigip]
#}

#   az vm image list --publisher  f5-networks --offer f5-big-ip-byol --all --output table
