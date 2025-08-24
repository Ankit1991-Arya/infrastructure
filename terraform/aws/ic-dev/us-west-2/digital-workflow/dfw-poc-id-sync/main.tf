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
      Environment = "dev"
      Owner       = "Digital First - Integrations"
      Product     = "POCIdSync"
      Repository  = "https://github.com/inContact/infrastructure-live"
    }
  }
}

module "digital_first_workflow_poc_id_sync" {
  source                = "spacelift.io/incontact/digital-first-workflow-dfo-poc-updater-lambda-modules/default"
  version               = ">= 0.1.0"
  aws_use_fips_endpoint = "true"
  aws_region_id         = "do"
}
