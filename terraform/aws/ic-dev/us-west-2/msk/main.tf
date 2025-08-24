terraform {
  required_version = ">= 1.5.7"
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
  region = "us-west-2"
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
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]
  cidr_ranges               = yamldecode(file("./cidr_ranges.yaml"))
  scram_users               = yamldecode(file("${path.module}/scram_users.yaml"))["scram_users"]
  scram_users_cross_account = fileexists("${path.module}/scram_users_cross_account.yaml") ? yamldecode(file("${path.module}/scram_users_cross_account.yaml"))["scram_users_cross_account"] : {}
}

module "msk" {
  source                                    = "spacelift.io/incontact/msk/default"
  version                                   = "0.4.0"
  region                                    = "us-west-2"
  vpc-id                                    = "vpc-05f9227c"
  internet-gateway-id                       = "igw-3f29f859"
  subnet-cidrs                              = local.subnet-cidrs
  availability-zones                        = local.availability-zones
  allowed-cidrs                             = local.cidr_ranges.allowed_cidrs
  prometheus_cidr_blocks                    = local.cidr_ranges.prometheus_cidr_blocks
  sasl_iam_cidr_blocks                      = local.cidr_ranges.sasl_iam_cidr_blocks
  instance-type                             = "kafka.m5.2xlarge"
  public-access                             = "true"
  delete-enabled                            = "true"
  storage-autoscaling-enabled               = "true"
  max-volume-size                           = "2000"
  ebs-volume-size                           = "1050"
  broker-logs-enabled                       = "true"
  enhanced-monitoring-level                 = "PER_TOPIC_PER_PARTITION"
  ec2-allowed-cidrs-ingress-max-rules-count = "30"
  kafka-version                             = "3.5.1"
  cloudwatch_retention_in_days              = "30"
  scram_users                               = local.scram_users
  scram_users_cross_account                 = try(local.scram_users_cross_account, {})
}
