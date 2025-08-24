terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner   = "MediaServices"
      Product = "Media-Services-Tools"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "mediaserver-jumpbox-2016" {
  source  = "spacelift.io/incontact/media-services-jumpbox/default"
  version = ">= 0.0.1"
  # source  = "<Need to check with jared>"
  os_type = ["Windows-2016"]
  count = 1
}

module "mediaserver-jumpbox-2019" {
  source  = "spacelift.io/incontact/media-services-jumpbox/default"
  version = ">= 0.0.1"
  # source  = "<Need to check with jared>"
  os_type = ["Windows-2019"]
  count = 1
}

module "mediaserver-jumpbox-2022" {
  # source  = "github.com/inContact/media-services-tools//terraform/jumpbox?ref=jumpbox-tf-tk"
  version = ">= 0.0.1"
  source  = "spacelift.io/incontact/media-services-jumpbox/default"
  os_type = ["Windows-2022"]
  count = 1
}
