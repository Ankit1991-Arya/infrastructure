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
      Service             = "cw-queries-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "cw-queries-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-cw-queries-entitymanagement/default"
  version = "0.0.3"

  region = "me-central-1"
}
