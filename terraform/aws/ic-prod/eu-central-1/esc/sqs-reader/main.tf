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
      Service             = "sqs-reader"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}


#tfsec:ignore:aws-ec2-no-public-egress-sgr
#tfsec:ignore:aws-sqs-queue-encryption-use-cmk Using AWS Managed Key instead of Customer Managed Key
module "sqs-reader" {
  source  = "spacelift.io/incontact/orch-entity-sqs-reader/default"
  version = "0.0.5"

  app-version   = "v0.3.0"
  s3-bucket     = "af-entitymanagement"
  aws-region    = "eu-central-1"
  aws-region-id = "af"
  environment   = "prod"
}
