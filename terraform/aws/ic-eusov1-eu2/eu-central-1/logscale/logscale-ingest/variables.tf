variable "namespace" {
  type    = string
  default = "logscale"
}

variable "ls_cloudtrail_name" {
  type    = string
  default = "ic-eusov1-eu2-cloudtrail-logs"
}

variable "ls_guardduty_name" {
  type    = string
  default = "ic-eusov1-eu2-guardduty-logs"
}

variable "sqs_subs_cloudtraillogs_name" {
  type    = string
  default = "ic-eusov1-eu2-cloudtraillogs"
}

variable "sqs_subs_guarddutylogs_name" {
  type    = string
  default = "ic-eusov1-eu2-guarddutylogs"
}

variable "cross_account_ingest_role" {
  type    = string
  default = "arn:aws:iam::495599744015:role/logscale_logscale_ingest20250121201115529700000004"
}
