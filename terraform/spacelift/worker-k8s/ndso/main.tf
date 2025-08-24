terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
      version = "1.10.1"
    }
  }
}

provider "spacelift" {
  api_key_endpoint = "https://incontact.app.spacelift.io"
}

provider "aws" {
  region = "us-west-2"
}

resource "spacelift_worker_pool" "k8s-core" {
  name        = "arun-test-worker"
  csr         = filebase64(/mnt/workspace/ndso-csr)
  description = "Used for all type jobs"
}
