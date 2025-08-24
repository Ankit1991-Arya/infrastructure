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
  region = "us-east-1"
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

data "aws_caller_identity" "current" {}

#tfsec:ignore:aws-kms-auto-rotate-keys
resource "aws_kms_key" "sns_key" {
  description = "shared_eks01_global_infra_notifications kms key"
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/shared_eks01_global_infra_notifications_key"
  target_key_id = aws_kms_key.sns_key.id
  depends_on    = [aws_kms_key.sns_key]
}

resource "aws_sns_topic" "shared_eks01_global_infra_notifications" {
  name              = "shared_eks01_global_infra_notifications"
  kms_master_key_id = aws_kms_key.sns_key.arn
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
          "events.amazonaws.com",
          "shield.amazonaws.com"
        ]
      },
      "Action": [
        "kms:GenerateDataKey*",
        "kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.sns_key.arn}"
    },
    {
      "Sid": "AWSEvents_POLICY",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:shared_eks01_global_infra_notifications"
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "email_subscription_br" {
  topic_arn = aws_sns_topic.shared_eks01_global_infra_notifications.arn
  protocol  = "email"
  endpoint  = "devops-cloud-native-core@nice.com" # Replace with your email
}