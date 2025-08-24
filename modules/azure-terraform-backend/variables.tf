# GitHub Actions Variables
variable "AZURE_CLIENT_ID_TEST" {
  type      = string
  sensitive = true
  default   = ""
}
variable "AZURE_CLIENT_SECRET_TEST" {
  type      = string
  sensitive = true
  default   = ""
}
variable "AZURE_SUBSCRIPTION_ID_TEST" {
  type      = string
  sensitive = true
  default   = ""
}
variable "AZURE_TENANT_ID" {
  type      = string
  sensitive = true
  default   = ""
}

variable "location" {
  description = ""
  type        = string
  default     = "SouthCentralUS"
}
variable "tfstate_storage_account_settings" {
  description = ""
  default     = {}
}
variable "tfstate_storage_account_tags" {
  description = ""
  default     = {}
}