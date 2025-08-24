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
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "interaction-broker"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "broker-alarms" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-broker-alarms-development/default"
  version = "0.0.18"

  env-name           = "DEV"
  environment-prefix = "do"
  region             = "us-west-2"
  sns-teams-endpoint = "2d4724e0.NICEinContact.com@emea.teams.ms"
}