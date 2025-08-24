terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-west-2"
}

#locals {
#  config = yamldecode(file("./inputs.yaml"))
#}
#
#module "grafana_rds" {
#  source                 = "spacelift.io/incontact/openapm-grafana-rds/default"
#  version                = "0.0.36"
#  availability_zones     = local.config.availability_zones
#  private_subnet_ids     = local.config.shared_eks_private_subnets
#  vpc_security_group_ids = local.config.vpc_security_group_ids
#  tags                   = local.config.tags
#}
