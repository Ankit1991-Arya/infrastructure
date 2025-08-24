terraform {
  required_version = ">= 1.3.7"
  required_providers {
    kafka = {
      source  = "spacelift.io/inContact/kafka"
      version = "0.7.8"
    }
  }
}

provider "kafka" {
  bootstrap_servers = var.bootstrap-servers
  tls_enabled       = true
  sasl_iam_enabled  = true
}

module "msk-config" {
  source  = "spacelift.io/incontact/msk-config/default"
  version = "0.1.51"
}

variable "bootstrap-servers" {
  type        = list(string)
  description = "The public SASL/SCRAM MSK urls"
  default = [
    "b-2-public.sharedmsk01uswest2.yeia0a.c13.kafka.us-west-2.amazonaws.com:9198",
    "b-1-public.sharedmsk01uswest2.yeia0a.c13.kafka.us-west-2.amazonaws.com:9198",
    "b-3-public.sharedmsk01uswest2.yeia0a.c13.kafka.us-west-2.amazonaws.com:9198"
  ]
}
