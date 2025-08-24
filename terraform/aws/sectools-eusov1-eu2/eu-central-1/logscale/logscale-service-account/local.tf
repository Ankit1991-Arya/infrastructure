locals {
  allow_cross_account_arns = [
    module.ingest-role-actor.iam_role_arn,           #local-account
    "arn:aws:iam::767398074926:role/logscale_actor", #cea-rta-eusov1-eu2
    "arn:aws:iam::727646484279:role/logscale_actor", #cea-rta-eusov1-eu3
    "arn:aws:iam::533267422300:role/logscale_actor", #ic-eusov1-eu2
    "arn:aws:iam::686255955853:role/logscale_actor", #ic-eusov1-eu3
    "arn:aws:iam::038462752189:role/logscale_actor", #iex-eem-eusov1-eu2
    "arn:aws:iam::619071307617:role/logscale_actor", #iex-eem-preview-eusov1-eu2
    "arn:aws:iam::783764587376:role/logscale_actor", #iex-main-eusov1-eu2
    "arn:aws:iam::296062565176:role/logscale_actor", #iex-preview-eusov1-eu2
    "arn:aws:iam::147997152450:role/logscale_actor", #iex-infosec-eusov1-eu2
    "arn:aws:iam::825765408389:role/logscale_actor", #iex-logs-eusov1-eu2
    "arn:aws:iam::084375579700:role/logscale_actor", #iex-sharedservices-eusov1-eu2
    "arn:aws:iam::235494780483:role/logscale_actor", #inview-eusov1-eu3
    "arn:aws:iam::891377152014:role/logscale_actor", #inview-eusov1-eu2
    "arn:aws:iam::851725368241:role/logscale_actor", #mon-eusov1-eu2
    "arn:aws:iam::670958080627:role/logscale_actor", #mon-eusov1-global
    "arn:aws:iam::794038233836:role/logscale_actor", #omilia-eusov1-eu2
    "arn:aws:iam::211125461681:role/logscale_actor", #rec-eusov1-eu2
    "arn:aws:iam::495599744015:role/logscale_actor", #sectools-eusov1-eu2
    "arn:aws:iam::058264282640:role/logscale_actor", #supervisor-eusov1-eu2
    "arn:aws:iam::471112663837:role/logscale_actor", #wfm-eusov1-eu2
    "arn:aws:iam::851725389895:role/logscale_actor", #wfo-eusov1-eu2
    "arn:aws:iam::043309323438:role/logscale_actor", #mon-eusov1-eu3
    "arn:aws:iam::390844753911:role/logscale_actor", #rec-eusov1-eu3
    "arn:aws:iam::872515277309:role/logscale_actor", #supervisor-eusov1-eu3
    "arn:aws:iam::390844757501:role/logscale_actor", #wfm-eusov1-eu3
    "arn:aws:iam::557690609302:role/logscale_actor"  #wfo-eusov1-eu3
  ]
}