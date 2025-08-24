terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "me-central-1"
}

data "aws_iam_role" "lambda_role" {
  name = "ServiceAccess-sre-ssl-cert-expiration-role"
}

locals {
  data = yamldecode(file("./inputs.yaml"))
}

module "cert_monitor" {
  # aka modules/ssl-expiration-monitor in repo
  source  = "spacelift.io/incontact/sre-ssl-expiration-monitor/default"
  version = "0.11.1"

  instance_name    = local.data.instance_name
  lambda_role      = data.aws_iam_role.lambda_role.arn
  sns_topic_prefix = local.data.sns_topic_prefix
  tags             = local.data.tags
}
