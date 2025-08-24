locals {
  namespace = "logscale"
  #AWS region
  account_region = "us-east-1"
  #AWS account alias
  account_alias               = "fm-fedramp-moderate"
  ls_guardduty_name           = "${local.account_alias}-guardduty-logs"
  sqs_subs_guarddutylogs_name = "${local.account_alias}-guarddutylogs"
  #Cross account role for trust policy from sectools-* account
  cross_account_ingest_role = "arn:aws:iam::975050239252:role/logscale_logscale_ingest20250115212826051600000004"
}