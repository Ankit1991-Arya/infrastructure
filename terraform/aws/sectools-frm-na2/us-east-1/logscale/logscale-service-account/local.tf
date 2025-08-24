locals {
  allow_cross_account_arn = [
    module.ingest-role-actor.iam_role_arn,           #local-account
    "arn:aws:iam::897230022309:role/logscale_actor", #fm-fedramp-moderate
    "arn:aws:iam::169249758722:role/logscale_actor", #illuminate-frm-na2
    "arn:aws:iam::300931244342:role/logscale_actor", #inview-compliance-prod
    "arn:aws:iam::971422711799:role/logscale_actor", #ittools-frm-na2
    "arn:aws:iam::161936459593:role/logscale_actor", #mon-frm-global
    "arn:aws:iam::751344753113:role/logscale_actor", #ic-compliance-prod
    "arn:aws:iam::283828150455:role/logscale_actor", #mon-frm-na2
    "arn:aws:iam::730335349404:role/logscale_actor", #omilia-frm-na2
    "arn:aws:iam::767397770115:role/logscale_actor", #supervisor-frm-na2
    "arn:aws:iam::891377221316:role/logscale_actor", #wfm-frm-na2
    "arn:aws:iam::975049966138:role/logscale_actor"  #rec-frm-na2
  ]

  account_alias                = "sectools-frm-na2"
  ls_cloudtrail_name           = "${local.account_alias}-cloudtrail-logs"
  ls_guardduty_name            = "${local.account_alias}-guardduty-logs"
  sqs_subs_cloudtraillogs_name = "${local.account_alias}-cloudtraillogs"
  sqs_subs_guarddutylogs_name  = "${local.account_alias}-guarddutylogs"
}