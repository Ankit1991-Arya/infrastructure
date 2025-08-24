
resource "azurerm_public_ip" "vng_pip_1" {
  name                = var.pip_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "ergw" {
  name                = var.gate_name
  location            = var.location
  resource_group_name = var.resource_group

  type = "ExpressRoute"
  sku  = "Standard"

  ip_configuration {
    name                          = format("config-%s", var.gate_name)
    public_ip_address_id          = azurerm_public_ip.vng_pip_1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }
}