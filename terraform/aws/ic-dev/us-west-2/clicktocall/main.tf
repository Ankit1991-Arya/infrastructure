terraform {
  required_version = ">=1.5.2"
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
      Product             = "VAAS"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "Click to Call"
      ApplicationOwner    = "MediaServices"
      InfrastructureOwner = "MediaServices"

    }
  }
}

# module "media-services-tools-clicktocall-windows-ec2-instance" {
#   source  = "spacelift.io/incontact/media-services-tools-clicktocall-windows-ec2-instance/default"
#   version = ">=0.0.1"

# Optional inputs
# key_pair              = string
# windows_instance_type = string
# }
