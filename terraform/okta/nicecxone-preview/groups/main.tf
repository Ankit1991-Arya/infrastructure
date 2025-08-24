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
  okta_org_name = "nicecxone"
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

  app_label_aws          = ["AWS-OpsLab"]
  app_label_azure        = ["DirSync_Okta-Preview_to_Office365-OpsLab"]
  app_label_gcp          = ["DirSync_Okta-Preview_to_GoogleWorkspace-OpsLab", "GCP-OpsLab"]
  app_label_okta_org2org = null
  dept_groups = {
    CloudNativeCore = {
      aws = true
      aws_role_okta_groups = {
        ic-ops = ["GroupAccess-CNC"]
      }
      azure = true
      gcp   = true
    }
    CloudOps = {
      aws                  = true
      aws_role_okta_groups = {}
      azure                = true
      gcp                  = true
    }
    SystemsArchitecture = {
      aws                  = true
      aws_role_okta_groups = {}
      azure                = true
      gcp                  = true
    }
    SystemsEngineering = {
      aws                  = true
      aws_role_okta_groups = {}
      azure                = true
      gcp                  = true
    }
    SystemsOperations = {
      aws                  = true
      aws_role_okta_groups = {}
      azure                = true
      gcp                  = true
    }
  }
}
