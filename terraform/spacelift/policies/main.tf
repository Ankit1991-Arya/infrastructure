terraform {
  required_version = "1.3.1"
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "0.1.31"
    }
  }
}

provider "spacelift" {
  api_key_endpoint = "https://incontact.app.spacelift.io"
}

module "spacelift-policies" {
  source  = "spacelift.io/incontact/policies/spacelift"
  version = "~> 1.0" # This means that terraform will automatically pull the latest feature version (the 2nd digit in the version)
}
