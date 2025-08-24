locals {
  standard_tags = {
    ApplicationOwner    = "devops-cloud-native-core@NiceinContact.com"
    InfrastructureOwner = "devops-cloud-native-core@NiceinContact.com"
    Product             = "Omilia"
  }
}

module "bmc" {
  source = "github.com/inContact/omilia-terraform-modules.git//modules/bmc-publisher?ref=2.0.6.0"

  name     = "omilia-bmc-publisher"
  role_arn = "arn:aws:iam::300813158921:role/ServiceAccess-omilia-bmc-publisher"

  environment_variables = {
    BMC_TOPICS_BASE_ARN = "arn:aws:sns:us-west-2:300813158921:cloudwatch-bmc"
  }

  source_topics_arns = [
    "arn:aws:sns:us-west-2:339713029084:ocp-stage-us-west-2-alarms-funnel"
  ]
}
