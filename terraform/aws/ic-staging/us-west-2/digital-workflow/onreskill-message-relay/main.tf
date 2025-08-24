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
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "staging"
      Owner       = "Digital-Workflow"
      Product     = "OnReskillDigital"
      Repository  = "https://github.com/inContact/infrastructure-live"
    }
  }
}

module "digital_first_workflow_onreskill_message_relay" {
  source  = "spacelift.io/incontact/digital-first-workflow-onreskill-message-relay-lambda-modules/default"
  version = ">= 0.1.0"

  aws_region_id = "so"
}