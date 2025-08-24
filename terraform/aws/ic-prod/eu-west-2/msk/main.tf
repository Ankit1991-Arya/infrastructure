terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      InfrastructureOwner : "Cloud Native Core/devops-cloud-native-core@nice.com"
      ApplicationOwner : "Cloud Native Core/devops-cloud-native-core@nice.com"
      Product : "Infrastructure"
      Service : "Shared MSK"
      Repository = "https://github.com/inContact/infrastructure-live"
    }
  }
}

locals {
  subnet-cidrs = [
    "10.0.12.0/22",
    "10.0.16.0/22",
    "10.0.20.0/22"
  ]
  availability-zones = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]
  cidr_ranges               = yamldecode(file("./cidr_ranges.yaml"))
  scram_users               = yamldecode(file("${path.module}/scram_users.yaml"))["scram_users"]
  scram_users_cross_account = fileexists("${path.module}/scram_users_cross_account.yaml") ? yamldecode(file("${path.module}/scram_users_cross_account.yaml"))["scram_users_cross_account"] : {}
}

module "msk" {
  source                                    = "spacelift.io/incontact/msk/default"
  version                                   = "0.4.0"
  region                                    = "eu-west-2"
  vpc-id                                    = "vpc-0605256dad0b7cfb5"
  internet-gateway-id                       = "igw-0ede766bdcb4375bd"
  subnet-cidrs                              = local.subnet-cidrs
  availability-zones                        = local.availability-zones
  allowed-cidrs                             = local.cidr_ranges.allowed_cidrs
  prometheus_cidr_blocks                    = local.cidr_ranges.prometheus_cidr_blocks
  sasl_iam_cidr_blocks                      = local.cidr_ranges.sasl_iam_cidr_blocks
  instance-type                             = "kafka.m5.large"
  public-access                             = "true"
  delete-enabled                            = "true"
  storage-autoscaling-enabled               = "true"
  max-volume-size                           = "2000"
  broker-logs-enabled                       = "true"
  enhanced-monitoring-level                 = "PER_TOPIC_PER_PARTITION"
  kafka-version                             = "3.5.1"
  ec2-allowed-cidrs-ingress-max-rules-count = "30"
  cloudwatch_retention_in_days              = "90"
  scram_users                               = local.scram_users
  scram_users_cross_account                 = try(local.scram_users_cross_account, {})
}
