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

data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

#
# These iam roles are used for lambdas
# Reference https://github.com/inContact/cicd-iam-service-roles/pull/3613
#
data "aws_iam_role" "cw_monitoring_lambda_role" {
  name = "ServiceAccess-sre-kinesis-dashboard-monitoring-lambda-role"
}

data "aws_iam_role" "kinesis_mock_metrics_lambda_role" {
  name = "ServiceAccess-sre-kinesis-dashboard-mock-metrics-lambda"
}

data "aws_iam_role" "schedule_health_event_lambda_role" {
  name = "ServiceAccess-sre-kinesis-dashboard-schedule-health-event-lambda"
}

data "aws_iam_role" "kinesis_health_lambda_role" {
  name = "ServiceAccess-sre-kinesis-dashboard-cw-health-event-lambda"
}

locals {
  data = yamldecode(file("./inputs.yaml"))
}

module "kms" {
  # aka modules/dashboard-kms in repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-kms/default"
  version = "0.12.0"

  environment    = local.data.environment
  sns_topic_name = local.data.sns_topic_name
  prefix         = local.data.prefix
  tags           = local.data.tags
}

# Original from AWS approach - email
# module "monitoring_notifications" {
#   # aka modules/sns in repo
#   source  = "spacelift.io/incontact/aws-kinesis-service-sns/default"
#   version = "0.5.0"

#   aws_kms_key_arn  = module.kms.aws_kms_key_arn
#   sns_topic_name   = local.data.sns_topic_name
#   alert_recipients = local.data.monitoring_notifications.alert_recipients
#   prefix           = local.data.prefix
#   tags             = local.data.tags
# }

# New, send to our critical sns topic
data "aws_sns_topic" "cloudwatch_bmc_critical" {
  name = "mon-prod-na1-cloudwatch-bmc-critical"
}

module "aws_cloudwatch_dashboard_aws_services" {
  # aka modules/dashboards/aws_services
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-aws-services/default"
  version = "0.2.0"

  prefix                                      = local.data.prefix
  custom_stream_name                          = local.data.test_kinesis_stream_name
  period_in_seconds                           = local.data.period_in_seconds
  custom_cloudwatch_namespace                 = local.data.custom_cloudwatch_namespace
  scheduled_health_check_lambda_function_name = module.aws_health_monitor.scheduled_health_check_function_arn
  health_event_lambda_function_name           = module.aws_health_monitor.health_event_processor_function_name
  live_services_to_check                      = local.data.live_services_to_check
}

module "aws_kinesis_data_stream" {
  # aka modules/mocks/kinesis_stream in repo
  source  = "spacelift.io/incontact/aws-kinesis-mock-kinesis-stream/default"
  version = "0.2.0"

  kinesis_kms_key_alias    = module.kms.aws_kms_alias_name
  test_kinesis_stream_name = local.data.test_kinesis_stream_name
  prefix                   = local.data.prefix
  tags                     = local.data.tags
}

module "service_monitoring_kinesis_stream" {
  # aka modules/service-monitoring/kinesis_stream in repo
  source  = "spacelift.io/incontact/aws-kinesis-service-monitoring-kinesis_stream/default"
  version = "0.9.0"

  prefix                                              = local.data.prefix
  tags                                                = local.data.tags
  python_runtime_version                              = local.data.python_runtime_version
  cloudwatch_event_rule_get_metrics_func_arn          = module.aws_cloudwatch_event_rule_kinesis_stream.aws_cloudwatch_event_rule_get_metrics_func_arn
  cloudwatch_event_rule_read_write_func_arn           = module.aws_cloudwatch_event_rule_kinesis_stream.aws_cloudwatch_event_rule_read_write_func_arn
  kinesis_data_stream_name                            = module.aws_kinesis_data_stream.aws_kinesis_data_stream_name
  custom_cloudwatch_namespace                         = local.data.custom_cloudwatch_namespace
  period_in_seconds                                   = local.data.period_in_seconds
  retrieval_window_in_minutes                         = local.data.service_monitoring_kinesis_stream.retrieval_window_in_minutes
  metric_statistics_math                              = local.data.service_monitoring_kinesis_stream.metric_statistics_math
  put_record_success_threshold                        = local.data.service_monitoring_kinesis_stream.put_record_success_threshold
  put_records_success_threshold                       = local.data.service_monitoring_kinesis_stream.put_records_success_threshold
  get_records_success_threshold                       = local.data.service_monitoring_kinesis_stream.get_records_success_threshold
  get_iterator_age_msec_threshold                     = local.data.service_monitoring_kinesis_stream.get_iterator_age_msec_threshold
  get_read_provisioned_throughput_exceeded_threshold  = local.data.service_monitoring_kinesis_stream.get_read_provisioned_throughput_exceeded_threshold
  get_write_provisioned_throughput_exceeded_threshold = local.data.service_monitoring_kinesis_stream.get_write_provisioned_throughput_exceeded_threshold
  aws_kms_key_arn                                     = module.kms.aws_kms_key_arn
  log_level                                           = local.data.lambda_log_level
  lambda_role                                         = data.aws_iam_role.kinesis_mock_metrics_lambda_role.arn
}

module "aws_cloudwatch_event_rule_kinesis_stream" {
  # aka modules/eventbridge/kinesis_stream in repo
  source  = "spacelift.io/incontact/aws-kinesis-eventbridge-kinesis-stream/default"
  version = "0.4.0"

  prefix                                  = local.data.prefix
  tags                                    = local.data.tags
  lambda_kinesis_get_metrics_function_arn = module.service_monitoring_kinesis_stream.lambda_kinesis_get_metrics_function_arn
  lambda_kinesis_read_write_function_arn  = module.service_monitoring_kinesis_stream.lambda_kinesis_read_write_function_arn
  aws_kinesis_accounts                    = local.data.aws_kinesis_accounts
  lambda_run_interval_minutes             = local.data.aws_cloudwatch_event_rule_kinesis_stream.lambda_run_interval_minutes
}

module "aws_cloudwatch_alarm" {
  # aka modules/alarms/kinesis_stream in the repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-alerts-kinesis-stream/default"
  version = "0.5.0"

  prefix                                      = local.data.prefix
  tags                                        = local.data.tags
  aws_region                                  = data.aws_region.this.name
  aws_topic_arn                               = data.aws_sns_topic.cloudwatch_bmc_critical.arn
  period_in_seconds                           = local.data.period_in_seconds
  cloudwatch_namespace                        = local.data.custom_cloudwatch_namespace
  test_kinesis_stream_name                    = local.data.test_kinesis_stream_name
  live_services_to_check                      = local.data.live_services_to_check
  health_event_lambda_function_name           = module.aws_health_monitor.health_event_processor_function_name
  scheduled_health_check_lambda_function_name = module.aws_health_monitor.scheduled_health_check_function_arn
}

module "aws_cloudwatch_event_rule_cloudwatch" {
  # aka modules/eventbridge/cloudwatch
  source  = "spacelift.io/incontact/aws-kinesis-eventbridge-cloudwatch/default"
  version = "0.2.0"

  prefix                                    = local.data.prefix
  tags                                      = local.data.tags
  lambda_cloudwatch_monitoring_function_arn = module.cloudwatch_monitoring.lambda_cloudwatch_monitoring_function_arn
  lambda_run_interval_minutes               = local.data.aws_cloudwatch_event_rule_kinesis_stream.lambda_run_interval_minutes
}

module "aws_cloudwatch_alarm_kinesis_stream" {
  # aka modules/alarms/kinesis_stream
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-alerts-kinesis-stream/default"
  version = "0.5.0"

  prefix                                      = local.data.prefix
  tags                                        = local.data.tags
  aws_region                                  = data.aws_region.this.name
  aws_topic_arn                               = data.aws_sns_topic.cloudwatch_bmc_critical.arn
  period_in_seconds                           = local.data.period_in_seconds
  cloudwatch_namespace                        = local.data.custom_cloudwatch_namespace
  test_kinesis_stream_name                    = local.data.test_kinesis_stream_name
  live_services_to_check                      = local.data.live_services_to_check
  health_event_lambda_function_name           = module.aws_health_monitor.health_event_processor_function_name
  scheduled_health_check_lambda_function_name = module.aws_health_monitor.scheduled_health_check_function_arn
}

module "aws_cloudwatch_dashboard_kinesis_stream" {
  # aka modules/dashboards/kinesis_stream in repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-dashboards-kinesis-stream/default"
  version = "0.3.0"

  prefix                      = local.data.prefix
  aws_kinesis_accounts        = local.data.aws_kinesis_accounts
  custom_stream_name          = local.data.test_kinesis_stream_name
  period_in_seconds           = local.data.period_in_seconds
  custom_cloudwatch_namespace = local.data.custom_cloudwatch_namespace
}

module "aws_health_monitor" {
  # aka modules/aws-health-monitor in repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-aws-health-monitor/default"
  version = "0.9.0"

  prefix                                = local.data.prefix
  live_services_to_check                = local.data.live_services_to_check
  scheduled_services_to_check           = local.data.aws_health_monitor.scheduled_services_to_check
  live_event_category_types             = local.data.aws_health_monitor.live_event_category_types
  scheduled_event_category_types        = local.data.aws_health_monitor.scheduled_event_category_types
  service_health_schedule_interval      = local.data.aws_health_monitor.service_health_schedule_interval
  tags                                  = local.data.tags
  python_runtime_version                = local.data.python_runtime_version
  custom_cloudwatch_namespace           = local.data.custom_cloudwatch_namespace
  aws_kms_key_arn                       = module.kms.aws_kms_key_arn
  log_level                             = local.data.lambda_log_level
  lambda_role_kinesis_health_arn        = data.aws_iam_role.kinesis_health_lambda_role.arn
  schedule_health_event_lambda_role_arn = data.aws_iam_role.schedule_health_event_lambda_role.arn
}

module "cross_account_monitoring" {
  # aka modules/cross-account-monitoring in repo
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-aws-cross-account-monitoring/default"
  version = "0.3.0"

  region                  = data.aws_region.this.name
  account_id              = data.aws_caller_identity.this.account_id
  prefix                  = local.data.prefix
  sink_name               = local.data.cross_account_monitoring.sink_name
  tags                    = local.data.tags
  source_account_ids      = local.data.cross_account_monitoring.source_account_ids
  organizational_unit_ids = local.data.cross_account_monitoring.organizational_unit_ids
  use_delegated_admin     = false
}

# This module is used test CloudWatch itself and send SNS notification if it is not available
module "cloudwatch_monitoring" {
  # aka modules/cloudwatch-monitoring
  source  = "spacelift.io/incontact/aws-kinesis-dashboard-cloudwatch-monitoring/default"
  version = "0.5.0"

  prefix                                               = local.data.prefix
  tags                                                 = local.data.tags
  python_runtime_version                               = local.data.python_runtime_version
  aws_kms_key_arn                                      = module.kms.aws_kms_key_arn
  cloudwatch_event_rule_cloudwatch_monitoring_func_arn = module.aws_cloudwatch_event_rule_cloudwatch.aws_cloudwatch_event_rule_cloudwatch_monitoring_func_arn
  sns_topic_arn                                        = data.aws_sns_topic.cloudwatch_bmc_critical.arn
  log_level                                            = local.data.lambda_log_level
  lambda_role                                          = data.aws_iam_role.cw_monitoring_lambda_role.arn
}

resource "aws_ssm_parameter" "sink_arn" {
  name        = "/${local.data.prefix}/${local.data.cross_account_monitoring.sink_name}/sink_arn"
  description = "The ARN of the sink"
  type        = "SecureString"
  value       = module.cross_account_monitoring.sink_arn
  tags        = local.data.tags
}

resource "aws_ssm_parameter" "link_url" {
  name        = "/${local.data.prefix}/${local.data.cross_account_monitoring.sink_name}/link_url"
  description = "The URL of the link"
  type        = "SecureString"
  value       = module.cross_account_monitoring.link_url
  tags        = local.data.tags
}
