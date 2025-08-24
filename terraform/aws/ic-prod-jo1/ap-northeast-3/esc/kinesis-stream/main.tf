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
  region = "ap-northeast-3"
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

  region                        = "ap-northeast-3"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-jo"
  firehose-s3-kms-arn           = "arn:aws:kms:ap-northeast-3:692416605838:key/98e26add-da5b-4b00-bc23-37001ec62c7d"
  shard_count                   = "8"
}
