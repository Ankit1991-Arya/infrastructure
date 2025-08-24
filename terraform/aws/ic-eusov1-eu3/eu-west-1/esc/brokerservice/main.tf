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

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "brokerservice" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-brokerservice/default"
  version = "0.1.1"

  env-name              = "PROD"
  environment-prefix    = "euie"
  region                = "eu-west-1"
  sns-teams-endpoint    = "098a4ba5.NICEinContact.com@emea.teams.ms"
  availability-zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  subnet-cidrs          = ["10.0.28.0/23", "10.0.30.0/23", "10.0.32.0/23"]
  vpc-id                = "vpc-0b234a1d59ecb03e5"
  log_retention_in_days = 60
}
