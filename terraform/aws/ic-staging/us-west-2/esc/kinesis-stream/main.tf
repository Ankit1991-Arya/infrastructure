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
  dl-bucket-env                 = "staging"
  firehose-s3-kms-arn           = "arn:aws:kms:us-west-2:946153222386:key/d9b66bcd-ed64-44a4-8387-bf51740796cb"
  shard_count                   = "2"
}
