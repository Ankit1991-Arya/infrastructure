terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "security_groups" {
  for_each = var.security_groups
  source  = "spacelift.io/incontact/aws_netops_security_group/default"
  version = "0.0.2"

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpcs[each.value.vpc_key].vpc_id

  ingress_rules = [
    for rule in each.value.ingress_rules : {
      description = "${title(each.value.vpc_key)} Subnet"
      from_port   = rule.from_port
      to_port     = rule.to_port
      protocol    = rule.protocol
      cidr_blocks = [
        for idx in rule.cidr_indexes : var.vpcs[each.value.vpc_key].subnet_cidrs[idx]
      ]
    }
  ]

  tags = merge(
    {
      Name = each.value.name
    },
    each.value.tags
  )
}

locals {
  sg_ids_map = {
    for key, mod in module.security_groups :
    key => {
      vpc_key = var.security_groups[key].vpc_key
      id      = mod.security_group_id
    }
  }
}

module "vpc_endpoints" {
  for_each = var.vpc_endpoints
  source  = "spacelift.io/incontact/aws_netops_privatelink_vpc_endpoint/default"
  version = "0.0.2"
  
  vpc_id              = var.vpcs[each.value.vpc_key].vpc_id
  subnet_ids          = var.vpcs[each.value.vpc_key].subnet_ids
  service_name        = each.value.service_name
  security_group_ids  = [local.sg_ids_map[each.value.security_group_key].id]
  private_dns_enabled = each.value.private_dns_enabled
  tags                = each.value.tags
}