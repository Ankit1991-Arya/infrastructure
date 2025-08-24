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
  region = "eu-west-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "ssm-digi"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ssm-digi" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ssm-digi/default"
  version = "0.0.5"

  region          = "eu-west-1"
  area-id         = "eu3"
  cluster-name    = "shared-eks01"
  dns-environment = "eusov1"
}

