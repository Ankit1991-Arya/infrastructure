locals {
  sectools_vpc_id          = "vpc-01458e7bfa2e2d803"
  sectools_private_subnets = ["subnet-05fde233563fa0106", "subnet-0db30aab87abe6068", "subnet-045eac886c490a143"]
  privatelink_allowed_principals = toset([
    "545209810301", #ic-staging
    "265671366761", #ic-test
    "300813158921", #ic-dev
    "339713029084"  #omilia-staging
  ])
  nexpose_private_domain_name = "nexposepoc.service.nicecxone-staging.com"
  #Create from https://github.com/inContact/acddevops-ansible-packer-playbooks workflow
  nexpose_scan_engine_AMI_ID = "ami-076fd6d797a9c51c6"
}
