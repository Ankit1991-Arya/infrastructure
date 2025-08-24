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
      Service             = "kms"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "kms" {
  source  = "spacelift.io/incontact/orch-aws-terraform-kms-development/default"
  version = "0.0.6"

  region = "us-west-2"
}
