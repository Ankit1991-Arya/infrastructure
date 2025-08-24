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
      Service             = "sqs-to-kafka-lambda"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "sqs-to-kafka-lambda" {
  source  = "spacelift.io/incontact/orch-entity-sqs-to-kafka-lambda/default"
  version = "0.1.5"

  app-version      = "v0.3.0"
  s3-bucket        = "af-entitymanagement"
  aws-region       = "eu-central-1"
  aws-region-id    = "af"
  msk-cluster-name = "shared-msk01-eu-central-1"
}
