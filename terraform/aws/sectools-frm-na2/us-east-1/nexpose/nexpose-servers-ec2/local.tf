locals {
  #sectools-frm-na2 account information
  sectools_vpc_id          = "vpc-0e656720bd6c65fb3"
  sectools_private_subnets = ["subnet-05e5d04611066b081", "subnet-06377c9cbc6af676b", "subnet-06ced50c37d26beb6"]
  privatelink_allowed_principals = toset([
    "751344753113", #ic-compliance-prod
    "300931244342", #inview-compliance-prod
    "897230022309", #fm-fedramp-moderate
    "169249758722", #illuminate-frm-na2
    "730335349404", #omilia-frm-na2
    "975049966138", #rec-frm-na2
    "767397770115", #supervisor-frm-na2
    "891377221316", #wfm-frm-na2
  ])
  nexpose_private_domain_name = "nexpose.service.nicecxone-gov.com"
  #Create from https://github.com/inContact/acddevops-ansible-packer-playbooks workflow
  nexpose_scan_engine_AMI_ID = "ami-0e0206a80448cfbaa"
}
