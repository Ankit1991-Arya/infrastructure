terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  data = yamldecode(file("./inputs.yaml"))
}

#
# We are configuring kms for the kinesis streams and then a consumer / generator
#

module "kms" {
  # aka modules/dashboard-kms in repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-kms/default"
  version = "0.5.0"

  environment    = local.data.environment
  sns_topic_name = local.data.sns_topic_name
  org_ids        = local.data.kms_org_ids
  prefix         = local.data.prefix
  tags           = local.data.tags
}

module "aws_kinesis_data_stream" {
  # aka modules/mocks/kinesis_stream in repo
  source  = "spacelift.io/incontact/aws-kinesis-mock-kinesis-stream/default"
  version = "0.2.0"

  kinesis_kms_key_alias    = module.kms.aws_kms_alias_name
  test_kinesis_stream_name = local.data.test_kinesis_stream_name
  prefix                   = local.data.prefix
  tags                     = local.data.tags
}
