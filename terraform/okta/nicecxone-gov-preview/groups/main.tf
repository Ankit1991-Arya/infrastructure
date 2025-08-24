terraform {
  required_providers {
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
}

provider "okta" {
  org_name = local.okta_org_name
  base_url = local.okta_base_url
  # api token is set using the OKTA_API_TOKEN env var
}

module "dept_groups" {
  source  = "spacelift.io/incontact/config/okta//modules/dept-groups"
  version = "3.0.0"

  app_label_aws          = ["AWS-Standard", "AWS-FRM"]
  app_label_azure        = ["Azure-Standard"]
  app_label_gcp          = ["GCP-Standard"]
  app_label_okta_org2org = "DirSync_Okta-FRM-Preview_to_Okta-Std-Preview"
  dept_groups = {
    CloudNativeCore = {
      aws = true
      aws_role_okta_groups = {
        ic-dev = ["GroupAccess-CNC"]
      }
      azure = true
      gcp   = true
    }
    CloudOps = {
      aws = true
      aws_role_okta_groups = {
        ic-dev = ["GroupAccess-CloudOps"]
      }
      azure = true
      gcp   = true
    }
    SystemsArchitecture = {
      aws = true
      aws_role_okta_groups = {
        ic-dev = ["GroupAccess-SystemsArchitecture"]
      }
      azure = true
      gcp   = true
    }
    SystemsEngineering = {
      aws = true
      aws_role_okta_groups = {
        ic-dev = ["GroupAccess-SystemEngineering"]
      }
      azure = true
      gcp   = true
    }
    SystemsOperations = {
      aws = true
      aws_role_okta_groups = {
        ic-dev = ["GroupAccess-SystemOperations"]
      }
      azure = true
      gcp   = true
    }
  }
}