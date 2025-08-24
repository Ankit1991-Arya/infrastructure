
variable "resource_group" {
  description = "resource_group for resource"
}
variable "location" {
  description = "location "
}
variable "subnet_id" {
  description = "DMZNetwork-PublicSubnet"
}
variable "app_gate_name" {
  description = "appgate_name"
}
variable "frontend_ip_configuration_name" {
  description = "frontend_ip_configuration_nam  "
}
variable "gateway_ip_configuration_name" {
  description = "gateway_ip_configuration_name "
}
variable "pip_name" {
  description = "pip_name"
}
variable "backend_address_pool_name_list" {
  description = "backend_address_pool_list"
}

variable "probe_name_list" {
  description = "probe_name"
}
variable "request_routing_rule_set" {
  description = "request_routing_rule_set"
}
variable "listener_list" {
  description = "listener_list"
}
variable "identity_ids" {
  description = "identity_ids "
}
variable "identity" {
  description = "identity"
}
variable "key_vault_secret_id" {
  description = "key_vault_secret_id "
}
variable "ssl_cert_key_name" {
  description = "ssl_cert_key_name"
}
variable "key_vault_id" {
  description = "key_vault_id"
}
variable "sku_name" {
  description = "sku_name"
}
variable "private_frontend" {
  description = "private_frontend"
}
variable "firewall_policy_id" { ##WAF
  description = "WAF_Policy_id"
}