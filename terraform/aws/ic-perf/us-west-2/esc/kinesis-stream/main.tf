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
  dl-bucket-env                 = "perf-wcx"
  firehose-s3-kms-arn           = "arn:aws:kms:us-west-2:636107004818:key/0bc0faca-60d4-4a24-87f4-0ee44cf799c9"
  shard_count                   = "8"
}
