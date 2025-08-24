terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, <= 5.90.1"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "EC2"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  sg_data               = yamldecode(file("./sg_inputs.yaml"))
  ec2_instances_data    = yamldecode(file("./inputs.yaml"))
  resource_gateway_data = yamldecode(file("./resource_gateway.yaml"))
}

module "nexpose_servers" {
  source               = "spacelift.io/incontact/aws_ec2_instances/default"
  version              = "0.1.0"
  ec2_instances_data   = local.ec2_instances_data.ec2_instances_data
  override_ebs_kms_arn = aws_kms_key.nexpose_ebs_kms_key.arn
  depends_on           = [aws_kms_key.nexpose_ebs_kms_key]
}

data "aws_instance" "nexpose_console" {
  instance_id = module.nexpose_servers.instance_id["nexpose-console-fips"]
  depends_on  = [module.nexpose_servers]
}

module "vpc_resource_gateway" {
  source                            = "spacelift.io/incontact/aws_resource_gateway/default"
  version                           = "0.1.1"
  resource_gateway_data             = local.resource_gateway_data.resource_gateway_data
  resource_configuration_ip_address = data.aws_instance.nexpose_console.private_ip
  resource_gateway_security_groups  = [module.rg_aws_security_group["resource-gateway-sg"].sg_id]
  depends_on                        = [module.nexpose_servers, module.rg_aws_security_group]
}

#Security group for Resource Gateway
module "rg_aws_security_group" {
  source                               = "spacelift.io/incontact/aws_security_groups/default"
  version                              = "0.1.0"
  for_each                             = { for key, value in local.sg_data.security-group-data : key => value if value.create_new_security_group == true }
  name                                 = each.value.security_group_name
  vpc_id                               = each.value.vpc_id
  aws_vpc_security_group_ingress_rules = try(each.value.aws_vpc_security_group_ingress_rules, {})
  aws_vpc_security_group_egress_rules  = try(each.value.aws_vpc_security_group_egress_rules, {})
  tags                                 = each.value.tags
}

#Share Nexpose Scan Engine AMI to Sub Accounts
resource "aws_ami_launch_permission" "nexpose_engine_ami_shared" {
  for_each   = local.privatelink_allowed_principals
  image_id   = local.nexpose_scan_engine_AMI_ID
  account_id = each.key
}