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
      Owner               = "MediaServices"
      Product             = "ACD"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "MediaServer"
      ApplicationOwner    = "MediaServices"
      InfrastructureOwner = "MediaServices"
    }
  }
}

module "pocredirector-jumpbox" {
  source  = "spacelift.io/incontact/pocredirector-jumpbox/default"
  version = ">=0.4.1"

  internal_sg_id = "sg-0f10f4aa42e3dda80"

  linux_instance_type = "t3.micro"
}