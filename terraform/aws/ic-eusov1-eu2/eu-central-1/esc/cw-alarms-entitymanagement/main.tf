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
  region = "eu-central-1"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "cw-alarms-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "cw-alarms-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-cw-alarms-entitymanagement/default"
  version = "0.0.3"

  environment-prefix  = "eusov1"
  region              = "eu-central-1"
  esc-alerts-endpoint = "098a4ba5.NICEinContact.com@emea.teams.ms"
}
