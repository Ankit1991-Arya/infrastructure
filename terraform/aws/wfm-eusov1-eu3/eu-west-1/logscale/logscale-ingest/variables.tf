variable "namespace" {
  type    = string
  default = "logscale"
}

variable "ls_cloudtrail_name" {
  type    = string
  default = "wfm-eusov1-eu3-cloudtrail-logs"
}

variable "ls_guardduty_name" {
  type    = string
  default = "wfm-eusov1-eu3-guardduty-logs"
}

variable "sqs_subs_cloudtraillogs_name" {
  type    = string
  default = "wfm-eusov1-eu3-cloudtraillogs"
}

variable "sqs_subs_guarddutylogs_name" {
  type    = string
  default = "wfm-eusov1-eu3-guarddutylogs"
}

variable "cross_account_ingest_role" {
  type    = string
  default = "arn:aws:iam::495599744015:role/logscale_logscale_ingest20250121201115529700000004"
}
