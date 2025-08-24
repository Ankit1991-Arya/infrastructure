terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    okta = {
      source  = "okta/okta"
      version = "3.35.0"
    }
  }
  required_version = "1.3.1"
}

locals {
  okta_org_name = "nicecxone-gov"
  okta_base_url = "oktapreview.com"
  # This name should be consistent across all AWS accounts which integrate with the same Okta saml app
  aws_saml_identity_provider_name = "okta_${local.okta_org_name}.${local.okta_base_url}"
}

provider "okta" {
  org_name = local.okta_org_name
  base_url = local.okta_base_url
  # api token is set using the OKTA_API_TOKEN env var
}

module "aws-saml-application" {
  source  = "spacelift.io/incontact/config/okta//modules/aws-saml-application"
  version = "3.0.0"

  application_name                = "AWS-FRM"
  aws_saml_identity_provider_name = local.aws_saml_identity_provider_name
}

# In nicecxone-gov.oktapreview.com we will use ic-dev to simulate a fedramp moderate account because
# we don't want to connect the real fedramp moderate account to a preview okta environment.
provider "aws" {
  alias = "ic_dev"
  assume_role {
    role_arn = "arn:aws:iam::300813158921:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "oktapreview_ic_dev" {
  provider               = aws.ic_dev
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}