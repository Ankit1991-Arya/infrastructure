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

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "brokerservice" {
  source  = "spacelift.io/incontact/orch-suit-data-broker-brokerservice/default"
  version = "0.2.0"

  env-name           = "STAGING"
  environment-prefix = "so"
  region             = "us-west-2"
  sns-teams-endpoint = "d9e2075e.NICEinContact.com@emea.teams.ms"
  availability-zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  subnet-cidrs       = ["10.0.28.0/23", "10.0.30.0/23", "10.0.32.0/23"]
  vpc-id             = "vpc-aaac0ad3"
  app-version        = "v0.1.0"
}
