locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "bmc" {
  source = "github.com/inContact/omilia-terraform-modules.git//modules/bmc-publisher?ref=7c36ef5438b915b0f3580501966b0d3d957560b6"

  name     = "omilia-bmc-publisher"
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ServiceAccess-omilia-bmc-publisher"

  environment_variables = {
    BMC_TOPICS_BASE_ARN = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cloudwatch-bmc"
  }

  source_topics_arns = [
    "arn:aws:sns:us-east-1:730335349404:ocp-prod-us-east-1-alarms-funnel"
  ]
}
