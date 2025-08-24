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
}

resource "aws_elasticache_parameter_group" "opa-cache-parameter-grp" {
  name        = "outbound-pacing-aggregator-prameter-grp-valkey"
  family      = "valkey8"
  description = "Parameter group for OPA redis cluster"
  tags = {
    Product             = "ACD",
    Services            = "Outbound-OPA",
    ApplicationOwner    = "CxOne_IM_OB@nice.com",
    InfrastructureOwner = "CxOne_IM_OB@nice.com"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
# tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group" "opa-valkey-security-grp" {
  name        = "do-ic-acdapi-valkey-dev-SecurityGroup"
  vpc_id      = "vpc-24ff1f43"
  description = "Security Group for elasticache valkey cluster nodes"

  # jump server : sg-0813af06525cf1065
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["sg-0813af06525cf1065"]
    cidr_blocks     = ["0.0.0.0/0"]
    # description     = "jump server : ${var.security_group_id_jump_server}"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Product             = "ACD",
    Services            = "Outbound-OPA",
    ApplicationOwner    = "CxOne_IM_OB@nice.com",
    InfrastructureOwner = "CxOne_IM_OB@nice.com"
  }
}

resource "aws_elasticache_replication_group" "Outbound-pacing-aggregator" {
  replication_group_id       = "OPA-replication-group"
  engine                     = "valkey"
  engine_version             = "8.0"
  node_type                  = "cache.t2.micro"
  port                       = 6379
  parameter_group_name       = "outbound-pacing-aggregator-prameter-grp-valkey"
  cluster_mode               = "disabled"
  automatic_failover_enabled = true
  num_node_groups            = 1
  replicas_per_node_group    = 1
  at_rest_encryption_enabled = true
  multi_az_enabled           = false
  transit_encryption_mode    = "required"
  transit_encryption_enabled = true
  apply_immediately          = true
  description                = "Valkey replication groups with single shards and replicas"
  security_group_ids         = [aws_security_group.opa-valkey-security-grp.id]
  subnet_group_name          = "do-ic-acdapi-valkey-dev-subnetgroup-gueq5hr8idor"

  tags = {
    Product             = "ACD",
    Services            = "Outbound-OPA",
    ApplicationOwner    = "CxOne_IM_OB@nice.com",
    InfrastructureOwner = "CxOne_IM_OB@nice.com"
  }
}