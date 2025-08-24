###################################################
# Pull Through Cache Rule
###################################################

# This code is adding Pull throgh cache rule in AWS ECR 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "eu-west-2"
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