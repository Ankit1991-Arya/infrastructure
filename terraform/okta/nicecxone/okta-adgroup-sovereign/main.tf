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
  okta_base_url = "okta.com"
}

provider "okta" {
  org_name = local.okta_org_name
  base_url = local.okta_base_url
  # api token is set using the OKTA_API_TOKEN env var
}

module "okta_groups" {
  source              = "spacelift.io/incontact/config/okta//modules/okta-adgroups-sov"
  version             = "3.7.0"
  org_name            = local.okta_org_name
  base_url            = local.okta_base_url
  okta_api_token      = var.okta_api_token
  csv_file            = "${path.module}/groupnames.csv"
  update_script_ausov = "${path.module}/update-okta-group-au.py"
  update_script_eusov = "${path.module}/update-adgroup-eu.py"
  update_script_uksov = "${path.module}/update-adgroup-uk.py"
}
