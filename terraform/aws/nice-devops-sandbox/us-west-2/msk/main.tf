terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14.0"
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
    "172.31.112.0/22",
    "172.31.116.0/22",
    "172.31.120.0/22"
  ]
  availability-zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]
  cidr_ranges = yamldecode(file("./cidr_ranges.yaml"))
  scram_users = yamldecode(file("${path.module}/scram_users.yaml"))["scram_users"]
}

module "msk" {
  source                        = "spacelift.io/incontact/msk/default"
  version                       = "0.4.0"
  region                        = "us-west-2"
  vpc-id                        = "vpc-f2e16f95"
  internet-gateway-id           = "igw-5c693b38"
  subnet-cidrs                  = local.subnet-cidrs
  availability-zones            = local.availability-zones
  allowed-cidrs                 = local.cidr_ranges.allowed_cidrs
  prometheus_cidr_blocks        = local.cidr_ranges.prometheus_cidr_blocks
  sasl_iam_cidr_blocks          = local.cidr_ranges.sasl_iam_cidr_blocks
  instance-type                 = "kafka.m5.xlarge"
  public-access                 = "true"
  delete-enabled                = "true"
  storage-autoscaling-enabled   = "true"
  max-volume-size               = 500
  broker-logs-enabled           = "true"
  enhanced-monitoring-level     = "PER_TOPIC_PER_PARTITION"
  kafka-version                 = "3.5.1"
  number-of-broker-nodes-per-az = 1
  ebs-volume-size               = 500
  scram_users                   = local.scram_users
  # multivpc-enabled                 = "true"
  # multivpc-sasl-iam-auth-enabled   = "true"
  # multivpc-sasl-scram-auth-enabled = "true"
  # multivpc-cluster-policy-accounts = ["032474939542", "300813158921"]
}
