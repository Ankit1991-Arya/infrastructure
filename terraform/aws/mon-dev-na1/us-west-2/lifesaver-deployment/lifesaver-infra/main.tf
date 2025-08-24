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

module "lifesaver-infra" {
  source  = "spacelift.io/incontact/lifesaver-infra/default"
  version = "0.2.1"

  sns_topic_subscriptions = local.config.sns_topic_subscriptions
  lambda_name             = local.config.lambda_name
  queue_name              = local.config.queue_name
  dlq_name                = local.config.dlq_name
  role_name               = local.config.role_name
  aws_region              = local.config.aws_region
  lambda_memory_megabytes = local.config.lambda_memory_megabytes
  lambda_debug_logging    = local.config.lambda_debug_logging
  secret_name             = local.config.secret_name
  vpc_id                  = local.config.vpc_id
  subnet_ids              = local.config.subnet_ids
  fips_compliant          = local.config.fips_compliant
  tags                    = local.config.tags
}