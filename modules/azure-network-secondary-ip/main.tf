
resource "random_id" "id" {
  count       = var.ip_count_number
  byte_length = 2
}

resource "azurerm_network_interface" "nic" {
  count               = var.ip_count_number
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = format("sec-%s%s", var.nic_name, random_id.id)
    subnet_id                     = var.sunbet_id
    private_ip_address_allocation = "Dynamic"
  }
}