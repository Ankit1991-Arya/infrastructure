variable "namespace" {
  type    = string
  default = "logscale"
}

variable "ls_cloudtrail_arn" {
  type    = string
  default = "arn:aws:s3:::ic-staging-cloudtrail-logs"
}

variable "ls_cloudtrail_name" {
  type    = string
  default = "ic-staging-cloudtrail-logs"
}

variable "ls_guardduty_arn" {
  type    = string
  default = "arn:aws:s3:::ic-staging-guardduty-logs"
}

variable "ls_guardduty_name" {
  type    = string
  default = "ic-staging-guardduty-logs"
}

variable "sqs_subs_cloudtraillogs_name" {
  type    = string
  default = "ic-staging-cloudtraillogs"
}

variable "sqs_subs_guarddutylogs_name" {
  type    = string
  default = "ic-staging-guarddutylogs"
}

variable "cross_account_ingest_role" {
  type    = string
  default = "arn:aws:iam::992382563823:role/logscale_logscale_ingest20240717205444987000000006"
}

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
  default     = "ic-staging"
}