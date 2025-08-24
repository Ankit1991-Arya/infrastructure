variable "virtual_machine_resource_name" {
  description = "Name of the Windows virtual machine."
  type        = string

  validation {
    condition     = length(var.virtual_machine_resource_name) <= 64
    error_message = "Virtual Machine resource name must be 64 or fewer characters."
  }
}
variable "virtual_machine_computer_name" {
  description = "Specifies the Hostname which should be used for this Virtual Machine. If unspecified, this module will attempt to use virtual_machine_resource_name or a variation thereof."
  type        = string
  default     = ""
}
variable "resource_group_name" {
  description = "Name of the resource group in which the windows virtual machine should exist."
  type        = string
}
variable "location" {
  description = "Azure location where the Windows Virtual Machine should exist."
  type        = string
}
variable "virtual_machine_size" {
  description = "The SKU which should be used for this Virtual Machine."
  type        = string
}
variable "admin_username" {
  description = "Local administrator username."
  type        = string
  default     = "inlocadmin"
}
variable "admin_ssh_key" {
  description = "Public SSH key for admin user. If not specified, it will be automatically generated."
  type        = string
  default     = ""
}
variable "source_image_id" {
  description = "The Image ID / Shared Image [Version] ID / Community Gallery Image [Version] ID / Shared Gallery Image [Version] ID value of the Image which this Virtual Machine should be created from."
  type        = string
  default     = ""
}
variable "source_image_reference" {
  description = "Map of source image reference."
  type = object(
    {
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }
  )
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
variable "os_disk_type" {
  description = ""
  type        = string
  default     = "Premium_LRS"
}
variable "os_disk_size" {
  description = ""
  type        = number
  default     = null
}
variable "os_disk_caching" {
  description = ""
  type        = string
  default     = "ReadWrite"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "Valid values are 'None', 'ReadOnly', or 'ReadWrite'."
  }
}
variable "data_disk_map" {
  description = "Provide a map of data disks to create and attach to the virtual machine. Attributes include name, storage_account_type (defaults to Premium_LRS), create_option (defaults to empty), disk_size_gb, lun, and caching."
  default     = {}
}
variable "diagnostics_storage_account_uri" {
  description = "Leaving blank or null will deploy a managed diagnostics storage account."
  type        = string
  default     = ""
}
variable "availability_zone" {
  description = "Specifies the availabilty zone ('1' or '2') in which the Virtual Machine should exist."
  type        = string
  default     = ""

  validation {
    condition     = contains(["1", "2"], var.availability_zone)
    error_message = "Please specify zone 1 ('1') or zone 2 ('2')."
  }
}
variable "availability_set_id" {
  description = "Optionally specifies the ID of an Availability Set in which the Virtual Machine should exist."
  type        = string
  default     = null
}
variable "proximity_placement_group_id" {
  description = ""
  default     = null
}
variable "patch_mode" {
  description = ""
  type        = string
  default     = "ImageDefault" # Okay to swich to "AutomaticByPlatform"?

  validation {
    condition     = contains(["ImageDefault", "AutomaticByPlatform"], var.patch_mode)
    error_message = "Valid values are 'ImageDefault' or 'AutomaticByPlatform'."
  }
}
variable "system_assigned_identity" {
  description = ""
  type        = bool
  default     = false
}
variable "user_assigned_identity_ids" {
  description = ""
  type        = list(string)
  default     = []
}
variable "custom_data" {
  description = ""
  type        = string
  default     = ""
}
variable "gallery_applications_map" {
  description = "Map of gallery applications to be installed."
  type        = map(any)
  default     = {}
}
variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}
# Networking-related variables
variable "ip_configuration_name" {
  description = "Name of ipconfiguration"
  type        = string
  default     = "ipconfig1"
}
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}
variable "private_ip_address_allocation" {
  description = ""
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Static", "Dynamic"], var.private_ip_address_allocation)
    error_message = "Valid values are either 'Static' or 'Dynamic'."
  }
}
variable "private_ip_address" {
  description = ""
  default     = null
}
variable "enable_accelerated_networking" {
  description = ""
  type        = bool
  default     = false
}
variable "network_interface_dns_servers" {
  description = "Override the virtual network DNS servers with a list of DNS servers for this Virtual Machine's network interface."
  default     = null
}
variable "associate_application_security_group" {
  description = "Boolean to specify whether to associate the NIC with an ASG"
  type        = bool
  default     = false
}
variable "application_security_group_id" {
  description = ""
  type        = string
  default     = ""
}
variable "network_security_group_id" {
  description = ""
  type        = string
}

# Chef bootstrap extension variables
variable "chef_bootstrap" {
  description = "Enable implementation of Chef bootstrap extension."
  type        = bool
  default     = false
}
variable "chef_runlist" {
  description = ""
  type        = string
  default     = ""
}
variable "chef_server_url" {
  description = "Chef server URL"
  type        = string
  default     = "https://<ChefServer-Name>.<RegionConfig-DomainName>/organizations/incontact"
}
variable "chef_environment" {
  description = "Chef environment"
  type        = string
  default     = "Development"
}
variable "chef_validation_key" {
  description = "The contents of your organization validator key, the format is either plaintext or base64 encoded (see validation_key_format)."
  type        = string
  default     = ""
}
variable "chef_server_crt" {
  description = "The SSL certificate of your Chef Infra Server that will be added to the trusted certificates."
  type        = string
  default     = ""
}
