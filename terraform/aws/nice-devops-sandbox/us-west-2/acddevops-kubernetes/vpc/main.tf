terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3, < 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "spacelift.io/incontact/acddevops-terraform-modules-eks-vpc/default"
  version = ">= 0.0.1"

  enable_vpc_peering                = false
  environment_availability_zones    = ["us-west-2a", "us-west-2b", "us-west-2c"]
  environment_cidr                  = "10.0.0.0/20"
  environment_instances             = ["01"]
  environment_intra_subnets_cidrs   = ["100.127.0.0/18", "100.127.64.0/18", "100.127.128.0/18"]
  environment_name                  = "shared_eks"
  environment_private_subnets_cidrs = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  environment_public_subnets_cidrs  = ["10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
  environment_vpc_cidr              = "10.0.0.0/20"
  environment_vpc_secondary_cidrs   = ["100.127.0.0/16"]
  tags = {
    CreatedBy = "terraform",
    Module    = "terraform/nice-devops-sandbox/us-west-2/shared_eks/vpc",
    Owner     = "pipelineinfraautomation",
    Product   = "kubernetes",
    Repo      = "https://github.com/inContact/acddevops-kubernetes"
  }
  vgw_create = false
}

output "vpc_outputs" {
  value = module.vpc
}

