
variable "resource_group" {
  description = "resource_group for resource"
}
variable "location" {
  description = "location"
}
variable "zoneid" {
  default = ["a", "b"]
}
variable "number" {
  default = ["1", "1"]
}

variable "key_vault_id" {
  description = "key_vault_id"
}

variable "zones" {
  default = ["1", "2"]
}

variable "security-palo-trust-subnet" {

}
variable "security-palo-mgmnt-subnet" {
  description = "security-fw-mgmnt-subnet"
}
variable "security-palo-untrust-subnet" {
  description = "security-fw-untrust-subnet"
}

variable "trust-int-name" {
  description = "trust-int-name"
}
variable "mgmnt-int-name" {
  description = "mgmnt-int-name"
}
variable "untrust-int-name" {
  description = "untrust-int-name"
}
variable "image-version" {
  description = "image-version"
}
variable "vm_size" {
  description = " vm_size"
}
variable "ng_network_paloalto_int_nsg_id" {
  description = " ng_network_paloalto_int_nsg"
}
variable "ng_network_paloalto_mgmnt_nsg_id" {
  description = "ng_network_paloalto_mgmnt_nsg"
}
variable "backend_address_pool_id_for_lb" {
  description = "backend_address_pool_id"
}
