locals {
  sectools_vpc_id          = "vpc-02d703b60270f7f52"
  sectools_private_subnets = ["subnet-081e51aaad0b12044", "subnet-0c854c5e4fefd786c", "subnet-0b965a1ecebe9d684"]
  privatelink_allowed_principals = toset([
    "147997157422", #ic-uksov1-uk2
    "396608801543"  #omilia-uksov1-uk2
  ])
  #Create from https://github.com/inContact/acddevops-ansible-packer-playbooks workflow
  nexpose_scan_engine_AMI_ID = "ami-0329c039ffeba9caa"
}
