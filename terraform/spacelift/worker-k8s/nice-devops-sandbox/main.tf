terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "0.1.31"
    }
  }
}

provider "spacelift" {
  api_key_endpoint = "https://incontact.app.spacelift.io"
}

provider "aws" {
  region = "us-west-2"
}

module "spacelift-workers" {
  source  = "spacelift.io/incontact/config/spacelift//modules/k8s-worker"
  version = "1.5.5"

  worker_pool_name     = "k8s-ndso"
  spacelift_key_id     = var.spacelift_key_id
  spacelift_key_secret = var.spacelift_key_secret
}
