terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ApplicationOwner    = "InfoSec"
      InfrastructureOwner = "InfoSec"
      Product             = "AlertLogic"
      Service             = "FedRampAlertLogicLogs"
      Repository          = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}