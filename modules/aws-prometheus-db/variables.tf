variable "alias" {
  description = "Specifies the name or alias to assign to the AWS for Prometheus (AMP) workspace."
  type        = string
}

variable "create_log_group" {
  description = "A boolean flag that determines whether a new CloudWatch log group should be created and associated to the AWS AMP workspace."
  type        = bool
  default     = false
}

variable "log_group_name" {
  description = "Defines the name of the CloudWatch log group intended for association with the AMP workspace (Optional)"
  type        = string
  default     = null
}

variable "log_group_retention" {
  description = "Specifies the retention in days for the CloudWatch log group to be created (Default: 180)"
  type        = number
  default     = 180
}

variable "infrastructure_owner" {
  description = "Name or email address to be used as a value for the 'InfrastructureOwner' tag."
  type        = string
}

variable "application_owner" {
  description = "Name or email address to be used as a value for the 'ApplicationOwner' tag."
  type        = string
  default     = null
}

variable "product" {
  description = "Specifies the product name or identifier to be used as value for the 'Product' tag."
  type        = string
  default     = "Managed Prometheus database"
}

variable "custom_tags" {
  description = "Collection of tags to be applied to all resources created by this module."
  type        = map(string)
  default     = {}
}
