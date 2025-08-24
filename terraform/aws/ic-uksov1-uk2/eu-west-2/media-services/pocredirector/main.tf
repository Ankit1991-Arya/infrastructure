terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner   = "MediaServices"
      Product = "POCRedirector"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "pocredirector-dynamodb" {
  source  = "spacelift.io/incontact/pocredirector-dynamodb/default"
  version = "0.1.9"

  instance_name   = "pocredirector"
  replica_regions = []
}

module "pocredirector-elasticache" {
  source  = "spacelift.io/incontact/pocredirector-elasticache/default"
  version = "1.0.9"

  cluster_name = "pocredirector"
  node_type    = "cache.t3.medium"
}

module "pocredirector-alerts" {
  source  = "spacelift.io/incontact/pocredirector-alerts/default"
  version = "0.2.5"

  pocredirector_instance = "pocredirector"
  alert_email            = "ea5cdff7.NICEinContact.com@emea.teams.ms" # POCRedirector Edge Alerts [Prod] - Media Services
  notify_noc             = true
}
