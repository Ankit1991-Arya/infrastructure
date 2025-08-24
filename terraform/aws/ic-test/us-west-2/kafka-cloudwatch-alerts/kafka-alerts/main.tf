terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      InfrastructureOwner = "Cloud Native Core/devops-cloud-native-core@nice.com"
      ApplicationOwner    = "Cloud Native Core/devops-cloud-native-core@nice.com"
      Product             = "Infrastructure"
      Service             = "Shared MSK"
      Repository          = "https://github.com/inContact/infrastructure-live"
    }
  }
}

# List of Kafka Broker IDs
variable "broker_ids" {
  type    = list(string)
  default = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
}

# Existing SNS Topics for Alerts
variable "sns_topic_info" {
  type    = string
  default = "arn:aws:sns:us-west-2:265671366761:cloudwatch-bmc-minor"
}

variable "sns_topic_critical" {
  type    = string
  default = "arn:aws:sns:us-west-2:265671366761:cloudwatch-bmc-critical"
}

# CloudWatch Alarms for INFO Alert (> 3000)
resource "aws_cloudwatch_metric_alarm" "kafka_connection_count_info" {
  for_each            = toset(var.broker_ids)
  alarm_name          = "TEST-KAFKA-ConnectionCount-Broker-${each.value}-MINOR"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 3000
  alarm_description   = "INFO Alert: Kafka ConnectionCount > 3000 for Broker ${each.value}"
  actions_enabled     = true
  alarm_actions       = [var.sns_topic_info]
  ok_actions          = [var.sns_topic_info]

  metric_name = "ConnectionCount"
  namespace   = "AWS/Kafka"
  dimensions = {
    "Cluster Name" = "shared-msk01-us-west-2"
    "Broker ID"    = each.value
  }
  period    = 60
  statistic = "Sum"
}

# CloudWatch Alarms for CRITICAL Alert (> 4000)
resource "aws_cloudwatch_metric_alarm" "kafka_connection_count_critical" {
  for_each            = toset(var.broker_ids)
  alarm_name          = "TEST-KAFKA-ConnectionCount-Broker-${each.value}-CRITICAL"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 4000
  alarm_description   = "CRITICAL Alert: Kafka ConnectionCount > 4000 for Broker ${each.value}"
  actions_enabled     = true
  alarm_actions       = [var.sns_topic_critical]
  ok_actions          = [var.sns_topic_critical]

  metric_name = "ConnectionCount"
  namespace   = "AWS/Kafka"
  dimensions = {
    "Cluster Name" = "shared-msk01-us-west-2"
    "Broker ID"    = each.value
  }
  period    = 60
  statistic = "Sum"
}
