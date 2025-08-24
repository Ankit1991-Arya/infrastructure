locals {
  namespace = "logscale"
  #AWS region
  account_region = "ap-southeast-2"
  #AWS account alias
  account_alias                = "iex-preview-ausov1-au2"
  ls_cloudtrail_name           = "${local.account_alias}-cloudtrail-logs"
  ls_guardduty_name            = "${local.account_alias}-guardduty-logs"
  sqs_subs_cloudtraillogs_name = "${local.account_alias}-cloudtraillogs"
  sqs_subs_guarddutylogs_name  = "${local.account_alias}-guarddutylogs"
  #Cross account role for trust policy from sectools-ausov* account
  cross_account_ingest_role = "arn:aws:iam::127214159914:role/logscale_logscale_ingest20250113170914172500000004"
}