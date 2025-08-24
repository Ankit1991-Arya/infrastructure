terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.2"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      ApplicationOwner    = "Trust"
      InfrastructureOwner = "Trust"
      Product             = "GuardDuty"
      Service             = "GuardDuty Findings"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "guardduty-monitoring" {
  source                              = "spacelift.io/incontact/guardduty-monitoring-guardduty-finding/default"
  version                             = "0.0.6"
  account_name                        = "mon-prod-jp1"
  cloudwatch_event_rule_name          = "trust-guardduty-cloudwatch-rule"
  function_name                       = "trust-guardduty-lambda-function"
  role_name                           = "Role-service-trust-guard-duty-connector"
  sns_topic_name                      = "trust-guardduty-sns-topic"
  subscription_emails                 = ["CSOC@nice.com", "CXoneInfoSecOperationsCSOC@nice.com"] #CSOC DL's
  timeout                             = 10
  cloudwatch_log_group_retention_days = 14
}
