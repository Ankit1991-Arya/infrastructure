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
  region = "us-east-1"
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

  # This is from a Teams channel email created specifically to receive the SNS notifications
  sns_email     = "2fc1766c.niceonline.onmicrosoft.com@amer.teams.ms"
  aws_region_id = "cv"
  region        = "us-east-1"
}