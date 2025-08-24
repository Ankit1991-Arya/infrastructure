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
  alerts_data = yamldecode(file("./inputs.yaml"))
}

module "infra_alerts" {
  source        = "spacelift.io/incontact/openapm-custom-infra-alerts-module/default"
  version       = "0.0.4"
  custom_alerts = local.alerts_data.custom_alerts
}