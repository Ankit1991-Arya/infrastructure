
terraform {
  required_version = "~>1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.22"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>0.6"
    }
  }
}

provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}

provider "aws" {
  region = "us-west-2"
}

locals {
  ###  json_data = jsondecode(file("connector.json"))
  zone_id            = "ZSS0JXDVU1NSJ"
  resource_group_net = "networkinfra-at"
  resource_group_sec = "networksecurity-at"
  location           = "South Central US"
  system_vault_id    = "/subscriptions/bfd801d5-9e25-47c9-93e4-d329d8d61246/resourceGroups/regionconfig-at/providers/Microsoft.KeyVault/vaults/ic-systems-at"
  key_vault_id       = "/subscriptions/bfd801d5-9e25-47c9-93e4-d329d8d61246/resourceGroups/regionconfig-at/providers/Microsoft.KeyVault/vaults/ic-envvar-at"
  sku                = "Standard"
  #  sku_v2             = "Standard_v2"
  allocation_method = "Static"
  # core vnet/subnet names
  #########
  core-vnetwork-name          = "core-vnet"
  core-subnet-name            = "core-subnet"
  core-vip-subnet-name        = "core-vip-subnet"
  core-mgmt-subnet-name       = "core-mgmnt-subnet"
  core-GatewaySubnet-name     = "GatewaySubnet"
  core-Serverless-subnet-name = "core-serverless-subnet"
  # dmz vnet/subnet names
  #########
  dmz-vnetwork-name         = "dmz-vnet"
  dmz-subnet-name           = "dmz-subnet"
  dmz-public-subnet-name    = "dmz-public-subnet"
  dmz-DMZGatewaySubnet-name = "GatewaySubnet"
  dmz-natgateway-name       = "dmz_natgateway"
  # security vnet/subnet names
  #########
  security-vnetwork-name = "security-vnet"
  # security-subnet-name = "securitySubnet"
  security-untrust-subnet-name = "security-untrust-subnet"
  security-trust-subnet-name   = "security-trust-subnet"
  security-mgnt-subnet-name    = "security-mgmnt-subnet"
  security-gateway-subnet-name = "GatewaySubnet"
}

##### main module
# RG  resource_group_net  = "networkinfra-tt"
# Core Network Resources
# Vnet
resource "azurerm_virtual_network" "core_vnet" {
  name                = local.core-vnetwork-name
  location            = local.location
  resource_group_name = local.resource_group_net
  address_space       = var.core_vnet_address_space
  dns_servers         = var.dns_servers
  tags                = merge({ "Name" = format("%s", local.core-vnetwork-name) }, var.tags, )
}
#Subnets
resource "azurerm_subnet" "core-subnet" {
  name                 = local.core-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = var.core_subnet
  service_endpoints    = var.core_service_endpoints
}

resource "azurerm_subnet" "vip-subnet" {
  name                 = local.core-vip-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = var.vip_subnet
}
resource "azurerm_subnet" "mgmt-subnet" {
  name                 = local.core-mgmt-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = var.mgmt_subnet
}
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = local.core-GatewaySubnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = var.gw_subnet
}
resource "azurerm_subnet" "Serverless-subnet" {
  name                 = local.core-Serverless-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = var.serverless_subnet
}
#Nat and Associations
resource "azurerm_public_ip" "nat_gw_pub_ip1" {
  name                = "nat-gw-pip-1"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}
resource "azurerm_public_ip" "nat_gw_pub_ip2" {
  name                = "nat-gw-pip-2"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}

# Core nat CIDR 1  output
resource "azurerm_key_vault_secret" "core-nat-public-cidr-1" {
  name         = "core-nat-public-cidr-1"
  value        = azurerm_public_ip.nat_gw_pub_ip1.ip_address
  key_vault_id = local.key_vault_id
}
# Core nat CIDR 2  output
resource "azurerm_key_vault_secret" "core-nat-public-cidr-2" {
  name         = "core-nat-public-cidr-2"
  value        = azurerm_public_ip.nat_gw_pub_ip2.ip_address
  key_vault_id = local.key_vault_id
}
###
# nat
resource "azurerm_nat_gateway" "nat_gw" {
  name                = "core_nat_gateway"
  location            = local.location
  resource_group_name = local.resource_group_net
}
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pub_ip1_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_gw_pub_ip1.id
}
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pub_ip2_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_gw_pub_ip2.id
}

#nat association
resource "azurerm_subnet_nat_gateway_association" "core_subnet_assoc" {
  subnet_id      = azurerm_subnet.core-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}
resource "azurerm_subnet_nat_gateway_association" "serverless_subne_assoc" {
  subnet_id      = azurerm_subnet.Serverless-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}
resource "azurerm_subnet_nat_gateway_association" "mgmt_subnet_assoc" {
  subnet_id      = azurerm_subnet.mgmt-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}
#
# RG  resource_group_net  = "networkinfra-tt"
# DMZ Network Resources
resource "azurerm_virtual_network" "dmz_vnet" {
  name                = local.dmz-vnetwork-name
  location            = local.location
  resource_group_name = local.resource_group_net
  address_space       = var.dmz_vnet_address_space
  dns_servers         = var.dns_servers
  tags                = merge({ "Name" = format("%s", local.dmz-vnetwork-name) }, var.tags, )
}
#Subnets
resource "azurerm_subnet" "dmz-subnet" {
  name                 = local.dmz-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.dmz_vnet.name
  address_prefixes     = var.dmz_subnet
  service_endpoints    = var.dmz_service_endpoints
}
resource "azurerm_subnet" "public-subnet" {
  name                 = local.dmz-public-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.dmz_vnet.name
  address_prefixes     = var.public_subnet
}
resource "azurerm_subnet" "DMZGatewaySubnet" {
  name                 = local.dmz-DMZGatewaySubnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.dmz_vnet.name
  address_prefixes     = var.dmz_gw_subnet
}
#dmz nat gateway
resource "azurerm_public_ip" "dmz_nat_gw_pub_ip1" {
  name                = "dmz_nat-gw-pip-1"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}
resource "azurerm_public_ip" "dmz_nat_gw_pub_ip2" {
  name                = "dmz_nat-gw-pip-2"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}
resource "azurerm_nat_gateway" "dmz_nat_gw" {
  name                = local.dmz-natgateway-name
  location            = local.location
  resource_group_name = local.resource_group_net
}
resource "azurerm_nat_gateway_public_ip_association" "dmz_nat_gw_pub_ip1_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.dmz_nat_gw.id
  public_ip_address_id = azurerm_public_ip.dmz_nat_gw_pub_ip1.id
}
resource "azurerm_nat_gateway_public_ip_association" "dmz_nat_gw_pub_ip2_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.dmz_nat_gw.id
  public_ip_address_id = azurerm_public_ip.dmz_nat_gw_pub_ip2.id
}

# DMZ nat CIDR 1  output
resource "azurerm_key_vault_secret" "dmz-nat-public-cidr-1" {
  name         = "dmz-nat-public-cidr-1"
  value        = azurerm_public_ip.dmz_nat_gw_pub_ip1.ip_address
  key_vault_id = local.key_vault_id
}
# DMZ nat CIDR 1  output
resource "azurerm_key_vault_secret" "dmz-nat-public-cidr-2" {
  name         = "dmz-nat-public-cidr-2"
  value        = azurerm_public_ip.dmz_nat_gw_pub_ip2.ip_address
  key_vault_id = local.key_vault_id
}

resource "azurerm_subnet_nat_gateway_association" "dmz_subnet_assoc" {
  subnet_id      = azurerm_subnet.dmz-subnet.id
  nat_gateway_id = azurerm_nat_gateway.dmz_nat_gw.id
}
#
# RG  resource_group_net  = "networkinfra-tt"
# Security Network Resources
resource "azurerm_virtual_network" "security_vnet" {
  name                = local.security-vnetwork-name
  location            = local.location
  resource_group_name = local.resource_group_net
  address_space       = var.security_vnet_address_space
  dns_servers         = var.dns_servers
  tags                = merge({ "Name" = format("%s", local.security-vnetwork-name) }, var.tags, )
}
resource "azurerm_subnet" "security_untrust_subnet" {
  name                 = local.security-untrust-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.security_vnet.name
  address_prefixes     = var.security_untrust_subnet
}
resource "azurerm_subnet" "security_trust_subnet" {
  name                 = local.security-trust-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.security_vnet.name
  address_prefixes     = var.security_trust_subnet
}
resource "azurerm_subnet" "security_mgnt_subnet" {
  name                 = local.security-mgnt-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.security_vnet.name
  address_prefixes     = var.security_mgmt_subnet
}
resource "azurerm_subnet" "security_gateway_subnet" {
  name                 = local.security-gateway-subnet-name
  resource_group_name  = local.resource_group_net
  virtual_network_name = azurerm_virtual_network.security_vnet.name
  address_prefixes     = var.security_gateway_subnet
}
#####
#Nat and Associations for security vnet
resource "azurerm_public_ip" "nat_security_gw_pub_ip1" {
  name                = "nat-security-gw-pip-1"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}
resource "azurerm_public_ip" "nat_security_gw_pub_ip2" {
  name                = "nat-security-gw-pip-2"
  location            = local.location
  resource_group_name = local.resource_group_net
  allocation_method   = local.allocation_method
  sku                 = local.sku
}
# nat
resource "azurerm_nat_gateway" "nat-security-gw" {
  name                = "security-nat-gateway"
  location            = local.location
  resource_group_name = local.resource_group_net
}
resource "azurerm_nat_gateway_public_ip_association" "nat_security_gw_pub_ip1_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat-security-gw.id
  public_ip_address_id = azurerm_public_ip.nat_security_gw_pub_ip1.id
}
resource "azurerm_nat_gateway_public_ip_association" "nat_security_gw_pub_ip2_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat-security-gw.id
  public_ip_address_id = azurerm_public_ip.nat_security_gw_pub_ip2.id
}

###nat association
resource "azurerm_subnet_nat_gateway_association" "security_mgnt_subnet_assoc" {
  subnet_id      = azurerm_subnet.security_mgnt_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat-security-gw.id
}
####

# output -> save to vault -> core-vnet
#
#   Name: CoreNetwork-CoreSubnet
resource "azurerm_key_vault_secret" "CoreNetwork-CoreSubnet" {
  name         = "core-network-core-subnet"
  value        = azurerm_subnet.core-subnet.id
  key_vault_id = local.key_vault_id
}
# Name: CoreNetwork-VIPSubnet
resource "azurerm_key_vault_secret" "CoreNetwork-VIPSubnet" {
  name         = "core-network-vip-subnet"
  value        = azurerm_subnet.vip-subnet.id
  key_vault_id = local.key_vault_id
}
#Name: CoreNetwork-ManagementSubnet
resource "azurerm_key_vault_secret" "CoreNetwork-ManagementSubnet" {
  name         = "core-network-management-subnet"
  value        = azurerm_subnet.mgmt-subnet.id
  key_vault_id = local.key_vault_id
}
# Name: CoreNetwork-GatewaySubnet
resource "azurerm_key_vault_secret" "CoreNetwork-GatewaySubnet" {
  name         = "core-network-gateway-subnet"
  value        = azurerm_subnet.GatewaySubnet.id
  key_vault_id = local.key_vault_id
}
# Name: CoreNetwork-ServerlessSubnet
resource "azurerm_key_vault_secret" "CoreNetwork-ServerlessSubnet" {
  name         = "core-network-serverless-subnet"
  value        = azurerm_subnet.Serverless-subnet.id
  key_vault_id = local.key_vault_id
}
#Name: CoreNetwork-Vnet
resource "azurerm_key_vault_secret" "CoreNetwork-Vnet" {
  name         = "core-network-vnet"
  value        = azurerm_virtual_network.core_vnet.id
  key_vault_id = local.key_vault_id
}
#Name: CoreNetwork-VPCaddressPrefix
resource "azurerm_key_vault_secret" "CoreNetwork-VPCaddressPrefix" {
  name         = "core-network-vnet-address-prefix"
  value        = join(", ", azurerm_virtual_network.core_vnet.address_space)
  key_vault_id = local.key_vault_id
}
#Name: CoreNetwork-S3Endpoint




# output -> save to vault -> "security_vnet"
#"security_vnet"
resource "azurerm_key_vault_secret" "security_vnet" {
  name         = "security-network-vnet"
  value        = azurerm_virtual_network.security_vnet.id
  key_vault_id = local.key_vault_id
}
#resource "azurerm_subnet" "security_untrust_subnet" {
resource "azurerm_key_vault_secret" "security_untrust_subnet" {
  name         = "security-untrust-subnet"
  value        = azurerm_subnet.security_untrust_subnet.id
  key_vault_id = local.key_vault_id
}
#resource "azurerm_subnet" "security_trust_subnet" {
resource "azurerm_key_vault_secret" "security_trust_subnet" {
  name         = "security-trust-subnet"
  value        = azurerm_subnet.security_trust_subnet.id
  key_vault_id = local.key_vault_id
}
#resource "azurerm_subnet" "security_mgnt_subnet" {
resource "azurerm_key_vault_secret" "security_mgnt_subnet" {
  name         = "security-mgnt-subnet"
  value        = azurerm_subnet.security_mgnt_subnet.id
  key_vault_id = local.key_vault_id
}
#resource "azurerm_subnet" "security_gateway_subnet" {
resource "azurerm_key_vault_secret" "security_gateway_subnet" {
  name         = "security-gateway-subnet"
  value        = azurerm_subnet.security_gateway_subnet.id
  key_vault_id = local.key_vault_id
}

# DMZNetwork-DMZServerSecurityGroup

#Name: DMZNetwork-S3Endpoint



# output -> save to vault -> "dmz_vnet"
#   Name: CoreNetwork-CoreSubnet
#"dmz_vnet"
resource "azurerm_key_vault_secret" "DMZNetwork-Vnet" {
  name         = "dmz-network-vnet"
  value        = azurerm_virtual_network.dmz_vnet.id
  key_vault_id = local.key_vault_id
}
#DMZNetwork-Az2DMZSubnet
#"dmz-subnet"
resource "azurerm_key_vault_secret" "DMZNetwork-DMZSubnet" {
  name         = "dmz-network-dmz-subnet"
  value        = azurerm_subnet.dmz-subnet.id
  key_vault_id = local.key_vault_id
}
#"public-subnet"
#
resource "azurerm_key_vault_secret" "DMZNetwork-PublicSubnet" {
  name         = "dmz-network-public-subnet"
  value        = azurerm_subnet.public-subnet.id
  key_vault_id = local.key_vault_id
}
# "DMZGatewaySubnet"
resource "azurerm_key_vault_secret" "DMZNetwork-GatewaySubnet" {
  name         = "dmz-network-gateway-subnet"
  value        = azurerm_subnet.DMZGatewaySubnet.id
  key_vault_id = local.key_vault_id
}
# DMZNetwork-VPCaddressPrefix
resource "azurerm_key_vault_secret" "DMZNetwork-VPCaddressPrefix" {
  name         = "dmz-network-vnet-address-prefix"
  value        = join(", ", azurerm_virtual_network.dmz_vnet.address_space)
  key_vault_id = local.key_vault_id
}



## security group module
# tfsec:ignore:azure-network-ssh-blocked-from-internet tfsec:ignore:azure-network-disable-rdp-from-internet tfsec:ignore:azure-network-no-public-ingress tfsec:ignore:azure-network-no-public-ingress tfsec:ignore:azure-network-no-public-egress
module "sg" {
  source                  = "../../../../../modules/azure-network-sg"
  sg_location             = local.location
  sg_resource_group       = local.resource_group_sec
  key_vault_id            = local.key_vault_id
  dmz_vnet_address_space  = join("", azurerm_virtual_network.dmz_vnet.address_space)
  core_vnet_address_space = join("", azurerm_virtual_network.core_vnet.address_space)
}
## peering Security to DMZ
module "peering_Security_DMZ" {
  source           = "../../../../../modules/azure-network-peering"
  src_vnet_id      = azurerm_virtual_network.security_vnet.id
  src_vnet_name    = azurerm_virtual_network.security_vnet.name
  remote_vnet_id   = azurerm_virtual_network.dmz_vnet.id
  remote_vnet_name = azurerm_virtual_network.dmz_vnet.name
  resource_group   = local.resource_group_net
}
### peering Security to Core
module "peering_Security_Core" {
  source           = "../../../../../modules/azure-network-peering"
  src_vnet_id      = azurerm_virtual_network.security_vnet.id
  src_vnet_name    = azurerm_virtual_network.security_vnet.name
  remote_vnet_id   = azurerm_virtual_network.core_vnet.id
  remote_vnet_name = azurerm_virtual_network.core_vnet.name
  resource_group   = local.resource_group_net
}



#######
#########  vng  gate for core

module "vng_core" {
  source         = "../../../../../modules/azure-network-network-gateway"
  location       = local.location
  pip_name       = "core-gateway-pip"
  gate_name      = "core-vnet-express-gateway"
  resource_group = local.resource_group_net
  subnet_id      = azurerm_subnet.GatewaySubnet.id
}
#  vng  gate for DMZ
module "vng_dmz" {
  source         = "../../../../../modules/azure-network-network-gateway"
  location       = local.location
  pip_name       = "dmz-gateway-pip"
  gate_name      = "dmz-vnet-express-gateway"
  resource_group = local.resource_group_net
  subnet_id      = azurerm_subnet.DMZGatewaySubnet.id
}
module "vng_security" {
  source         = "../../../../../modules/azure-network-network-gateway"
  location       = local.location
  pip_name       = "security-gateway-pip"
  gate_name      = "security-vnet-express-gateway"
  resource_group = local.resource_group_net
  subnet_id      = azurerm_subnet.security_gateway_subnet.id
}

#palo lb
module "lb_ha_palo" {
  source                         = "../../../../../modules/azure-network-lb"
  location                       = local.location
  resource_group                 = local.resource_group_net
  frontend_ip_configuration_name = "pa-lb-frontend"
  subnet_id                      = azurerm_subnet.security_trust_subnet.id
  lb_name                        = "security-vnet-pa-lb"
  sku                            = "Standard"
  backend_address_pool_name      = "transitvnet-pa-pool"
  prob_list = [
    {
      probe_name                = "pa_health_prob"
      probe_protocol            = "Tcp"
      probe_port                = 22
      probe_interval_in_seconds = 5
      probe_request_path        = ""
    },
  ]
  rule_list = [
    {
      rule_name          = "ha_ports"
      rule_protocol      = "All"
      rule_backend_port  = 0
      rule_frontend_port = 0
    },
  ]
}

#######pa
#pa update v2.2
# tfsec:ignore:azure-compute-disable-password-authentication
module "palo_alto" {
  source                           = "../../../../../modules/azure-network-palo-alto"
  image-version                    = "10.1.3"
  location                         = local.location
  resource_group                   = local.resource_group_sec
  mgmnt-int-name                   = "mgmnt-interface"
  trust-int-name                   = "trust-interface"
  untrust-int-name                 = "untrust-interface"
  security-palo-mgmnt-subnet       = azurerm_subnet.security_mgnt_subnet.id
  security-palo-trust-subnet       = azurerm_subnet.security_trust_subnet.id
  security-palo-untrust-subnet     = azurerm_subnet.security_untrust_subnet.id
  vm_size                          = "Standard_D8as_v4"
  ng_network_paloalto_int_nsg_id   = module.sg.ng_network_paloalto_int_nsg
  ng_network_paloalto_mgmnt_nsg_id = module.sg.ng_network_paloalto_mgmnt_nsg
  key_vault_id                     = local.key_vault_id
  backend_address_pool_id_for_lb   = module.lb_ha_palo.azurerm_lb_backend_address_pool_lb_id
}
# custom RT modele
module "core-rt" {
  source         = "../../../../../modules/azure-network-route-tables"
  location       = local.location
  name           = "core-route-table"
  resource_group = local.resource_group_net
  subnet_id = [
    {
      subnet_id = azurerm_subnet.core-subnet.id
    },
    {
      subnet_id = azurerm_subnet.mgmt-subnet.id
    },
    {
      subnet_id = azurerm_subnet.Serverless-subnet.id
    },
    {
      subnet_id = azurerm_subnet.vip-subnet.id
    },
  ]
  route_list = [
    {
      name                   = "to-dmz-vnet"
      address_prefix         = join("", azurerm_virtual_network.dmz_vnet.address_space)
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.lb_ha_palo.azurerm_lb_ip
    },
  ]
}
module "dmz-rt" {
  source         = "../../../../../modules/azure-network-route-tables"
  location       = local.location
  name           = "dmz-route-table"
  resource_group = local.resource_group_net
  subnet_id = [
    {
      subnet_id = azurerm_subnet.dmz-subnet.id
    },
    {
      subnet_id = azurerm_subnet.public-subnet.id
  }, ]
  route_list = [
    {
      name                   = "to-core-vnet"
      address_prefix         = join("", azurerm_virtual_network.core_vnet.address_space)
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.lb_ha_palo.azurerm_lb_ip
  }, ]
}

######################################################################
#####################################################agw for DMZ
#external-domain-name
module "cert_assigned_identity_agw" {
  source            = "../../../../../modules/azure-network-alb-cert-identity"
  location          = local.location
  resource_group    = local.resource_group_net
  system_vault_id   = local.system_vault_id
  ssl_cert_key_name = "nicecxone"
  name              = "test"
}

data "azurerm_key_vault_secret" "external-domain-name" {
  name         = "external-domain-name"
  key_vault_id = local.key_vault_id
}
data "azurerm_key_vault_secret" "ic-region-id" {
  name         = "ic-region-id"
  key_vault_id = local.key_vault_id
}
locals {
  #regional agw
  pool_name                = "ng-globalweb-backend-pool"
  port_name_https          = "port-443"
  protocol_https           = "Https"
  port_name_http           = "port-80"
  protocol_http            = "Http"
  probe_name_list_regional = ["targetgroupbi"]



  # cluster app agw
  cluster-id                 = "c700"
  pool_name_api              = "ng-api-backend-pool"
  pool_name_web              = "ng-web-backend-pool"
  probe_name_list            = ["targetgroupbase", "targetgroupapi", "targetgrouphome", "targetgroupincontrol"]
  cluster_listener_name_list = ["GroupBase", "API", "Home", "incontrol"]
}


module "agw_regional_app" {
  depends_on    = [module.cert_assigned_identity_agw]
  source        = "../../../../../modules/azure-network-alb"
  app_gate_name = "regional-service-app-agw-c700"
  # sku_name                       =  ["Standard_v2" ,"Standard_v2" ]
  sku_name                       = ["WAF_v2", "WAF_v2"]
  firewall_policy_id             = module.waf_for_cluster.firewall_policy_id
  location                       = local.location
  resource_group                 = local.resource_group_net
  subnet_id                      = azurerm_subnet.public-subnet.id
  gateway_ip_configuration_name  = "regional-gateway-ip-configuration"
  frontend_ip_configuration_name = "reginal-agw-feip-2"
  pip_name                       = "cluster-agw-pip-2"
  backend_address_pool_name_list = [
    {
      name = local.pool_name
    },
  ]
  probe_name_list = [
    {
      name                  = local.probe_name_list_regional[0]
      path                  = "/BISecurityProxy/healthcheck.aspx"
      protocol              = "Http"
      port                  = 80
      backend_settings_port = 80
      cookie_based_affinity = "Enabled"
    },

  ]
  ##home-{cluster_id}.{external-domain-name}
  ## bi-{ic-region-id}.{external-domain-name}
  #api-{cluster_id}.{external-domain-name}
  listener_list = [
    {
      listener_name = "listener-SSLBI"
      port_name     = local.port_name_https
      protocol      = local.protocol_https
      host_name     = format("bi-%s.%s", data.azurerm_key_vault_secret.ic-region-id.value, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    {
      listener_name = "listener-http-SSLBI"
      port_name     = local.port_name_http
      protocol      = local.protocol_http
      host_name     = format("bi-%s.%s", data.azurerm_key_vault_secret.ic-region-id.value, data.azurerm_key_vault_secret.external-domain-name.value)
    },
  ]
  request_routing_rule_set = [
    {
      name                  = "SSLBI"
      pool_name             = local.pool_name
      target_listener_name  = null
      listener_name         = "listener-SSLBI"
      backend_http_settings = local.probe_name_list_regional[0]
      redirect              = false
      redirect_conf_name    = null
    },
    {
      name                  = "http-SSLBI"
      pool_name             = local.pool_name
      target_listener_name  = "listener-SSLBI"
      listener_name         = "listener-http-SSLBI"
      backend_http_settings = local.probe_name_list_regional[0]
      redirect              = true
      redirect_conf_name    = "rule-http-SSLBI-redirect"
    },
  ]
  identity_ids        = module.cert_assigned_identity_agw.principal_id
  identity            = [1]
  private_frontend    = []
  key_vault_secret_id = module.cert_assigned_identity_agw.key_vault_secret_id
  ssl_cert_key_name   = "nicecxone"
  key_vault_id        = local.key_vault_id
}
########################################################################################
####################
#    api-c700.nice-incontact.com
#    c700.nice-incontact.com
#    home-c700.nice-incontact.com
#    incontrol-c700.nice-incontact.com
#
#
#
#


module "agw_cluster_app_agw" {
  depends_on    = [module.cert_assigned_identity_agw]
  source        = "../../../../../modules/azure-network-alb"
  app_gate_name = "cluster-app-agw-c700"
  #sku_name                       =  ["Standard_v2" ,"Standard_v2" ]
  sku_name                       = ["WAF_v2", "WAF_v2"]
  firewall_policy_id             = module.waf_for_cluster.firewall_policy_id
  location                       = local.location
  resource_group                 = local.resource_group_net
  subnet_id                      = azurerm_subnet.public-subnet.id
  gateway_ip_configuration_name  = "cluster-app-gateway-ip-configuration"
  frontend_ip_configuration_name = "cluster-app-agw-feip-2"
  pip_name                       = "cluster-app-agw-pip-2"
  backend_address_pool_name_list = [
    {
      name = local.pool_name_api
    },
    {
      name = local.pool_name_web
    },
  ]
  probe_name_list = [
    {
      name                  = local.probe_name_list[0]
      path                  = "/L7HealthCheck/healthcheck.aspx"
      protocol              = "Http"
      port                  = 80
      backend_settings_port = 80
      cookie_based_affinity = "Enabled"
    },
    {
      name                  = local.probe_name_list[1]
      path                  = "/inContactAPI/healthcheck"
      protocol              = "Http"
      port                  = 80
      backend_settings_port = 80
      cookie_based_affinity = "Disabled"
    },
    {
      name                  = local.probe_name_list[2]
      path                  = "/inContact/healthcheck.aspx"
      protocol              = "Http"
      port                  = 80
      backend_settings_port = 80
      cookie_based_affinity = "Enabled"
    },
    {
      name                  = local.probe_name_list[3]
      path                  = "/incontrol.net/healthcheck.aspx"
      protocol              = "Http"
      port                  = 80
      backend_settings_port = 80
      cookie_based_affinity = "Enabled"
    },
  ]
  #c700.nice-incontact.com
  listener_list = [
    {
      listener_name = format("listener-SSL-%s", local.cluster_listener_name_list[0])
      port_name     = local.port_name_https
      protocol      = local.protocol_https
      host_name     = format("%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    {
      listener_name = format("listener-http-%s", local.cluster_listener_name_list[0])
      port_name     = local.port_name_http
      protocol      = local.protocol_http
      host_name     = format("%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    #api-c700.nice-incontact.com
    {
      listener_name = format("listener-SSL-%s", local.cluster_listener_name_list[1])
      port_name     = local.port_name_https
      protocol      = local.protocol_https
      host_name     = format("api-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    {
      listener_name = format("listener-http-%s", local.cluster_listener_name_list[1])
      port_name     = local.port_name_http
      protocol      = local.protocol_http
      host_name     = format("api-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    #home-c700.nice-incontact.com
    {
      listener_name = format("listener-SSL-%s", local.cluster_listener_name_list[2])
      port_name     = local.port_name_https
      protocol      = local.protocol_https
      host_name     = format("home-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    {
      listener_name = format("listener-http-%s", local.cluster_listener_name_list[2])
      port_name     = local.port_name_http
      protocol      = local.protocol_http
      host_name     = format("home-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    #incontrol-c700.nice-incontact.com
    {
      listener_name = format("listener-SSL-%s", local.cluster_listener_name_list[3])
      port_name     = local.port_name_https
      protocol      = local.protocol_https
      host_name     = format("incontrol-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
    {
      listener_name = format("listener-http-%s", local.cluster_listener_name_list[3])
      port_name     = local.port_name_http
      protocol      = local.protocol_http
      host_name     = format("incontrol-%s.%s", local.cluster-id, data.azurerm_key_vault_secret.external-domain-name.value)
    },
  ]
  request_routing_rule_set = [
    {
      name                  = format("SSL-%s", local.cluster_listener_name_list[0])
      pool_name             = local.pool_name_web
      target_listener_name  = null
      listener_name         = format("listener-SSL-%s", local.cluster_listener_name_list[0])
      backend_http_settings = local.probe_name_list[0]

      redirect           = false
      redirect_conf_name = null
    },
    {
      name                  = format("http-%s", local.cluster_listener_name_list[0])
      pool_name             = local.pool_name_web
      target_listener_name  = format("listener-SSL-%s", local.cluster_listener_name_list[0])
      listener_name         = format("listener-http-%s", local.cluster_listener_name_list[0])
      backend_http_settings = local.probe_name_list[0]
      redirect              = true
      redirect_conf_name    = format("rule-http-%s-redirect", local.cluster_listener_name_list[0])
    },
    {
      name                  = format("SSL-%s", local.cluster_listener_name_list[1])
      pool_name             = local.pool_name_api
      target_listener_name  = null
      listener_name         = format("listener-SSL-%s", local.cluster_listener_name_list[1])
      backend_http_settings = local.probe_name_list[1]
      redirect              = false
      redirect_conf_name    = null
    },
    {
      name                  = format("http-%s", local.cluster_listener_name_list[1])
      pool_name             = local.pool_name_api
      target_listener_name  = format("listener-SSL-%s", local.cluster_listener_name_list[1])
      listener_name         = format("listener-http-%s", local.cluster_listener_name_list[1])
      backend_http_settings = local.probe_name_list[1]
      redirect              = true
      redirect_conf_name    = format("rule-http-%s-redirect", local.cluster_listener_name_list[1])
    },
    {
      name                  = format("SSL-%s", local.cluster_listener_name_list[2])
      pool_name             = local.pool_name_web
      target_listener_name  = null
      listener_name         = format("listener-SSL-%s", local.cluster_listener_name_list[2])
      backend_http_settings = local.probe_name_list[2]
      redirect              = false
      redirect_conf_name    = null
    },
    {
      name                  = format("http-%s", local.cluster_listener_name_list[2])
      pool_name             = local.pool_name_web
      target_listener_name  = format("listener-SSL-%s", local.cluster_listener_name_list[2])
      listener_name         = format("listener-http-%s", local.cluster_listener_name_list[2])
      backend_http_settings = local.probe_name_list[2]
      redirect              = true
      redirect_conf_name    = format("rule-http-%s-redirect", local.cluster_listener_name_list[2])
    },
    {
      name                  = format("SSL-%s", local.cluster_listener_name_list[3])
      pool_name             = local.pool_name_web
      target_listener_name  = null
      listener_name         = format("listener-SSL-%s", local.cluster_listener_name_list[3])
      backend_http_settings = local.probe_name_list[3]
      redirect              = false
      redirect_conf_name    = null
    },
    {
      name                  = format("http-%s", local.cluster_listener_name_list[3])
      pool_name             = local.pool_name_web
      target_listener_name  = format("listener-SSL-%s", local.cluster_listener_name_list[3])
      listener_name         = format("listener-http-%s", local.cluster_listener_name_list[3])
      backend_http_settings = local.probe_name_list[3]
      redirect              = true
      redirect_conf_name    = format("rule-http-%s-redirect", local.cluster_listener_name_list[3])
    },
  ]
  identity_ids        = module.cert_assigned_identity_agw.principal_id
  identity            = [1]
  private_frontend    = []
  key_vault_secret_id = module.cert_assigned_identity_agw.key_vault_secret_id
  ssl_cert_key_name   = "nicecxone"
  key_vault_id        = local.key_vault_id
}

#
#module "lb_storagemigration" {
#  source                         = "../../../../../modules/azure-network-lb"
#  location                       = local.location
#  resource_group                 = local.resource_group_net
#  frontend_ip_configuration_name = "at99-storagemigration-frontend"
#  subnet_id                      = azurerm_subnet.Serverless-subnet.id
#  lb_name                        = "at99-storagemigration-lb"
#  sku                            = "Standard"
#  backend_address_pool_name      = "at99-storagemigration-pool"
#  prob_list                      = [
#                                  {
#                                    probe_name = "at99-storagemigration-probe"
#                                    probe_protocol =  "Http"
#                                    probe_port   =  8888
#                                    probe_interval_in_seconds = 5
#                                    probe_request_path  = "/"
#                                  },
#                                ]
#  rule_list =  [
#                                  {
#                                    rule_name = "at99-storagemigration-rule"
#                                    rule_protocol =  "Tcp"
#                                    rule_backend_port   =  3333
#                                    rule_frontend_port = 3333
#                                  },
#                                ]
#}
#
## aws route A recors
resource "aws_route53_record" "agw_regional_records" {
  zone_id = local.zone_id
  name    = "bi-at"
  type    = "A"
  ttl     = 300
  records = [module.agw_regional_app.agw_public_ip]
}
locals {
  records_name_list = [
    {
      name = "api-c700"
    },
    {
      name = "c700"
    },
    {
      name = "home-c700"
    },
    {
      name = "incontrol-c700"
    },
  ]

  ####### api-c700.nice-incontact.com

  #c700.nice-incontact.com
  #home-c700.nice-incontact.com
  #incontrol-c700.nice-incontact.com
}
resource "aws_route53_record" "luster_app_records" {
  for_each = { for idx, record in local.records_name_list : idx => record }

  zone_id = local.zone_id
  name    = each.value.name
  type    = "A"
  ttl     = 300
  records = [module.agw_cluster_app_agw.agw_public_ip]
}

## waf
module "waf_for_cluster" {
  source         = "../../../../../modules/azure-network-waf"
  location       = local.location
  resource_group = local.resource_group_net
  wafpolicy_name = "waf-for-cluster-policy-prod"
}
##adding rules to waf