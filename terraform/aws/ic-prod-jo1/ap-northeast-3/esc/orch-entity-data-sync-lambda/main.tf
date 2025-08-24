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
      Service             = "data-sync-lambda"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "orch-entity-data-sync-lambda-terraform-contact-cleanup-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-contact-cleanup-processor/default"
  version = "1.1.0"

  app_version   = "v0.3.0"
  aws-account   = "ic-prod-jo1"
  aws-region    = "ap-northeast-3"
  aws-region-id = "acos"
  s3_bucket     = "acos-entitymanagement"
}

module "orch-entity-data-sync-lambda-terraform-s3-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-s3-processor/default"
  version = "1.0.5"

  app_version   = "v0.3.0"
  aws-account   = "ic-prod-jo1"
  aws-region    = "ap-northeast-3"
  aws-region-id = "acos"
  s3_bucket     = "acos-entitymanagement"
}

module "orch-entity-data-sync-lambda-terraform-stream-processor" {
  source  = "spacelift.io/incontact/orch-entity-data-sync-lambda-terraform-stream-processor/default"
  version = "1.0.5"

  app_version          = "v0.3.0"
  aws-region           = "ap-northeast-3"
  aws-region-id        = "acos"
  s3_bucket            = "acos-entitymanagement"
  lambda-debug-logging = true
}
