terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  sns_data = yamldecode(file("./inputs.yaml"))
}

module "sns_topics" {
  source = "github.com/inContact/openapm-terraform-modules.git//modules/sns_failure_alerts?ref=SRE-4677-alerting-for-openapm-resource-monitoring"
  # version  = "0.0.1"
  sns_data = local.sns_data.sns_data
}