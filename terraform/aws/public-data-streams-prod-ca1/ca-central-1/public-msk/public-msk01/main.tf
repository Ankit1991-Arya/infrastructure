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
  region = "ca-central-1"
  default_tags {
    tags = {
      InfrastructureOwner : "Cloud Native Core/devops-cloud-native-core@nice.com"
      ApplicationOwner : "Cloud Native Core/devops-cloud-native-core@nice.com"
      Product : "Infrastructure"
      Service : "Public MSK"
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
    "ca-central-1a",
    "ca-central-1b",
    "ca-central-1d"
  ]
  cidr_ranges = yamldecode(file("./cidr_ranges.yaml"))
  scram_users = fileexists("./scram_users.yaml") ? yamldecode(file("./scram_users.yaml")) : []
}

module "msk" {
  source                                    = "spacelift.io/incontact/aws_public_msk_msk/default"
  version                                   = "0.1.1"
  region                                    = "ca-central-1"
  name-prefix                               = "public-msk01"
  vpc-id                                    = "vpc-0c549dbf2620da245"
  internet-gateway-id                       = "igw-0fc1efbaa929a0970"
  subnet-cidrs                              = local.subnet-cidrs
  availability-zones                        = local.availability-zones
  allowed-cidrs                             = local.cidr_ranges.allowed_cidrs
  security_group_ids                        = ["sg-0f26d57efc2b7fbb7", "sg-09ea149fcd584dd1e", "sg-084cb96f772acd1ee", "sg-0fb887b84c94e64d1"]
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
