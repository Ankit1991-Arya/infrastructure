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
  region = "ap-northeast-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "sqs-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

#tfsec:ignore:aws-sqs-queue-encryption-use-cmk
module "sqs-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-sqs-entitymanagement/default"
  version = "0.0.3"

  region             = "ap-northeast-1"
  environment-prefix = "aj"
}
