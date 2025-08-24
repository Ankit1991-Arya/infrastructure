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
  region = "us-west-2"
  default_tags {
    tags = {
      Owner               = "MediaServices"
      Product             = "ACD"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "MediaServer"
      ApplicationOwner    = "MediaServices"
      InfrastructureOwner = "MediaServices"
    }
  }
}

module "pocredirector-jumpbox" {
  source  = "spacelift.io/incontact/pocredirector-jumpbox/default"
  version = ">=0.4.1"

  internal_sg_id = "sg-dcc844a7"

  linux_instance_type = "t3.micro"
}

module "pocredirector-dynamodb" {
  source  = "spacelift.io/incontact/pocredirector-dynamodb/default"
  version = "0.1.9"

  instance_name   = "pocredirector"
  replica_regions = ["ca-central-1", "eu-west-2", "eu-central-1", "ap-southeast-2", "ap-northeast-1"]
}

module "pocredirector-elasticache" {
  source  = "spacelift.io/incontact/pocredirector-elasticache/default"
  version = "1.0.3"

  cluster_name = "pocredirector"
}

module "pocredirector-alerts" {
  source  = "spacelift.io/incontact/pocredirector-alerts/default"
  version = "0.2.5"

  pocredirector_instance = "pocredirector"
  alert_email            = "af938f42.NICEinContact.com@emea.teams.ms" # EKS Alerts - Non Production - Nice inContact Kubernetes
  notify_noc             = true
}
