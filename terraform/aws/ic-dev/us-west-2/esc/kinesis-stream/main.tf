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
  source  = "spacelift.io/incontact/orch-aws-terraform-kinesis-stream-development/default"
  version = "0.0.3"

  region                        = "us-west-2"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "dev"
  firehose-s3-kms-arn           = "arn:aws:kms:us-west-2:934137132601:key/f57e7869-dac2-4e22-8665-a7b9d14d1723"
  shard_count                   = "2"
}
