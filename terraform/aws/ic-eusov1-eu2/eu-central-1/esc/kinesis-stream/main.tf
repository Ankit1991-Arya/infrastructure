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
  region = "eu-central-1"
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

  region                        = "eu-central-1"
  deploy-findmatch-test-streams = "true"
  dl-bucket-env                 = "production-eusov1"
  firehose-s3-kms-arn           = "arn:aws:kms:eu-central-1:851725389895:key/7bae9a62-6c61-4337-ad36-a6b61b9299c8"
  shard_count                   = "8"
}
