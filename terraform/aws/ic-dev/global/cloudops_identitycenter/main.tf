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
  region = "us-east-1"
  default_tags {
    tags = {
      Owner               = "CloudOps"
      Product             = "IAM"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "Identity Center"
      InfrastructureOwner = "CloudOps"
      ApplicationOwner    = "CloudOps"
    }
  }
}

module "permission_set" {
  source             = "github.com/inContact/terraform-identitycenter-policies.git//module/iam_policy?ref=AWS-9313-01"
  policy_name        = "MyTestPolicy"
  policy_description = "IAM test policy for identity center in ic-dev"
  policy_document    = data.aws_iam_policy_document.My_Test_Policy.json

  tags = {
    Environment = "dev"
    Project     = "AWS-9313"
  }
}

data "aws_iam_policy_document" "My_Test_Policy" {
  statement {
    effect = "Allow"
    # tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "iam:*"
    ]
    # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "*"
    ]
  }
}
