###################################################
# Pull Through Cache Rule
###################################################

# This code is adding Pull throgh cache rule in AWS ECR 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  default_namespaces = {
    # Namespace          = Upstream URL
    "quay.io"         = "quay.io"
    "public.ecr.aws"  = "public.ecr.aws"
    "registry.k8s.io" = "registry.k8s.io"
  }
}


resource "aws_ecr_pull_through_cache_rule" "example" {
  for_each = local.default_namespaces

  ecr_repository_prefix = each.key
  upstream_registry_url = each.value
}

resource "aws_ecr_pull_through_cache_rule" "docker_hub" {
  ecr_repository_prefix = "registry-1.docker.io"
  upstream_registry_url = "registry-1.docker.io"
  credential_arn        = "arn:aws:secretsmanager:us-west-2:077940578811:secret:ecr-pullthroughcache/dockerhub-OvxUlj"
}

resource "aws_ecr_pull_through_cache_rule" "github" {
  ecr_repository_prefix = "ghcr.io"
  upstream_registry_url = "ghcr.io"
  credential_arn        = "arn:aws:secretsmanager:us-west-2:077940578811:secret:ecr-pullthroughcache/ghcr-WruEMu"
}