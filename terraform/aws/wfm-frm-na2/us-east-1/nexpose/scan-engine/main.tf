terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, <= 5.88.0"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "Nexpose"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  sg_data            = yamldecode(file("./sg_inputs.yaml"))
  ec2_instances_data = yamldecode(file("./ec2_inputs.yaml"))
  private_link_data  = yamldecode(file("./privatelink_inputs.yaml"))
}

module "resource_privatelink_endpoint" {
  source  = "spacelift.io/incontact/aws_privatelink_vpc_endpoint/default"
  version = "0.1.4"
  private_link_data = { for k, a in local.private_link_data.private_link_data : k =>
    merge(a, { security_group_ids = lookup({ nexpose-console = [module.endpoint_aws_security_group["nexpose-console-sg"].sg_id] }, k, a.security_group_ids)
  }) }
  depends_on = [module.endpoint_aws_security_group]
}

module "endpoint_aws_security_group" { # used for vpc_security_group_ids, need to set output to sg_id in security_groups module to use here
  source                               = "spacelift.io/incontact/aws_security_groups/default"
  version                              = "0.1.0"
  for_each                             = { for key, value in local.sg_data.security-group-data : key => value if value.create_new_security_group == true }
  name                                 = each.value.security_group_name
  vpc_id                               = each.value.vpc_id
  aws_vpc_security_group_ingress_rules = try(each.value.aws_vpc_security_group_ingress_rules, {})
  aws_vpc_security_group_egress_rules  = try(each.value.aws_vpc_security_group_egress_rules, {})
  tags                                 = each.value.tags
}

module "nexpose_engine_servers" {
  source               = "spacelift.io/incontact/aws_ec2_instances/default"
  version              = "0.1.0"
  ec2_instances_data   = local.ec2_instances_data.ec2_instances_data
  override_ebs_kms_arn = aws_kms_key.nexpose_ebs_kms_key.arn
  depends_on           = [module.nexpose_ec2_instance_profile_role, aws_kms_key.nexpose_ebs_kms_key]
}