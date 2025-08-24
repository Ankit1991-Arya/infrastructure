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

locals {
  config = yamldecode(file("./inputs.yaml"))
}

module "testing_lambda" {
  source  = "spacelift.io/incontact/testing_lambda/default"
  version = "1.0.0"

  lambda_name = local.config.lambda_name
  role_name   = local.config.role_name
  aws_region  = local.config.aws_region
  # lambda_debug_logging    = local.config.lambda_debug_logging
  vpc_id             = local.config.vpc_id
  subnet_ids         = local.config.subnet_ids
  security_group_ids = local.config.security_group_ids
  tags               = local.config.tags
}