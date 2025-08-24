terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, <= 5.74.0"
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
      Service             = "Logscale"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  private_link_data = yamldecode(file("./privatelink_inputs.yaml"))
}

module "corenetwork_privatelink_endpoint" {
  source  = "spacelift.io/incontact/aws_privatelink_vpc_endpoint/default"
  version = "0.1.3"
  private_link_data = { for k, a in local.private_link_data.private_link_data_corenetwork : k =>
    merge(a, { security_group_ids = lookup({ logscale-corenetwork = [module.endpoint_aws_security_group["logscale-corenetwork-sg"].sg_id] }, k, a.security_group_ids)
  }) }
  depends_on = [module.endpoint_aws_security_group]
}

module "endpoint_aws_security_group" { # used for vpc_security_group_ids, need to set output to sg_id in security_groups module to use here
  source                               = "spacelift.io/incontact/aws_security_groups/default"
  version                              = "0.1.0"
  for_each                             = { for key, value in local.private_link_data.security-group-data : key => value if value.create_new_security_group == true }
  name                                 = each.value.security_group_name
  vpc_id                               = each.value.vpc_id
  aws_vpc_security_group_ingress_rules = try(each.value.aws_vpc_security_group_ingress_rules, {})
  aws_vpc_security_group_egress_rules  = try(each.value.aws_vpc_security_group_egress_rules, {})
  tags                                 = each.value.tags
}