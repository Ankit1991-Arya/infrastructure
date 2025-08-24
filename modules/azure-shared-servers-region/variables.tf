variable "ic_region_id" {
  description = ""
  type        = string
}
variable "location" {
  description = "Azure region / location for the cluster resource group."
  type        = string
}
variable "vm_size_class" {
  description = "Specify which VM sizing tier ('Prod' or 'PreProd') to use for default Virtual Machine sizes."
  type        = string

  validation {
    condition     = contains(["Prod", "PreProd"], var.vm_size_class)
    error_message = "Valid values are 'Prod' or 'PreProd'."
  }
}
variable "disk_size_class" {
  description = "Specify which disk sizing tier ('Prod' or 'PreProd') to use for data disks."
  type        = string

  validation {
    condition     = contains(["Prod", "PreProd"], var.disk_size_class)
    error_message = "Valid values are 'Prod' or 'PreProd'."
  }
}
variable "bidatamart_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "bmcmonitoring_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "databasemonitor_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "globalweb_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "logicmonitor_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "thousandeyesagentdmz_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "thousandeyesagentinternal_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "tags" {
  description = "Any tags provided here will override tags defined by module."
  type        = map(string)
  default     = {}
}