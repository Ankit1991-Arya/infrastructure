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
      Service             = "ecr"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "ecr" {
  source  = "spacelift.io/incontact/orch-aws-terraform-ecr-development/default"
  version = "0.0.4"

  region     = "us-west-2"
  repo-names = ["entity-kafdrop", "kafka-connect-custom", "create-topics", "cruise-control"]
}
