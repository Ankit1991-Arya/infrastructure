#Core Network Variables

variable "core_vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = ["10.230.0.0/21"]
  type        = list(string)
}
variable "core_subnet" {
  description = "Cidr for Core Subnet"
  default     = ["10.230.0.0/23"]
  type        = list(string)
}

variable "vip_subnet" {
  description = "Cidr for VIP Subnet"
  default     = ["10.230.2.0/24"]
  type        = list(string)
}
variable "mgmt_subnet" {
  description = "Cidr for MGMT Subnet"
  default     = ["10.230.3.0/25"]
  type        = list(string)
}
variable "gw_subnet" {
  description = "Cidr for Gateway Subnet"
  default     = ["10.230.3.128/25"]
  type        = list(string)
}
variable "serverless_subnet" {
  description = "Cidr for serverless_subnett"
  default     = ["10.230.4.0/22"]
  type        = list(string)
}

variable "core_service_endpoints" {
  description = "Service endpoints to add to the firewall subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}
variable "dmz_vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = ["10.230.8.0/21"]
  type        = list(string)
}
variable "dmz_subnet" {
  description = "Cidr for DMZ Subnet"
  default     = ["10.230.8.0/23"]
  type        = list(string)
}
variable "public_subnet" {
  description = "Cidr for public Subnet"
  default     = ["10.230.10.0/24"]
  type        = list(string)
}
variable "dmz_gw_subnet" {
  description = "Cidr for Gateway Subnet"
  default     = ["10.230.12.128/25"]
  type        = list(string)
}
variable "dmz_service_endpoints" {
  description = "Service endpoints to add to the firewall subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}

variable "security_vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = ["10.230.16.0/24"]
  type        = list(string)
}

variable "security_untrust_subnet" {
  description = "Cidr for untrust Subnet"
  default     = ["10.230.16.0/28"]
  type        = list(string)
}
variable "security_trust_subnet" {
  description = "Cidr for trust Subnet"
  default     = ["10.230.16.16/28"]
  type        = list(string)
}
variable "security_mgmt_subnet" {
  description = "Cidr for mgmt Subnet"
  default     = ["10.230.16.32/28"]
  type        = list(string)
}
variable "security_gateway_subnet" {
  description = "Cidr for gateway_subnet"
  default     = ["10.230.16.128/27"]
  type        = list(string)
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  type        = list(string)
  default     = ["10.230.0.5", "10.230.0.4"]
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}