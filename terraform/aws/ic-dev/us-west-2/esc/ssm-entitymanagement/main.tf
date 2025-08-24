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
      Service             = "ssm-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ssm-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ssm-entitymanagement-development/default"
  version = "0.0.3"

  region             = "us-west-2"
  area-id            = "na1"
  aws-region-id      = "do"
  cluster-name       = "shared-eks01"
  dns-environment    = "dev"
  global-poc-vcvip   = "doa-c66cor01.in.lab"
  orchestrator-port  = "9885"
  settings-s3-prefix = "ic-dev"
}
