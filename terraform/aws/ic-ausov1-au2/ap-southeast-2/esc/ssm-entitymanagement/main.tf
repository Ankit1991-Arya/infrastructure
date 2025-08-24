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
  region = "ap-southeast-2"
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

  region             = "ap-southeast-2"
  area-id            = "au2"
  aws-region-id      = "ausy"
  cluster-name       = "shared-eks01"
  dns-environment    = "ausov1"
  global-poc-vcvip   = "vc-sy26.vipau2.cxsov1.au"
  orchestrator-port  = "entitymanagement-au2.omnichannel.ausov1.internal:443"
  settings-s3-prefix = "ic-ausov1"
}
