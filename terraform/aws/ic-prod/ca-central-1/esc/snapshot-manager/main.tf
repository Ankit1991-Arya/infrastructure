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
  region = "ca-central-1"
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

#tfsec:ignore:aws-sns-enable-topic-encryption
module "snapshot-manager" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-snapshot-manager/default"
  version = "0.0.26"

  env-name           = "PROD"
  environment-prefix = "am"
  region             = "ca-central-1"
  sns-teams-endpoint = "098a4ba5.NICEinContact.com@emea.teams.ms"
}
