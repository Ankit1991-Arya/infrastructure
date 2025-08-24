variable "guard_duty_enabled" {
  description = "Flag to enable/disable AWS Guard Duty"
  type        = bool
  default     = true
}

variable "guard_duty_s3_bucket_enabled" {
  description = "Flag to enable/disable AWS Guard Duty S3 Bucket"
  type        = bool
  default     = true
}

variable "account_alias" {
  description = "Account alias for bucket name creation."
  type        = string
  default     = "supervisor-frm-na2"
}