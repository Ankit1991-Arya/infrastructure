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
  region = "ap-northeast-2"
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

  region                        = "ap-northeast-2"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-kr"
  firehose-s3-kms-arn           = "arn:aws:kms:ap-northeast-2:814740517824:key/251480f4-6c59-4aa4-a3b2-a1b365488b49"
  shard_count                   = "8"
}
