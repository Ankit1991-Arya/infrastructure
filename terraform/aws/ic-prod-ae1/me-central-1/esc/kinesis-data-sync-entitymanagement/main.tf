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
  region = "me-central-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "kinesis-data-sync-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "kinesis-data-sync-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-kinesis-data-sync-entitymanagement/default"
  version = "0.0.5"

  region = "me-central-1"
}
