terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
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
      Service             = "kms"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "kms" {
  source  = "spacelift.io/incontact/orch-aws-terraform-kms/default"
  version = "0.0.3"

  region = "ap-northeast-2"
}
