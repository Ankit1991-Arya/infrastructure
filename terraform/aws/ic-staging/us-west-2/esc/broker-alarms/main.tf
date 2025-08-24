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
  source  = "spacelift.io/incontact/orch-suit-data-broker-broker-alarms/default"
  version = "0.0.18"

  env-name           = "STAGING"
  environment-prefix = "so"
  region             = "us-west-2"
  sns-teams-endpoint = "d9e2075e.NICEinContact.com@emea.teams.ms"
}
