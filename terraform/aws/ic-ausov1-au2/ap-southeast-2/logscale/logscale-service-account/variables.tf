variable "namespace" {
  type    = string
  default = "logscale"
}

variable "ls_cloudtrail_name" {
  type    = string
  default = "ic-ausov1-au2-cloudtrail-logs"
}

variable "ls_guardduty_name" {
  type    = string
  default = "ic-ausov1-au2-guardduty-logs"
}

variable "sqs_subs_cloudtraillogs_name" {
  type    = string
  default = "ic-ausov1-au2-cloudtraillogs"
}

variable "sqs_subs_guarddutylogs_name" {
  type    = string
  default = "ic-ausov1-au2-guarddutylogs"
}

variable "cross_account_ingest_role" {
  type    = string
  default = "arn:aws:iam::127214159914:role/logscale_logscale_ingest20250113170914172500000004"
}
