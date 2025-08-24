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
  region = "eu-central-1"
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
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]
  cidr_ranges = yamldecode(file("./cidr_ranges.yaml"))
  scram_users = fileexists("./scram_users.yaml") ? yamldecode(file("./scram_users.yaml")) : []
}

module "msk" {
  source                                    = "spacelift.io/incontact/aws_public_msk_msk/default"
  version                                   = "0.1.1"
  region                                    = "eu-central-1"
  name-prefix                               = "public-msk01"
  vpc-id                                    = "vpc-0356260f857735c92"
  internet-gateway-id                       = "igw-085aa1503df6a4f71"
  subnet-cidrs                              = local.subnet-cidrs
  availability-zones                        = local.availability-zones
  allowed-cidrs                             = local.cidr_ranges.allowed_cidrs
  security_group_ids                        = ["sg-0ecd82d53d74e35e9", "sg-04bdddecfed4b5eba", "sg-036b0d08d02ed83f6", "sg-0adb9f5fa0cddcb36"]
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