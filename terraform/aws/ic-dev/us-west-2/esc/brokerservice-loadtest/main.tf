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
      Service             = "interaction-broker"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "brokerservice-loadtest" {
  source  = "spacelift.io/incontact/orch-aws-terraform-brokerservice-loadtest-development/default"
  version = "0.0.8"

  environment-prefix = "do"
  region             = "us-west-2"
  parallelism        = 8
  shard_count        = "1"
}
