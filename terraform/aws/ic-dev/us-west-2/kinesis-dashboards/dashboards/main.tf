terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  data = yamldecode(file("./inputs.yaml"))
}

#
# This sets up the ic-dev monitoring side.
#

# This module is used to create the cross-account monitoring sources
module "source_account_management" {
  # aka modules/source-account-management in repo
  source  = "spacelift.io/incontact/aws-kinesis-source-account-management/default"
  version = "0.5.0"


  # This comes from the monitoring account ( eg mon-dev )
  monitoring_account_id = local.data.monitoring_account_id

  # This comes from monitoring account (mon-dev) module output module.cross_account_monitoring.sink_id
  # module def: https://github.com/inContact/infrastructure-live/blob/5d5634078d9561fdd8786f30f93758c400c98108/terraform/aws/mon-dev-na1/us-west-2/kinesis-dashboards/dashboards/main.tf#L206-L219
  # Where to get the value: https://github.com/inContact/infrastructure-live/blob/5d5634078d9561fdd8786f30f93758c400c98108/terraform/aws/mon-dev-na1/us-west-2/kinesis-dashboards/dashboards/main.tf#L237-L242
  # TODO: Doing a split on the value like this feels wrong. This is how AWS provided it so persisting for now
  monitoring_sink_id = split("/", local.data.monitoring_sink_id)[1]
  prefix             = local.data.prefix
  tags               = local.data.tags
}
