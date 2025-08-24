##########################################################################
## This file contains definitions of terraform providers and state
## backends. Typically you will not need to modify this file.
##########################################################################

locals {
  # This will contain the directory of the service role module being executed
  cwd_path_elements = split("/", path.cwd)
  # This will contain the name of the service role module being executed
  module_name = element(local.cwd_path_elements, length(local.cwd_path_elements) - 1)
  # TODO: move standard_tags into some sort of common module to keep this logic DRY
  standard_tags = {
    Owner   = "pipelineinfraautomation"
    Product = "infrastructure-live"
    Module  = local.module_name
    Repo    = "https://github.com/inContact/infrastructure-live"
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = local.standard_tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
  required_version = ">= 1.4.6"
}