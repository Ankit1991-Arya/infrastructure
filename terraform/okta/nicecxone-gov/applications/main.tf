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
  okta_base_url = "okta.com"
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

provider "aws" {
  alias = "ic_compliance_prod"
  assume_role {
    role_arn = "arn:aws:iam::751344753113:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-east-1"
}

resource "aws_iam_saml_provider" "okta_ic_compliance_prod" {
  provider               = aws.ic_compliance_prod
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "wfo_compliance_prod"
  assume_role {
    role_arn = "arn:aws:iam::334442430111:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-east-1"
}

resource "aws_iam_saml_provider" "okta_wfo_compliance_prod" {
  provider               = aws.wfo_compliance_prod
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}