locals {
  #sectools-ausov1-au2 account information
  sectools_vpc_id          = "vpc-0d246739cef8c1535"
  sectools_private_subnets = ["subnet-01b51000c9c969f3a", "subnet-0ce77c1a1497364ce", "subnet-040cae1a1478a6556"]
  privatelink_allowed_principals = toset([
    "637423616941", #ic-ausov1-au2
    "438465139399"  #omilia-ausov1-au2
  ])
  nexpose_private_domain_name = "nexpose.service.nicecxone-sov1.au"
  #Create from https://github.com/inContact/acddevops-ansible-packer-playbooks workflow
  nexpose_scan_engine_AMI_ID = "ami-061bae99c6a0cf88d"
}
