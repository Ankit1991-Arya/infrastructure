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
  region = "ca-central-1"
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

  region                        = "ca-central-1"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-ca"
  firehose-s3-kms-arn           = "arn:aws:kms:ca-central-1:918987959928:key/dd023c6b-67ab-439e-b4a3-c08b65f52140"
  shard_count                   = "8"
}
