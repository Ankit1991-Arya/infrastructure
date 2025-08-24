terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53.0"
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
      Service             = "ecr"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ecr" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ecr/default"
  version = "0.0.3"

  region     = "us-west-2"
  repo-names = ["kafdrop"]
}
