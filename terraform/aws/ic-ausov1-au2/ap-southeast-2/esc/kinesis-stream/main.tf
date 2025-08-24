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
  region = "ap-southeast-2"
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

  region                        = "ap-southeast-2"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-ausov1"
  firehose-s3-kms-arn           = "arn:aws:kms:ap-southeast-2:637423329662:key/ca2e6839-6ca7-4677-ab9d-d959fa6f01a9"
  shard_count                   = "8"
}
