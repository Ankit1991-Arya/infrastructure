terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner   = "Digital-Workflow"
      Product = "Estimated Wait Time"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "digital-first-workflow-ewt-lambdas-elasticache" {
  source  = "spacelift.io/incontact/digital-first-workflow-ewt-lambdas-elasticache/default"
  version = "1.0.2"

  vpc_name_common      = "CoreNetwork"
  common_user_group_id = "ewt-user-group-eu2"
}