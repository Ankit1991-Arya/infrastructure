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
  region = "us-west-2"
  default_tags {
    tags = {
      InfrastructureOwner : "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      ApplicationOwner : "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      Product : "Infrastructure"
      Service : "Public-MSK"
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
  cidr_ranges = yamldecode(file("./cidr_ranges.yaml"))
  scram_users = fileexists("./scram_users.yaml") ? yamldecode(file("./scram_users.yaml")) : []
}

module "msk" {
  source                                    = "spacelift.io/incontact/aws_public_msk_msk/default"
  version                                   = "0.1.1"
  region                                    = "us-west-2"
  name-prefix                               = "public-msk01"
  vpc-id                                    = "vpc-0793a887b4f51b99f"
  internet-gateway-id                       = "igw-0dc818f2de2f97dec"
  subnet-cidrs                              = local.subnet-cidrs
  availability-zones                        = local.availability-zones
  allowed-cidrs                             = local.cidr_ranges.allowed_cidrs
  security_group_ids                        = ["sg-02fbf0e092c8cb0f3", "sg-076355c98a0bee393", "sg-0439a9abb64287790", "sg-0319ad5fd582c2048"]
  instance-type                             = "kafka.m5.large"
  public-access                             = "true"
  delete-enabled                            = "true"
  storage-autoscaling-enabled               = "true"
  max-volume-size                           = 2000
  broker-logs-enabled                       = "true"
  enhanced-monitoring-level                 = "PER_TOPIC_PER_PARTITION"
  ec2-allowed-cidrs-ingress-max-rules-count = 15
  kafka-version                             = "3.5.1"
  cloudwatch_retention_in_days              = 30
  scram_users                               = local.scram_users
}
