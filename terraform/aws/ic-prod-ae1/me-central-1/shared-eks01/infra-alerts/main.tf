terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "me-central-1"
  default_tags {
    tags = {
      InfrastructureOwner = "Cloud Native Core/devops-cloud-native-core@nice.com"
      Product             = "Infrastructure"
      Service             = "Shared EKS"
      Repository          = "https://github.com/inContact/infrastructure-live"
      ServiceOwner        = "Cloud Native Core/devops-cloud-native-core@nice.com"
      ApplicationOwner    = "Cloud Native Core/devops-cloud-native-core@nice.com"
    }
  }
}

variable "region" {
  type    = string
  default = "me-central-1"
}

data "aws_caller_identity" "current" {}

#tfsec:ignore:aws-kms-auto-rotate-keys
resource "aws_kms_key" "sns_key" {
  description = "shared_eks01_infra_notifications kms key"
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/shared_eks01_infra_notifications_key"
  target_key_id = aws_kms_key.sns_key.id
  depends_on    = [aws_kms_key.sns_key]
}

resource "aws_sns_topic" "shared_eks01_infra_notifications" {
  name              = "shared_eks01_infra_notifications"
  kms_master_key_id = aws_kms_key.sns_key.arn
}

resource "aws_sns_topic_policy" "sns_topic_policy_eks" {
  arn    = aws_sns_topic.shared_eks01_infra_notifications.arn
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "${aws_sns_topic.shared_eks01_infra_notifications.arn}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
        }
      }
    },
    {
      "Sid": "AWSEvents_POLICY",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.shared_eks01_infra_notifications.arn}"
    }
  ]
}
EOF 
}

resource "aws_kms_key_policy" "sns_key_policy" {
  key_id = aws_kms_key.sns_key.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for SNS, CloudWatch",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudwatch.amazonaws.com",
          "sns.amazonaws.com",
          "events.amazonaws.com"
        ]
      },
      "Action": [
        "kms:GenerateDataKey*",
        "kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.sns_key.arn}"
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "email_subscription_br" {
  topic_arn = aws_sns_topic.shared_eks01_infra_notifications.arn
  protocol  = "email"
  endpoint  = "devops-cloud-native-core@nice.com" # Replace with your email
}

#Below code we are applying cloudwatch alarms on to the respective metrics
resource "aws_cloudwatch_metric_alarm" "waf_rate_limit_alarm" {
  alarm_name          = "shared_eks01_waf_rate_limit_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when the API rate limit rule starts blocking requests"
  treat_missing_data  = "notBreaching"
  dimensions = {
    WebACL = "shared_eks01-${var.region}"
    Rule   = "AppGlobalIpRateLimit"
    Region = var.region
  }
  alarm_actions = [aws_sns_topic.shared_eks01_infra_notifications.arn]
  ok_actions    = [aws_sns_topic.shared_eks01_infra_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "eks-waf-blocked-req-all" {
  alarm_name          = "shared_eks01_waf_blocked_req_all"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 200
  alarm_description   = "Alarm when the WAF blocks more than 200 requests in 5 minutes"
  treat_missing_data  = "notBreaching"
  dimensions = {
    WebACL = "shared_eks01-${var.region}"
    Rule   = "ALL"
    Region = var.region
  }
  alarm_actions = [aws_sns_topic.shared_eks01_infra_notifications.arn]
  ok_actions    = [aws_sns_topic.shared_eks01_infra_notifications.arn]
}
