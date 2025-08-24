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
  default     = "ic-compliance-prod"
}

variable "guardduty_detector_id" {
  description = "Guard Duty detector id"
  type        = string
  default     = "48b4747858499e47b4cf305730e8d3a9"
}