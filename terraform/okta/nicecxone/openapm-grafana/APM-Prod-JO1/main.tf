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

module "okta_grafana" {
  source  = "spacelift.io/incontact/config/okta//modules/okta_grafana"
  version = "3.1.4"

  label                     = "APM-Prod-JO1"
  redirect_uris             = ["https://mon-jo1.nicecxone.com/login/okta"]
  login_uri                 = "https://mon-jo1.nicecxone.com/login/okta"
  post_logout_redirect_uris = ["https://mon-jo1.nicecxone.com/logout"]
}