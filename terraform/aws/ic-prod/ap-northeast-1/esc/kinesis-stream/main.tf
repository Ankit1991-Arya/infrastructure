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
  region = "ap-northeast-1"
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

  region                        = "ap-northeast-1"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-jp"
  firehose-s3-kms-arn           = "arn:aws:kms:ap-northeast-1:918987959928:key/83f222b6-62d0-4deb-8b62-14c40a4d3cf5"
  shard_count                   = "8"
}
