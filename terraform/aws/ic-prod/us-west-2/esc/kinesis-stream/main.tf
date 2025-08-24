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
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "kinesis-stream"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "kinesis-stream" {
  source  = "spacelift.io/incontact/orch-aws-terraform-kinesis-stream/default"
  version = "0.0.3"

  region                        = "us-west-2"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production"
  firehose-s3-kms-arn           = "arn:aws:kms:us-west-2:918987959928:key/2f73d783-0f4b-4e24-8fb6-7ff96bb2712a"
  shard_count                   = "8"
}
