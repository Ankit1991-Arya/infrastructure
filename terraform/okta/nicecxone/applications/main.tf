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
  okta_org_name = "nicecxone"
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

  application_name                = "AWS-Standard"
  aws_saml_identity_provider_name = local.aws_saml_identity_provider_name
}

provider "aws" {
  alias = "nice_devops_sandbox"
  assume_role {
    role_arn = "arn:aws:iam::032474939542:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_nice_devops_sandbox" {
  provider               = aws.nice_devops_sandbox
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "nice_devops"
  assume_role {
    role_arn = "arn:aws:iam::369498121101:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_nice_devops" {
  provider               = aws.nice_devops
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_dev"
  assume_role {
    role_arn = "arn:aws:iam::300813158921:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_dev" {
  provider               = aws.ic_dev
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_test"
  assume_role {
    role_arn = "arn:aws:iam::265671366761:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_test" {
  provider               = aws.ic_test
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_staging"
  assume_role {
    role_arn = "arn:aws:iam::545209810301:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_staging" {
  provider               = aws.ic_staging
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_prod"
  assume_role {
    role_arn = "arn:aws:iam::737494165703:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_prod" {
  provider               = aws.ic_prod
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "wfo_dev"
  assume_role {
    role_arn = "arn:aws:iam::934137132601:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_wfo_dev" {
  provider               = aws.wfo_dev
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "wfo_staging"
  assume_role {
    role_arn = "arn:aws:iam::946153222386:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_wfo_staging" {
  provider               = aws.wfo_staging
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "wfo_prod"
  assume_role {
    role_arn = "arn:aws:iam::918987959928:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_wfo_prod" {
  provider               = aws.wfo_prod
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}


provider "aws" {
  alias = "openrec_dev_na1"
  assume_role {
    role_arn = "arn:aws:iam::486795465754:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_openrec_dev_na1" {
  provider               = aws.openrec_dev_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}


provider "aws" {
  alias = "openrec_test_na1"
  assume_role {
    role_arn = "arn:aws:iam::537019868532:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_openrec_test_na1" {
  provider               = aws.openrec_test_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "openrec_staging_na1"
  assume_role {
    role_arn = "arn:aws:iam::847643097177:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_openrec_staging_na1" {
  provider               = aws.openrec_staging_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "openrec_perf_na1"
  assume_role {
    role_arn = "arn:aws:iam::330082613449:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_openrec_perf_na1" {
  provider               = aws.openrec_perf_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "openrec_prod_na1"
  assume_role {
    role_arn = "arn:aws:iam::563398248045:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_openrec_prod_na1" {
  provider               = aws.openrec_prod_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_dev"
  assume_role {
    role_arn = "arn:aws:iam::218540985735:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_dev" {
  provider               = aws.inview_dev
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_test"
  assume_role {
    role_arn = "arn:aws:iam::352895064632:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_test" {
  provider               = aws.inview_test
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_staging"
  assume_role {
    role_arn = "arn:aws:iam::504108155783:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_staging" {
  provider               = aws.inview_staging
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_perf"
  assume_role {
    role_arn = "arn:aws:iam::006823508907:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_perf" {
  provider               = aws.inview_perf
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_prod"
  assume_role {
    role_arn = "arn:aws:iam::454591960327:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_prod" {
  provider               = aws.inview_prod
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_prod_ae1"
  assume_role {
    role_arn = "arn:aws:iam::925142894017:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_prod_ae1" {
  provider               = aws.inview_prod_ae1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_prod_jo1"
  assume_role {
    role_arn = "arn:aws:iam::115496622340:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_inview_prod_jo1" {
  provider               = aws.inview_prod_jo1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}


provider "aws" {
  alias = "ic_prod_jo1"
  assume_role {
    role_arn = "arn:aws:iam::635146017371:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_prod_jo1" {
  provider               = aws.ic_prod_jo1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_prod_ae1"
  assume_role {
    role_arn = "arn:aws:iam::977437863335:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

provider "aws" {
  alias = "wfo_prod_jo1"
  assume_role {
    role_arn = "arn:aws:iam::692416605838:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_wfo_prod_jo1" {
  provider               = aws.wfo_prod_jo1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}
resource "aws_iam_saml_provider" "okta_ic_prod_ae1" {
  provider               = aws.ic_prod_ae1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "mon_test_na1"
  assume_role {
    role_arn = "arn:aws:iam::837589194720:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_mon_test_na1" {
  provider               = aws.mon_test_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}


provider "aws" {
  alias = "mon_staging_na1"
  assume_role {
    role_arn = "arn:aws:iam::747639319642:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_mon_staging_na1" {
  provider               = aws.mon_staging_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "mon_perf_na1"
  assume_role {
    role_arn = "arn:aws:iam::077940578811:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_mon_perf_na1" {
  provider               = aws.mon_perf_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "mon_prod_na1"
  assume_role {
    role_arn = "arn:aws:iam::672696122715:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_mon_prod_na1" {
  provider               = aws.mon_prod_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_api_sandbox"
  assume_role {
    role_arn = "arn:aws:iam::444193133714:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_api_sandbox" {
  provider               = aws.ic_api_sandbox
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_architects"
  assume_role {
    role_arn = "arn:aws:iam::583027634990:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_architects" {
  provider               = aws.ic_architects
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_channels"
  assume_role {
    role_arn = "arn:aws:iam::548381600163:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_channels" {
  provider               = aws.ic_channels
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_dba"
  assume_role {
    role_arn = "arn:aws:iam::445582093160:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_dba" {
  provider               = aws.ic_dba
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_fedramp_high_mgmt"
  assume_role {
    role_arn = "arn:aws:iam::754339672523:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_fedramp_high_mgmt" {
  provider               = aws.ic_fedramp_high_mgmt
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_media"
  assume_role {
    role_arn = "arn:aws:iam::663995847246:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_media" {
  provider               = aws.ic_media
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_qaautomation"
  assume_role {
    role_arn = "arn:aws:iam::819802526560:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_qaautomation" {
  provider               = aws.ic_qaautomation
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_reporting"
  assume_role {
    role_arn = "arn:aws:iam::575635630823:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_reporting" {
  provider               = aws.ic_reporting
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_sandbox_enttools"
  assume_role {
    role_arn = "arn:aws:iam::847953932059:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_sandbox_enttools" {
  provider               = aws.ic_sandbox_enttools
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_sandbox_trust"
  assume_role {
    role_arn = "arn:aws:iam::127509991989:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_sandbox_trust" {
  provider               = aws.ic_sandbox_trust
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_storage_pune"
  assume_role {
    role_arn = "arn:aws:iam::887500884480:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_storage_pune" {
  provider               = aws.ic_storage_pune
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_tools_sandbox"
  assume_role {
    role_arn = "arn:aws:iam::789877560314:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_tools_sandbox" {
  provider               = aws.ic_tools_sandbox
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "mon_dev_na1"
  assume_role {
    role_arn = "arn:aws:iam::300101013673:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_mon_dev_na1" {
  provider               = aws.mon_dev_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "apa_dev_na1"
  assume_role {
    role_arn = "arn:aws:iam::352449608209:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_apa_dev_na1" {
  provider               = aws.apa_dev_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "rec_net_dev_na1"
  assume_role {
    role_arn = "arn:aws:iam::022038092021:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_rec_net_dev_na1" {
  provider               = aws.rec_net_dev_na1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "rec_dev_na1_cell1"
  assume_role {
    role_arn = "arn:aws:iam::454949757413:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_rec_dev_na1_cell1" {
  provider               = aws.rec_dev_na1_cell1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "ic_prod_kr1"
  assume_role {
    role_arn = "arn:aws:iam::225195882266:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "ap-northeast-2"
}

resource "aws_iam_saml_provider" "okta_ic_prod_kr1" {
  provider               = aws.ic_prod_kr1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "inview_prod_kr1"
  assume_role {
    role_arn = "arn:aws:iam::400339296799:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "ap-northeast-2"
}

resource "aws_iam_saml_provider" "okta_inview_prod_kr1" {
  provider               = aws.inview_prod_kr1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}

provider "aws" {
  alias = "wfoprodkr1"
  assume_role {
    role_arn = "arn:aws:iam::814740517824:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "ap-northeast-2"
}

resource "aws_iam_saml_provider" "okta_wfoprodkr1" {
  provider               = aws.wfoprodkr1
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}