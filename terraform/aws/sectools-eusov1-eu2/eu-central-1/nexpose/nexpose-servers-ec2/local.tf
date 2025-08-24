locals {
  #sectools-frm-na2 account information
  sectools_vpc_id          = "vpc-04af41a12c4911516"
  sectools_private_subnets = ["subnet-0fa3f33fbd6f82ab9", "subnet-0a59644632951783a", "subnet-0994c3ec29a33fb9a"]
  privatelink_allowed_principals = toset([
    "533267422300" #ic-eusov1-eu1
  ])
  nexpose_private_domain_name = "nexpose.service.nicecxone-sov1.eu"
  #Create from https://github.com/inContact/acddevops-ansible-packer-playbooks workflow
  nexpose_scan_engine_AMI_ID = "ami-0c7afdb051afda169"
}
