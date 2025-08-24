terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      InfrastructureOwner = "Cloud Native Core/devops-cloud-native-core@nice.com"
      Product             = "Infrastructure"
      Service             = "Shared EKS"
      Repository          = "https://github.com/inContact/infrastructure-live"
      ApplicationOwner    = "Cloud Native Core/devops-cloud-native-core@nice.com"
    }
  }
}

data "aws_vpc" "core" {
  tags = {
    Name = "Staging-core-network"
  }
}

data "aws_vpc" "sharedeks" {
  tags = {
    Name = "shared_eks"
  }
}


# ---- Custom sg for livevox privatelink endpoint in shared eks ----
resource "aws_security_group" "livevox-private-link-sg" {
  name        = "livevox-privatelink-sg"
  description = "Privatelink endpoint sg for accessing livevox SmartReach"
  vpc_id      = data.aws_vpc.sharedeks.id
  tags = {
    InfrastructureOwner = "Cloud Native Core/devops-cloud-native-core@nice.com"
    ApplicationOwner    = "Outbound"
    Product             = "Outbound"
    Service             = "SmartReach"
    Repository          = "https://github.com/inContact/infrastructure-live"
    Name                = "privatelink-sharedeks-to-livevox"
  }
}

resource "aws_vpc_security_group_ingress_rule" "livevox-private-link-sg-core" {
  security_group_id = aws_security_group.livevox-private-link-sg.id
  cidr_ipv4         = data.aws_vpc.core.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS/gRPC traffic from Core VPC"
}

resource "aws_vpc_security_group_ingress_rule" "livevox-private-link-sg-sharedeks" {
  security_group_id = aws_security_group.livevox-private-link-sg.id
  cidr_ipv4         = data.aws_vpc.sharedeks.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS/gRPC traffic from SharedEKS VPC"
}

resource "aws_vpc_security_group_egress_rule" "livevox-private-link-sg" {
  security_group_id = aws_security_group.livevox-private-link-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ---- And so on ----
