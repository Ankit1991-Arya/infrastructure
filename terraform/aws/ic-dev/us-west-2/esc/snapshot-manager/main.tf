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

#tfsec:ignore:aws-sns-enable-topic-encryption
module "snapshot-manager" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-snapshot-manager-development/default"
  version = "0.1.0"

  app-version = "development"

  env-name           = "DEV"
  environment-prefix = "do"
  region             = "us-west-2"
  sns-teams-endpoint = "2d4724e0.NICEinContact.com@emea.teams.ms"
  app-names          = "broker-service,state-streams-vc-contact,state-streams-dfo-contact,state-streams-mixed-dfo-contact,state-streams-mixed-vc-contact,state-streams-vc-agent-contact"

}
