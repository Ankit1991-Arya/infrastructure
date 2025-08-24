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
      Service             = "ssm-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ssm-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ssm-entitymanagement/default"
  version = "0.0.3"

  region             = "ap-northeast-2"
  area-id            = "kr1"
  aws-region-id      = "acsl"
  cluster-name       = "shared-eks01"
  dns-environment    = "prod"
  global-poc-vcvip   = "vc-sl26.vip.inucn.com"
  orchestrator-port  = "entitymanagement-kr1.omnichannel.prod.internal:443"
  settings-s3-prefix = "ic-prod"
}
