terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  config = yamldecode(file("./inputs.yaml"))
}

module "load_testing_instances" {
  source  = "spacelift.io/incontact/load-testing-instances/default"
  version = "0.1.1"

  vpc_id                    = local.config.vpc_id
  subnet_name               = local.config.subnet_name
  instance_count            = local.config.instance_count
  instance_type             = local.config.instance_type
  iam_instance_profile_name = local.config.iam_instance_profile_name
  iam_role_name             = local.config.iam_role_name
  volume_size               = local.config.volume_size
  volume_type               = local.config.volume_type
  instance_name_prefix      = local.config.instance_name_prefix
  security_group_name       = local.config.security_group_name

  tags = local.config.tags
}
