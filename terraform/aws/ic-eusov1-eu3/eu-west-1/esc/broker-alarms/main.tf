terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "interaction-broker"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "broker-alarms" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-broker-alarms/default"
  version = "0.0.18"

  env-name           = "PROD"
  environment-prefix = "euie"
  region             = "eu-west-1"
  sns-teams-endpoint = "098a4ba5.NICEinContact.com@emea.teams.ms"
}