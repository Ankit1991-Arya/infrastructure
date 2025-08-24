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
  region = "eu-west-2"
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

  region                        = "eu-west-2"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-uk"
  firehose-s3-kms-arn           = "arn:aws:kms:eu-west-2:918987959928:key/1158312a-1f4b-4df5-9873-cb131285bf11"
  shard_count                   = "8"
}
