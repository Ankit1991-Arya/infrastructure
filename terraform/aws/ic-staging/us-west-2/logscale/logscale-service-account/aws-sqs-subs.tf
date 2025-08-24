module "sqs_cloudtrail_awslogs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.1.1"

  name            = var.sqs_subs_cloudtraillogs_name
  use_name_prefix = true

  create_queue_policy = true

  queue_policy_statements = {
    sns = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [aws_sns_topic.cloudtrail-topic.arn]
      }]
    }
    logscale = {
      sid = "logscale"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:GetQueueAttributes",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = [module.ingest-role-actor.iam_role_arn]
        }
      ]
    }
  }

}

resource "aws_sns_topic_subscription" "aws_cloudtrail_logs" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.cloudtrail-topic.arn
  endpoint             = module.sqs_cloudtrail_awslogs.queue_arn
}


module "sqs_guardduty_logs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.1.1"

  name            = var.sqs_subs_guarddutylogs_name
  use_name_prefix = true

  create_queue_policy = true

  queue_policy_statements = {
    sns = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]
      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [aws_sns_topic.guardduty-topic.arn]
      }]
    }
    logscale = {
      sid = "logscale"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:GetQueueAttributes",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = [module.ingest-role-actor.iam_role_arn]
        }
      ]
    }
  }

}

resource "aws_sns_topic_subscription" "aws_guardduty_logs" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.cloudtrail-topic.arn
  endpoint             = module.sqs_guardduty_logs.queue_arn
}