locals {
  allow_cross_account_arn = [
    module.ingest-role-actor.iam_role_arn,                                     #local-account
    "arn:aws:iam::637423616941:role/logscale_actor20250327164114947400000006", #ic-ausov1-au2
    "arn:aws:iam::211125518981:role/logscale_actor",                           #cea-rta-ausov1-au2
    "arn:aws:iam::886436949630:role/logscale_actor",                           #iex-eem-ausov1-au2
    "arn:aws:iam::539247469891:role/logscale_actor",                           #iex-eem-preview-ausov1-au2
    "arn:aws:iam::039612884580:role/logscale_actor",                           #iex-main-ausov1-au2
    "arn:aws:iam::135808957669:role/logscale_actor",                           #iex-preview-ausov1-au2
    "arn:aws:iam::664418989257:role/logscale_actor",                           #iex-infosec-ausov1-au2
    "arn:aws:iam::831926617351:role/logscale_actor",                           #iex-logs-ausov1-au2
    "arn:aws:iam::842675971706:role/logscale_actor",                           #iex-sharedservices-ausov1-au2
    "arn:aws:iam::637423201907:role/logscale_actor",                           #mon-ausov1-au2
    "arn:aws:iam::570851831933:role/logscale_actor",                           #mon-ausov1-global
    "arn:aws:iam::438465139399:role/logscale_actor",                           #omilia-ausov1-au2
    "arn:aws:iam::767397942707:role/logscale_actor",                           #rec-ausov1-au2
    "arn:aws:iam::381492156597:role/logscale_actor",                           #supervisor-ausov1-au2
    "arn:aws:iam::654654429736:role/logscale_actor",                           #wfm-ausov1-au2
    "arn:aws:iam::637423329662:role/logscale_actor",                           #wfo-ausov1-au2
    "arn:aws:iam::211125341997:role/logscale_actor"                            #inview-ausov1-au2
  ]

  account_alias                = "sectools-ausov1-au2"
  ls_cloudtrail_name           = "${local.account_alias}-cloudtrail-logs"
  ls_guardduty_name            = "${local.account_alias}-guardduty-logs"
  sqs_subs_cloudtraillogs_name = "${local.account_alias}-cloudtraillogs"
  sqs_subs_guarddutylogs_name  = "${local.account_alias}-guarddutylogs"
}