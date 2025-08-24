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
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Owner   = "Digital-Workflow"
      Product = "Estimated Wait Time"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "digital-first-workflow-ewt-lambdas-cloudwatch" {
  source  = "spacelift.io/incontact/digital-first-workflow-ewt-lambdas-cloudwatch/default"
  version = "1.0.5"

  sns_email     = "193baeea.niceonline.onmicrosoft.com@amer.teams.ms"
  aws_region_id = "ausy"
  region        = "ap-southeast-2"
}