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
  cost_monitor_data = yamldecode(file("./inputs.yaml"))
}

module "cost-anamoly" {
  source       = "spacelift.io/incontact/openapm-cost-anamoly-detection/default"
  version      = "0.5.5"
  cost_monitor = local.cost_monitor_data.cost_monitor
}