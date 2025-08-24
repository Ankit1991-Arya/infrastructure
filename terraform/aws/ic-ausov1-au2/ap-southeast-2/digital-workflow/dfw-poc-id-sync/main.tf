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
      Product = "POCIdSync"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "digital_first_workflow_poc_id_sync" {
  source  = "spacelift.io/incontact/digital-first-workflow-dfo-poc-updater-lambda-modules/default"
  version = "0.2.39"

  aws_region_id     = "ausy"
  kinesis_region_id = "sy"
  image_tag         = "c990515db7716e5e56de18095239ed5926eb1f67"
}