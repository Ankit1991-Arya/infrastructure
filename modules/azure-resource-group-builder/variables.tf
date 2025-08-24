variable "ic-region-id" {
  description = "CXone region ID - https://nice-ce-cxone-prod.atlassian.net/wiki/spaces/IN/pages/15569918/Region+IDs"
  type        = string
  default     = "" # As we have introduced two more variables for system and area id, we can make this optional
}

variable "location" {
  type = string
}

variable "resource_groups_map" {
  default = {
    "networkinfra" = {
      tags = {
        ApplicationOwner    = "Network Teams"
        InfrastructureOwner = "Network Teams"
      }
    }
    "networksecurity" = {
      tags = {
        ApplicationOwner    = "Network Teams"
        InfrastructureOwner = "Network Teams"
      }
    }
    "regionconfig" = {
      tags = {
        ApplicationOwner    = "Systems Teams"
        InfrastructureOwner = "Systems Teams"
        Product             = "Infrastructure"
      }
    }
    "domaincontrollers" = {
      tags = {
        ApplicationOwner    = "Systems Teams"
        InfrastructureOwner = "Systems Teams"
        Product             = "Infrastructure"
      }
    }
  }
  description = "The names of resources groups to be created "
  type        = any
}

variable "resource_groups_system_map" {
  description = "The names of resources groups to be created with system id"
  type        = any
  default     = {}
}

variable "resource_groups_area_map" {
  description = "The names of resources groups to be created with area id"
  type        = any
  default     = {}
}

variable "repository_role_assignment" {
  description = "The names of application set and role assignment groups that needs to be attached with it"
  type        = any
  default     = {}
}