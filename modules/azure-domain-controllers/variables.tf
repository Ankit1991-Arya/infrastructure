variable "ic-region-id" {
  description = "Region ID to use to pull environment variables from Azure Key Vault(s)."
  type        = string
}
variable "instance_list" {
  description = "List of domain controller VMs to create. Specified to allow for selective/specific removal/replacements."
  type        = list(any)
  default     = []
}
variable "virtual_machine_size" {
  description = "Azure VM size of the domain controllers."
  type        = string
  default     = "Standard_D4s_v5"
}
variable "source_image_reference" {
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
variable "enable_accelerated_networking" {
  description = "Bool to enable accelerated networking feature on VM NIC (set to false as it's not supported on some VM sizes)."
  type        = bool
  default     = false
}
variable "ad_ou_path" {
  description = "Path to organizational unit within Active Directory to place newly-joined virtual machines. Blank goes to default OU."
  type        = string
  default     = ""
}
variable "tags" {
  description = "Map of tags to override the default tags applied to all domain controller VMs."
  type        = map(string)
  default     = {}
}
