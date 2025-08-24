variable "ic_region_id" {
  description = ""
  type        = string
}
variable "location" {
  description = "Azure region / location for the cluster resource group."
  type        = string
}
variable "cluster_id" {
  description = ""
  type        = string
}
variable "vm_size_class" {
  description = "Specify which VM sizing tier ('Prod', 'PreProd', or 'Dev') to use for default Virtual Machine sizes."
  type        = string

  validation {
    condition     = contains(["Prod", "PreProd", "Dev"], var.vm_size_class)
    error_message = "Valid values are 'Prod', 'PreProd', or 'Dev'."
  }
}
variable "disk_size_class" {
  description = "Specify which disk sizing tier ('Prod', 'PreProd', or 'Dev') to use for data disks."
  type        = string

  validation {
    condition     = contains(["Prod", "PreProd", "Dev"], var.disk_size_class)
    error_message = "Valid values are 'Prod', 'PreProd', or 'Dev'."
  }
}
variable "default_source_image_reference" {
  description = "Map to specify the Azure Marketplace VM image to use for deployed VMs."
  type = object(
    {
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }
  )
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter"
    version   = "latest"
  }
}
variable "api_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "bitube_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "core_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "datawarehouse_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "media_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "storagemigration_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "web_instance_map" {
  description = ""
  type        = map(any)
  default     = {}
}
variable "tags" {
  description = "Any tags provided here will override tags defined by module."
  type        = map(string)
  default     = {}
}