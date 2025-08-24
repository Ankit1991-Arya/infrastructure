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
      Service             = "Failure Queue"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "failure-queue" {
  source  = "spacelift.io/incontact/orch-entity-failure-queue/default"
  version = "0.0.19"

  app-version          = "v0.6.0"
  s3-bucket            = "acsl-entitymanagement"
  alarm-sns-topic-name = "entitymanagement_alerts_account_prod"
  aws-region           = "ap-northeast-2"
  dynamodb-table-name  = "entitymanagement-state"
  debug-logging        = true
  env-prefix           = "acsl"
}
