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
      Service             = "ssm-digi"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ssm-digi" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ssm-digi/default"
  version = "0.0.5"

  region          = "us-west-2"
  area-id         = "na1"
  cluster-name    = "shared-eks01"
  dns-environment = "perf"
}
