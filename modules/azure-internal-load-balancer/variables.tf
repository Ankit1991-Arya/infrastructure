variable "lb_name" {
  description = "Name of Internal Load Balancer"
  type        = string
}
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}
variable "location" {
  description = "Location"
  type        = string
}
variable "sku" {
  description = ""
  type        = string
  default     = "Standard"
}
variable "zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["1", "2", "3"]
}
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}
variable "private_ip_address" {
  description = "Optionally provide a static private IP address to assign to the ILB. Leave blank to have dynamic IP assigned."
  type        = string
  default     = ""
}
variable "backend_address_pool_map" {
  description = "Map of backend pools with lists of NIC IDs to associate."
  type = map(map(object({
    network_interface_id  = string
    ip_configuration_name = string
  })))
  # example = {
  #   "backend_pool_name" = {
  #     instance_key = {
  #       network_interface_id  = module.datawarehouse[instance_key].network_interface_id
  #       ip_configuration_name = module.datawarehouse[instance_key].ip_configuration_name
  #     }
  #   }
  # }
}
variable "lb_probe_map" {
  description = "Map of internal load balancer probes"
  type        = map(any)
  # example = {
  #   "probe_name" = {
  #     protocol            = string # Options: Http or Https or Tcp
  #     port                = number
  #     request_path        = string # Only used with Http or Https
  #     interval_in_seconds = string # minimum: 5 default: 15
  #     number_of_probes    = number # default: 2 (number_of_probes * interval_in_seconds minimum: 10)
  #   }
  # }
}
variable "lb_rule_map" {
  description = "Map of internal load balancer rules"
  type        = map(any)
  # example = {
  #   "rule_name" = {
  #     backend_address_pool_key = string # defaults to first object in var.backend_address_pool_map
  #     lb_probe_key             = string # defaults to first object in var.lb_probe_map
  #     protocol                 = string # default: Tcp
  #     frontend_port            = number
  #     backend_port             = number
  #     enable_floating_ip       = bool # default: true
  #     idle_timeout_in_minutes  = number # default: 4
  #     disable_outbound_snat    = bool # default: false
  #     enable_tcp_reset         = bool # default: false
  #   }
  # }
}
variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}