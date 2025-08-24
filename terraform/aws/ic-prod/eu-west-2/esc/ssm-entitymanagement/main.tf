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
  region = "eu-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "ssm-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ssm-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ssm-entitymanagement/default"
  version = "0.0.3"

  region             = "eu-west-2"
  area-id            = "uk1"
  aws-region-id      = "al"
  cluster-name       = "shared-eks01"
  dns-environment    = "prod"
  global-poc-vcvip   = "vc-l32.vip.inucn.com"
  orchestrator-port  = "entitymanagement-eu1.omnichannel.prod.internal:443"
  settings-s3-prefix = "ic-prod"
}
