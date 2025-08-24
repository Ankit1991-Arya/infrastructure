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
      Service             = "data-sync-lambda"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "orch-entity-data-sync-lambda-terraform-contact-cleanup-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-contact-cleanup-processor/default"
  version = "1.1.0"

  app_version   = "v0.3.0"
  aws-account   = "ic-eusov1-eu2"
  aws-region    = "eu-central-1"
  aws-region-id = "euft"
  s3_bucket     = "euft-entitymanagement"
}

module "orch-entity-data-sync-lambda-terraform-s3-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-s3-processor/default"
  version = "1.0.5"

  app_version   = "v0.3.0"
  aws-account   = "ic-eusov1-eu2"
  aws-region    = "eu-central-1"
  aws-region-id = "euft"
  s3_bucket     = "euft-entitymanagement"
}

module "orch-entity-data-sync-lambda-terraform-stream-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-stream-processor/default"
  version = "1.0.5"

  app_version          = "v0.3.0"
  aws-region           = "eu-central-1"
  aws-region-id        = "euft"
  s3_bucket            = "euft-entitymanagement"
  lambda-debug-logging = true
}
