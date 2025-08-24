terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 5.64.0"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "EC2"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  ec2_instances_data = yamldecode(file("./inputs.yaml"))
}

module "nexpose_servers" {
  source               = "spacelift.io/incontact/aws_ec2_instances/default"
  version              = "0.1.0"
  ec2_instances_data   = local.ec2_instances_data.ec2_instances_data
  override_ebs_kms_arn = aws_kms_key.nexpose_ebs_kms_key.arn
  depends_on           = [aws_kms_key.nexpose_ebs_kms_key]
}

#Share Nexpose Scan Engine AMI to Sub Accounts
resource "aws_ami_launch_permission" "nexpose_engine_ami_shared" {
  for_each   = local.privatelink_allowed_principals
  image_id   = local.nexpose_scan_engine_AMI_ID
  account_id = each.key
}