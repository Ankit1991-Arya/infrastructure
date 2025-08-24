terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "kinesis-stream"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "kinesis-stream" {
  source  = "spacelift.io/incontact/orch-aws-terraform-kinesis-stream/default"
  version = "0.0.3"

  region                        = "eu-west-1"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-iesov1"
  firehose-s3-kms-arn           = "arn:aws:kms:eu-west-1:557690609302:key/785e652f-7c64-4752-a6b7-47f83e5718d2"
  shard_count                   = "8"
}