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
  region = "eu-central-1"
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

  region             = "eu-central-1"
  area-id            = "eu2"
  aws-region-id      = "euft"
  cluster-name       = "shared-eks01"
  dns-environment    = "eusov1"
  global-poc-vcvip   = "vc-ft26.vipeu2.cxsov1.eu"
  orchestrator-port  = "entitymanagement-eu2.omnichannel.eusov1.internal:443"
  settings-s3-prefix = "ic-eusov1"
}
